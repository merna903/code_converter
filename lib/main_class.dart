import 'dart:io';

String error(String message) {
  return( message);
}

List<int> extractCondition(String cppStatment){
  int count = 0;
  if(cppStatment.indexOf("(") != -1){
    count++;
  }
  int bodyStartIndex = cppStatment.indexOf("(") + 1;
  for(int i = bodyStartIndex; i < cppStatment.length; i++){
    if(cppStatment[i] == '('){
      count++;
    }
    else if(cppStatment[i] == ')'){
      count--;
    }
    if(count == 0){
      return [bodyStartIndex, i];
    }
  }
  return [];
}

List<String> extractCode(String cppCode , int conditionEndIndex){
  int count = 0;
  if(cppCode.substring(conditionEndIndex ,conditionEndIndex + 1) != "{"){
    if(cppCode.indexOf(";")==-1)
      error("statment without body");
    return [cppCode.substring(conditionEndIndex + 1, cppCode.indexOf(";"))+"\n", extractRest(cppCode, cppCode.indexOf(";") + 1)];
  }
  if(cppCode.indexOf("{") != -1){
    count++;
  }
  int body_start_index = cppCode.indexOf("{") + 1;
  for(int i = body_start_index; i < cppCode.length; i++){
    if(cppCode[i] == '{'){
      count++;
    }
    else if(cppCode[i] == '}'){
      count--;
    }
    if(count == 0){
      return [cppCode.substring(body_start_index, i)+"\n",extractRest(cppCode, i+1)];
    }
  }
  return [];
}

String extractRest(String cppCode, int restOfTheCodeStartindex){
  return cppCode.substring(restOfTheCodeStartindex);
}

bool checkCondition(String condition){
  var conditionRegex = RegExp(r'^\s*([^;]+)\s*$');
  return !conditionRegex.hasMatch(condition);
}

bool checkVariableName(String variableName){
  var variableRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
  return !variableRegex.hasMatch(variableName);
}

bool checkValueExpression(String valueExpression){
  var valueRegex = RegExp(r'^\s*\(?[a-zA-Z]\w*\)?\s*[-+*/]\s*\(?[a-zA-Z]\w*\)?\s*$|^(\d+[-+*/]\d+)\s*$|^([0-9]{1,2})\s*$');
  return !valueRegex.hasMatch(valueExpression);
}

String removeDataTypes(String cppCode){
  var dataTypeRegex = RegExp(r"^(int|short|long|float|double|char|bool|String|signed|unsigned)");
  final newString = cppCode.replaceAll(dataTypeRegex, '');
  return newString;
}

String removeWhiteSpace(String statment){
  return statment.replaceAll(' ', '');
}

String formatter(String code)
{
  List<String> cppOperators = ["&&","||","true","false"];
  List<String> pythonOperators = [" and "," or "," True "," False "];
  for(int i =0;i<cppOperators.length;i++){
    int pos = 0;
    while ((pos = code.indexOf(cppOperators[i], pos)) != -1) {
      code = code.replaceRange(pos, cppOperators[i].length + pos, pythonOperators[i]);
      pos += pythonOperators[i].length;
    }
  }
  return code;
}



/* ************************************************************************** */

