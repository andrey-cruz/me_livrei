import '../services/api_ibge.dart';

/// Helper para converter IDs de localização em nomes legíveis
/// Usa cache para otimizar performance
class LocationHelper {
  static final LocationService _locationService = LocationService();

  // Cache para evitar múltiplas chamadas à API
  static final Map<int, String> _estadosCache = {};
  static final Map<int, String> _cidadesCache = {};

  /// Converte ID do estado para sigla
  /// Retorna o próprio ID em caso de erro
  static Future<String> getEstadoSigla(String estadoIdStr) async {
    try {
      final estadoId = int.parse(estadoIdStr);

      // Verificar se já está no cache
      if (_estadosCache.containsKey(estadoId)) {
        return _estadosCache[estadoId]!;
      }

      // Buscar da API
      final estados = await _locationService.fetchEstados();
      final estado = estados.firstWhere(
            (e) => e.id == estadoId,
        orElse: () => throw Exception('Estado não encontrado'),
      );

      // Salvar no cache
      _estadosCache[estadoId] = estado.sigla;

      return estado.sigla;
    } catch (e) {
      // Fallback: retorna o ID caso dê erro
      return estadoIdStr;
    }
  }

  /// Converte ID da cidade para nome
  /// Retorna o próprio ID em caso de erro
  static Future<String> getCidadeNome(String cidadeIdStr, String estadoIdStr) async {
    try {
      final cidadeId = int.parse(cidadeIdStr);

      // Verificar se já está no cache
      if (_cidadesCache.containsKey(cidadeId)) {
        return _cidadesCache[cidadeId]!;
      }

      // Buscar da API
      final estadoId = int.parse(estadoIdStr);
      final cidades = await _locationService.fetchCidades(estadoId);
      final cidade = cidades.firstWhere(
            (c) => c.id == cidadeId,
        orElse: () => throw Exception('Cidade não encontrada'),
      );

      // Salvar no cache
      _cidadesCache[cidadeId] = cidade.nome;

      return cidade.nome;
    } catch (e) {
      // Fallback: retorna o ID caso dê erro
      return cidadeIdStr;
    }
  }

  /// Formata localização completa no padrão: "Cidade, UF • País"
  /// Retorna texto genérico em caso de dados incompletos
  static Future<String> formatarLocalizacao(String? cidadeId, String? estadoId) async {
    if (cidadeId == null || estadoId == null || cidadeId.isEmpty || estadoId.isEmpty) {
      return 'Localização não informada';
    }

    try {
      final cidadeNome = await getCidadeNome(cidadeId, estadoId);
      final estadoSigla = await getEstadoSigla(estadoId);

      return '$cidadeNome, $estadoSigla • Brasil';
    } catch (e) {
      return 'Brasil';
    }
  }

  /// Limpa o cache (útil para testes ou atualização forçada)
  static void limparCache() {
    _estadosCache.clear();
    _cidadesCache.clear();
  }
}