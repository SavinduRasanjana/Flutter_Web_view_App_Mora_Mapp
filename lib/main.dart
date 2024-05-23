import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true), // Use Material 3 theme
      home: const WebViewApp(),
    ),
  );
}

// Main StatefulWidget for the WebView application
class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller; // Controller to manage WebView
  bool _isLoading = true; // State to track loading status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Navigate back in webview history
                controller.goBack();
              },
            ),
            const SizedBox(width: 8), // Add some space between buttons
            const Text('Mora Mapp'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              // Show instructions
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Instructions'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInstructionText('How to use'),
                      const SizedBox(height: 8),
                      Text('1. Touch the direction you want to go.'),
                      Text('2. Drag your finger to look around.'),
                      Text('3. Pinch with two fingers to zoom in and out.'),
                      Text('4. Use the search bar to find places.'),
                      Text('5. After giving feedback, use the back button on the upper left side to navigate back to the map.'),
                      const SizedBox(height: 16),
                      _buildInstructionText('Errors'),
                      const SizedBox(height: 8),
                      Text('If there is an error message, please check your internet connection and use the reload button.'),
                      Text('If the error continues, please close the app and try restarting.'),
                      const SizedBox(height: 16),
                      Text('For more help, email support@example.com.'), // Use a placeholder email
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Reload the WebView
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://example.com', // Use a placeholder URL
            onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;
              controller.loadUrl('https://example.com'); // Load the placeholder URL again
            },
            javascriptMode: JavascriptMode.unrestricted, // Allow JavaScript
            navigationDelegate: (NavigationRequest request) {
              // Check if the URL is a pop-up or unwanted redirect
              if (request.url.startsWith('https://my.matterport.com/show/popup') ||
                  request.url.startsWith('https://unwantedredirect.com')) {
                return NavigationDecision.prevent; // Cancel the navigation
              }
              return NavigationDecision.navigate; // Allow all other navigations
            },
            onPageStarted: (url) {
              setState(() {
                _isLoading = true; // Show loading indicator when page starts loading
              });
            },
            onPageFinished: (url) {
              setState(() {
                _isLoading = false; // Hide loading indicator when page finishes loading
              });
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(), // Show loading spinner
            ),
        ],
      ),
    );
  }

  // Helper method to build instructional text with specific styling
  Widget _buildInstructionText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
