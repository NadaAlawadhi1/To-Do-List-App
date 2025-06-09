import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/color.dart';
import 'package:todo/provider.dart';

class CreatePage extends StatefulWidget {
  Map? itemData;
  CreatePage({super.key, this.itemData});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titleCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final data = widget.itemData;
    if (data != null) {
      isEdit = true;
      titleCont.text = data['title'];
      descriptionCont.text = data['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Services>(
      context,
    );
    return Container(
      decoration: BoxDecoration(
          color: kBlackColor,
          border: Border(top: BorderSide(width: 5, color: kOrangeColor))),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task Title"),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: titleCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kOrangeColor),
                  ),
                  fillColor: kBlack2Color,
                  filled: true,
                  hintText: "Enter task title...",
                  hintStyle: TextStyle(color: kGreyColor, fontSize: 14),
                ),
              ),
              SizedBox(height: 20),
              Text("Task Description"),
              SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 5,
                controller: descriptionCont,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kOrangeColor),
                  ),
                  fillColor: kBlack2Color,
                  filled: true,
                  hintText: "Enter task description...",
                  hintStyle: TextStyle(color: kGreyColor, fontSize: 14),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kOrangeColor,
                          foregroundColor: kWhiteColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        isEdit
                            ? prov.putDataProvider(
                                id1: widget.itemData!["_id"],
                                title: titleCont.text,
                                desc: descriptionCont.text,
                                context: context)
                            : prov.postDataProvider(
                                title: titleCont.text,
                                desc: descriptionCont.text,
                                context: context);
                      },
                      child: Text(isEdit ? "Update Task" : "Create Task"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
