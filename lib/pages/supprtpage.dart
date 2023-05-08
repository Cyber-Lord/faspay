import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  TextEditingController _chatController = TextEditingController();

  List<String> _faqs = [
    "What is Faspay?",
    "How do I sign up for Faspay?",
    "How do I contact customer support?",
    "How do I update my account information?",
    "How do I change my password?",
    // "How do I add a payment method?",
    // "How do I cancel my subscription?",
    // "How do I change my notification settings?"
  ];
  List<String> _answer = [
    "Faspay is a fintech platform that enables businesses and individuals to process payments quickly and efficiently using QR codes, phone numbers, and NFC cards. It is available on the App Store and Play Store.",
    "You can sign up for Faspay by downloading the app from the App Store or Play Store, and following the prompts to create an account. You will need to provide some basic information such as your name, phone number, and email address.",
    "You can contact customer support by sending us a message in the app, or by sending an email to support@faspay.africa",
    "You can update your account information by going to the Account tab in the app, and tapping on the Edit button.",
    "You can change your password by going to the Account tab in the app, and tapping on the Change Password button.",
    // "You can add a payment method by going to the Account tab in the app, and tapping on the Add Payment Method button.",
    // "You can cancel your subscription by going to the Account tab in the app, and tapping on the Cancel Subscription button.",
    // "You can change your notification settings by going to the Account tab in the app, and tapping on the Notification Settings button.
  ];

  List<String> _chatMessages = [];

  void _sendMessage(String message) {
    setState(() {
      _chatMessages.add("You: $message");
    });

    // Perform some logic to handle the user's message

    // Then, send a response back from the "customer support" agent
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _chatMessages.add(
            "Customer Support: Thank you for contacting us! We will get back to you shortly.");
      });
    });

    // Clear the chat input field
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _faqs.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    title: Text(
                      _faqs[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          "${_answer[index]}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Chat with us",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(_chatMessages[index]),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: "Type your message here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: (() {
                    _sendMessage(_chatController.text);
                  }),
                  icon: Icon(
                    Icons.send,
                    color: Colors.blue.shade900,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
