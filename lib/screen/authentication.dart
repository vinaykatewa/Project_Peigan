import 'package:flutter/material.dart';
import 'package:hey/services/firebase.dart';
import 'package:hey/screen/home.dart';
import 'package:hey/widget/userImage.dart';
import 'package:hey/providers/provider.dart';
import 'package:provider/provider.dart';
import 'package:hey/screen/anonymouseHome.dart';
import 'dart:io';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final authFormKey = GlobalKey<FormState>();
  final firebase = FirebaseClass();
  String email = '';
  String userName = '';
  String password = '';
  File? selectedImage;
  bool isLoading = false;
  void onImagePicked(File? image) {
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;

    void submitSignup() async {
      if (authFormKey.currentState!.validate() && selectedImage != null) {
        setState(() {
          isLoading = true;
        });
        firebase
            .signup(email, userName, password, selectedImage!)
            .then((result) {
          setState(() {
            isLoading = false;
          });
          if (result != null) {
            print('done');
            print(result);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          }
          }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              title: const Text('Error'),
              content: Text(error.toString()),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
              ],
            );
          });
        });
      }
    }

    submitLogin() async {
      if (authFormKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        firebase.signin(email, password).then((result) {
          if (result != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          }
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          authProvider.toogleUser();
        });
      }
    }

    anonymousUser() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              title: const Text('Anonymous User'),
              content: const Text("You won't be able to send message. You can only see them."),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () async{
                           final userCredential =
                      await firebase.anonymousUser();
                  Navigator.pop(context);
                  if (userCredential != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AnonymousHome()),
                      (route) => false,
                    );
                  }
                        },
                        child: const Text('Agree')),
                  ],
                ),
              ],
            );
          });
    }
    return Stack(
      children: [
        Scaffold(
            backgroundColor: const Color.fromRGBO(41, 47, 63, 0.3),
            body: Center(
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.all(10),
                    color: const Color.fromRGBO(15, 26, 58, 0.5),
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: authFormKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                !authProvider.alreadyUser
                                    ? UserImage(onPickedImage: onImagePicked)
                                    : const SizedBox(
                                        width: 0,
                                      ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.emailAddress,
                                  textCapitalization: TextCapitalization.none,
                                  validator: (value) {
                                    if (value == null || value.isEmpty || !value.contains('@gmail.com')) {
                                      return 'Please Enter email';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your Email',
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),

                                ///UserName for new users
                                ///
                                ///
                                authProvider.alreadyUser
                                    ? const SizedBox(
                                        width: 0,
                                      )
                                    : Column(
                                        children: [
                                          TextFormField(
                                            style: const TextStyle(
                                                color: Colors.white),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            textCapitalization:
                                                TextCapitalization.none,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter UserName';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Username',
                                              labelText: 'Username',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                userName = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter password';
                                      }
                                      if (value.length < 5) {
                                        return 'Please Enter more than 5 character password';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      focusColor: Colors.blue,
                                      hintText: 'Enter a password',
                                      labelText: 'Password',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    }),
                                SizedBox(
                                  height: height * 0.02,
                                ),

                                ///login and registration button
                                ///
                                ///
                                ///logic here
                                authProvider.alreadyUser
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue[800]),
                                        ),
                                        onPressed: submitLogin,
                                        child: const Text('Login'))
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue[800]),
                                        ),
                                        onPressed: submitSignup,
                                        child: Text('Register')),

                                ///login and registration buttonopenDialogBox
                                ///
                                ///
                                ///logic ends here
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: anonymousUser,
                                        child: const Text('Anonymous')),
                                    authProvider.alreadyUser
                                        ? TextButton(
                                            onPressed: () {
                                              authProvider.toogleUser();
                                            },
                                            child: const Text('New User'))
                                        : TextButton(
                                            onPressed: () {
                                              authProvider.toogleUser();
                                            },
                                            child: const Text('Login')),
                                  ],
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            )),

        /// loading loading
        ///
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(
                0.5), // this is a simple dark overlay, you can adjust its color and opacity as you wish
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}