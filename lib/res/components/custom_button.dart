import 'package:flutter/material.dart';
import 'package:todo_reminder/res/styles/app_text_styles.dart';
import '../color/app_color.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback? onPressed;
  final double? width;
  final double height;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color? borderColor; // Naya parameter border color ke liye
  final double borderWidth; // Naya parameter border width ke liye
  final double fontSize;
  final bool isLoading;
  final double iconSize;
  final double spacing;

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    this.iconWidget,
    required this.onPressed,
    this.width,
    this.height = 45,
    this.borderRadius = 8,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.white,
    this.iconColor = AppColors.white,
    this.borderColor, // Default null rahega
    this.borderWidth = 1.0,
    this.fontSize = 14,
    this.isLoading = false,
    this.iconSize = 20,
    this.spacing = 6,
  }) : assert(text != null || icon != null,
  "Either text or icon must be provided");

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          padding: EdgeInsets.zero, // 🔥 important
          minimumSize: Size.zero,   // 🔥 important
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: borderWidth)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconWidget != null)
              Padding(
                padding: EdgeInsets.only(right: text != null ? spacing : 0),
                child: iconWidget,
              )
            else if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            if (icon != null && text != null)
              SizedBox(width: spacing),
            if (text != null)
              Text(
                text!,
                style: AppTextStyles.button.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}