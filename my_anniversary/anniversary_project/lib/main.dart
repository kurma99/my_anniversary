import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class DateModel extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  int _anniversary = 0;

  DateModel() {
    _loadDate();
  }

  DateTime get selectedDate => _selectedDate;

  int get anniversary => _anniversary;

  Future<void> _loadDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getInt('selectedDate');
    final savedYears = prefs.getInt('anniversary');

    if (savedDate != null) {
      _selectedDate = DateTime.fromMillisecondsSinceEpoch(savedDate);
      notifyListeners();
    }
    if (savedYears != null) {
      _anniversary = savedYears;
      notifyListeners();
    }
  }

  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = newDate;

    DateTime currentDate = DateTime.now();

    // Calculate the years passed since the anniversary
    int yearsPassed = currentDate.year - _selectedDate.year;

    // Check if the anniversary date has occurred for the current year
    DateTime currentAnniversary = DateTime(_selectedDate.year + yearsPassed, _selectedDate.month, _selectedDate.day);
    if (currentDate.isBefore(currentAnniversary)) {
      yearsPassed--;
    }

    _anniversary = yearsPassed;
    
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedDate', newDate.millisecondsSinceEpoch);
    prefs.setInt('anniversary', _anniversary);
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DateModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}


class _MyApp extends State<MyApp>  {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("Selected Index: $_selectedIndex");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Medals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
          body: <Widget>[
              StatsPageWidget(),
              MedalsPageWidget(),
              SettingsPageWidget(),
            ][_selectedIndex],
        ),   
      ),
    );
  }
}

class StatsPageWidget extends StatelessWidget {
  const StatsPageWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateModel>(context);

    DateTime then = dateModel.selectedDate;
    DateTime now = DateTime.now();
    Duration interval = now.difference(then);
    int monthsApart = (now.year - then.year) * 12 + now.month - then.month;
    if (now.day < then.day) {
      monthsApart -= 1;
    }
    int yearsDifference = (interval.inDays / 365).floor();

    return Column(
      children: [
        const Text('Togther'),
        FactContainer(
          title: "in DAYS", 
          info: '${interval.inDays}',
        ),
        FactContainer(
          title: "in MONTHS", 
          info: '$monthsApart',
        ),
        FactContainer(
          title: "in YEARS", 
          info: '$yearsDifference',
        ),
        const FactContainer(
          title: "Times one could have watcjed Titanic", 
          info: "60",
        ),
      ],
    );
  }
}

class MedalsPageWidget extends StatelessWidget {
  const MedalsPageWidget({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> anniversaryList = [
    {'title': 'Green Anniversary', 'year': 0},
    {'title': 'Paper Anniversary', 'year': 1},
    {'title': 'Cotton Anniversary', 'year': 2},
    {'title': 'Leather Anniversary', 'year': 3},
    {'title': 'Wooden Anniversary', 'year': 5},
    {'title': 'Sugar Anniversary', 'year': 6},
    {'title': 'Copper Anniversary', 'year': 7},
    {'title': 'Poppy Anniversary', 'year': 8},
    {'title': 'Glass Anniversary', 'year': 9},
    {'title': 'Rose Anniversary', 'year': 10},
    {'title': 'Coral Anniversary', 'year': 11},
    {'title': 'Silver Anniversary', 'year': 25},
    {'title': 'Gold Anniversary', 'year': 50},
    {'title': 'Diamond Anniversary', 'year': 100},
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnniversaryWidget(),
        Consumer<DateModel>(
          builder: (context, dateModel, child) {
            Map<String, dynamic> selectedAnniversary = anniversaryList.firstWhere(
              (anniversary) => anniversary['year'] == dateModel.anniversary,
              orElse: () => {'title': 'One Day Anniversary', 'year': 0},
            );

            return MedalWidget(
              title: selectedAnniversary['title'],
              year: selectedAnniversary['year'],
            );
          },
        ),
        Container(
          height: 400.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: anniversaryList.length,
            itemBuilder: (BuildContext context, int index) {
              return MedalWidget(
                title: anniversaryList[index]['title'],
                year: anniversaryList[index]['year'],
              );
            },
          )
        ),
      ],
    );
  }  
}


class MedalWidget extends StatelessWidget {
  MedalWidget({
    Key? key,
    required this.title,
    required this.year,
    }) : super(key: key);
  
  final String title;
  final int year;

  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateModel>(context);

    bool activated = false;
    activated = dateModel._anniversary >= year;
    return Column(
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: activated
            ? Image.asset('assets/gold_medal.jpg')
            : Image.asset('assets/gold_locked.jpg'),
        ),
        Text(title),
      ],
    );
  }
}

class SettingsPageWidget extends StatelessWidget {
  const SettingsPageWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateChangerWidget(),
        DateWidget(),
        AnniversaryWidget(),
        const Text("..."),
      ],
    );
  }
}

class FactContainer extends StatelessWidget {
  const FactContainer({
    Key? key,
    required this.title,
    required this.info
    }) : super(key: key);
  
  final String title;
  final String info;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(title),
          Text(info),
        ],
      ),
    );
  }
}


class DateChangerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateModel>(context);

    return ElevatedButton(
      onPressed: () {
        // Show date picker or any other method to change the date
        // For example, using showDatePicker
        showDatePicker(
          context: context,
          initialDate: dateModel.selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        ).then((newDate) {
          if (newDate != null) {
            dateModel.changeDate(newDate);
          }
        });
      },
      child: const Text('Change Date'),
    );
  }
}

class DateWidget extends StatelessWidget {
  const DateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateModel>(context);

    return Text('Selected Date: ${dateModel.selectedDate}');
  }
}

class AnniversaryWidget extends StatelessWidget {
  const AnniversaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dateModel = Provider.of<DateModel>(context);

    return Text('Selected Date: ${dateModel.anniversary}');
  }
}