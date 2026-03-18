import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:todo_reminder/res/routes/routes_names.dart';
import 'package:todo_reminder/view/auth/create_new_password_screen.dart';
import 'package:todo_reminder/view/auth/forget_screen.dart';
import 'package:todo_reminder/view/auth/otp_screen.dart';
import 'package:todo_reminder/view/auth/sign_in_screen.dart';
import 'package:todo_reminder/view/auth/sign_up_screen.dart';
import 'package:todo_reminder/view/create_reminder_form.dart';
import 'package:todo_reminder/view/delete_screen.dart';
import 'package:todo_reminder/view/help_and_support_screen.dart';
import 'package:todo_reminder/view/home/add_person_form.dart';
import 'package:todo_reminder/view/home/home_screen.dart';
import 'package:todo_reminder/view/payable_screen.dart';
import 'package:todo_reminder/view/payment_screen.dart';
import 'package:todo_reminder/view/person_profile_screen.dart';
import 'package:todo_reminder/view/profile_screen.dart';
import 'package:todo_reminder/view/receivable_screen.dart';
import 'package:todo_reminder/view/statement_screen.dart';
import 'package:todo_reminder/view/transaction_screen.dart';
import 'package:todo_reminder/view/welcome/welcome_screen.dart';

class AppRoutes {
  static List<GetPage> appRoute() => [
    GetPage(name: RouteName.welcome, page: () => WelcomeScreen()),
    GetPage(
      name: RouteName.signIn,
      page: () => SignInScreen(),
      // binding: DashboardBinding(),
    ),
    GetPage(name: RouteName.signUp, page: () => SignUpScreen()),
    GetPage(name: RouteName.forgetPassword, page: () => ForgetScreen()),
    GetPage(name: RouteName.otp, page: () => OtpScreen()),
    GetPage(
      name: RouteName.createNewPass,
      page: () => CreateNewPasswordScreen(),
    ),
    GetPage(name: RouteName.homeScreen, page: ()=> HomeScreen()),
    GetPage(name: RouteName.addPersonForm, page: ()=> AddPersonForm()),
    GetPage(name: RouteName.transactionScreen, page: ()=> TransactionScreen()),
    GetPage(name: RouteName.paymentScreen, page: ()=> PaymentScreen()),
    GetPage(name: RouteName.statementScreen, page: ()=> StatementScreen()),
    GetPage(name: RouteName.receivableScreen, page: ()=> ReceivableScreen()),
    GetPage(name: RouteName.payableScreen, page: ()=> PayableScreen()),
    GetPage(name: RouteName.profileScreen, page: ()=> ProfileScreen()),
    GetPage(name: RouteName.deleteScreen, page: ()=> DeleteScreen()),
    GetPage(name: RouteName.helpScreen, page: ()=> HelpAndSupportScreen()),
    GetPage(name: RouteName.personProfile, page: ()=>PersonProfileScreen()),
    GetPage(name: RouteName.createReminder, page: ()=>CreateReminderForm()),
  ];
}
