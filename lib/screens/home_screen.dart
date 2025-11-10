import 'package:flutter/material.dart';
import 'package:me_livrei/constants/app_colors.dart';

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
      body: Column(
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
                  prefixIcon: Icon(Icons.search, color: AppColors.cinzaPoeira),
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
                Icon(Icons.show_chart, size: 24, color: AppColors.terracotaQueimado),
                SizedBox(width: 8,),
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
        ],
      ),
    );
  }
}
