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
      child: SizedBox(
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
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: AppColors.carvaoSuave),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 6),
            Text(
              author,
              style: TextStyle(fontSize: 12, color: AppColors.cinzaPoeira),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
