import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calendar_ap/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:calendar_ap/services/notification_service.dart';

class EventFormScreen extends StatefulWidget {
  final EventModel? event;

  const EventFormScreen({super.key, this.event});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  late TimeOfDay _selectedEndTime;

  DateTime _selectedStartDateTime = DateTime.now();
  DateTime _selectedEndDateTime = DateTime.now().add(const Duration(hours: 1));

  bool _isLoading = false;

  Color _selectedCategoryColor = Colors.blue;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description ?? '';
      _selectedStartDateTime = widget.event!.startTime;
      _selectedEndDateTime = widget.event!.endTime;
      _selectedDate = DateTime(
        _selectedStartDateTime.year,
        _selectedStartDateTime.month,
        _selectedStartDateTime.day,
      );
      _selectedStartTime = TimeOfDay.fromDateTime(_selectedStartDateTime);
      _selectedEndTime = TimeOfDay.fromDateTime(_selectedEndDateTime);

      if (widget.event!.categoryColorValue != null) {
        final loadedColor = Color(widget.event!.categoryColorValue!);
        _selectedCategoryColor = _availableColors.firstWhere(
          (color) => color.value == loadedColor.value,
          orElse: () => Colors.blue,
        );
      }
    } else {
      _selectedEndTime = TimeOfDay.fromDateTime(
        DateTime.now().add(const Duration(minutes: 60)),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateTimes();
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context, {
    required bool isStartTime,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _selectedStartTime : _selectedEndTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = picked;
        } else {
          _selectedEndTime = picked;
        }
        _updateDateTimes();
      });
    }
  }

  void _updateDateTimes() {
    _selectedStartDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );
    _selectedEndDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );

    if (_selectedEndDateTime.isBefore(_selectedStartDateTime)) {
      _selectedEndDateTime = _selectedStartDateTime.add(
        const Duration(hours: 1),
      );
      _selectedEndTime = TimeOfDay.fromDateTime(_selectedEndDateTime);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time adjusted to be after start time.'),
        ),
      );
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to create or edit events.'),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final newEvent = EventModel(
      id: widget.event?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _selectedStartDateTime,
      endTime: _selectedEndDateTime,
      createdBy: user.uid,
      categoryColorValue: _selectedCategoryColor.value,
    );

    try {
      if (newEvent.id == null) {
        final docRef = await FirebaseFirestore.instance
            .collection('events')
            .add(newEvent.toFirestore());
        newEvent.id = docRef.id;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('events')
            .doc(newEvent.id)
            .update(newEvent.toFirestore());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully!')),
        );
      }

      if (_selectedStartDateTime.isAfter(DateTime.now())) {
        await NotificationService.cancelNotification(newEvent.id.hashCode);
        await NotificationService.scheduleNotification(
          id: newEvent.id.hashCode,
          title: 'Event Reminder: ${newEvent.title}',
          body:
              'Your event "${newEvent.title}" is starting soon at ${DateFormat('HH:mm').format(newEvent.startTime)}.',
          scheduledDate: newEvent.startTime.subtract(
            const Duration(minutes: 20), // reminder 20 min before event!
          ),
        );
      } else if (newEvent.id != null) {
        await NotificationService.cancelNotification(newEvent.id.hashCode);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving event: ${e.message}')),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add New Event' : 'Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(
                  'Start Time: ${_selectedStartTime.format(context)}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, isStartTime: true),
              ),
              ListTile(
                title: Text('End Time: ${_selectedEndTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, isStartTime: false),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Color>(
                value: _selectedCategoryColor,
                decoration: const InputDecoration(
                  labelText: 'Category Color',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.color_lens),
                ),
                onChanged: (Color? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategoryColor = newValue;
                    });
                  }
                },
                items:
                    _availableColors.map<DropdownMenuItem<Color>>((
                      Color color,
                    ) {
                      return DropdownMenuItem<Color>(
                        value: color,
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveEvent,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          widget.event == null ? 'Add Event' : 'Save Changes',
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
