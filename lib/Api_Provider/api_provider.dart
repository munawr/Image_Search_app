import 'dart:convert';
import '../Model/search_model.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String path =
      'https://pixabay.com/api/?key=31404840-23ef9ae49703e962c5036664b&q=';

  Future<SearchModel> search(String keyword) async {
    final response =
        await http.get(Uri.parse('$path$keyword&image_type=photo'));

    if (response.statusCode == 200) {
      print(response.statusCode);
      final jsondata = jsonDecode(response.body);
      return SearchModel.fromJson(jsondata);
    } else {
      throw 'error';
    }
  }
}
