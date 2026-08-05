import 'dart:convert';
import 'package:http/http.dart' as http;

class VegaService {
  static const String _apiUrl =
    'http://192.168.1.103:8000/chat';
    
 Future<String> sendMessage(String message) async {
  print("===== SEND START =====");
  print("MESSAGE: $message");

  print("SENDING TO:");
  print(_apiUrl);

  final response = await http.post(
    Uri.parse(_apiUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'message': message,
    }),
  );

  print("STATUS:");
  print(response.statusCode);

  print("BODY:");
  print(response.body);

  return response.body;
}
}