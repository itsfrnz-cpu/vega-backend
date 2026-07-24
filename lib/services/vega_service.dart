import 'dart:convert';
import 'package:http/http.dart' as http;

class VegaService {
  static const String _apiUrl =
    'https://vega-backend-iogk.onrender.com/chat';
    
  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'جوابی دریافت نشد';
      } else {
        return 'خطا از سرور Vega: ${response.statusCode}';
      }
    } catch (e) {
      return 'خطا در ارتباط با Vega: $e';
    }
  }
}