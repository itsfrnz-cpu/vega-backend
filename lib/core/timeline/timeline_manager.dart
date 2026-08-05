import 'timeline_model.dart';
import 'timeline_service.dart';

class TimelineManager {
  TimelineModel timeline = const 
TimelineModel();
final TimelineService _service = TimelineService();
Future<void> loadTimeline() async {
  final firstChat = await _service.getFirstChat();
  final lastChat = await _service.getLastChat();

  timeline = TimelineModel(
    firstChat: firstChat != null
        ? DateTime.parse(firstChat)
        : null,
    lastChat: lastChat != null
        ? DateTime.parse(lastChat)
        : null,
  );
}

Future<void> increaseChatCount() async {
  final currentCount = await _service.getChatCount();

  final newCount = currentCount + 1;

  await _service.saveChatCount(newCount);

  print("CHAT COUNT: $newCount");
}
Future<void> saveTimeline() async {
  if (timeline.firstChat != null) {
    await _service.saveFirstChat(
      timeline.firstChat!.toIso8601String(),
    );
  }

  if (timeline.lastChat != null) {
    await _service.saveLastChat(
      timeline.lastChat!.toIso8601String(),
    );
  }
}

 Future<void> startFirstChat() async {
  final now = DateTime.now();

  timeline = timeline.copyWith(
    firstChat: now,
    lastChat: now,
  );

  await saveTimeline();
}

Future<void> updateLastChat() async {
  timeline = timeline.copyWith(
    lastChat: DateTime.now(),
  );

  await saveTimeline();
  await increaseChatCount();
}
  Duration? timeSinceLastChat() {
    if (timeline.lastChat == null) {
      return null;
    }

    return DateTime.now().difference(
      timeline.lastChat!,
    );
  }
  String? getTimeSinceLastChatText() {
  final duration = timeSinceLastChat();

  if (duration == null) {
    return null;
  }

  if (duration.inMinutes < 60) {
    return "${duration.inMinutes} دقیقه پیش";
  }

  if (duration.inHours < 24) {
    return "${duration.inHours} ساعت پیش";
  }

  return "${duration.inDays} روز پیش";
}
}