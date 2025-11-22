import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';
import 'package:me_livrei/widgets/book_card.dart';
import '../models/Book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Book> highlightBooks = [
    Book(
      id: '1',
      userId: '1',
      description: '',
      title: 'A Biblioteca da Meia-Noite',
      author: 'Matt Haig',
      coverUrl:
          'https://m.media-amazon.com/images/I/51kAYMwbQIL._SY445_SX342_ML2_.jpg',
    ),
    Book(
      id: '2',
      userId: '2',
      description: '',
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      coverUrl: 'https://m.media-amazon.com/images/I/81BTkpMrLYL._SY425_.jpg',
    ),
    Book(
      id: '3',
      userId: '3',
      description: '',
      title: 'Fahrenheit 451',
      author: 'Ray Bradbury',
      coverUrl: 'https://m.media-amazon.com/images/I/51tAD6LyZ-L._SY466_.jpg',
    ),
    Book(
      id: '4',
      userId: '4',
      description: '',
      title: 'A revolução dos bichos',
      author: 'George Orwell',
      coverUrl: 'https://m.media-amazon.com/images/I/91BsZhxCRjL._SY466_.jpg',
    ),
  ];

  final List<Book> interestBooks = [
    Book(
      id: '5',
      userId: '5',
      description: '',
      title: '1984',
      author: 'George Orwell',
      coverUrl: 'https://m.media-amazon.com/images/I/61t0bwt1s3L._SY425_.jpg',
    ),
    Book(
      id: '6',
      userId: '6',
      description: '',
      title: 'Senhor das Moscas',
      author: 'William Golding',
      coverUrl: 'https://m.media-amazon.com/images/I/A1bFiBBPWFS._SY466_.jpg',
    ),
    Book(
      id: '7',
      userId: '7',
      description: '',
      title: 'Como fazer amigos',
      author: 'Dale Carnegie',
      coverUrl: 'https://m.media-amazon.com/images/I/71x-i7sKSvL._SY425_.jpg',
    ),
    Book(
      id: '8',
      userId: '8',
      description: '',
      title: 'O poder do Hábito',
      author: 'Charles Duhigg',
      coverUrl: 'https://m.media-amazon.com/images/I/815iPX0SgkL._SY425_.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.marfimAntigo,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(31, 81, 74, 43),
              child: SizedBox(
                width: 306,
                height: 51,
                child: TextField(
                  cursorColor: AppColors.cinzaPoeira,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        width: 0.5,
                        color: AppColors.carvaoSuave,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.cinzaPoeira,
                    ),
                    hintText: 'Pesquisar por títulos, autores...',
                    hintStyle: TextStyle(color: AppColors.cinzaPoeira),
                    filled: true,
                    fillColor: AppColors.brancoCreme,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 124, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 24,
                    color: AppColors.terracotaQueimado,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Destaque do Me Livrei',
                    style: TextStyle(
                      color: AppColors.carvaoSuave,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildHorizontalList(highlightBooks),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 36, 124, 16),
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_add,
                    size: 24,
                    color: AppColors.terracotaQueimado,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Meus Interesses',
                    style: TextStyle(
                      color: AppColors.carvaoSuave,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildHorizontalList(interestBooks),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<Book> books) {
    return SizedBox(
      height: 308,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return BookCard(
            imageUrl: book.coverUrl,
            title: book.title,
            author: book.author,
            onTap: () {},
          );
        },
      ),
    );
  }
}
