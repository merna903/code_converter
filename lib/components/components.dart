import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

Widget buildBoardingItem({
  required String icon,
  required bool isReadOnly,
  required CodeController controller
}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image(image: AssetImage(icon), height: 80,),),
        const SizedBox(
          height: 20.0,
        ),
        Expanded(
          child: defaultFormField(
              controller: controller,
              readOnly:isReadOnly
          ),
        ),
      ],
    );


Widget defaultFormField({
  required CodeController controller,
  required bool readOnly,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: CodeField(
              gutterStyle: const GutterStyle(
                showErrors: false,
                width: 70,
              ),
              controller: controller,
              readOnly: readOnly,
              minLines: 10,
            ),
          ),
        ),
      ),
    );


void navigateTo(context,widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget ,
  ),
);
