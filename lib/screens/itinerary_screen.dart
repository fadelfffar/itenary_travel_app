import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/trip.dart';
import '../models/activity.dart';

class ItineraryScreen extends StatefulWidget {
  final Trip trip;

  const ItineraryScreen({super.key, required this.trip});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<Activity>> _activitiesPerDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.trip.startDate;
    _selectedDay = widget.trip.startDate;
    _groupActivitiesByDay();
  }

  void _groupActivitiesByDay() {
    // In a real app, each activity would have its own date.
    // For demo, we'll simulate by assigning activities to days
    // within the trip duration. We'll create a simple distribution:
    _activitiesPerDay = {};
    final activities = widget.trip.activities;
    final tripDays = widget.trip.endDate.difference(widget.trip.startDate).inDays + 1;

    // Distribute activities across days (round robin)
    for (int i = 0; i < activities.length; i++) {
      final dayOffset = i % tripDays;
      final activityDate = widget.trip.startDate.add(Duration(days: dayOffset));
      final dateOnly = DateTime(activityDate.year, activityDate.month, activityDate.day);
      _activitiesPerDay.putIfAbsent(dateOnly, () => []).add(activities[i]);
    }
  }

  List<Activity> _getActivitiesForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return _activitiesPerDay[normalized] ?? [];
  }

  void _addNewActivity() {
    // Simple dialog to add an activity for the selected day
    final titleController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time (e.g., 10:00 AM)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newActivity = Activity(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text.trim(),
                time: timeController.text.trim(),
                description: null,
              );
              setState(() {
                final dayKey = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
                _activitiesPerDay.putIfAbsent(dayKey, () => []).add(newActivity);
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activitiesToday = _getActivitiesForDay(_selectedDay);
    final isWithinTrip = _selectedDay.isAfter(widget.trip.startDate.subtract(const Duration(days: 1))) &&
        _selectedDay.isBefore(widget.trip.endDate.add(const Duration(days: 1)));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trip.destination),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Calendar widget
          TableCalendar(
            firstDay: widget.trip.startDate,
            lastDay: widget.trip.endDate,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
          ),
          const Divider(height: 1),
          // Activities list
          Expanded(
            child: isWithinTrip
                ? activitiesToday.isEmpty
                ? const Center(
              child: Text(
                'No activities planned for this day.\nTap + to add one.',
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: activitiesToday.length,
              itemBuilder: (context, index) {
                final act = activitiesToday[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.event_note),
                    title: Text(act.title),
                    subtitle: act.time != null ? Text(act.time!) : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _activitiesPerDay[_selectedDay]?.remove(act);
                          if (_activitiesPerDay[_selectedDay]?.isEmpty == true) {
                            _activitiesPerDay.remove(_selectedDay);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            )
                : Center(
              child: Text(
                'Select a date between\n${DateFormat.yMMMd().format(widget.trip.startDate)} and ${DateFormat.yMMMd().format(widget.trip.endDate)}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isWithinTrip
          ? FloatingActionButton(
        onPressed: _addNewActivity,
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}