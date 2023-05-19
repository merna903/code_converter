import 'package:code_converter/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:highlight/languages/python.dart';

class PyLayoutScreen extends StatelessWidget {
  String? code;
  late CodeController pyController ;

  PyLayoutScreen(String code, {super.key}){
    pyController = CodeController(text: code,language: python);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
                  HexColor("ffcf40").withOpacity(0.5),
                  HexColor("104f87").withOpacity(0.5),
                ],
              )
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.bottomLeft,
              colors: [
                HexColor("ffcf40").withOpacity(0.5),
                HexColor("104f87").withOpacity(0.5),
              ],
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: buildBoardingItem(
                    icon: 'assets/images/icons8-python-96.png',
                    isReadOnly: true,
                    controller: pyController),
                ),
            ],
          ),
          ),
        ),
    );
  }
}
