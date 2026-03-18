
import 'package:todo_reminder/data/network/network_api_service.dart';
import '../../res/app_url/app_url.dart';

class FcmService {
  final NetworkApiService _apiService = NetworkApiService();

  /// Send FCM Token to Server
  Future<T> sendFcmToken<T>(String fcmToken) async {
    return await _apiService.postApi<T>(
      AppUrl.fcmToken,
      {"fcm_token": fcmToken},
    );
  }
}