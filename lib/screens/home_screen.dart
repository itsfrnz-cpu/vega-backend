import 'package:flutter/material.dart';
import '../core/presence/vega_star.dart';
import 'dart:ui';
import '../services/vega_service.dart';
import '../core/presence/vega_mood.dart';
import '../core/audio/vega_audio.dart';
import '../core/audio/vega_wake_word.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


// وضعیت‌های مکالمه
enum VegaState {
  idle,
  listening,
  thinking,
  responding,
}


class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
with SingleTickerProviderStateMixin {

late AnimationController _controller;
late Animation<double> _pulse;

final Color vegaColor = const Color(0xFFFFE9A8);

VegaMood currentMood = VegaMood.comforting;

final TextEditingController messageController =
TextEditingController();

final VegaService _vegaService = VegaService();
final VegaWakeWord _wakeWord = VegaWakeWord();
final List<Map<String, String>> messages = [];
final stt.SpeechToText _speech = stt.SpeechToText();
bool _isListening = false;
String userMessage = '';
String vegaMessage = 'سلام فرناز ✨\nآماده‌ام که کنارت باشم';


// وضعیت فعلی
VegaState currentState = VegaState.idle;

// تشخیص مود از روی متن و وضعیت
VegaMood detectMood(String text, VegaState state) {
  final t = text.toLowerCase();

  // فقط listening و thinking مستقیم مود را تعیین می‌کنند
  if (state == VegaState.listening) {
    return VegaMood.listening;
  }

  if (state == VegaState.thinking) {
    return VegaMood.thinking;
  }

  // در حالت responding احساس متن بررسی می‌شود
  if (t.contains('غمگین') ||
      t.contains('ناراحت') ||
      t.contains('خسته') ||
      t.contains('تنها') ||
      t.contains('گریه')) {
    return VegaMood.comforting;
  }

  if (t.contains('خوشحال') ||
      t.contains('عالی') ||
      t.contains('دوست دارم') ||
      t.contains('خوبم')) {
    return VegaMood.happy;
  }

  if (t.contains('هیجان') ||
      t.contains('وای') ||
      t.contains('بزن بریم') ||
      t.contains('عاشقشم')) {
    return VegaMood.excited;
  }

  if (t.contains('فکر') ||
      t.contains('نمیدونم') ||
      t.contains('چرا') ||
      t.contains('شاید')) {
    return VegaMood.listening;
  }

  return VegaMood.comforting;
}

// تغییر مود Vega
void updateVegaMood(String text, VegaState state) {
  setState(() {
    currentState = state;
    currentMood = detectMood(text, state);
  });
}

@override
void initState() {
super.initState();
_wakeWord.start();

_controller = AnimationController(
duration: const Duration(seconds: 3),
vsync: this,
);

_pulse = Tween<double>(
begin: 0.9,
end: 1.1,
).animate(
CurvedAnimation(
parent: _controller,
curve: Curves.easeInOut,
),
);

_controller.repeat(reverse: true);
}

@override
void dispose() {
  _wakeWord.dispose();

  _controller.dispose();
  messageController.dispose();

  super.dispose();
}
Future<void> _startListening() async {
  print('Mic button pressed');

  bool available = await _speech.initialize(
    onStatus: (status) {
      print('Speech status: $status');
    },
    onError: (error) {
      print('Speech error: $error');
    },
  );

  print('Speech available: $available');

  if (available) {
    setState(() {
      _isListening = true;
      currentMood = VegaMood.listening;
    });

    //await VegaAudio.playChime();

    _speech.listen(
      localeId: 'fa_IR',
      onResult: (result) {
        print('Recognized: ${result.recognizedWords}');

        setState(() {
          messageController.text = result.recognizedWords;
        });

        if (result.finalResult) {
          _sendMessage();
        }
      },
    );
  } else {
    print('Speech recognition not available');
  }
}

Future<void> _sendMessage() async {
  print('SEND MESSAGE CALLED');
  final text = messageController.text.trim();

  if (text.isEmpty) return;

  setState(() {
    messages.add({
      'role': 'user',
      'text': text,
    });

    messageController.clear();
    _isListening = false;
  });

  updateVegaMood(text, VegaState.thinking);

  final reply = await _vegaService.sendMessage(text);

  setState(() {
    messages.add({
      'role': 'vega',
      'text': reply,
    });
  });

  updateVegaMood(reply, VegaState.responding);
}

Widget buildVegaStar() {

return AnimatedBuilder(

animation: _pulse,

builder: (context, child) {

return Transform.scale(

scale: _pulse.value,

child: Stack(

alignment: Alignment.center,

children: [

Transform.rotate(
  angle: 0.785,
  child: Container(
    width: 90,
    height: 90,
    decoration: BoxDecoration(
      color: vegaColor,
      boxShadow: [
        BoxShadow(
          color: vegaColor.withOpacity(0.45),
          blurRadius: 35,
          spreadRadius: 8,
        ),
      ],
    ),
  ),
),

Container(

width: 150,
height: 150,

decoration: BoxDecoration(

shape: BoxShape.circle,

gradient: RadialGradient(

colors: [

Colors.white,

vegaColor,

],

),

boxShadow: [

BoxShadow(

color: vegaColor,

blurRadius: 60,

),

],

),

),

],

),

);

},

);

}

Widget messageBubble() {
  return Expanded(
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg['role'] == 'user';

        return Align(
          alignment:
              isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isUser
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              msg['text'] ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        );
      },
    ),
  );
}
Widget inputBox() {
  return Container(
    margin: const EdgeInsets.all(25),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.08),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText: 'پیام برای وگا...',
              hintStyle: TextStyle(
                color: Colors.white54,
              ),
              border: InputBorder.none,
            ),
          ),
        ),

        // دکمه میکروفون
        IconButton(
  onPressed: () {
    print('MIC BUTTON CLICKED');
    _startListening();
  },
  icon: Icon(
    _isListening ? Icons.mic : Icons.mic_none,
    color: _isListening
        ? Colors.redAccent
        : const Color(0xFFB8E8FF),
  ),
),

        // دکمه ارسال
        IconButton(
          onPressed: _sendMessage,
          icon: const Icon(
            Icons.send,
            color: Color(0xFFB8E8FF),
          ),
        ),
      ],
    ),
  );
}
 
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0B1020),
    resizeToAvoidBottomInset: true,
    body: SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 40),

          VegaStar(mood: currentMood),

          const SizedBox(height: 20),

          messageBubble(),

          inputBox(),
        ],
      ),
    ),
  );
}

}