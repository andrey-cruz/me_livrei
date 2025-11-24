import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/literary_genres.dart';

/// Dropdown específico para seleção de gênero literário de LIVROS
///
/// Uso: Em book_edit_screen e add_book_screen
class BookGenreDropdown extends StatelessWidget {
  final String? selectedGenre;
  final Function(String?) onChanged;
  final bool enabled;

  const BookGenreDropdown({
    super.key,
    this.selectedGenre,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gênero Literário',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.carvaoSuave,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedGenre,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Selecione o gênero do livro',
            hintStyle: const TextStyle(
              color: AppColors.cinzaPoeira,
              fontSize: 14,
            ),
            filled: true,
            fillColor: enabled ? AppColors.brancoCreme : Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.cinzaPoeira,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.cinzaPoeira,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.terracotaQueimado,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.bordoLiterario,
                width: 1,
              ),
            ),
          ),
          items: [
            // Item vazio para permitir limpar seleção
            const DropdownMenuItem<String>(
              value: null,
              child: Text(
                'Nenhum (opcional)',
                style: TextStyle(
                  color: AppColors.cinzaPoeira,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            // Lista de gêneros
            ...LiteraryGenres.genres.map((genre) {
              return DropdownMenuItem<String>(
                value: genre,
                child: Text(
                  genre,
                  style: const TextStyle(
                    color: AppColors.carvaoSuave,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ],
          onChanged: enabled ? onChanged : null,
          validator: (value) {
            // Gênero é opcional, então não valida
            return null;
          },
        ),
      ],
    );
  }
}