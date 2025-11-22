import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.hintText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.carvaoSuave,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          obscureText: obscureText,
          validator: validator,
          keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
          textInputAction: maxLines > 1 ? TextInputAction.newline : textInputAction,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.cinzaPoeira),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.carvaoSuave, width: 0.5),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.ambarQuente),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.bordoLiterario),
            ),
            filled: true,
            fillColor: AppColors.brancoCreme,
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(color: AppColors.carvaoSuave),
        ),
      ],
    );
  }
}