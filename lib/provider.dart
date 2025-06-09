import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Services with ChangeNotifier {
  List myData = [];

  List allList = [];
// GET method to fetch data
  getDataProvider() async {
    var url = Uri.parse("https://api.nstack.in/v1/todos");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> fetchedData = json['items'];
      final filterList = fetchedData.where((element) {
        return element['is_completed'] == false;
      }).toList();

      myData = filterList;

      allList = json['items'];

      notifyListeners();
    }
  }

// Post method to create data
  Future<void> postDataProvider({
    required String title,
    required String desc,
    required BuildContext context,
  }) async {
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false,
    };
    var url = Uri.parse("https://api.nstack.in/v1/todos");

    var response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Created Successfully"),
        backgroundColor: Colors.green,
      ));
      getDataProvider();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Creation Failed"),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Put method to update data

  Future<void> putDataProvider(
      {required String id1,
      required String title,
      required String desc,
      required BuildContext context}) async {
    final id = id1;
    final body = {
      "title": title,
      "description": desc,
      "is_completed": false,
    };
    var url = Uri.parse("https://api.nstack.in/v1/todos/$id");

    var response = await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Updated Successfully"),
        backgroundColor: Colors.green,
      ));
      getDataProvider();

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Update Failed"),
        backgroundColor: Colors.red,
      ));
    }
  }

  //Delete to delete data
  deleteDataProvider(String id) async {
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    await http.delete(url);
    getDataProvider();
  }

  //Check to check task

  checkBoxProvider(
      {required check,
      required String id,
      required String title,
      required String desc}) async {
    final body = {
      "title": title,
      "description": desc,
      "is_completed": check,
    };
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");

    // final response =
    await http.put(url,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    getDataProvider();
  }
}



// Future<void> getDataProvider() async {
//   var url = Uri.parse("https://api.nstack.in/v1/todos");
//   int currentPage = 1; // Start from the first page
//   List<dynamic> allItems = []; // To collect all items

//   do {
//     // Fetch data for the current page
//     var response = await http.get(Uri.parse("$url?page=$currentPage"));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> json = jsonDecode(response.body);
//       List<dynamic> fetchedData = json['items'];

//       // Add fetched data to the allItems list
//       allItems.addAll(fetchedData);

//       // Check if there are more pages
//       bool hasMorePage = json['meta']['has_more_page'];
//       if (!hasMorePage) {
//         break; // Exit if there are no more pages
//       }

//       currentPage++; // Move to the next page
//     } else {
//       // Handle error
//       print("Error fetching data: ${response.statusCode}");
//       break; // Exit loop on error
//     }
//   } while (true); // Continue until all pages are fetched

//   // Filter and update the myData list as needed
//   myData = allItems.where((element) => element['is_completed'] == false).toList();
//   notifyListeners(); // Notify listeners to update UI
// }