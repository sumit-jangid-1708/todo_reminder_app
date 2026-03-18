import 'package:flutter/material.dart';
import 'package:todo_reminder/res/color/app_color.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool isPassword;
  final bool isValid;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines; // ✅ Fixed typo (was maxLine)
  final int? minLines; // ✅ Added minLines
  final TextAlign textAlign; // ✅ Added textAlign
  final bool enabled; // ✅ Added enabled
  final void Function(String)? onChanged; // ✅ Added onChanged

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isValid = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1, // ✅ Default 1 line
    this.minLines, // ✅ Optional minLines
    this.textAlign = TextAlign.start, // ✅ Default left align
    this.enabled = true, // ✅ Default enabled
    this.onChanged, // ✅ Optional callback
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscure : false,
          maxLines: widget.isPassword ? 1 : widget.maxLines, // ✅ Password always single line
          minLines: widget.minLines, // ✅ Added minLines
          textAlign: widget.textAlign, // ✅ Added textAlign
          enabled: widget.enabled, // ✅ Added enabled
          onChanged: widget.onChanged, // ✅ Added onChanged
          style: const TextStyle(fontSize: 15, color: AppColors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.enabled
                ? AppColors.white
                : Colors.grey.shade200, // ✅ Disabled color
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),

            // Suffix Icon Logic
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
                : (widget.isValid
                ? const Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 20,
            )
                : null),

            // Borders
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4A80F0),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder( // ✅ Added disabled border
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}