String convertStatment(String cppStatment, String statmentType)
{
  List<int> conditionExpressionIndecis = [];
  String conditionExpression = "";
  if(statmentType == "if" || statmentType == "else if" || statmentType == "while")
  {
    // extract the condition expression
    conditionExpressionIndecis = extractCondition(cppStatment);
    conditionExpression = cppStatment.substring(conditionExpressionIndecis[0], conditionExpressionIndecis[1]);

    // check if the condition expression is valid
    if (checkCondition(conditionExpression)) {
      error("Error in condition expression");
    }
    conditionExpression = removeWhiteSpace(conditionExpression);
  }

  // extract the body and the rest of the code of the if statement
  List<String> code = [];

  if(statmentType != "else")
    code = extractCode(cppStatment, conditionExpressionIndecis[1]+1);
  else
    code = extractCode(cppStatment, 4);
  if(code.length == 0)
    error("Error in the body of the statment");
  String body = code[0];
  String restOfCode = code[1];
  body = removeDataTypes(body);
  body = translate(body);


  cppStatment = removeWhiteSpace(cppStatment);

  // create the equivalent Python code
  String pythonCode = "";
  if(statmentType == "if")
  {
    pythonCode = "if " + conditionExpression + ":\n";
  }
  else if(statmentType == "else if")
  {
    pythonCode = "elif " + conditionExpression + ":\n";
  }
  else if(statmentType == "else")
  {
    pythonCode = "else:\n";
  }
  else
  {
    pythonCode = "while " + conditionExpression + ":\n";
  }

  int pos = 0;
  while ((pos = body.indexOf("\n", pos)) != -1) {
    body = body.replaceRange(pos, pos+1, "\n   ");
    pos += 2;
  }

  pythonCode +='    ' + body ;

  for(int i =0;i<pythonCode.length;i++)
    if(pythonCode[i]==';')
      pythonCode.replaceFirst(';','');

  String translatedCode = "";

  if(restOfCode != "")
    translatedCode = translate(restOfCode);

  if(translatedCode != ""){
    pythonCode += "\n" + translatedCode;
  }
  return pythonCode;
}

bool checkValidAssignmentStatement(String cppStatment)
{
  // remove any leading/trailing white space
  cppStatment = cppStatment.trim();

  // check if the statement contains an equal sign
  if (cppStatment.indexOf("=") == -1) {
    return false;
  }
  // extract the variable name
  int variableEndIndex = cppStatment.indexOf("=");
  String variableName = cppStatment.substring(0, variableEndIndex);
  // remove any data types
  // remove any data types
  variableName = removeDataTypes(variableName);
  variableName = removeWhiteSpace(variableName);

  // check if the variable name is valid
  if (checkVariableName(variableName)) {
    return false;
  }

  // extract the value expression
  if(cppStatment.indexOf(";")==-1)
    return false;

  String valueExpression = cppStatment.substring(variableEndIndex + 1,cppStatment.indexOf(";"));

  // check if the value expression is valid
  if (checkValueExpression(valueExpression)) {
    return false;
  }

  return true;
}

String convertAssignmentStatement(String cppAssignmentStatement) {
  // remove any leading/trailing white space
  cppAssignmentStatement = cppAssignmentStatement.trim();

  // extract the variable name
  int variableEndIndex = cppAssignmentStatement.indexOf("=");
  String variableName = cppAssignmentStatement.substring(0, variableEndIndex);

  // remove any data types
  variableName = removeDataTypes(variableName);
  variableName = removeWhiteSpace(variableName);
  String valueExpression = cppAssignmentStatement.substring(variableEndIndex + 1,cppAssignmentStatement.indexOf(";"));
  cppAssignmentStatement = cppAssignmentStatement.substring(cppAssignmentStatement.indexOf(";")+1);

  // create the equivalent Python code
  String translated = "";
  if(cppAssignmentStatement !="")
  {
    translated = translate(cppAssignmentStatement);
  }

  String pythonCode = variableName + " = " + valueExpression + (translated==""?"":"\n" + translated);
  return pythonCode;
}

String translate(String code){
  String translatedCode;

  // remove any leading/trailing white space
  code = code.trim();

  // check if the statement starts with "if"
  if (code.length>=2&&code.substring(0, 2) == "if") {
    translatedCode = convertStatment(code, "if");
  }else if(code.length>=7&&code.substring(0, 7) == "else if"){
    translatedCode = convertStatment(code, "else if");
  }else if(code.length>=4&&code.substring(0, 4) == "else"){
    translatedCode = convertStatment(code, "else");
  }
  else if(code.length>=5&&code.substring(0, 5) == "while"){
    translatedCode = convertStatment(code, "while");
  }
  else if(checkValidAssignmentStatement(code)){
    translatedCode = convertAssignmentStatement(code);
  }
  else {
    return error("Invalid statement : " + code);
  }
  return translatedCode;
}