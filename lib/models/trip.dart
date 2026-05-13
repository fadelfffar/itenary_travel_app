import 'activity.dart';

class Trip {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<Activity> activities; // All activities across all days

  Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.activities,
  });

  // ✅ Correct implementation: filters activities by exact date
  List<Activity> getActivitiesForDate(DateTime date) {
    return activities.where((activity) {
      return activity.date.year == date.year &&
          activity.date.month == date.month &&
          activity.date.day == date.day;
    }).toList();
  }
}