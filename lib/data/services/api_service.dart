import 'package:dio/dio.dart';

class ApiService {

  final Dio dio = Dio(
      BaseOptions(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    Future<List<dynamic>> fetchPhotos() async {
      final response = await dio.get('/photos?_limit=20');
      return response.data;
    }
}