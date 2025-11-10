// 📘 lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 🎯 MUDANÇA: Convertido para StatefulWidget
class BookDetailScreen extends StatefulWidget {
  final Book book;
  final bool isOwner;

  const BookDetailScreen({Key? key, required this.book, this.isOwner = false})
    : super(key: key);

  @override
  // 🎯 MUDANÇA: Adicionado o método createState
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

// 🎯 MUDANÇA: Criada a classe State
class _BookDetailScreenState extends State<BookDetailScreen> {
  // 🎯 MUDANÇA: Variável de estado para controlar o status
  bool _isLivrado = false;

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
              // ============================================================
              // 🟤 CABEÇALHO (título, autor, imagem e botões principais)
              // ============================================================
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // 🎯 MUDANÇA: Usando 'widget.book' para acessar o livro
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

                        // 🎯 MUDANÇA: Usando 'widget.book'
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
                              // 🎯 MUDANÇA: Usando 'widget.book'
                              child: Image.asset(
                                widget.book.coverUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ============================================================
                        // 🔵 BOTÕES DE AÇÃO (usuário comum ou dono)
                        // ============================================================

                        // 🎯 MUDANÇA: Usando 'widget.isOwner'
                        if (!widget.isOwner) ...[
                          // ===== INÍCIO: VISÃO DO USUÁRIO COMUM =====
                          SizedBox(
                            width: 348,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC85C48),
                                foregroundColor: Colors.white,
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
                                    'assets/icons/bookmark_add_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24 1.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Demonstrar Interesse',
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

                          // ===== INÍCIO: Entrar em contato =====
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
                          // ===== FIM: Entrar em contato =====
                          // ===== FIM: VISÃO DO USUÁRIO COMUM =====
                        ] else ...[
                          // ===== INÍCIO: VISÃO DO DONO DO LIVRO =====
                          SizedBox(
                            width: 348,
                            child: ElevatedButton(
                              // 🎯 MUDANÇA: Ação do botão
                              onPressed: _isLivrado
                                  ? null // Desabilitado se já foi "Livrado"
                                  : () {
                                      setState(() {
                                        _isLivrado = true;
                                        // TODO: Adicionar aqui a lógica para
                                        // atualizar o status no Firebase
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                // 🎯 MUDANÇA: Cor de fundo dinâmica
                                backgroundColor: _isLivrado
                                    ? const Color(
                                        0xFFEACDBE,
                                      ) // ✅ Sua cor "Livrado"
                                    : const Color(0xFFC85C48), // Cor padrão
                                // 🎯 MUDANÇA: Cor do texto dinâmica
                                foregroundColor: _isLivrado
                                    ? Colors
                                          .white // ✅ Cor do texto "Livrado"
                                    : Colors.white, // Cor padrão
                                // Cor quando desabilitado (para garantir)
                                disabledBackgroundColor: const Color(
                                  0xFFEACDBE,
                                ),
                                disabledForegroundColor: Colors.white,
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
                                    'assets/icons/check_24dp_E3E3E3_FILL1_wght400_GRAD0_opsz24 1.svg',
                                    height: 20,
                                    width: 20,
                                    // 🎯 MUDANÇA: Cor do ícone
                                    colorFilter: ColorFilter.mode(
                                      _isLivrado
                                          ? Colors
                                                .white // ✅ Cor do ícone "Livrado"
                                          : Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // 🎯 MUDANÇA: Texto dinâmico
                                  Text(
                                    _isLivrado ? 'Livrado' : 'Me livrar',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // ===== INÍCIO: BOTÃO Ver lista de interessados =====
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
                          // ===== FIM: BOTÃO Ver lista de interessados =====
                          // ===== FIM: VISÃO DO DONO DO LIVRO =====
                        ],
                      ],
                    ),
                  ),
                  // ===== FIM: Container principal =====

                  // ===== INÍCIO: Ícone de fechar =====
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
                  // ===== FIM: Ícone de fechar =====
                ],
              ),

              // ============================================================
              // 🟢 SEÇÃO DE INFORMAÇÕES DO LIVRO
              // ============================================================
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

                    // 🎯 MUDANÇA: Usando 'widget.book'
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

                    // ============================================================
                    // 🔴 BOTÕES DE EDIÇÃO E EXCLUSÃO NO FINAL
                    // ============================================================
                    // 🎯 MUDANÇA: Usando 'widget.isOwner'
                    if (widget.isOwner) ...[
                      const SizedBox(height: 10),
                      // ===== INÍCIO: Botão editar informações =====
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

                      // ===== FIM: Botão editar informações =====
                      const SizedBox(height: 12),

                      // ===== INÍCIO: Botão deletar =====
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
                      // ===== FIM: Botão deletar =====
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // ===== FIM: Conteúdo rolável =====
    );
  }
}

// ============================================================
// 🔸 COMPONENTE: Linhas de informações
// ============================================================
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
