import 'package:flutter/material.dart';
import '../Constants/app_colors.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: AppColors.brancoCreme,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_rounded,
              size: 48,
              color: AppColors.bordoLiterario,
            ),
            const SizedBox(height: 16),

            const Text(
              "Deletar perfil?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.carvaoSuave,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            const Text(
              "Essa ação é permanente e não poderá ser desfeita. "
                  "Deseja realmente apagar seu perfil?",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.cinzaPoeira,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bordoLiterario,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Sim, deletar",
                  style: TextStyle(
                    color: AppColors.brancoCreme,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.cinzaPoeira),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    color: AppColors.carvaoSuave,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
