import 'package:calendar_timeline_sbk/calendar_timeline.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mapfeature_project/Todo/databasehelper.dart';
import 'package:mapfeature_project/Todo/event_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:intl/intl.dart';

// import 'package:todo3/databasehelper.dart';

// import 'package:soothe-bot/Todo/event_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> _isCompleted = [];
  late DateTime _selectedDate;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late String _eventName = '';
  late TextEditingController _eventNameController;
  late TextEditingController _selectedStartTimeController;
  late TextEditingController _selectedEndTimeController;
  List<EventModel> events = [];
  Future? _future;
  Future<void> getAllEvents() async {
    events = await DBHelper.db.getAllEvents();
    _isCompleted = List.generate(events.length, (index) => false);
    setState(() {});
  }

  @override
  void initState() {
    tz.initializeTimeZones();
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });
    super.initState();
    _resetSelectedDate();
    _resetSelectedTime();
    _eventNameController = TextEditingController();
    _selectedStartTimeController = TextEditingController();
    _selectedEndTimeController = TextEditingController();
    _future = getAllEvents();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 0));
  }

  void _deleteEvent(int index) async {
    print('Length before deletion: ${events.length}');
    int eventId = events[index].id!;
    await DBHelper.db.deleteEvent(eventId); // حذف الحدث من قاعدة البيانات
    setState(() {
      events.removeAt(index);
      // حذف الحدث من القائمة
      print('Length after deletion: ${events.length}');
    });
  }

  // static Future<void> scheduleNotification({
  //   required schedule,
  // }) async {
  //   // await AwesomeNotifications().createNotification(
  //   //   content: NotificationContent(
  //   //     id: 10,
  //   //     channelKey: 'Recommendations',
  //   //     title: 'End of Event',
  //   //     body: 'Your now have break time .',
  //   //     category: NotificationCategory.Alarm,
  //   //     notificationLayout: NotificationLayout.BigText,
  //   //     locked: true,
  //   //     autoDismissible: false,
  //   //     wakeUpScreen: true,
  //   //     fullScreenIntent: true,
  //   //     displayOnForeground: true,
  //   //     backgroundColor: Colors.transparent,
  //   //   ),
  //   //   schedule: NotificationCalendar(
  //   //     minute: schedule.time.minute,
  //   //     hour: schedule.time.hour,
  //   //     day: schedule.time.day,
  //   //     weekday: schedule.time.weekday,
  //   //     month: schedule.time.month,
  //   //     year: schedule.time.year,
  //   //     preciseAlarm: true,
  //   //     allowWhileIdle: true,
  //   //     timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
  //   //   ),

  //   //   //actionButtons: NotificationActionButton(key: 'close', label: 'close Reminder',autoDismissible: true)
  //   // );
  // }

  void _resetSelectedTime() {
    _selectedStartTime = TimeOfDay.now();
    _selectedEndTime = TimeOfDay.now();
  }

  // void createNotification(String eventName, DateTime scheduledDate) async {
  //   // await AwesomeNotifications().createNotification(
  //   //   content: NotificationContent(
  //   //     id: 10,
  //   //     channelKey: 'Recommendations',
  //   //     title: 'End of Event',
  //   //     body: 'Your event "$eventName" has ended.',
  //   //   ),
  //   //   schedule: NotificationInterval(
  //   //     interval: 60, // بالدقائق
  //   //     timeZone: 'UTC', // يمكن تغييرها حسب التوقيت المطلوب
  //   //     repeats: true, // يتكرر بشكل مستمر
  //   //     allowWhileIdle: true,

  //   //     // exact: true,
  //   //     // startFrom: scheduledDate,
  //   //   ),
  //   // );
  // }

  // static final _notifications = FlutterLocalNotificationsPlugin();
  // static Future showScheduleNotification(
  //         {var id = 0,
  //         var title,
  //         var body,
  //         var payload,
  //         required DateTime scheduleTime}) async =>
  //     _notifications.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz.TZDateTime.from(scheduleTime, tz.local),
  //       await notificationDetails(),
  //       payload: payload,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  // static notificationDetails() async {
  //   return const NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'Recommendation',
  //       'visit your recommends?!',
  //       importance: Importance.max,
  //     ),
  //   );
  // }

  void _showEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 40),
              TextField(
                onChanged: (value) => _eventName = value,
                controller: _eventNameController,
                decoration: InputDecoration(
                  // hintText: 'Your Event Name',
                  // hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:Color(0xFF61A0A6) ),labelText: 'Event Name',
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(200),
                    borderSide: const BorderSide(color: Color(0xFF61A0A6)),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 1.0, horizontal: 50),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),
              TextFormField(
                onTap: () => _selectDate(context),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(200)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 1.0, horizontal: 50),
                ),
                controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(_selectedDate)),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      onTap: () => _selectStartTime(context),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 15, 10, 10),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(200)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 20),
                      ),
                      controller: _selectedStartTimeController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      onTap: () => _selectEndTime(context),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(200)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 25),
                      ),
                      controller: _selectedEndTimeController,
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار بدون حفظ
              },
              child: const Text('Cancel'), // إضافة معلمة الطفرة هنا
            ),
            ElevatedButton(
              onPressed: () async {
                // ((((((((((getAllEvents(); <-- Not necessary))))))))))
                // showScheduleNotification(
                //     title: 'Recommendation',
                //     body: 'visit your recommendations',
                //     scheduleTime:
                //         DateTime.now().add(const Duration(seconds: 1)));

                // إنشاء كائن Event وملء البيانات من الحقول المدخلة
                EventModel event = EventModel(
                  name: _eventName,
                  startTime: _selectedStartTime,
                  endTime: _selectedEndTime,
                  date: _selectedDate,
                );
                // AwesomeNotifications().createNotification(
                //     content: NotificationContent(
                //       id: 1,
                //       channelKey: "recommendation",
                //       title: 'your have break time',
                //       body: 'what about visiting recommendation screen',
                //     ),
                //     schedule:
                //         NotificationCalendar.fromDate(date: DateTime.now()));

                // قم بإضافة الحدث إلى قاعدة البيانات
                int id = await DBHelper.db.insertEvent(event
                    .toMap()); //((((( add event to database and return the id)))))
                event.id = id;
                setState(() {
                  _isCompleted.add(false);
                  events.add(
                      event); // (((((((add event to the list we show)))))))
                });
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                _showEventDetails();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEventDetails() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Event Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('Event Name: $_eventName',
                  style: const TextStyle(fontSize: 16)),
              Text('Start Time: ${_selectedStartTime.format(context)}',
                  style: const TextStyle(fontSize: 16)),
              Text('End Time: ${_selectedEndTime.format(context)}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _eventNameController.text =
            DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );

    if (pickedStartTime != null && pickedStartTime != _selectedStartTime) {
      setState(() {
        _selectedStartTime = pickedStartTime;
        _selectedStartTimeController.text = pickedStartTime.format(context);
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );

    if (pickedEndTime != null && pickedEndTime != _selectedEndTime) {
      setState(() {
        _selectedEndTime = pickedEndTime;
        _selectedEndTimeController.text = pickedEndTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //((((((((((( getAllEvents(); <--- not necessary)))))))))))
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F3),
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              color: Color(0xFF61A0A6),
              onPressed: () {
                Navigator.of(context).pop();
              })),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.tealAccent[100]),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: CalendarTimeline(
                    showYears: false,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
                    onDateSelected: (date) =>
                        setState(() => _selectedDate = date),
                    dotsColor: const Color(0xFF61A0A6),
                    dayColor: const Color(0xFF555B5C),
                    dayNameColor: Colors.white,
                    activeDayColor: Colors.white,
                    inactiveDayNameColor: Colors.black,
                    activeBackgroundDayColor: const Color(0xFF61A0A6),
                    selectableDayPredicate: (date) => true,
                    locale: 'en',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (BuildContext context, int index) {
                        // (((((((((((compare with day, month and year here)))))))))))
                        if (events[index].date.day == _selectedDate.day &&
                            events[index].date.month == _selectedDate.month &&
                            events[index].date.year == _selectedDate.year) {
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8FA5A8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 80,
                                width: 350,
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          events[index].name,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          ' Time :${events[index].startTime.format(context)} - ${events[index].endTime.format(context)}',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isCompleted[index] =
                                                  !_isCompleted[index];
                                            });
                                            // ((((((((update here the status of the event))))))))
                                            // قم بتنفيذ الإجراء الخاص بـ complete هنا
                                          },
                                          child: Icon(Icons.check_circle,
                                              color: _isCompleted[index]
                                                  ? Color(0xFF61A0A6)
                                                  : Colors.white),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                            onTap: () {
                                              _deleteEvent(index);

                                              // حذف الحدث عند النقر على أيقونة السلة
                                            },
                                            child: const Icon(Icons.delete,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // اضافة الفراغ بين العناصر
                              const SizedBox(height: 10),
                            ],
                          );
                        } else {
                          return const SizedBox
                              .shrink(); // يخفي العناصر غير المطابقة
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Center(child: Text("لا يوجد شيء لعرضه"));
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: FloatingActionButton(
                onPressed: _showEventDialog,
                backgroundColor:
                    const Color(0xFF61A0A6), // عرض الحوار عند الضغط
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
