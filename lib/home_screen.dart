import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_tickets/sliding_page_view.dart';
import 'package:gallery_tickets/tabs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              SizedBox(
                height: 30,
              ),
              Tabs(),
              SizedBox(
                height: 10,
              ),
              SlidingPageView(),
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 30, left: 30, top: 20),
      child: Text(
        'Shaimaa Salama',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
