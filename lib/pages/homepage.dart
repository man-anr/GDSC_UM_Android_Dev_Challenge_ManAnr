import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclaire/pages/addentry.dart';
import 'package:eclaire/pages/viewentry.dart';
import 'package:eclaire/utils/seperator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:analog_clock/analog_clock.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('entries');

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.add,
          color: Colors.white,

        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => AddEntry(),
              ))
              .then((value) => setState(() {}));
        },
      ),
      // appBar: AppBar(
      //   title: Text(
      //     'eClaire',
      //   ),
      //   elevation: 5.0,
      //   backgroundColor: Colors.blue,
      // ),
      body: CustomPaint(
        painter: ContainerPatternPainter(),
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 190.00,
                decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo,
                      blurRadius: 10.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(0.0, 0.0), // shadow direction: bottom right
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'eClaire',
                        style: TextStyle(
                          fontFamily: 'Aharoni',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 36.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 150.0,
                      height: 150.0,
                      child: AnalogClock(
                        decoration: BoxDecoration(
                            // border: Border.all(width: 2.0, color: Colors.black),
                            color: Colors.indigo,
                            shape: BoxShape.circle,
                            boxShadow: [
                            BoxShadow(
                              color: Colors.indigo,
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  0.0, 0.0), // shadow direction: bottom right
                            )
                          ],
                            
                            ),
                        width: 90.0,
                        isLive: true,
                        hourHandColor: Colors.white,
                        minuteHandColor: Colors.white,
                        showSecondHand: true,
                        numberColor: Colors.white,
                        showNumbers: true,
                        showAllNumbers: false,
                        textScaleFactor: 2.0,
                        showTicks: true,
                        showDigitalClock: true,
                        digitalClockColor: Colors.white,
                        datetime: DateTime.now(),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Text(
                    //     'A book that is near to our hearts',
                    //     style: TextStyle(
                    //       color: Colors.indigo,
                    //       // fontWeight: FontWeight.bold,

                    //       fontSize: 15.0,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ]),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: ref.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map data = snapshot.data!.docs[index].data();

                          DateTime tempDate =
                              new DateFormat("yyyy-MM-dd hh:mm:ss")
                                  .parse(data['date']);

                          String timeago = Jiffy(tempDate).fromNow();

                          String formatedTime =
                              DateFormat('EEE MMM d yyyy').format(tempDate);

                          int intColor = int.parse(data['color']);

                          Color mainColor = Color(intColor).withOpacity(1);
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 0.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => ViewEntry(
                                              data,
                                              snapshot
                                                  .data!.docs[index].reference,
                                            )))
                                    .then((value) => setState(() {}));
                              },
                              onLongPress: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title:
                                      const Text('You are deleting this entry'),
                                  content: const Text(
                                      'Are you sure on throwing away this masterpiece permanently?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'OK');
                                        snapshot.data!.docs[index].reference
                                            .delete()
                                            .then((value) => setState(() {}));
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              child: Card(
                                color: mainColor,
                                elevation: 1.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 10.0, 6.0, 6.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$formatedTime — ${data['body']}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      const MySeparator(color: Colors.grey),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "Created " + timeago,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: Center(
                        child: Text('Loading...'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dots(
    //         bgColor: Colors.lightBlue.shade100,
    //         fgColor: Colors.blueAccent,
    //         featuresCount: 100)
    //     .paintOnWidget(canvas, size);
    DiagonalStripesLight(
      bgColor: Colors.white,
      fgColor: Colors.lightBlue.shade100,
      featuresCount: 100,
    ).paintOnWidget(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
