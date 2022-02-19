import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclaire/utils/classifier.dart';
import 'package:eclaire/utils/evaluator.dart';
import 'package:eclaire/utils/keywords_lib.dart';
import 'package:eclaire/utils/seperator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:eclaire/controller/google_auth.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  _AddEntryState createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  String entryBody = "";
  String entryDate = DateFormat("yyyy-MM-dd hh:mm:s").format(DateTime.now());
  String? entryQuote;
  String? entryQuoteAuthor;
  final TextStyle inputTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 15.0,
  );

  Color color = Colors.white;

  late RichTextController _controller;
  Classifier? _classifier;
  // late List<Widget> _children;

  @override
  void initState() {
    _classifier = Classifier();
    _controller = RichTextController(
      patternMatchMap: Keywords.getKeywords(),
      onMatch: (List<String> matches) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CustomPaint(
                    painter: ContainerPatternPainter(),
                    child: Container(
                      // color: Colors.lightBlue[100],
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 65.0),
                          child: Container(
                            height: 555,
                            width: 350,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        entryDate,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const MySeparator(color: Colors.grey),
                                Expanded(
                                    child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Form(
                                        child: Column(
                                      children: [
                                        TextFormField(
                                          maxLines: 20,
                                          minLines: 10,
                                          style: inputTextStyle,
                                          decoration: InputDecoration.collapsed(
                                              hintText:
                                                  "Start writing your thoughts on today"),
                                          controller: _controller,
                                          onChanged: (_val) {
                                            entryBody = _val;
                                          },
                                        )
                                      ],
                                    )),
                                  ),
                                )),
                                const MySeparator(color: Colors.grey),
                                Container(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 10, 8, 8),
                                  child: Text(name, style: TextStyle(
                                      fontFamily: 'Shorelines',
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // final text = _controller.text;

                        if (entryBody == "") {
                          Navigator.pop(context);
                        } else {
                          add();
                        }
                      },
                      child: Icon(Icons.arrow_back_ios_new),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.5,
                        shape: CircleBorder(),
                        primary: Colors.transparent, // <-- Button color
                        onPrimary: Colors.lightBlue[100], // <-- Splash color
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                      child: ElevatedButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Page Color'),
                            content: Column(
                              children: [
                                const Text('Pick a color that you prefer'),
                                buildColorPicker(),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  print(color.toString());
                                },
                                child: const Text('Okay'),
                              ),
                            ],
                          ),
                        ),
                        child: Icon(Icons.color_lens),
                        style: ElevatedButton.styleFrom(
                          elevation: 0.5,
                          shape: CircleBorder(),
                          primary: Colors.transparent, // <-- Button color
                          onPrimary: Colors.lightBlue[100], // <-- Splash color
                        ),
                      ),
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

  void add() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('entries');

    final prediction = _classifier!.classify(entryBody);

    String colorString = color.toString().substring(6, 16);

    entryQuote = Evaluator.getQuotes(
            Evaluator.getResult(prediction[1], prediction[0]))!['text']
        .toString();
    entryQuoteAuthor = Evaluator.getQuotes(
            Evaluator.getResult(prediction[1], prediction[0]))!['author']
        .toString();

    var data = {
      'date': entryDate,
      'body': entryBody,
      'created':
          DateFormat("yyyy-MM-dd hh:mm:s").format(DateTime.now()).toString(),
      'quote_author': entryQuoteAuthor,
      'quote': entryQuote,
      'color': colorString,
    };

    ref.add(data);

    Navigator.pop(context);
  }

  Widget buildColorPicker() => BlockPicker(
      pickerColor: color,
      availableColors: [
        Colors.white,
        Colors.lightGreen.shade50,
        Colors.lightBlue.shade50,
        Colors.pink.shade50,
        Colors.orange.shade50,
        Colors.deepOrange.shade50,
        Colors.amber.shade50,
        Colors.indigo.shade50,
        Colors.brown.shade50,
      ],
      onColorChanged: (color) => setState(() => this.color = color));
}

class ContainerPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Dots(
            bgColor: Colors.indigo.shade100,
            fgColor: Colors.indigo,
            featuresCount: 50)
        .paintOnWidget(canvas, size);
    // DiagonalStripesLight(
    //         bgColor: Color(0xff0509050), fgColor: Color(0xfffdbf6f))
    //     .paintOnWidget(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
