import 'dart:async';
import 'dart:convert'; 
import 'package:http/http.dart' as http;
import 'package:state_management_example/base/base_enpoint.dart';
import 'package:state_management_example/model/model.dart';
import 'package:state_management_example/model/person_model.dart';  

class CallApi {
  Future<ModelCountry> fetchDataFromApi(String name) async {
    try {
      final url = Uri.parse('${EndPoint.GET_API}$name');
      final response = await http.get(url).timeout(EndPoint.REQUEST_LIMIT_TIME_OUT);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final modelCountry = ModelCountry.fromJson(data);
        return modelCountry; 
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }

  Future<List<PersonModel>> fetchDataPersonModelFromApi() async {
    try {
      final url = Uri.parse('${EndPoint.GET_API_PERSON}');
      final response =
          await http.get(url).timeout(EndPoint.REQUEST_LIMIT_TIME_OUT);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<PersonModel> dataResponeResult =
            data.map((dynamic json) => PersonModel.fromJson(json)).toList();
        return dataResponeResult;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error calling API: $e');
    }
  }
}



