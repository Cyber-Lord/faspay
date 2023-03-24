import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'homepage.dart';
class Login extends StatefulWidget {
  const Login({Key? key,required this.phoneNumber,required this.name}) : super(key: key);
  final String phoneNumber;
final String name;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isButtonEnabled = false;
  bool show_preogress =false;
  bool surgest_login=false;
  bool correct_pass_checker=false ;
  String? _phoneNumber;
  String token="";

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
body: Stack(
  children: [

    ListView(
      children: [

        Padding(
          padding: EdgeInsets.all(16.0),
          child:    Form(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 200.0,
                        // color: Colors.blue.shade900,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Welcome back,"+widget.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        "To use Faspay, Please enter your faspay Password",
                        style: TextStyle(
                          fontFamily: "Times New Roman",
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _textEditingController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue.shade900,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue.shade900,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),

                        prefixStyle: TextStyle(
                          color: Colors.black,
                        ),
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                     onChanged: (value){
                       _onTextChanged();
                     },
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: _isButtonEnabled ? Colors.blue.shade900 : Colors.grey,
                  ),
                  child: TextButton(
                    onPressed:(){
                      setState(() {
                        show_preogress=true;
                        login(widget.phoneNumber,_textEditingController.text);
                      });

                    },
                    child: Text(
                      'PROCEED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

      ],
    ),


    Visibility(
        visible: show_preogress,
        child:    Container(

            color: Colors.black.withOpacity(0.5),
            child: ListView(
              children: const [
                LinearProgressIndicator(
                  semanticsLabel: 'Linear progress indicator',
                )
              ],
            )
        )

    ),


  ],
),
    );
  }
  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  void goto_dashboard(BuildContext context){

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(phoneNumber: widget.phoneNumber,token:token)),
    );
  }
  Future login(mail,pass)async{
    var url="https://a2ctech.net/api/faspay/login.php";
    var response;
      response=await http.post(Uri.parse(url),body:{
        "mail":mail,
        "pass":pass
      });


    var data=json.decode(response.body);
    if(response.statusCode == 200){
      print(response.body);

      if(data["status"]=="true"){
        token=data["token"];
        SharedPreferences pref =await SharedPreferences.getInstance();
        pref.setString("phone", widget.phoneNumber);
        pref.setString("token", token);
        goto_dashboard( context);
       // _showToast(context,"Invalid Login Details");/
      }
    }else{
      print(response.statusCode);

      setState(() {
        correct_pass_checker=true;
      });
    }
    setState(() {
      show_preogress=false;
    });
  }
  void _showToast(BuildContext context,String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content:  Text(msg),
        action: SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _textEditingController.text.length >= 4;
    });
  }
}
