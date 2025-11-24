import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/book.dart';
import '../widgets/book_card.dart';

class BooksListScreen extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BooksListScreen({super.key, required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.marfimAntigo,
      appBar: AppBar(
        backgroundColor: AppColors.marfimAntigo,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.carvaoSuave),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.carvaoSuave,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: books.isEmpty
          ? Center(
              child: Text(
                'Nenhum livro encontrado.',
                style: TextStyle(color: AppColors.cinzaPoeira),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 livros por linha
                childAspectRatio: 0.55, // Proporção altura/largura
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(
                  imageUrl: book.coverUrl,
                  title: book.title,
                  author: book.author,
                  onTap: () {
                    // Aqui você pode navegar para o BookDetailScreen futuramente
                  },
                );
              },
            ),
    );
  }
}
