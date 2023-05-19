import 'dart:io';
import 'dart:async' show Future;

import 'package:code_converter/main_class.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:bloc/bloc.dart';
import 'package:code_converter/cudits/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';


class AppCubit extends Cubit<AppStates>
{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  //get path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  //output File
  Future<File> get _localFile1 async {
    final path = await _localPath;
    return File('$path/output.py');
  }

  //input File
  Future<File> get _localFile2 async {
    final path = await _localPath;
    return File('$path/input.cpp');
  }

  //read file
  Future<String> readCode(bool py) async {
    emit(AppReadCodeLoadingState());
    try {
       final file =  py? await _localFile1 : await _localFile2 ;
      // Read the file
      final code = await file.readAsString();
      emit(AppReadCodeSuccessState());
      return code;
    } catch (e) {
      emit(AppReadCodeErrorState(e.toString()));
      // If encountering an error, return 0
      return e.toString();
    }
  }

  //write file
  Future<File> writeCode(String code,bool py) async {
    emit(AppWriteCodeLoadingState());
    final file = py? await _localFile1 : await _localFile2;
    // Write the file
    emit(AppWriteCodeSuccessState());
    return file.writeAsString(code);
  }

  Future<File> excuteMainCpp() async
  {
    String cppCode = await readCode(false);
    String pythonCode = formatter(translate(cppCode));
    return writeCode(pythonCode, true);
  }

}