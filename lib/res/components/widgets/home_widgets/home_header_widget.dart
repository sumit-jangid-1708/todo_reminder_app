// lib/view/home/widgets/home_header.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import '../../../color/app_color.dart';
import '../../../../view_models/controller/auth_controller.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // ✅ Avatar — shows image if available, fallback to icon
            InkWell(
              onTap: () => Get.toNamed(RouteName.profileScreen),
              borderRadius: BorderRadius.circular(50),
              child: Obx(() {
                final avatarUrl = authController.profileAvatarUrl.value;

                return Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: ClipOval(
                    child: avatarUrl.isNotEmpty
                        ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person_outline,
                        color: AppColors.white,
                        size: 26,
                      ),
                    )
                        : const Icon(
                      Icons.person_outline,
                      color: AppColors.white,
                      size: 26,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(width: 12),

            // Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}