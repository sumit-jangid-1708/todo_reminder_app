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
  final int maxLines;
  final int? minLines;
  final TextAlign textAlign;
  final bool enabled;
  final bool readOnly;           // ✅ NEW
  final Widget? suffixIcon;      // ✅ NEW
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.isPassword = false,
    this.isValid = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.textAlign = TextAlign.start,
    this.enabled = true,
    this.readOnly = false,        // ✅ Default false
    this.suffixIcon,              // ✅ Optional
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    // Suffix icon priority:
    // 1. Password toggle  2. Custom suffixIcon  3. isValid check icon
    Widget? resolvedSuffix;
    if (widget.isPassword) {
      resolvedSuffix = IconButton(
        icon: Icon(
          _obscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.primary,
          size: 20,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    } else if (widget.suffixIcon != null) {
      resolvedSuffix = widget.suffixIcon;
    } else if (widget.isValid) {
      resolvedSuffix = const Icon(
        Icons.check_circle_outline,
        color: AppColors.success,
        size: 20,
      );
    }

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
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          minLines: widget.minLines,
          textAlign: widget.textAlign,
          enabled: widget.enabled,
          readOnly: widget.readOnly, // ✅
          onChanged: widget.onChanged,
          style: TextStyle(
            fontSize: 15,
            color: (widget.readOnly || !widget.enabled)
                ? Colors.grey.shade600
                : AppColors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: (widget.readOnly || !widget.enabled)
                ? Colors.grey.shade100
                : AppColors.white,
            hintText: widget.hintText,
            hintStyle:
            TextStyle(color: Colors.grey.shade500, fontSize: 14),
            suffixIcon: resolvedSuffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: widget.readOnly
                  ? BorderSide(color: Colors.grey.shade200, width: 1)
                  : const BorderSide(color: Color(0xFF4A80F0), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1),
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