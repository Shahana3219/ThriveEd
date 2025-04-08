import 'package:emotional_learning_platform/STUDENT/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Explicit platform registration for WebView
  if (WebViewPlatform.instance == null) {
    // Determine and set the appropriate WebView platform
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      WebViewPlatform.instance = AndroidWebViewPlatform();
    } else if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      WebViewPlatform.instance = WebKitWebViewPlatform();
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
