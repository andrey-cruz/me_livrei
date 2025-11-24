import 'package:flutter/material.dart';
import 'package:me_livrei/models/Book.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/interest_service.dart';
import '../services/user_service.dart';
import '../services/book_service.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final bool isOwner;

  const BookDetailScreen({Key? key, required this.book, this.isOwner = false})
      : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final InterestService _interestService = InterestService();
  final UserService _userService = UserService();
  final BookService _bookService = BookService();

  bool _isLivrado = false;
  bool _hasInterest = false;
  bool _isLoadingInterest = false;
  List<Map<String, dynamic>> _interests = [];
  int _interestCount = 0;

  @override
  void initState() {
    super.initState();
    _checkUserInterest();
    if (widget.isOwner) {
      _loadInterests();
    }
  }

  Future<void> _checkUserInterest() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final uid = authService.currentUserId;

    if (uid == null || widget.isOwner) return;

    try {
      final hasInterest = await _interestService.hasUserInterest(
        userId: uid,
        bookId: widget.book.id,
      );

      final count = await _interestService.getBookInterestCount(widget.book.id);

      if (mounted) {
        setState(() {
          _hasInterest = hasInterest;
          _interestCount = count;
        });
      }
    } catch (e) {
      // Ignorar erro silenciosamente
    }
  }

  Future<void> _toggleInterest() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final uid = authService.currentUserId;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você precisa estar logado')),
      );
      return;
    }

    setState(() => _isLoadingInterest = true);

    try {
      if (_hasInterest) {
        await _interestService.removeInterest(
          userId: uid,
          bookId: widget.book.id,
        );

        if (mounted) {
          setState(() {
            _hasInterest = false;
            _interestCount = _interestCount > 0 ? _interestCount - 1 : 0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Interesse cancelado'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        final user = await _userService.getUser(uid);

        if (user == null) {
          throw 'Usuário não encontrado';
        }

        await _interestService.addInterest(
          bookId: widget.book.id,
          bookTitle: widget.book.title,
          userId: uid,
          userName: user.displayName,
          userEmail: user.email,
          ownerId: widget.book.userId,
        );

        if (mounted) {
          setState(() {
            _hasInterest = true;
            _interestCount++;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Interesse demonstrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingInterest = false);
      }
    }
  }

  Future<void> _loadInterests() async {
    try {
      final interests = await _interestService.getBookInterests(widget.book.id);
      if (mounted) {
        setState(() {
          _interests = interests;
          _interestCount = interests.length;
        });
      }
    } catch (e) {
      // Ignorar erro
    }
  }

  Future<void> _handleMeLivrar() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar como Livrado'),
        content: const Text(
          'Tem certeza que deseja marcar este livro como livrado? '
              'Ele não aparecerá mais como disponível para outros usuários.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _bookService.updateBookStatus(widget.book.id, 'unavailable');

        if (mounted) {
          setState(() => _isLivrado = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Livro marcado como livrado!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showInterestedUsers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pessoas interessadas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_interests.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'Nenhuma pessoa demonstrou interesse ainda',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _interests.length,
                  itemBuilder: (context, index) {
                    final interest = _interests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFC85C48),
                          child: Text(
                            interest['userName'][0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          interest['userName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(interest['userEmail']),
                        trailing: IconButton(
                          icon: const Icon(Icons.email),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Email: ${interest['userEmail']}'),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5EFE6), Color(0xFFEFE2CF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        if (widget.book.title != null)
                          Text(
                            widget.book.title!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A2A2A),
                            ),
                          ),
                        const SizedBox(height: 4),

                        if (widget.book.author != null)
                          Text(
                            widget.book.author!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF8B8680),
                            ),
                          ),
                        const SizedBox(height: 20),

                        Center(
                          child: Container(
                            width: 348,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                widget.book.coverUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (!widget.isOwner) ...[
                          SizedBox(
                            width: 348,
                            child: ElevatedButton(
                              onPressed: _isLoadingInterest ? null : _toggleInterest,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _hasInterest
                                    ? const Color(0xFF95A99A)
                                    : const Color(0xFFC85C48),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isLoadingInterest)
                                    const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  else ...[
                                    Icon(
                                      _hasInterest ? Icons.check : Icons.favorite_border,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _hasInterest
                                          ? 'Já demonstrei interesse'
                                          : 'Demonstrar interesse${_interestCount > 0 ? " ($_interestCount)" : ""}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          SizedBox(
                            width: 348,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFC85C48),
                                side: const BorderSide(
                                  color: Color(0xFFC85C48),
                                ),
                                backgroundColor: const Color(0xFFFAF7F2),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/chat_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24 1.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Entrar em contato',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(
                            width: 348,
                            child: ElevatedButton(
                              onPressed: _isLivrado ? null : _handleMeLivrar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLivrado
                                    ? const Color(0xFF95A99A)
                                    : const Color(0xFFC85C48),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(_isLivrado ? Icons.check_circle : Icons.check, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isLivrado ? 'Já foi livrado' : 'Me livrar',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (_interestCount > 0) ...[
                            OutlinedButton(
                              onPressed: _showInterestedUsers,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: Color(0xFFC85C48), width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.people,
                                    color: Color(0xFFC85C48),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ver interessados ($_interestCount)',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC85C48),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          SizedBox(
                            width: 348,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFC85C48),
                                side: const BorderSide(
                                  color: Color(0xFFC85C48),
                                ),
                                backgroundColor: const Color(0xFFFAF7F2),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/list_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24 1.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Ver lista de interessados',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/close_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24 1 (1).svg',
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações do livro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2A2A2A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (widget.book.title != null)
                      _InfoItem('Título', widget.book.title!),
                    if (widget.book.author != null)
                      _InfoItem('Autor', widget.book.author!),
                    if (widget.book.publisher != null)
                      _InfoItem('Editora', widget.book.publisher!),
                    if (widget.book.genre != null)
                      _InfoItem('Gênero', widget.book.genre!),
                    if (widget.book.condition != null)
                      _InfoItem('Condições do livro', widget.book.condition!),
                    if (widget.book.description != null)
                      _InfoItem('Descrição', widget.book.description!),

                    if (widget.isOwner) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC85C48),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/edit_24dp_E3E3E3_FILL0_wght400_GRAD0_opsz24 1.svg',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Editar informações do livro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFC85C48),
                            side: const BorderSide(color: Color(0xFFC85C48)),
                            backgroundColor: const Color(0xFFFAF7F2),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/delete_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24 (1) 1.svg',
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Deletar meu livro',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B8680),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2A2A2A),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}