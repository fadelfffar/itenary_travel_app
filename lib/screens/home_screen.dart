import 'package:flutter/material.dart';
import 'itinerary_screen.dart';
import '../models/trip.dart';
import '../models/activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy trip data (in real app, fetch from backend/local DB)
  late List<Trip> trips;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  void _loadTrips() {
    // Create some sample activities
    final activitiesParis = [
      Activity(
        id: 'a1',
        title: 'Eiffel Tower',
        description: 'Visit the iconic tower',
        time: '10:00 AM',
      ),
      Activity(
        id: 'a2',
        title: 'Louvre Museum',
        description: 'See the Mona Lisa',
        time: '2:00 PM',
      ),
      Activity(
        id: 'a3',
        title: 'Seine River Cruise',
        description: 'Evening cruise',
        time: '7:00 PM',
      ),
    ];

    final activitiesTokyo = [
      Activity(
        id: 'b1',
        title: 'Shibuya Crossing',
        description: 'Busiest crossing',
        time: '9:00 AM',
      ),
      Activity(
        id: 'b2',
        title: 'Senso-ji Temple',
        description: 'Ancient temple',
        time: '1:00 PM',
      ),
    ];

    trips = [
      Trip(
        id: 't1',
        destination: 'Paris, France',
        startDate: DateTime(2026, 6, 10),
        endDate: DateTime(2026, 6, 15),
        activities: activitiesParis,
      ),
      Trip(
        id: 't2',
        destination: 'Tokyo, Japan',
        startDate: DateTime(2026, 7, 20),
        endDate: DateTime(2026, 7, 25),
        activities: activitiesTokyo,
      ),
      Trip(
        id: 't3',
        destination: 'Milan, Italy',
        startDate: DateTime(2026, 7, 20),
        endDate: DateTime(2026, 7, 25),
        activities: activitiesTokyo,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: trips.isEmpty
          ? const Center(child: Text('No trips yet. Add a new trip!'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItineraryScreen(trip: trip),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.destination,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatDate(trip.startDate)} - ${_formatDate(trip.endDate)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.tour, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${trip.activities.length} activities planned',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For demo: show a snackbar (in real app, open add trip screen)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add trip feature coming soon!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}