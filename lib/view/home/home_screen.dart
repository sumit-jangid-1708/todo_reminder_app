// lib/view/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_reminder/res/color/app_color.dart';
import 'package:todo_reminder/res/components/custom_button.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import '../../res/assets/images_assets.dart';
import '../../res/components/widgets/home_widgets/home_header_widget.dart';
import '../../res/components/widgets/home_widgets/transaction_card.dart';
import '../../res/components/widgets/home_widgets/weekly_calander_widget.dart';
import '../../view_models/controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Fixed Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  HomeHeader(userName: controller.userName),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // ✅ Scrollable Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
                color: AppColors.primary,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekly Calendar
                      const SizedBox(height: 10),
                      _buildHeader(controller),
                      const SizedBox(height: 8),
                      const WeeklyCalendar(),

                      const SizedBox(height: 10),

                      // Filter Chips
                      _buildFilterChips(controller),

                      const SizedBox(height: 20),

                      // ✅ Contacts List or Empty State
                      Obx(() => controller.hasTransactions
                          ? _buildContactsList(controller)
                          : _buildEmptyState()),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
        child: Row(
          children: [
            // Creditors / Debitors Switch
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.darkGray, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Creditors Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.isCreditor.value = true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            Obx(
                                  () => Text(
                                "Creditors",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: controller.isCreditor.value
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: controller.isCreditor.value
                                      ? AppColors.black
                                      : AppColors.text1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Obx(
                                  () => Container(
                                height: 2.5,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: controller.isCreditor.value
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Divider
                    Container(
                      width: 1,
                      height: 25,
                      color: AppColors.darkGray,
                    ),

                    // Debitors Tab
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.isCreditor.value = false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            Obx(
                                  () => Text(
                                "Debitors",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: !controller.isCreditor.value
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: !controller.isCreditor.value
                                      ? AppColors.black
                                      : AppColors.text1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Obx(
                                  () => Container(
                                height: 2.5,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: !controller.isCreditor.value
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Add Button
            CustomButton(
              onPressed: () {
                Get.toNamed(RouteName.addPersonForm);
              },
              height: 50,
              width: 50,
              icon: Icons.note_add_outlined,
              iconColor: AppColors.white,
              iconSize: 24,
              borderRadius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Helper Widgets ====================

Widget _buildHeader(HomeController controller) {
  return Obx(
        () => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${controller.weekDay.value}.',
          style: const TextStyle(
            fontSize: 50,
            color: AppColors.black,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${controller.month.value} ${controller.date.value}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              controller.year.value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildFilterChips(HomeController controller) {
  return SizedBox(
    height: 40,
    child: Obx(() => ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.filters.length,
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        String filterName = controller.filters[index];
        bool isActive = controller.selectedFilter.value == filterName;

        return GestureDetector(
          onTap: () => controller.onFilterChipTap(filterName),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.gray,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
                  : [],
            ),
            child: Center(
              child: Text(
                filterName,
                style: TextStyle(
                  color: isActive ? AppColors.white : AppColors.text1,
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    )),
  );
}

/// ✅ Contacts List (Updated to use ContactModel)
Widget _buildContactsList(HomeController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Section Title
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          'Recent',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ),

      // Contact Cards
      ...controller.currentList.map((contact) {
        return TransactionCard(
          personName: contact.name,
          amount: '₹${contact.pendingAmount}',
          status: contact.pendingAmount > 0 ? 'Due' : 'Paid',
          onTap: () => controller.onContactTap(contact), // ✅ Updated method
        );
      }).toList(),
    ],
  );
}

/// ✅ Empty State
Widget _buildEmptyState() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        children: [
          Image.asset(ImageAssets.emptyList, height: 100),
          const SizedBox(height: 5),
          const Text(
            "Nothing Here Yet",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Add your first transaction to start tracking who owes you and whom you owe.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}