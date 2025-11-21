import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';
import 'package:me_livrei/widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              padding: EdgeInsets.fromLTRB(31, 81, 74, 43),
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
            SizedBox(
              height: 308,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/51kAYMwbQIL._SY445_SX342_ML2_.jpg',
                      title: 'A Biblioteca da Meia-Noite',
                      author: 'Matt Haig',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/81BTkpMrLYL._SY425_.jpg',
                      title: 'Sapiens - Uma Breve História da Humanidade',
                      author: 'Yuval Noah Harari',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/51tAD6LyZ-L._SY466_.jpg',
                      title: 'Fahrenheit 451',
                      author: 'Ray Bradbury',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/91BsZhxCRjL._SY466_.jpg',
                      title: 'A revolução dos bichos: Um conto de fadas',
                      author: 'George Orwell',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
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
            SizedBox(
              height: 308,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/61t0bwt1s3L._SY425_.jpg',
                      title: '1984',
                      author: 'George Orwell',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/A1bFiBBPWFS._SY466_.jpg',
                      title: 'Senhor das Moscas (Nova edição)',
                      author: 'William Golding',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/71x-i7sKSvL._SY425_.jpg',
                      title: 'Como fazer amigos e influenciar pessoas',
                      author: 'Dale Carnegie',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'https://m.media-amazon.com/images/I/815iPX0SgkL._SY425_.jpg',
                      title: 'O poder do Hábito: Por que fazemos o que fazemos na vida e nos negócios',
                      author: 'Charles Duhigg',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
