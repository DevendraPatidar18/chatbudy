import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AboutUs extends StatefulWidget{
  const AboutUs();

  @override
  State<StatefulWidget> createState() => _AboutUsState();
}
class _AboutUsState extends State<AboutUs> {
  Map<String, dynamic>? aboutData;

  @override
  void initState() {
    super.initState();
    loadAboutUsData();
  }
  Future<void> loadAboutUsData() async {
    String jsonString = await rootBundle.loadString('assets/src/about_us.json');
    setState(() {
      aboutData = json.decode(jsonString);
    });
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child : Padding(
          padding: EdgeInsets.symmetric(horizontal: height*0.03,vertical: width*0.08),
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                aboutData!["title"],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(aboutData!["description"], style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text("Developed by: ${aboutData!["company"]}",
                  style: TextStyle(fontSize: 16)),
              Text("Author: ${aboutData!["author"]}",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Text("Contact Us:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Email: ${aboutData!["email"]}"),
              Text("Website: ${aboutData!["website"]}"),
            ],
          ),
        ),
      ),
    );
  }
}
