import 'package:todo_reminder/data/network/network_api_service.dart';

import '../../res/app_url/app_url.dart';

class HomeService {
  final NetworkApiService _apiService = NetworkApiService();

  Future<T> addTransaction<T>(Map<String, dynamic> data) async {
    return await _apiService.postApi<T>(
      AppUrl.transaction,
      data,
    );
  }

  Future<T> getAllTransactions<T>() async {
    return await _apiService.getApi<T>(
      AppUrl.getAllTransaction,
    );
  }

  Future<T> getContacts<T>()async{
    return await _apiService.getApi<T>(AppUrl.getContacts);
  }

}