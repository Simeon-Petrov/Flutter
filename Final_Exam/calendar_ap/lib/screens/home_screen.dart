import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_ap/models/event_model.dart';
import 'package:calendar_ap/screens/event_form_screen.dart';
import 'package:calendar_ap/services/notification_service.dart';
import 'package:calendar_ap/screens/login_screen.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay plusMinutes(int minutes) {
    int newMinute = this.minute + minutes;
    int newHour = this.hour + (newMinute ~/ 60);
    newMinute %= 60;
    newHour %= 24;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<EventModel>> _events = {};
  List<EventModel> _eventsForSelectedDay = [];
  bool _isLoadingEvents = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadAllEvents();
  }

  Future<void> _loadAllEvents() async {
    setState(() {
      _isLoadingEvents = true;
      _events = {};
      _eventsForSelectedDay = [];
    });

    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('events')
              .orderBy('startTime', descending: false)
              .get();

      final Map<DateTime, List<EventModel>> tempEventsForCalendar = {};

      for (var doc in querySnapshot.docs) {
        try {
          final event = EventModel.fromFirestore(doc);
          final eventDay = DateTime.utc(
            event.startTime.year,
            event.startTime.month,
            event.startTime.day,
          );
          tempEventsForCalendar.update(
            eventDay,
            (value) => [...value, event],
            ifAbsent: () => [event],
          );
        } catch (e) {
          print('Error parsing event from Firestore: ${doc.id} - $e');
        }
      }

      setState(() {
        _events = tempEventsForCalendar;
        _isLoadingEvents = false;
        if (_selectedDay != null) {
          _eventsForSelectedDay = _getEventsForDay(_selectedDay!);
        } else {
          _eventsForSelectedDay = [];
        }
      });
    } catch (e) {
      print('Error loading events: $e');
      if (mounted) {
        setState(() {
          _isLoadingEvents = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading events: ${e.toString()}')),
        );
      }
    }
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      _calendarFormat = CalendarFormat.month;

      if (_selectedDay != null && isSameDay(_selectedDay, selectedDay)) {
        _selectedDay = null;
        _eventsForSelectedDay = [];
      } else {
        _selectedDay = selectedDay;
        _eventsForSelectedDay = _getEventsForDay(selectedDay);
      }
    });
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

  Future<void> _deleteEvent(String eventId) async {
    try {
      await NotificationService.cancelNotification(eventId.hashCode);

      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();

      await _loadAllEvents();
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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool isGuest = user?.isAnonymous ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut),
        ],
      ),
      body:
          _isLoadingEvents
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return _selectedDay != null &&
                          isSameDay(_selectedDay, day);
                    },
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
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
                      titleCentered: true,
                      formatButtonShowsNext: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isNotEmpty) {
                          return Positioned(
                            right: 1,
                            bottom: 1,
                            child: Row(
                              children:
                                  events.map((event) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 0.5,
                                      ),
                                      width: 8.0,
                                      height: 8.0,
                                      decoration: BoxDecoration(
                                        color:
                                            (event as EventModel).categoryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child:
                        _selectedDay == null
                            ? const SizedBox.shrink()
                            : _eventsForSelectedDay.isEmpty
                            ? const SizedBox.shrink()
                            : ListView.builder(
                              itemCount: _eventsForSelectedDay.length,
                              itemBuilder: (context, index) {
                                final event = _eventsForSelectedDay[index];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
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
                                      '${DateFormat('dd/MM/yyyy').format(event.startTime)} '
                                      '${DateFormat('HH:mm').format(event.startTime)} - '
                                      '${DateFormat('HH:mm').format(event.endTime)}\n'
                                      '${event.description ?? 'No description'}',
                                    ),
                                    trailing:
                                        isGuest
                                            ? null
                                            : Row(
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
                                                            ) =>
                                                                EventFormScreen(
                                                                  event: event,
                                                                ),
                                                        transitionsBuilder: (
                                                          context,
                                                          animation,
                                                          secondaryAnimation,
                                                          child,
                                                        ) {
                                                          const begin = Offset(
                                                            1.0,
                                                            0.0,
                                                          );
                                                          const end =
                                                              Offset.zero;
                                                          const curve =
                                                              Curves.easeInOut;
                                                          var tween = Tween(
                                                            begin: begin,
                                                            end: end,
                                                          ).chain(
                                                            CurveTween(
                                                              curve: curve,
                                                            ),
                                                          );
                                                          return SlideTransition(
                                                            position: animation
                                                                .drive(tween),
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
                                                      await _loadAllEvents();
                                                    }
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                  ),
                                                  color: Colors.black,
                                                  onPressed:
                                                      () =>
                                                          _confirmDelete(event),
                                                ),
                                              ],
                                            ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
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
                    await _loadAllEvents();
                  }
                },
                child: const Icon(Icons.add),
              ),
    );
  }
}
