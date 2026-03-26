// lib/res/components/custom_profile_picker.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo_reminder/res/color/app_color.dart';

class CustomProfilePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onCameraTap;

  const CustomProfilePicker({
    super.key,
    this.imagePath,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // Profile Image Circle
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primary,
            backgroundImage: _getImageProvider(),
            child: imagePath == null || imagePath!.isEmpty
                ? const Icon(
              Icons.person,
              size: 55,
              color: Colors.white,
            )
                : null,
          ),

          // Camera Icon Button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onCameraTap,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 18,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    if (imagePath == null || imagePath!.isEmpty) {
      return null;
    }

    // Check if it's a local file path
    if (imagePath!.startsWith('/') || imagePath!.startsWith('C:')) {
      return FileImage(File(imagePath!));
    }

    // Otherwise treat as network URL
    return NetworkImage(imagePath!);
  }
}