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
                      imageUrl: 'abc',
                      title: 'Livro1',
                      author: 'Autor1',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'abc',
                      title: 'Livro2',
                      author: 'Autor2',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'abc',
                      title: 'Livro3',
                      author: 'Autor3',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'abc',
                      title: 'Livro4',
                      author: 'Autor4',
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
                      imageUrl: 'abc',
                      title: 'Livro1',
                      author: 'Autor1',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'abc',
                      title: 'Livro2',
                      author: 'Autor2',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'abc',
                      title: 'Livro3',
                      author: 'Autor3',
                      onTap: () {},
                    ),
                    BookCard(
                      imageUrl: 'abc',
                      title: 'Livro4',
                      author: 'Autor4',
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
