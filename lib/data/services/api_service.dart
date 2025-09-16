import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('https://elwekala.onrender.com/product/Laptops');
      return response.data['product'];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}