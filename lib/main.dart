import 'package:ddd_notes/injection.dart';
import 'package:ddd_notes/presentation/core/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /* if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "",
          authDomain: "",
          databaseURL: "", // **DATABASEURL MUST BE GIVEN.**
          projectId: "",
          storageBucket: "",
          messagingSenderId: "",
          appId: ""),
    );
  } else {
    await Firebase.initializeApp();
  } */
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
