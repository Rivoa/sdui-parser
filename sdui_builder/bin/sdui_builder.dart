import 'dart:convert';
import 'dart:io';
import './swidget.dart';

void main() async {
  // 1. Define your screen
  final loginScreen = SScaffold(
    appBar: SAppBar(
      title: SText("Welcome User"),
      centerTitle: true,
      backgroundColor: "#4A90E2",
      foregroundColor: "#FFFFFF",
    ),
    body: SContainer(
      padding: 24.0,
      child: SColumn(
        mainAxisAlignment: "center",
        crossAxisAlignment: "stretch",
        children: [
          // Logo Area
          SCenter(
            child: SIcon("lock", size: 80, color: "#4A90E2"),
          ),
          SSizedBox(height: 32),

          // Inputs
          STextField(
            controllerId: "email_input",
            labelText: "Email Address",
            prefixIcon: SIcon("email"),
            border: "outline",
          ),
          SSizedBox(height: 16),
          STextField(
            controllerId: "pass_input",
            labelText: "Password",
            prefixIcon: SIcon("lock"),
            obscureText: true,
            border: "outline",
          ),

          SSizedBox(height: 32),

          // Action Button
          SElevatedButton(
            onPressed: "login()", // <--- The signal to your Flutter Logic
            padding: 16.0,
            child: SText(
              "SIGN IN", 
              style: {"fontWeight": "bold", "fontSize": 16}
            ),
          ),
        ],
      ),
    ),
  );

  // 2. Generate JSON string
  final jsonString = loginScreen.toJsonString(pretty: true);

  // 3. Option A: Print to console (for testing)
  print(jsonString);

  // 4. Option B: Save to file (for local dev server)
  // final file = File('login_screen.json');
  // await file.writeAsString(jsonString);
  // print("Saved to login_screen.json");
}