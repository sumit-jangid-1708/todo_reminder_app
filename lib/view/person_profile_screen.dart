// lib/view/person_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_button.dart';
import 'package:todo_reminder/res/components/custom_textfield.dart';
import 'package:todo_reminder/view_models/controller/transaction_controller.dart';

import '../res/components/widgets/custom_profile_picker.dart';

class PersonProfileScreen extends StatefulWidget {
  const PersonProfileScreen({super.key});

  @override
  State<PersonProfileScreen> createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  late TransactionController controller;

  // Text controllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // The phone number for this contact (passed via Get.arguments or from controller)
  late String phone;

  @override
  void initState() {
    super.initState();

    controller = Get.find<TransactionController>();

    // Phone can come via Get.arguments OR from the controller (set in TransactionScreen)
    final args = Get.arguments as Map<String, dynamic>?;
    phone = args?['phone'] ?? controller.contactPhone;

    // Fetch the profile data
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    await controller.fetchContactProfile(phone);

    // Once loaded, populate the text fields
    final profile = controller.profileData.value;
    if (profile != null) {
      nameController.text = profile.name;
      addressController.text = profile.address ?? '';
    }
  }

  /// Opens bottom sheet to pick image from camera or gallery
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (file != null) {
                  controller.selectedAvatarFile.value = File(file.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? file = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (file != null) {
                  controller.selectedAvatarFile.value = File(file.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Confirm delete dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Contact',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${nameController.text}"? '
          'This will also delete all their transactions.',
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteContact(phone);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // ── Loading State ──────────────────────────────────────────
        if (controller.isLoadingProfile.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ── Populate fields once data arrives ──────────────────────
        final profile = controller.profileData.value;
        if (profile != null) {
          if (nameController.text.isEmpty) {
            nameController.text = profile.name;
          }
          if (addressController.text.isEmpty) {
            addressController.text = profile.address ?? '';
          }
        }

        // ── Content ───────────────────────────────────────────────
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Profile Image ────────────────────────────────────
              Obx(() {
                final pickedFile = controller.selectedAvatarFile.value;
                // Determine the image path to show:
                // 1. Newly picked file takes priority
                // 2. Existing avatar URL from API
                final String? imagePath = pickedFile != null
                    ? pickedFile.path
                    : profile?.avatarUrl;

                return CustomProfilePicker(
                  imagePath: imagePath,
                  onCameraTap: _pickImage,
                );
              }),

              const SizedBox(height: 32),

              // ── Balance Summary ──────────────────────────────────
              if (profile != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        'Given',
                        '₹${profile.totalGiven}',
                        AppColors.error,
                      ),
                      _buildDivider(),
                      _buildStat(
                        'Received',
                        '₹${profile.totalReceived}',
                        AppColors.success,
                      ),
                      _buildDivider(),
                      _buildStat(
                        profile.balanceType == 'settled'
                            ? 'Settled'
                            : profile.balanceType == 'you_will_pay'
                            ? 'You Pay'
                            : 'You Get',
                        profile.balanceType == 'settled'
                            ? '—'
                            : '₹${profile.balance}',
                        profile.balanceType == 'settled'
                            ? Colors.grey
                            : profile.balanceType == 'you_will_pay'
                            ? AppColors.error
                            : AppColors.success,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // ── Name Field ───────────────────────────────────────
              CustomTextField(
                controller: nameController,
                hintText: 'Enter name',
              ),

              const SizedBox(height: 24),

              const Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),

              // Phone (read-only)
              CustomTextField(
                controller: TextEditingController(text: phone),
                hintText: 'Phone number',
                keyboardType: TextInputType.phone,
                readOnly: true,
                suffixIcon: const Icon(
                  Icons.lock_outline,
                  size: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 14),

              // Address
              CustomTextField(
                controller: addressController,
                hintText: 'Enter address',
              ),

              const SizedBox(height: 28),

              // ── Delete Option ────────────────────────────────────
              Obx(
                () => InkWell(
                  onTap: controller.isDeletingContact.value
                      ? null
                      : _showDeleteConfirmation,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.isDeletingContact.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.redAccent,
                                ),
                              )
                            : const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                        const SizedBox(width: 8),
                        const Text(
                          'Delete Contact',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Save Button ──────────────────────────────────────
              Obx(
                () => CustomButton(
                  text: 'Save Changes',
                  onPressed: () {
                    controller.updateContactProfile(
                      phone: phone,
                      name: nameController.text,
                      address: addressController.text.trim().isEmpty
                          ? null
                          : addressController.text.trim(),
                      avatarFile: controller.selectedAvatarFile.value,
                    );
                  },
                  isLoading: controller.isSavingProfile.value,
                  backgroundColor: AppColors.primary,
                  textColor: Colors.white,
                  height: 55,
                  borderRadius: 30,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: Colors.grey.shade200);
  }
}
