import 'package:flutter/material.dart';
import '../models/interested_user.dart';
// Se você quiser usar suas cores padrões, importe:
// import '../constants/app_colors.dart';

class InterestedUsersScreen extends StatelessWidget {
  const InterestedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados simulados (Mock Data)
    final List<InterestedUser> interestedUsers = [
      InterestedUser(name: 'Andrey Cruz', timeSince: 'há 5 dias'),
      InterestedUser(name: 'Hermione Granger', timeSince: 'há 10 dias'),
      InterestedUser(name: 'Kamily Cúrcio', timeSince: 'há 10 dias'),
    ];

    // Cores definidas pelo seu amigo (Idealmente mover para AppColors)
    const Color backgroundColor = Color(0xFFF7F2E9);
    const Color primaryColor = Color(0xFF424242);
    const Color iconColor = Color(0xFFB71C1C);
    const Color lightTextColor = Color(0xFFAAAAAA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),

              // Título
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Lista de Interessados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Subtítulo com RichText
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Livro\n',
                        style: TextStyle(
                          fontSize: 14,
                          color: lightTextColor,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'O Pequeno Príncipe',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lista Branca com Sombra
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Cabeçalho da Lista interna
                      _buildListHeader(primaryColor, interestedUsers.length),
                      Divider(height: 1, color: Colors.grey[200]),

                      // ListView Builder
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: interestedUsers.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            indent: 60,
                            endIndent: 15,
                            color: Colors.grey[200],
                          ),
                          itemBuilder: (context, index) {
                            return _UserListItem(
                              user: interestedUsers[index],
                              iconColor: iconColor,
                              primaryColor: primaryColor,
                              index: index,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botão de Fechar (X)
          const Positioned(
            top: 40,
            right: 10,
            child: CloseButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader(Color primaryColor, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Usuários',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '($count)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
          Icon(
            Icons.sort,
            color: primaryColor.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}

// Widget Privado para o item da lista (Extraído para organização)
class _UserListItem extends StatelessWidget {
  final InterestedUser user;
  final Color iconColor;
  final Color primaryColor;
  final int index;

  const _UserListItem({
    required this.user,
    required this.iconColor,
    required this.primaryColor,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Círculo com número
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.timeSince,
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}