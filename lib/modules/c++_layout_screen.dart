import 'package:code_converter/components/components.dart';
import 'package:code_converter/cudits/cudit.dart';
import 'package:code_converter/cudits/states.dart';
import 'package:code_converter/modules/python_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:highlight/languages/cpp.dart';

class CppLayoutScreen extends StatelessWidget {

  var cppController = CodeController(language: cpp);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>AppCubit() ,
      child: BlocConsumer<AppCubit,AppStates>(
        builder: (BuildContext context, state)
        {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: const [
                  Image(image: AssetImage('assets/images/icons8-code-48.png'),
                    height: 35,),
                  SizedBox(
                    width: 7,
                  ),
                  Text('CodeConvert',
                  style: TextStyle(
                    fontFamily: 'FiraCode',
                  ),),
                ],
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.topLeft,
                      colors: [
                        HexColor("104f87").withOpacity(0.5),
                        HexColor("ffcf40").withOpacity(0.5),
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
                      HexColor("104f87").withOpacity(0.5),
                      HexColor("ffcf40").withOpacity(0.5),
                    ],
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children:
                  [
                    Expanded(
                      child: buildBoardingItem(
                        icon: 'assets/images/icons8-c++-96.png',
                        isReadOnly: false,
                        controller: cppController,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF000000).withAlpha(60),
                                blurRadius: 6.0,
                                spreadRadius: 0.0,
                                offset: const Offset(
                                  0.0,
                                  3.0,
                                ),
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.black.withOpacity(0.8))
                              ),
                              onPressed: () {
                                  AppCubit.get(context).writeCode(cppController.fullText,false).then((value)
                                  {
                                    AppCubit.get(context).excuteMainCpp().then((value) {
                                      navigateTo(
                                          context,
                                          FutureBuilder(
                                              future:AppCubit.get(context).readCode(true),
                                              builder: (context,data)
                                              {
                                                return PyLayoutScreen(data.data.toString());
                                              }
                                          )
                                      );
                                    });
                                  });
                              },
                              child: const Text('Convert', style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white70,
                              ),)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, Object? state)
        {

        },
      ),
    );
  }
}
