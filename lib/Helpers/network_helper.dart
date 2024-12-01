import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

Future<bool> checkInternet() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
  if (connectivityResult.last == ConnectivityResult.mobile ||
      connectivityResult.last == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

Dio getDio() {
  Dio dio = Dio();
  dio.options.followRedirects = false;
  dio.options.validateStatus = (status) {
    return status! <= 500;
  };
  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers['Accept'] = 'application/json';
  // Session data is not needed
  // if (SessionData().token != null) {
  //   dio.options.headers['Authorization'] = 'Bearer ' + SessionData().token!;
  // }
  dio.options.responseType = ResponseType.json;

  return dio;
}
