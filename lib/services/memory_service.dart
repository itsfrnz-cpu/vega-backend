import 'dart:convert';
import 'package:flutter/services.dart';

class MemoryService {
  Future<Map<String, dynamic>> loadIdentity() async {
    final jsonString =
        await
 rootBundle.loadString('assets/memory/identity.json');

    return json.decode(jsonString);
   }

   Future<Map<String, dynamic>> loadPreferences() async {
     final jsonString =
         await
 rootBundle.loadString('assets/memory/preferences.json');

     return json.decode(jsonString);
  }

  Future<Map<String, dynamic>> loadProjects() async {
    final jsonString =
        await
 rootBundle.loadString('assets/memory/projects.json');

    return json.decode(jsonString);
  }

  Future<Map<String, dynamic>> loadGoals() async {
    final jsonString =
        await
 rootBundle.loadString('assets/memory/goals.json');

    return json.decode(jsonString);
  }

  Future<Map<String, dynamic>> loadMemories() async {
    final jsonString =
        await
 rootBundle.loadString('assets/memory/memories.json');

    return json.decode(jsonString);
  }
 }