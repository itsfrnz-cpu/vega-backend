import 'package:shared_preferences/shared_preferences.dart';

class TimelineService {
  static const String firstChatKey = 
"first_chat";
  static const String lastChatKey = 
"last_chat";

  Future<void> saveFirstChat(String date) async {
    final prefs = await SharedPreferences.getInstance();
await prefs.setString(firstChatKey, date);
}

  Future<void> saveLastChat(String date) async {
    final prefs = await 
 SharedPreferences.getInstance();
    await 
 prefs.setString(lastChatKey, date);
   }

  Future<String?> getFirstChat() async {
    final prefs = await 
 SharedPreferences.getInstance();
    return 
 prefs.getString(firstChatKey);
   }

  Future<String?> getLastChat() async {
    final prefs = await 
 SharedPreferences.getInstance();
    return 
 prefs.getString(lastChatKey);
   }
 }