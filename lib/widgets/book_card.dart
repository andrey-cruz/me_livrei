import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';

class BookCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 4, 0),
        width: 180,
        height: 292,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl,
                width: 180,
                height: 240,
                fit: BoxFit.cover,
                loadingBuilder:
                    (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        width: 180,
                        height: 240,
                        color: Colors.grey[200],
                        // Cor de fundo
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: AppColors.cinzaPoeira, // Cor do loading
                        ),
                      );
                    },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Container(
                    width: 180,
                    height: 240,
                    color: Colors.grey[200], // Cor de fundo
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined, // Ícone de erro
                      color: AppColors.cinzaPoeira, // Cor do ícone
                      size: 48,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: AppColors.carvaoSuave),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                author,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12, color: AppColors.cinzaPoeira),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
