import 'package:flutter/material.dart';
import '../models/Book.dart';
import '../widgets/book_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final List<Book> myBooks = [
    Book(
      id: '1',
      userId: '1',
      title: 'O Pequeno Príncipe',
      author: 'Antoine de Saint-Exupéry',
      description: 'abc',
      coverUrl: 'https://m.media-amazon.com/images/I/81QluJ4QXyL._SY425_.jpg',
    ),
    Book(
      id: '2',
      userId: '2',
      title: 'Maze Runner: Correr ou Morrer',
      author: 'James Dashner',
      description: 'abc',
      coverUrl: 'https://m.media-amazon.com/images/I/51UqHWh58-L._SY445_SX342_ML2_.jpg',
    ),
    Book(
      id: '3',
      userId: '3',
      title: '1984',
      author: 'George Orwell',
      description: 'abc',
      coverUrl: 'https://m.media-amazon.com/images/I/61t0bwt1s3L._SY425_.jpg',
    ),
    Book(
      id: '4',
      userId: '4',
      title: 'Fahrenheit 451',
      author: 'Ray Bradbury',
      description: 'abc',
      coverUrl: 'https://m.media-amazon.com/images/I/51tAD6LyZ-L._SY466_.jpg',
    ),
  ];

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
