// lib/res/app_url/app_url.dart

class AppUrl {
  static const String baseUrl = "https://todotransaction.testwebs.in/api";
  static const String baseUrl2 = "$baseUrl/auth";
  static const String localUrl = "https://everywhere-folk-funny-ontario.trycloudflare.com/api/auth";
  static const String localUrl2 = "https://everywhere-folk-funny-ontario.trycloudflare.com/api";
  static const String signIn = "$baseUrl2/sign-in";
  static const String signUp = "$baseUrl2/sign-up";
  static const String forgetPass = "$baseUrl2/forgot-password";
  static const String verifyOtp = "$baseUrl2/verify-otp";
  static const String resetPass = "$baseUrl2/reset-password";
  static const String logout = "$baseUrl2/logout";
  static const String transaction ="$baseUrl/transactions";
  static const String getAllTransaction = "$baseUrl/transactions";
  static const String reminders = "$baseUrl/reminders";

  static const String updateProfile = '$baseUrl2/update-profile';
  static const String deleteAccount = '$baseUrl2/delete-account';
  // Dynamic URLs
  static String getReminderById(int id) => "$reminders/$id";
  static String completeReminder(int id) => "$reminders/$id/complete";
  static String updateReminder(int id) => "$reminders/$id";
  static String deleteReminder(int id) => "$reminders/$id";

  static const String quickTransaction = "$baseUrl/quick/transaction";
  static const String getContacts = "$baseUrl/contacts";
  static const String statements = "$baseUrl/contacts";
  static const String contactsList = "$baseUrl/contacts-list";

  // ✅ NEW: Receivables and Payables
  static const String receivables = "$baseUrl/contacts/receivables";
  static const String payables = "$baseUrl/contacts/payables";

  static const String fcmToken = "$baseUrl/notifications/fcm-token";
  static const String googleLogin = "$baseUrl2/google-login";
}