import 'package:flutter/material.dart';
import 'package:todo_reminder/res/color/app_color.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final Function(String?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    this.hint = "Select type",
    this.onChanged,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.white, // light grey
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkGray),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(
            widget.hint,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.black,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          items: widget.items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
        ),
      ),
    );
  }
}