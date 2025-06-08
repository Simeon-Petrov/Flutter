import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:calendar_ap/models/event_model.dart';
import 'package:calendar_ap/screens/event_form_screen.dart';
import 'package:calendar_ap/services/notification_service.dart';
import 'package:calendar_ap/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user?.isAnonymous ?? true;

    if (user != null) {
      print('Current User UID: ${user.uid}');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16.0),
              if (user != null)
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          user.email ?? 'N/A (Guest User)',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (!isGuest && user.uid.isNotEmpty)
                          FutureBuilder<DocumentSnapshot>(
                            future:
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    'Error loading name: ${snapshot.error}',
                                  ),
                                );
                              }
                              if (snapshot.hasData && snapshot.data!.exists) {
                                final userData = UserModel.fromFirestore(
                                  snapshot.data!,
                                );
                                final userName =
                                    userData.name.isNotEmpty
                                        ? userData.name
                                        : 'N/A';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16.0),
                                    Text(
                                      'Name:',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      userName,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Account Type:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          isGuest ? 'Guest Account' : 'Registered User',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (isGuest) ...[
                          const SizedBox(height: 16.0),
                          Text(
                            'Guest accounts cannot save events permanently. Please register to keep your events.',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else
                const Text('No user logged in.'),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              if (user != null && !isGuest)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Events',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16.0),
                    EventListWidget(userId: user.uid),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventListWidget extends StatefulWidget {
  final String userId;

  const EventListWidget({super.key, required this.userId});

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  List<EventModel> _myEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyEvents();
  }

  Future<void> _loadMyEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where('createdBy', isEqualTo: widget.userId)
              .orderBy('startTime', descending: false)
              .get();

      final List<EventModel> fetchedEvents = [];
      for (var doc in querySnapshot.docs) {
        try {
          final event = EventModel.fromFirestore(doc);
          fetchedEvents.add(event);
        } catch (e) {
          print(
            'Error parsing event from Firestore in ProfileScreen: ${doc.id} - $e',
          );
        }
      }

      setState(() {
        _myEvents = fetchedEvents;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading my events: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading your events: ${e.toString()}')),
      );
    }
  }

  Future<void> _confirmDelete(EventModel event) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "${event.title}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      if (event.id != null) {
        await _deleteEvent(event.id!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Event ID is missing.')),
        );
      }
    }
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      await NotificationService.cancelNotification(eventId.hashCode);
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();

      _loadMyEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_myEvents.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No events found for this user.'),
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _myEvents.length,
        itemBuilder: (context, index) {
          final event = _myEvents[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
            child: ListTile(
              title: Text(event.title),
              subtitle: Text(
                '${DateFormat('dd/MM/yyyy').format(event.startTime)} '
                '${DateFormat('HH:mm').format(event.startTime)} - '
                '${DateFormat('HH:mm').format(event.endTime)}\n'
                '${event.description ?? 'No description'}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventFormScreen(event: event),
                        ),
                      );
                      if (result == true) {
                        _loadMyEvents();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () => _confirmDelete(event),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
