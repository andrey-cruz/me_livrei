import 'package:http/http.dart' as http;
import 'dart:convert';

/// Service para gerenciar chamadas à API do IBGE
///
/// Separa a lógica de API dos widgets, facilitando:
/// - Testes
/// - Reutilização
/// - Manutenção
class LocationService {
  final http.Client _client;

  LocationService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl =
      'https://servicodados.ibge.gov.br/api/v1/localidades';
  static const Duration _timeout = Duration(seconds: 10);

  /// Busca todos os estados brasileiros
  ///
  /// Retorna lista de estados ordenada alfabeticamente
  /// Lança [LocationException] em caso de erro
  Future<List<Estado>> fetchEstados() async {
    try {
      final url = Uri.parse('$_baseUrl/estados');
      final response = await _client.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final estados = data
            .map((json) => Estado.fromJson(json))
            .toList();

        // Ordenar alfabeticamente
        estados.sort((a, b) => a.nome.compareTo(b.nome));

        return estados;
      } else {
        throw LocationException(
          'Erro ao buscar estados. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('Erro ao buscar estados: ${e.toString()}');
    }
  }

  /// Busca todas as cidades de um estado
  ///
  /// [estadoId] - ID do estado do IBGE
  ///
  /// Retorna lista de cidades ordenada alfabeticamente
  /// Lança [LocationException] em caso de erro
  Future<List<Cidade>> fetchCidades(int estadoId) async {
    try {
      final url = Uri.parse('$_baseUrl/estados/$estadoId/municipios');
      final response = await _client.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final cidades = data
            .map((json) => Cidade.fromJson(json))
            .toList();

        // Ordenar alfabeticamente
        cidades.sort((a, b) => a.nome.compareTo(b.nome));

        return cidades;
      } else {
        throw LocationException(
          'Erro ao buscar cidades. Código: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('Erro ao buscar cidades: ${e.toString()}');
    }
  }
}

/// Modelo de Estado
class Estado {
  final int id;
  final String sigla;
  final String nome;

  Estado({
    required this.id,
    required this.sigla,
    required this.nome,
  });

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json['id'] as int,
      sigla: json['sigla'] as String,
      nome: json['nome'] as String,
    );
  }

  @override
  String toString() => nome;
}

/// Modelo de Cidade
class Cidade {
  final int id;
  final String nome;

  Cidade({
    required this.id,
    required this.nome,
  });

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      id: json['id'] as int,
      nome: json['nome'] as String,
    );
  }

  @override
  String toString() => nome;
}

/// Exceção customizada para erros de localização
class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => message;
}