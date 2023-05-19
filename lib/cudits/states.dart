abstract class AppStates{}

class AppInitialState extends AppStates {}

class AppWriteCodeLoadingState extends AppStates {}

class AppWriteCodeSuccessState extends AppStates {}

class AppReadCodeLoadingState extends AppStates {}

class AppReadCodeSuccessState extends AppStates {}

class AppReadCodeErrorState extends AppStates
{
  final String error;
  AppReadCodeErrorState(this.error);

}