import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
              useMaterial3: true,
            ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: [
              StatsPageWidget(),
              MedalsPageWidget(),
              SettingsPageWidget(),
            ],
          ),
          bottomNavigationBar: const TabBar(
            
            tabs: [
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Icon(Icons.bar_chart),
                ),
              ),
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Icon(Icons.calendar_month),
                ),
              ),
              Tab(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Icon(Icons.settings),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

class StatsPageWidget extends StatelessWidget {
  const StatsPageWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('This is the stats widget'),
    );
  }
}
class MedalsPageWidget extends StatelessWidget {
  const MedalsPageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Horizontal List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center( 
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 100),
            height: 200,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: const [
                MedalWidget(),
                MedalWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class SettingsPageWidget extends StatelessWidget {
  const SettingsPageWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('This is the settings widget'),
    );
  }
}

class MedalWidget extends StatelessWidget {
  const MedalWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/gold_test.jpg'),
        Image.asset('assets/gold_test.jpg'),
      ],
    );
  }
}