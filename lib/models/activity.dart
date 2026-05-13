class Activity {
  final String id;
  final String title;
  final String? description;
  final String? time; // e.g., "10:00 AM"

  Activity({
    required this.id,
    required this.title,
    this.description,
    this.time,
  });

  get date => null;
}