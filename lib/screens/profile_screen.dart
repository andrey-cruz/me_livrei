import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../widgets/book_card.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/book_service.dart';
import '../services/interest_service.dart'; // NOVO IMPORT
import '../constants/location_helper.dart';
import 'add_book_screen.dart';
import 'book_detail_screen.dart';
import 'login_screen.dart';
import 'perfil_edit_screen.dart';
import 'books_list_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final BookService _bookService = BookService();
  final InterestService _interestService = InterestService(); // NOVO SERVIÇO

  UserModel? _currentUser;
  List<Book> _myBooks = [];
  List<Book> _interestedBooks = []; // NOVA LISTA
  bool _isLoading = true;
  String? _error;
  String _locationText = 'Carregando...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final uid = authService.currentUserId;

      if (uid == null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
        return;
      }

      // 1. Carregar Usuário
      final user = await _userService.getUser(uid);

      // 2. Carregar Meus Livros (Estante)
      final myBooks = await _bookService.getUserBooks(uid);

      // 3. Carregar Meus Interesses (NOVA LÓGICA)
      final interestedIds = await _interestService.getUserInterestedBookIds(uid);
      final interestedBooks = await _bookService.getBooksByIds(interestedIds);

      String location = 'Brasil';
      if (user != null) {
        location = await LocationHelper.formatarLocalizacao(
          user.city,
          user.state,
        );
      }

      if (mounted) {
        setState(() {
          _currentUser = user;
          _myBooks = myBooks;
          _interestedBooks = interestedBooks; // Atualiza a lista de interesses
          _locationText = location;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _handleLogout() async {
    try {
      await Provider.of<AuthService>(context, listen: false).signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao sair: $e')),
      );
    }
  }

  void _navigateToEditProfile() async {
    if (_currentUser == null) return;
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerfilEditScreen(user: _currentUser!),
      ),
    );

    if (updatedUser != null && updatedUser is UserModel) {
      setState(() {
        _currentUser = updatedUser;
        _updateLocationText(updatedUser);
      });
    }
  }

  Future<void> _updateLocationText(UserModel user) async {
    final loc = await LocationHelper.formatarLocalizacao(user.city, user.state);
    if (mounted) setState(() => _locationText = loc);
  }

  // LÓGICA DE CONSTRUÇÃO DA LISTA (Atualizada)
  Widget _buildBookList(List<Book> books, {required bool isMyShelf}) {
    if (books.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          isMyShelf
              ? 'Você ainda não cadastrou livros.'
              : 'Você ainda não demonstrou interesse.',
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

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
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(
                    book: book,
                    isOwner: isMyShelf, // Se for minha estante, sou dono. Se for interesse, não.
                  ),
                ),
              );
              // Recarrega os dados ao voltar (para atualizar caso tenha removido interesse)
              if (mounted) _loadUserData();
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(color: AppColors.terracotaQueimado)),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFFBF8F1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text('Erro: $_error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadUserData();
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F1),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
          if (result == true && mounted) {
            _loadUserData();
          }
        },
        backgroundColor: const Color(0xFFEC5641),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 36, color: AppColors.begePapel),
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
                    Text(
                      _locationText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentUser?.displayName ?? 'Usuário',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${_currentUser?.username ?? ''}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn(_myBooks.length.toString(), 'Livros'),
                        _buildStatColumn(
                            _myBooks
                                .where((b) => b.coverUrl.contains('livrado'))
                                .length
                                .toString(),
                            'Livrados'),
                        _buildStatColumn(_interestedBooks.length.toString(), 'Interesses'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToEditProfile();
                  } else if (value == 'logout') {
                    _handleLogout();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.carvaoSuave),
                          SizedBox(width: 8),
                          Text('Editar Perfil'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sair', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // MINHA ESTANTE
              _buildSectionHeader(
                'Minha estante',
                Icons.bookmark_border,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BooksListScreen(
                        title: 'Minha Estante',
                        books: _myBooks,
                      ),
                    ),
                  );
                },
              ),
              _buildBookList(_myBooks, isMyShelf: true),

              // MEUS INTERESSES
              _buildSectionHeader('Meus interesses', Icons.star_border, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BooksListScreen(
                      title: 'Meus Interesses',
                      books: _interestedBooks,
                    ),
                  ),
                );
              }),
              _buildBookList(_interestedBooks, isMyShelf: false),

              const SizedBox(height: 80),
            ]),
          ),
        ],
      ),
    );
  }
}

// Widgets Auxiliares
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