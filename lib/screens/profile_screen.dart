import 'package:flutter/material.dart';

import '../models/Book.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

final List<Book> myBooks = [
  Book(
    id: '1',
    userId: '1',
    title: 'O Pequeno Príncipe',
    author: 'Antoine de Saint-Exupéry',
    description: 'abc',
    coverUrl: 'abc',
  ),
  Book(
    id: '2',
    userId: '2',
    title: 'Maze Runner: Correr ou Morrer',
    author: 'James Dashner',
    description: 'abc',
    coverUrl: 'abc',
  ),
  Book(
    id: '3',
    userId: '3',
    title: '1984',
    author: 'George Orwell',
    description: 'abc',
    coverUrl: 'abc',
  ),
  Book(
    id: '4',
    userId: '4',
    title: 'Fahrenheit 451',
    author: 'Ray Bradbury',
    description: 'abc',
    coverUrl: 'abc',
  ),
];

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F1),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFEC5641),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 36),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFFBF8F1),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFFEC5641),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Florianópolis, SC • Brasil',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Andrey Cruz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '@andrey.mcruz',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('99', 'LIVROS'),
                        _buildStatColumn('99', 'INTERESSES'),
                        _buildStatColumn('99', 'TROCAS'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildSectionHeader(
                'Minha estante',
                Icons.bookmark_border,
                () {},
              ),
              _buildBookList(myBooks),
              _buildSectionHeader('Meus interesses', Icons.star_border, () {}),
              _buildBookList(myBooks),
              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
    );
  }
}

Widget _buildStatColumn(String count, String label) {
  return Container(
    width: 100,
    height: 70,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Color(0xFFEC5641),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFEC5641), fontSize: 10),
        ),
      ],
    ),
  );
}

Widget _buildSectionHeader(String title, IconData icon, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFFEC5641)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'Ver Todos',
            style: TextStyle(color: Color(0xFFEC5641), fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBookList(List<Book> books) {
  return SizedBox(
    height: 220,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: books.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(width: 16);
        }
        if (index == books.length + 1) {
          return const SizedBox(width: 16);
        }
        final book = books[index - 1];
        return BookItem(book: book);
      },
    ),
  );
}

class BookItem extends StatelessWidget {
  final Book book;
  static const double bookItemWidth = 130;

  const BookItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: bookItemWidth,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.white,
                child: const Center(
                  child: Icon(Icons.menu_book, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            book.author,
            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
