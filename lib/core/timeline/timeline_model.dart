class TimelineModel {
  final DateTime? firstChat;
  final DateTime? lastChat;
  final DateTime? lastProjectUpdate;

  const TimelineModel({
    this.firstChat,
    this.lastChat,
    this.lastProjectUpdate,
  });

TimelineModel copyWith({
  DateTime? firstChat,
  DateTime? lastChat,
  DateTime? lastProjectUpdate,
  }) {
  return TimelineModel(
    firstChat: firstChat ?? 
this.firstChat,
      lastChat: lastChat ?? 
this.lastChat,
      lastProjectUpdate:
          lastProjectUpdate ?? 
this.lastProjectUpdate,
    );
  }
}