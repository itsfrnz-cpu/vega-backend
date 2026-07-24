import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
const ChatScreen({super.key});

@override
State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF0B1020),

appBar: AppBar(
backgroundColor: const Color(0xFF0B1020),
elevation: 0,
centerTitle: true,
title: const Text(
"Vega",
style: TextStyle(color: Colors.white),
),
),

body: Column(
children: [
const Expanded(
child: Center(
child: Text(
"💬\n\nHey, Farnaz.\nI'm here.",
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.white,
fontSize: 24,
),
),
),
),

Padding(
padding: const EdgeInsets.all(16),
child: Row(
children: [
Expanded(
child: TextField(
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
hintText: "Type a message...",
hintStyle: const TextStyle(color: Colors.white54),
filled: true,
fillColor: Colors.white10,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(30),
),
),
),
),

const SizedBox(width: 10),

IconButton(
onPressed: () {},
icon: const Icon(
Icons.send,
color: Colors.lightBlueAccent,
),
),
],
),
),
],
),
);
}
}