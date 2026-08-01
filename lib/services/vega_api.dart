import 'dart:convert';
import 'package:http/http.dart' as http;

class VegaApi {
  static const String baseUrl =
      "https://vega-backend-iogk.onrender.com";

  static Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse("$baseUrl/chat"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "message": message,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["reply"];
    } else {
      throw Exception(
          "Vega server error: ${response.statusCode}\n${response.body}");
    }
  }
}