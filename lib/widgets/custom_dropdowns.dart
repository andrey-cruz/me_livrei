import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../constants/literary_genres.dart';
import '../../services/api_ibge.dart';

class Dropdowns extends StatefulWidget {
  final Function(String?) onEstadoChanged;
  final Function(String?) onCidadeChanged;
  final Function(String?) onGeneroChanged;
  final String? initialEstadoId;
  final String? initialCidadeId;
  final String? initialGeneroId;

  const Dropdowns({
    super.key,
    required this.onEstadoChanged,
    required this.onCidadeChanged,
    required this.onGeneroChanged,
    this.initialEstadoId,
    this.initialCidadeId,
    this.initialGeneroId,
  });

  @override
  State<Dropdowns> createState() => _DropdownsState();
}

class _DropdownsState extends State<Dropdowns> {
  // ⭐ Service separado!
  final LocationService _locationService = LocationService();

  // Valores selecionados
  String? _estadoSelecionado;
  String? _cidadeSelecionada;
  String? _generoSelecionado;

  // Listas de dados
  List<Estado> _estados = [];
  List<Cidade> _cidades = [];

  // Estados de loading e erro
  bool _carregandoEstados = true;
  bool _carregandoCidades = false;
  String? _erroEstados;
  String? _erroCidades;

  @override
  void initState() {
    super.initState();

    // Inicializar com valores iniciais
    _estadoSelecionado = widget.initialEstadoId;
    _cidadeSelecionada = widget.initialCidadeId;
    _generoSelecionado = widget.initialGeneroId;

    _buscarEstados();
  }

  /// Busca estados usando o service
  Future<void> _buscarEstados() async {
    setState(() {
      _carregandoEstados = true;
      _erroEstados = null;
    });

    try {
      // ⭐ Usa o service!
      final estados = await _locationService.fetchEstados();

      if (mounted) {
        setState(() {
          _estados = estados;
          _carregandoEstados = false;
        });

        // Se tem estado inicial, buscar cidades
        if (_estadoSelecionado != null) {
          await _buscarCidades(int.parse(_estadoSelecionado!));
        }
      }
    } on LocationException catch (e) {
      if (mounted) {
        setState(() {
          _carregandoEstados = false;
          _erroEstados = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregandoEstados = false;
          _erroEstados = 'Erro inesperado ao carregar estados';
        });
      }
    }
  }

  /// Busca cidades usando o service
  Future<void> _buscarCidades(int estadoId) async {
    setState(() {
      _carregandoCidades = true;
      _erroCidades = null;

      // Só limpa cidade se mudou o estado
      if (_estadoSelecionado != widget.initialEstadoId) {
        _cidades = [];
        _cidadeSelecionada = null;
      }
    });

    try {
      // ⭐ Usa o service!
      final cidades = await _locationService.fetchCidades(estadoId);

      if (mounted) {
        setState(() {
          _cidades = cidades;
          _carregandoCidades = false;
        });
      }
    } on LocationException catch (e) {
      if (mounted) {
        setState(() {
          _carregandoCidades = false;
          _erroCidades = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _carregandoCidades = false;
          _erroCidades = 'Erro inesperado ao carregar cidades';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final fieldSpacing = isTablet ? 20.0 : 16.0;
        final textSize = isTablet ? 16.0 : 14.0;
        final maxFieldWidth = isTablet ? 450.0 : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxFieldWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEstadoDropdown(textSize),
                SizedBox(height: fieldSpacing),
                _buildCidadeDropdown(textSize),
                SizedBox(height: fieldSpacing),
                _buildGeneroDropdown(textSize),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEstadoDropdown(double textSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Estado", textSize),
        const SizedBox(height: 8),

        // Loading
        if (_carregandoEstados)
          _buildLoadingIndicator()

        // Erro
        else if (_erroEstados != null)
          _buildErrorContainer(_erroEstados!, _buscarEstados)

        // Dropdown
        else
          DropdownButtonFormField<String>(
            value: _estadoSelecionado,
            decoration: _buildInputDecoration("Selecione o estado"),
            items: _estados.map((estado) {
              return DropdownMenuItem(
                value: estado.id.toString(),
                child: Text(estado.nome),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _estadoSelecionado = value);
              widget.onEstadoChanged(value);

              if (value != null) {
                _buscarCidades(int.parse(value));
              }
            },
            validator: (v) => v == null ? "Selecione um estado" : null,
          ),
      ],
    );
  }

  Widget _buildCidadeDropdown(double textSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Cidade", textSize),
        const SizedBox(height: 8),

        // Loading
        if (_carregandoCidades)
          _buildLoadingIndicator()

        // Erro
        else if (_erroCidades != null)
          _buildErrorContainer(
            _erroCidades!,
            _estadoSelecionado != null
                ? () => _buscarCidades(int.parse(_estadoSelecionado!))
                : null,
          )

        // Dropdown
        else
          DropdownButtonFormField<String>(
            value: _cidadeSelecionada,
            decoration: _buildInputDecoration("Selecione a cidade"),
            items: _cidades.map((cidade) {
              return DropdownMenuItem(
                value: cidade.id.toString(),
                child: Text(cidade.nome),
              );
            }).toList(),
            onChanged: _cidades.isEmpty ? null : (value) {
              setState(() => _cidadeSelecionada = value);
              widget.onCidadeChanged(value);
            },
            validator: (v) => v == null ? "Selecione uma cidade" : null,
          ),
      ],
    );
  }

  Widget _buildGeneroDropdown(double textSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Gênero Literário Favorito", textSize),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _generoSelecionado,
          decoration: _buildInputDecoration("Selecione um gênero"),
          items: LiteraryGenres.genres.map((genero) {
            return DropdownMenuItem(
              value: genero,
              child: Text(genero),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _generoSelecionado = value);
            widget.onGeneroChanged(value);
          },
          validator: (v) => v == null ? "Selecione um gênero" : null,
        ),
      ],
    );
  }

  // ==================== WIDGETS AUXILIARES ====================

  Widget _buildLabel(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.carvaoSuave,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.cinzaPoeira),
      filled: true,
      fillColor: AppColors.brancoCreme,
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.carvaoSuave, width: 0.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.ambarQuente),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bordoLiterario),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.brancoCreme,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cinzaPoeira),
      ),
      child: const Center(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorContainer(String message, VoidCallback? onRetry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bordoLiterario,
        border: Border.all(color: AppColors.cinzaPoeira),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.bordoLiterario, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.bordoLiterario,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.refresh, size: 20),
              onPressed: onRetry,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }
}