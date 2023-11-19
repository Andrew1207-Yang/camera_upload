import 'package:camera_upload/camera_page.dart';
import 'package:camera_upload/video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'globals.dart' as globals;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Firebase Auth Demo',
      home: AuthenticationScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/camera': (context) => const CameraPage(),
      },
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print('Failed to sign in with Google: $e');
    }
  }

  Future<UserCredential?> _createAccountWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Failed to create account: $e');
    }
  }

  Future<UserCredential?> _signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Authentication'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CupertinoButton.filled(
                onPressed: () {
                  _showSignInForm(context);
                },
                child: Text('Sign In'),
              ),
              SizedBox(height: 16.0),
              CupertinoButton.filled(
                onPressed: () {
                  _showSignUpForm(context);
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignInForm(BuildContext context){
    showCupertinoModalPopup(
      barrierColor: Colors.white,
      context: context, 
      builder: (context){
        return _buildSignInForm(context);
      });
  }

  void _showSignUpForm(BuildContext context){
    showCupertinoModalPopup(
      barrierColor: Colors.white,
      context: context, 
      builder: (context){
        return _buildEmailPasswordForm(context);
      });
  }

  Widget _buildSignInForm(BuildContext context){
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Sign In'),
        ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right:20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoTextField(
                controller: _emailController,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 8.0),
              CupertinoTextField(
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 16.0),
        
              CupertinoButton.filled(
                onPressed: () async {
                  UserCredential? userCredential = await _signInWithEmailAndPassword(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (userCredential != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text('Sign In'),
              ),
              
              SizedBox(height: 24.0),
        
              CupertinoButton.filled(
                onPressed: () async {
                  UserCredential? userCredential = await _signInWithGoogle();
                  if (userCredential != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text('Sign In with Google'),
              ),
              ]
              ),
        ),
      ),
    );
  }

  Widget _buildEmailPasswordForm(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Sign Up'),
        ),
      child: Center(
        child: Padding(
          padding: const  EdgeInsets.only(left: 20, right:20),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CupertinoTextField(
                    controller: _emailController,
                    placeholder: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 8.0),
                  CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 16.0),
            CupertinoButton.filled(
              onPressed: () async {
                UserCredential? userCredential = await _createAccountWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (userCredential != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text('Sign Up'),
            ),
          ],
            ),
        ),
      ));
  }
}

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int itemcounter(){
    if (globals.names.length < 5 ){
      return globals.names.length;
    }
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Home'),
        automaticallyImplyLeading: false
      ),
      child:
      Column(
        children: [
          SizedBox(height: 150),
          Image.asset('assets/images/Deco.png', height: 100),
          SizedBox(height: 50),
          Center(child: Text("Last 5 Uploaded Files")),
          Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.5,
                child: ListView.builder(
                  itemCount: itemcounter(),
                  itemBuilder: (context, index){
                    return Center(child: Text(globals.names[itemcounter() - 1 - index]));
                  }
                  ),
              ),
            ),
          Center(
            child: CupertinoButton.filled(
              onPressed: () {
                // Perform actions on button press
                Navigator.pushReplacementNamed(context, '/camera');
              },
              child: Text('Take Video'),
            ),
          ),
        ],
      ),
    );
  }
}
