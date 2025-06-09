import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/color.dart';
import 'package:todo/create.dart';
import 'package:http/http.dart' as http;
import 'package:todo/provider.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  @override
  void initState() {
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Services>(
      context,
    );
    List myData = prov.allList;

    return Scaffold(
      backgroundColor: kBlackColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kOrangeColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allow for fixed height
            builder: (context) {
              return Container(
                height: 400, // Set your desired fixed height
                child: CreatePage(), // Your CreatePage widget
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),
      appBar: AppBar(
        backgroundColor: kBlackColor,
        surfaceTintColor: kBlackColor,
        foregroundColor: kOrangeColor,
        centerTitle: true,
        title: Text(
          "All Tasks",
          style: TextStyle(fontSize: 16),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         // getData();
        //       },
        //       icon: Icon(Icons.refresh))
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: kOrangeColor,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.all(8),
                child: Text("${myData.length}  Tasks"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: myData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = myData.reversed.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: kBlack2Color,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data["title"],
                                style: TextStyle(
                                  fontSize: 20,
                                  decoration: data["is_completed"]
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                data["description"],
                                style: TextStyle(color: kGreyColor),
                              )),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat.yMMMEd()
                                    .format(DateTime.parse(data["created_at"]))
                                    .toString(),
                                style:
                                    TextStyle(color: kGreyColor, fontSize: 12),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return CreatePage(
                                        itemData: data,
                                      ); // For new task creation
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  size: 18,
                                ),
                                color: kGreenColor,
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: kBlack2Color,
                                        icon: Icon(
                                          Icons.warning,
                                          color: kRedColor,
                                          size: 40,
                                        ),
                                        title: Text(
                                          "Confirm Deletion",
                                          style: TextStyle(color: kGreyColor),
                                        ),
                                        content: Text(
                                            "Are you sure you want to delete this task?"),
                                        actions: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: kGreenColor),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: kRedColor),
                                            onPressed: () {
                                              prov.deleteDataProvider(
                                                  data['_id']);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "Delete",
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                                color: kRedColor,
                                iconSize: 18,
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                    shape: CircleBorder(),
                                    activeColor: kOrangeColor,
                                    side: BorderSide(color: kWhiteColor),
                                    value: data['is_completed'],
                                    onChanged: (val) {
                                      prov.checkBoxProvider(
                                          check: val!,
                                          id: data['_id'],
                                          title: data['title'],
                                          desc: data['description']);
                                    }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
