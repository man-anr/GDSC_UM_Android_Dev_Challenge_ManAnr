import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eclaire/utils/seperator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:patterns_canvas/patterns_canvas.dart';
import 'package:eclaire/controller/google_auth.dart';

import '../utils/keywords_lib.dart';

class ViewEntry extends StatefulWidget {
  final Map data;
  final DocumentReference ref;

  ViewEntry(this.data, this.ref);

  @override
  _ViewEntryState createState() => _ViewEntryState();
}

class _ViewEntryState extends State<ViewEntry> {
  late String entryBody = widget.data['body'];

  late String modEntryBody = entryBody;
  late String entryDate =
      DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now());

  late String quote = widget.data['quote'];
  late String quoteAuthor = widget.data['quote_author'];

  late RichTextController _controller;
  late Map<String, HighlightedWord> words;

  final EdgeInsetsGeometry padding = EdgeInsets.all(8.0);

  final BoxDecoration decoration = BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(50),
  );

  final TextStyle inputTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 15.0,
  );

  final TextStyle textStyle = TextStyle(
    color: Colors.red,
    fontSize: 26.0,
  );

  late int intColor = int.parse(widget.data['color']);
  late Color mainColor = Color(intColor).withOpacity(1);

  @override
  void initState() {
    _controller = RichTextController(
      text: entryBody,
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
                              color: mainColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      quote + " — " + quoteAuthor,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                                const MySeparator(color: Colors.grey),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                Expanded(
                                    child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Form(
                                        child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _controller,
                                          maxLines: 20,
                                          minLines: 10,
                                          style: inputTextStyle,
                                          // initialValue: "${widget.data['body']}",
                                          decoration: InputDecoration.collapsed(
                                            hintText: "Start writing...",
                                          ),
                                          onChanged: (_val) {
                                            modEntryBody = _val;
                                            print(entryBody);
                                          },
                                        ),
                                      ],
                                    )),
                                  ),
                                )),
                                const MySeparator(color: Colors.grey),
                                Container(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 10, 8, 8),
                                  child: Text(
                                    name,
                                    style: TextStyle(
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
                        if (!identical(modEntryBody, entryBody)) {
                          widget.ref.update({
                            'body': modEntryBody,
                          });
                        }

                        Navigator.pop(context);
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
                                  print(mainColor.toString());
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

  Widget buildColorPicker() => BlockPicker(
      pickerColor: mainColor,
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
      onColorChanged: (color) => setState(() => this.mainColor = mainColor));
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
