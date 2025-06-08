import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_ap/models/event_model.dart';
import 'package:calendar_ap/screens/event_form_screen.dart';
import 'package:calendar_ap/services/notification_service.dart';
import 'package:calendar_ap/screens/login_screen.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  String? _userName;
  List<EventModel> _myEvents = [];
  bool _isLoadingMyEvents = true;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _loadUserData(_currentUser!);
      _loadMyEvents(_currentUser!.uid);
    } else {
      setState(() {
        _isLoadingMyEvents = false;
      });
    }

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
          if (user != null) {
            _loadUserData(user);
            _loadMyEvents(user.uid);
          } else {
            _userName = null;
            _myEvents = [];
            _isLoadingMyEvents = false;
          }
        });
      }
    });
  }

  Future<void> _loadUserData(User user) async {
    if (user.isAnonymous) {
      setState(() {
        _userName = 'Guest';
      });
    } else if (user.displayName != null && user.displayName!.isNotEmpty) {
      setState(() {
        _userName = user.displayName;
      });
    } else {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
        if (doc.exists &&
            doc.data() != null &&
            doc.data()!.containsKey('name')) {
          setState(() {
            _userName = doc.data()!['name'];
          });
        } else {
          setState(() {
            _userName = 'N/A';
          });
        }
      } catch (e) {
        print('Error fetching user name from Firestore: $e');
        setState(() {
          _userName = 'N/A';
        });
      }
    }
  }

  Future<void> _loadMyEvents(String? uid) async {
    setState(() {
      _isLoadingMyEvents = true;
      _myEvents = [];
    });

    if (uid == null) {
      setState(() {
        _isLoadingMyEvents = false;
      });
      return;
    }

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .where('createdBy', isEqualTo: uid)
              .orderBy('startTime', descending: false)
              .get();

      final List<EventModel> tempMyEvents = [];
      for (var doc in querySnapshot.docs) {
        try {
          final event = EventModel.fromFirestore(doc);
          tempMyEvents.add(event);
        } catch (e) {
          print('Error parsing my event from Firestore: ${doc.id} - $e');
        }
      }

      setState(() {
        _myEvents = tempMyEvents;
        _isLoadingMyEvents = false;
      });
    } catch (e) {
      print('Error loading my events: $e');
      if (mounted) {
        setState(() {
          _isLoadingMyEvents = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading personal events: ${e.toString()}'),
          ),
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

      _loadMyEvents(_currentUser?.uid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event successfully deleted.')),
        );
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting event: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
          ),
        );
      }
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Missing event ID.')),
          );
        }
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out.');
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print('Error signing out: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;
    final bool isGuest = user?.isAnonymous ?? true;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email, size: 20, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            'Email: ${isGuest ? 'Guest User' : (user?.email ?? 'N/A')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Name: ${_userName ?? 'Loading...'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _signOut,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'My Events',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _isLoadingMyEvents
                  ? const Center(child: CircularProgressIndicator())
                  : (isGuest
                      ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'Please log in to view and manage your events.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                      : (_myEvents.isEmpty
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                'You have not added any events yet.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _myEvents.length,
                            itemBuilder: (context, index) {
                              final event = _myEvents[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: ListTile(
                                  leading: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: event.categoryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  title: Text(event.title),
                                  subtitle: Text(
                                    '${DateFormat('dd/MM/yyyy HH:mm').format(event.startTime)} - '
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
                                            PageRouteBuilder(
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) => EventFormScreen(
                                                    event: event,
                                                  ),
                                              transitionsBuilder: (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                              ) {
                                                const begin = Offset(1.0, 0.0);
                                                const end = Offset.zero;
                                                const curve = Curves.easeInOut;
                                                var tween = Tween(
                                                  begin: begin,
                                                  end: end,
                                                ).chain(
                                                  CurveTween(curve: curve),
                                                );
                                                return SlideTransition(
                                                  position: animation.drive(
                                                    tween,
                                                  ),
                                                  child: child,
                                                );
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 400,
                                                  ),
                                            ),
                                          );
                                          if (result == true) {
                                            await _loadMyEvents(
                                              _currentUser?.uid,
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        color: Colors.black,
                                        onPressed: () => _confirmDelete(event),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ))),
            ],
          ),
        ),
      ),
      floatingActionButton:
          isGuest
              ? null
              : FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              const EventFormScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                  if (result == true) {
                    await _loadMyEvents(_currentUser?.uid);
                  }
                },
                child: const Icon(Icons.add),
              ),
    );
  }
}
