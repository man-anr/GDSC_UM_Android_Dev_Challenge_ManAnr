import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RichText Controller Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: RichTextControllerDemo()),
    );
  }
}

class RichTextControllerDemo extends StatefulWidget {
  @override
  _RichTextControllerDemoState createState() => _RichTextControllerDemoState();
}

class _RichTextControllerDemoState extends State<RichTextControllerDemo> {
  late RichTextController _controller;

  @override
  void initState() {
    _controller = RichTextController(
      patternMatchMap: {
        RegExp(
          "num|Byte|bool|byte|short|int|long|float|double|boolean|char/g",
        ): TextStyle(color: Colors.red),
        RegExp(
          "async|await|break|case|catch|class|const|continue|default|defferred|do|dynamic|else|enum|export|external/g",
        ): TextStyle(color: Colors.blue),
      },
      onMatch: (List<String> matches) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextFormField(
          controller: _controller,
        ),
      ),
    );
  } 
}
