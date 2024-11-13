import 'dart:async';
import 'dart:math';
import 'package:state_management_example/manage_state/simple_stream_state.dart';
import 'package:state_management_example/model/model.dart';
import 'package:state_management_example/model/person_model.dart';
import 'package:state_management_example/service/get_data_api.dart';

class StateManager {
  final Map<String, StreamController<dynamic>> _controllers = {};
  int _count = 0;
  String nameDefault = "State Management Demo";
  final StreamController<int> _countController =
      StreamController<int>.broadcast();

  Stream<int> get countStream => _countController.stream;
  int get count => _count;
  String get name => nameDefault;

  final CallApi _callApi = CallApi();

  final List<String> _userNames = [
    'Nguyen Van A',
    'Nguyen Van B',
    'Nguyen Van C',
    'Nguyen Van D'
  ];

  SimpleStreamState<dynamic> createState<T>(String key, T defaultValue) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = StreamController<T>.broadcast();
      _controllers[key]!.add(defaultValue); 
    }

    return SimpleStreamState<dynamic>(_controllers[key]!);
  }

  void updateRandomUserName() {
    final random = Random();
    final randomUserName =
        _userNames[random.nextInt(_userNames.length)]; 
    _controllers['userName']?.add(randomUserName); 
  }

  SimpleStreamState<int> creaseCount() {
    _count++; 
    _countController.add(_count); 

    if (!_controllers.containsKey('count')) {
      _controllers['count'] = _countController;
    }

    return SimpleStreamState<int>(_countController);
  }

  SimpleStreamState<int> inCreaseCount() {
    _count--; 
    _countController.add(_count); 

    if (!_controllers.containsKey('count')) {
      _controllers['count'] = _countController;
    }

    return SimpleStreamState<int>(_countController);
  }

  void resetAllToDefault() {
    _count = 0;
    _countController.add(_count);
     _controllers['userName']?.add(nameDefault); 
  }

  void dispose() {
    _countController.close();
    _controllers.forEach((key, controller) {
      controller.close();
    });
  }

  Future<ModelCountry> fetchDataFromApi(String name) async {
    return await _callApi
        .fetchDataFromApi(name); 
  }

  Future<List<PersonModel>> fetchPerSonDataFromApi() async {
    return await _callApi
        .fetchDataPersonModelFromApi();
  }
}
