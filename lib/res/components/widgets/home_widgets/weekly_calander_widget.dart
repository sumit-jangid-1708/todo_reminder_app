// lib/res/components/widgets/home_widgets/weekly_calander_widget.dart

import 'package:awesome_calendart/awesome_calendart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_reminder/res/components/custom_button.dart';
import 'package:todo_reminder/res/components/widgets/home_widgets/reminder_action_dialog.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view_models/controller/reminder_controller.dart';
import '../../../color/app_color.dart';
import '../../../../view_models/controller/home_controller.dart';

class WeeklyCalendar extends StatelessWidget {
  const WeeklyCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final ReminderController reminderController = Get.put(ReminderController());

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.darkGray,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Section: Icon and Create Reminder Button
          _buttonsCalaRem(reminderController),
          const SizedBox(height: 10),

          // Middle Section: Week Days Row
          _buildWeekDaysRow(reminderController),

          const SizedBox(height: 10),

          // Tabs Section: Todo, Complete, Pending
          _buildTabs(homeController),

          const SizedBox(height: 10),

          // Reactive Task List based on selected tab
          Obx(() => _buildTaskList(
            homeController.selectedTab.value,
            reminderController,
          )),
        ],
      ),
    );
  }

  Widget _buttonsCalaRem(ReminderController reminderController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          onPressed: () {
            // ✅ Reminder dates ko EventMarker me convert karo
            final List<DateTime> reminderDates = reminderController
                .allReminders
                .map((r) {
              try {
                return DateTime.parse(r.reminderDate);
              } catch (e) {
                return null;
              }
            })
                .whereType<DateTime>()
                .toList();

            Get.dialog(
              Dialog(
                child: SizedBox(
                  height: 300,
                  child: AwesomeCalenDart(
                    elevation: 5,
                    borderRadius: 20,
                    locale: LocaleType.en,
                    displayFullMonthName: true,
                    theme: LightTheme(),
                    // ✅ Reminder dates highlight hongi
                    eventMarkers: reminderDates,
                  ),
                ),
              ),
            );
          },
          height: 35,
          width: 35,
          icon: Icons.calendar_today,
          iconSize: 18,
          iconColor: AppColors.white,
        ),

        CustomButton(
          onPressed: () {
            Get.find<ReminderController>().clearForm();
            Get.toNamed(RouteName.createReminder);
          },
          height: 38,
          width: 150,
          borderRadius: 50,
          backgroundColor: AppColors.white,
          borderColor: AppColors.black.withOpacity(0.5),
          icon: Icons.add,
          iconSize: 14,
          fontSize: 12,
          iconColor: AppColors.black,
          text: "Create Reminder",
          textColor: AppColors.black,
        ),
      ],
    );
  }

  Widget _buildWeekDaysRow(ReminderController reminderController) {
    return Obx(() {
      // Generate current week days
      final now = DateTime.now();
      final List<Map<String, dynamic>> weekDays = [];

      for (int i = 0; i < 7; i++) {
        final day = now.add(Duration(days: i - now.weekday + 1));
        final dayStr = DateFormat('EEE').format(day);
        final dateStr = day.day.toString();
        final fullDate = DateFormat('yyyy-MM-dd').format(day);

        // Check if this day has reminders
        final hasReminder = reminderController.pendingReminders.any((reminder) {
          return reminder.reminderDate == fullDate;
        });

        String type = 'none';
        if (day.day == now.day && day.month == now.month) {
          type = 'current';
        } else if (hasReminder) {
          type = 'reminder';
        }

        weekDays.add({
          'day': dayStr,
          'date': dateStr,
          'type': type,
        });
      }

      return SizedBox(
        height: 85,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: weekDays.length,
          itemBuilder: (context, index) {
            final dayData = weekDays[index];
            final String type = dayData['type'];

            Color bgColor = Colors.transparent;
            Color textColor = AppColors.primaryDark;
            Color dayColor = AppColors.text1;

            if (type == 'current') {
              bgColor = AppColors.lightBlue;
            } else if (type == 'reminder') {
              bgColor = AppColors.primary;
              textColor = AppColors.white;
              dayColor = AppColors.white;
            }

            return Container(
              width: 52,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayData['day'],
                    style: TextStyle(
                      fontSize: 12,
                      color: dayColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayData['date'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildTabs(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Obx(
            () => Row(
          children: [
            _buildSingleTab(
              label: 'Todo',
              icon: Icons.calendar_month_outlined,
              isActive: controller.selectedTab.value == 0,
              onTap: () => controller.selectedTab.value = 0,
            ),
            _buildSingleTab(
              label: 'Complete',
              icon: Icons.check_circle_outline,
              isActive: controller.selectedTab.value == 1,
              onTap: () => controller.selectedTab.value = 1,
            ),
            _buildSingleTab(
              label: 'Pending',
              icon: Icons.access_time,
              isActive: controller.selectedTab.value == 2,
              onTap: () => controller.selectedTab.value = 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleTab({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? Colors.white : const Color(0xFF757575),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFF757575),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(int selectedIndex, ReminderController reminderController) {
    List<dynamic> reminders = [];

    switch (selectedIndex) {
      case 0: // Todo
        reminders = reminderController.getTodoReminders();
        break;
      case 1: // Complete
        reminders = reminderController.getCompleteReminders();
        break;
      case 2: // Pending
        reminders = reminderController.getPendingReminders();
        break;
    }

    if (reminders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'No reminders',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: reminders.map((reminder) {
        return _buildTaskItem(reminder, reminderController);
      }).toList(),
    );
  }

  Widget _buildTaskItem(dynamic reminder, ReminderController reminderController) {
    final date = DateFormat('EEE, dd').format(DateTime.parse(reminder.reminderDate));
    final title = '${reminder.title} - ₹${reminder.amount}';

    return GestureDetector(
      onTap: () {
        // Show action dialog
        Get.dialog(
          ReminderActionDialog(reminder: reminder),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF212121),
            ),
          ],
        ),
      ),
    );
  }
}




// // lib/view/home/widgets/weekly_calendar.dart
// import 'package:awesome_calendart/awesome_calendart.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:todo_reminder/res/components/custom_button.dart';
// import 'package:todo_reminder/res/routes/routes_names.dart';
// import '../../../../view_models/controller/home_controller.dart';
// import '../../../color/app_color.dart';
//
// class WeeklyCalendar extends StatelessWidget {
//   const WeeklyCalendar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.find<HomeController>();
//
//     return Container(
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.darkGray,
//           width: 1.5,
//         ), // Subtle border
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.black.withOpacity(0.03),
//             blurRadius: 10,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           // Top Section: Icon and Create Reminder Button
//           _buttonsCalaRem(),
//           const SizedBox(height: 10),
//           // Middle Section: Week Days Row
//           _buildWeekDaysRow(),
//
//           const SizedBox(height: 10),
//
//           // Tabs Section: Todo, Complete, Pending
//           _buildTabs(controller),
//
//           const SizedBox(height: 10),
//
//           // Reactive Task List based on selected tab
//           Obx(() => _buildTaskList(controller.selectedTab.value)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buttonsCalaRem() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Blue square icon box
//         CustomButton(
//           onPressed: () {
//             Get.dialog(
//               Dialog(
//                 // backgroundColor: Colors.white,
//                 // insetPadding: EdgeInsets.all(16),
//                 // shape: RoundedRectangleBorder(
//                 //   borderRadius: BorderRadius.circular(20),
//                 // ),
//                 child: SizedBox(
//                   // padding: EdgeInsets.all(16),
//                   height: 300,
//                   child: AwesomeCalenDart(
//                     elevation: 5,
//                     borderRadius: 20,
//                     locale: LocaleType.en,
//                     displayFullMonthName: true,
//                     theme: LightTheme(),
//                     eventMarkers: [],
//                   ),
//                 ),
//               ),
//             );
//           },
//           height: 35,
//           width: 35,
//           icon: Icons.calendar_today,
//           iconSize: 18,
//           iconColor: AppColors.white,
//         ),
//
//         // Dashed border style button logic
//         CustomButton(
//           onPressed: () {
//             Get.toNamed(RouteName.createReminder);
//           },
//           height: 38,
//           width: 150,
//           borderRadius: 50,
//           backgroundColor: AppColors.white,
//           borderColor: AppColors.black.withOpacity(0.5),
//           icon: Icons.add,
//           iconSize: 14,
//           fontSize: 12,
//           iconColor: AppColors.black,
//           text: "Create Reminder",
//           textColor: AppColors.black,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildWeekDaysRow() {
//     // Data exactly as per image
//     final List<Map<String, dynamic>> weekDays = [
//       {'day': 'MO', 'date': '12', 'type': 'none'},
//       {'day': 'Tue', 'date': '13', 'type': 'current'},
//       {'day': 'Wed', 'date': '14', 'type': 'reminder'},
//       {'day': 'Thu', 'date': '15', 'type': 'none'},
//       {'day': 'Fri', 'date': '16', 'type': 'reminder'},
//       {'day': 'Sat', 'date': '17', 'type': 'none'},
//       {'day': 'sun', 'date': '18', 'type': 'none'},
//     ];
//
//     return SizedBox(
//       height: 85,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: weekDays.length,
//         itemBuilder: (context, index) {
//           final dayData = weekDays[index];
//           final String type = dayData['type'];
//
//           Color bgColor = Colors.transparent;
//           Color textColor = AppColors.primaryDark;
//           Color dayColor = AppColors.text1;
//
//           if (type == 'current') {
//             bgColor = AppColors.lightBlue; // Light blue
//           } else if (type == 'reminder') {
//             bgColor = AppColors.primary; // Selected blue
//             textColor = AppColors.white;
//             dayColor = AppColors.white;
//           }
//
//           return Container(
//             width: 52,
//             margin: const EdgeInsets.symmetric(horizontal: 4),
//             decoration: BoxDecoration(
//               color: bgColor,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   dayData['day'],
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: dayColor,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   dayData['date'],
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTabs(HomeController controller) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F6F8), // Background shade
//         borderRadius: BorderRadius.circular(50),
//         border: Border.all(color: Colors.grey.withOpacity(0.1)),
//       ),
//       child: Obx(
//         () => Row(
//           children: [
//             _buildSingleTab(
//               label: 'Todo',
//               icon: Icons.calendar_month_outlined,
//               isActive: controller.selectedTab.value == 0,
//               onTap: () => controller.selectedTab.value = 0,
//             ),
//             _buildSingleTab(
//               label: 'Complete',
//               icon: Icons.check_circle_outline,
//               isActive: controller.selectedTab.value == 1,
//               onTap: () => controller.selectedTab.value = 1,
//             ),
//             _buildSingleTab(
//               label: 'Pending',
//               icon: Icons.access_time,
//               isActive: controller.selectedTab.value == 2,
//               onTap: () => controller.selectedTab.value = 2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSingleTab({
//     required String label,
//     required IconData icon,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             color: isActive ? AppColors.primary : Colors.transparent,
//             borderRadius: BorderRadius.circular(30),
//             boxShadow: isActive
//                 ? [
//                     BoxShadow(
//                       color: AppColors.primary.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 icon,
//                 size: 16,
//                 color: isActive ? Colors.white : const Color(0xFF757575),
//               ),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
//                   color: isActive ? Colors.white : const Color(0xFF757575),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTaskList(int selectedIndex) {
//     if (selectedIndex != 0) return const SizedBox();
//     return Column(
//       children: [
//         _buildTaskItem('Wed, 14', 'EMI Payment - ₹4,802'),
//         const SizedBox(height: 8),
//         _buildTaskItem('Wed, 16', 'EMI Payment - ₹4,802'),
//       ],
//     );
//   }
//
//   Widget _buildTaskItem(String date, String title) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 date,
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF212121),
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
//               ),
//             ],
//           ),
//           const Icon(
//             Icons.arrow_forward_ios,
//             size: 14,
//             color: Color(0xFF212121),
//           ),
//         ],
//       ),
//     );
//   }
// }
