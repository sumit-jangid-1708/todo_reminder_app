// lib/res/languages/languages.dart

import 'package:get/get.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': _enUS,
    'hi_IN': _hiIN,
  };

  static const Map<String, String> _enUS = {
    // Auth
    'email': 'Email',
    'password': 'Password',
    'login': 'Login',
    'logout': 'Logout',
    'auth': 'Authentication',

    // Screens
    'home': 'Home Screen',
    'splash_screen': 'Hello\nWelcome to our app',

    // Exceptions
    'internet_exception':
    'We are unable to show results.\nPlease check your internet connection.',
    'request_timeout': 'Request timed out. Please try again.',
    'bad_request': 'Invalid request. Please check your input.',
    'unauthorized': 'Session expired. Please login again.',
    'server_error': 'Server error. Please try again later.',
    'fetch_error': 'Failed to fetch data.',
    'not_found': 'Resource not found.',
    'unknown_error': 'Something went wrong.',

    // General
    'error': 'Error',
    'success': 'Success',
    'confirm': 'Confirm',
    'cancel': 'Cancel',
    'ok': 'OK',
    'please_wait': 'Please wait...',
    'are_you_sure': 'Are you sure?',
  };

  static const Map<String, String> _hiIN = {
    // Auth
    'email': 'ईमेल',
    'password': 'पासवर्ड',
    'login': 'लॉगिन',
    'logout': 'लॉग आउट',
    'auth': 'प्रमाणीकरण',

    // Screens
    'home': 'होम स्क्रीन',
    'splash_screen': 'नमस्ते\nहमारे ऐप में आपका स्वागत है',

    // Exceptions
    'internet_exception':
    'हम परिणाम दिखाने में असमर्थ हैं।\nकृपया अपना इंटरनेट कनेक्शन जांचें।',
    'request_timeout': 'अनुरोध समय समाप्त। कृपया पुनः प्रयास करें।',
    'bad_request': 'अमान्य अनुरोध। कृपया अपनी जानकारी जांचें।',
    'unauthorized': 'सत्र समाप्त। कृपया फिर से लॉगिन करें।',
    'server_error': 'सर्वर त्रुटि। कृपया बाद में पुनः प्रयास करें।',
    'fetch_error': 'डेटा प्राप्त करने में विफल।',
    'not_found': 'संसाधन नहीं मिला।',
    'unknown_error': 'कुछ गलत हो गया।',

    // General
    'error': 'त्रुटि',
    'success': 'सफलता',
    'confirm': 'पुष्टि करें',
    'cancel': 'रद्द करें',
    'ok': 'ठीक है',
    'please_wait': 'कृपया प्रतीक्षा करें...',
    'are_you_sure': 'क्या आप सुनिश्चित हैं?',
  };
}