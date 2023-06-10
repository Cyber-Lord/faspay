import 'package:faspay/pages/qrscan.dart';
import 'package:faspay/pages/supprtpage.dart';
import 'package:faspay/pages/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'homepage.dart';

class Custome_tba extends StatefulWidget {

  const Custome_tba({Key? key, required this.trnx_id}) : super(key: key);
  final String trnx_id;
  @override
  State<Custome_tba> createState() => _Custome_tbaState();
}

class _Custome_tbaState extends State<Custome_tba> {
  @override
  Widget build(BuildContext context) {
    setState(() {
     _launchURL(context);
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 10,


      ),

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(phoneNumber: '', token: 'token'),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: const Text(
              'Return to Dashboard',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await launch(
        'https://myphp0101.azurewebsites.net/?ref='+widget.trnx_id,
        customTabsOption: CustomTabsOption(
          toolbarColor: theme.primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: theme.primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
