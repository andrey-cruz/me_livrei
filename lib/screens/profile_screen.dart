import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../widgets/book_card.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/book_service.dart';
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

  UserModel? _currentUser;
  List<Book> _myBooks = [];
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

      final user = await _userService.getUser(uid);
      final books = await _bookService.getUserBooks(uid);

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
          _myBooks = books;
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

  // --- FUNÇÃO DE NAVEGAÇÃO PARA EDITAR ---
  void _navigateToEditProfile() async {
    // Segurança: Só navega se o usuário estiver carregado
    if (_currentUser == null) return;

    // Aguarda o retorno da tela de edição
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PerfilEditScreen(user: _currentUser!),
      ),
    );

    // Se voltou com um usuário atualizado, atualiza a tela
    if (updatedUser != null && updatedUser is UserModel) {
      setState(() {
        _currentUser = updatedUser;
        // Atualiza localização também se necessário
        _updateLocationText(updatedUser);
      });
    }
  }

  Future<void> _updateLocationText(UserModel user) async {
    final loc = await LocationHelper.formatarLocalizacao(user.city, user.state);
    if (mounted) setState(() => _locationText = loc);
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
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookDetailScreen(
                    book: book,
                    isOwner: true, // Dono
                  ),
                ),
              );
              // Recarrega os dados quando voltar (caso tenha deletado/editado)
              if (mounted) _loadUserData();
            },
          );
        },
      ),
    );
  }
  // ============================================

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
                        _buildStatColumn('0', 'Interesses'),
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
              _buildBookList(_myBooks), // Agora funciona perfeitamente!
              _buildSectionHeader('Meus interesses', Icons.star_border, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BooksListScreen(
                      title: 'Meus Interesses',
                      books: [],
                    ),
                  ),
                );
              }),
              _buildBookList(_myBooks),
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