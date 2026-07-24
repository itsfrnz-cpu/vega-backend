import 'vega_mood.dart';

class VegaState {
  VegaMood mood;
  String name;
  String message;

  VegaState({
    this.name = "Vega",
    this.mood = VegaMood.calm,
    this.message = "سلام فرناز ⭐",
  });

  void changeMood(VegaMood newMood) {
    mood = newMood;
  }

  void updateMessage(String newMessage) {
    message = newMessage;
  }
}