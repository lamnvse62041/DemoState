import 'package:flutter/material.dart';
import 'package:state_management_example/manage_state/state_manager.dart';
import 'package:state_management_example/model/person_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StateManager _stateManager = StateManager();
  late Future<dynamic> _apiDataFuture;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('State Management Demo')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder<dynamic>(
              stream: _stateManager.createState<String>('userName', '').stream,
              initialData: _stateManager.nameDefault,
              builder: (context, snapshot) {
                return Text('${snapshot.data}');
              },
            ),
            ElevatedButton(
              onPressed: () {
                _stateManager.updateRandomUserName();
              },
              child: const Text('Change User Name'),
            ),
            StreamBuilder<int>(
              stream: _stateManager.countStream,
              initialData: _stateManager.count,
              builder: (context, snapshot) {
                return Text('Count: ${snapshot.data}');
              },
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _stateManager.creaseCount();
                  },
                  child: const Text('Count ++'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _stateManager.inCreaseCount();
                  },
                  child: const Text('Count --'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _stateManager.resetAllToDefault();
              },
              child: const Text('Reset to default'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _apiDataFuture = _stateManager.fetchDataFromApi("nathaniel");
                });
              },
              child: const Text('Fetch API Data'),
            ),
            FutureBuilder(
              future: _stateManager.fetchDataFromApi("nathaniel"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final modelCountry = snapshot.data!;
                  return Column(
                    children: [
                      Text('Name: ${modelCountry.name ?? "No Name"}'),
                      Text('Count: ${modelCountry.count ?? "No Count"}'),
                      if (modelCountry.country != null)
                        Column(
                          children: modelCountry.country!
                              .map((country) => Text(
                                  'Country: ${country.countryId}, Probability: ${country.probability}'))
                              .toList(),
                        ),
                    ],
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
            FutureBuilder<List<PersonModel>>(
              future: _stateManager.fetchPerSonDataFromApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final personModels = snapshot.data!;
                  return ListView.builder(
                    itemCount: personModels.length,
                    itemBuilder: (context, index) {
                      final person = personModels[index];
                      return Card(
                        margin:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Text(person.title ?? "No Title"),
                          subtitle: Text(person.body ?? "No Body"),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
