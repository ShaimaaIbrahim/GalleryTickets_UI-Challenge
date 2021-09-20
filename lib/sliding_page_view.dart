import 'package:flutter/material.dart';
import 'dart:math' as math;

class SlidingPageView extends StatefulWidget {
  const SlidingPageView({Key? key}) : super(key: key);

  @override
  _SlidingPageViewState createState() => _SlidingPageViewState();
}

class _SlidingPageViewState extends State<SlidingPageView> {
  late PageController pageController;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page!);
      print('page number is ===========${pageController.page}');
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: PageView(
        controller: pageController,
        children: [
          SlidingCard(
              name: 'shaimaa salma being late for my gfggf 00---3',
              date: '4.28-31',
              assetName: 'hyper.png',
              offset: pageOffset),
          SlidingCard(
              name: 'shaimaa salma being late for my gfggf 00---3',
              date: '4.28-31',
              assetName: 'hyper.png',
              offset: pageOffset - 1),
          SlidingCard(
              name: 'shaimaa salma being late for my gfggf 00---3',
              date: '4.28-31',
              assetName: 'hyper.png',
              offset: pageOffset - 2),
        ],
      ),
    );
  }
}

class SlidingCard extends StatelessWidget {
  final String name;
  final String date;
  final String assetName;
  final double offset;

  const SlidingCard(
      {Key? key,
      required this.name,
      required this.date,
      required this.assetName,
      required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
      to make transformation at top level when reach 0.5 and then return near to 0 again
      we should use Gaussin function for this....
     */
    double gauss = math.exp(-(math.pow((offset.abs() - 0.5), 2) / 0.08));
    return Transform.translate(
        offset: Offset(-32 * gauss * offset.sign, 0), //transform card
        child: Card(
          margin: EdgeInsets.only(left: 8, right: 8, bottom: 15),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Image.asset(
                  'assets/$assetName',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  //alignment: Alignment(-offset.abs(), 0),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              CardContent(name: name, date: date, offset: gauss)
            ],
          ),
        ));
  }
}

class CardContent extends StatelessWidget {
  final String name;
  final String date;
  final double offset;

  const CardContent(
      {Key? key, required this.name, required this.date, required this.offset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 8,
            ),
            Text(
              date,
              style: TextStyle(color: Colors.grey),
            ),
            // Spacer(),
            Row(
              children: [
                RaisedButton(
                  color: Color(0xFF162A49),
                  child: Text('Reserve'),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  onPressed: () {},
                ),
                Spacer(),
                Text(
                  '0.00 \$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 16),
              ],
            )
          ],
        ));
  }
}
