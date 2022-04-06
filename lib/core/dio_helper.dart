import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://api.musixmatch.com/ws/1.1/',
          receiveDataWhenStatusError: true),
    );
  }

  static Future<Response> getData({
    String? url,
    String? trackId,
  }) async {
    return await dio!.get(
      url!,
      queryParameters: {
        'apikey': '2d782bc7a52a41ba2fc1ef05b9cf40d7',
        'track_id': trackId,
      },
    );
  }
}
