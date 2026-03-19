import 'package:todo_reminder/data/network/network_api_service.dart';
import 'package:todo_reminder/res/app_url/app_url.dart';

class TransactionService {
  final NetworkApiService _apiService = NetworkApiService();

  Future<T> quickTransaction<T>(Map<String, dynamic> data) async{
    return await _apiService.postApi<T>(AppUrl.quickTransaction, data);
  }
}