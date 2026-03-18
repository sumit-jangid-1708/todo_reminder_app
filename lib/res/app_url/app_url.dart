class AppUrl {
  static const String baseUrl = "https://www.appUrl.com/api/v1/";
  static const String localUrl = "https://nearly-trustee-movements-freeware.trycloudflare.com/api/auth";
  static const String localUrl2 = "https://nearly-trustee-movements-freeware.trycloudflare.com/api";
  static const String signIn = "$localUrl/sign-in";
  static const String signUp = "$localUrl/sign-up";
  static const String forgetPass = "$localUrl/forgot-password";
  static const String verifyOtp = "$localUrl/verify-otp";
  static const String resetPass = "$localUrl/reset-password";
  static const String logout = "$localUrl/logout";
  static const String transaction ="$localUrl2/transactions";
  static const String getAllTransaction = "$localUrl2/transactions";
  static const String reminders = "$localUrl2/reminders";

  // Dynamic URLs
  static String getReminderById(int id) => "$reminders/$id";
  static String completeReminder(int id) => "$reminders/$id/complete";
  static String updateReminder(int id) => "$reminders/$id";
  static String deleteReminder(int id) => "$reminders/$id";

  static const String fcmToken = "$localUrl2/notifications/fcm-token";
}