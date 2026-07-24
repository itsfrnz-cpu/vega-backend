import 'dart:async';

class VegaWakeWord {

  bool isRunning = false;

  Timer? _timer;

 void start() {
  if (isRunning) return;

  isRunning = true;

  print("⭐ Vega wake word started");
  print("🎙️ Listening for: وگا");
}


  void stop() {
    isRunning = false;

    _timer?.cancel();

    print("⭐ Vega wake word stopped");
  }


  void dispose() {
    stop();
  }
}