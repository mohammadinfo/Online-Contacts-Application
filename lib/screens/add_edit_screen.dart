import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_app/models/contact.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEditScreen extends StatefulWidget {
  AddEditScreen({Key? key}) : super(key: key);

  static final TextEditingController nameController = TextEditingController();
  static final TextEditingController phoneController = TextEditingController();
  static int id = 0;

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  bool isLoading = false;
  bool isConnected = false;
  final _formKey = GlobalKey<FormState>();
  //
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  //
  Future<void> postData() async {
    setState(() {
      isLoading = true;
    });
    Uri url = Uri.parse('https://retoolapi.dev/dE3FfW/contacts');
    Contact contact = Contact(
      phone: '${AddEditScreen.phoneController.text}',
      fullname: '${AddEditScreen.nameController.text}',
    );

    http.post(url, body: contact.toJson()).then((response) {
      print(response.body);
    });

    Future.delayed(
      Duration(seconds: 3),
      () {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> putData() async {
    Uri url =
        Uri.parse('https://retoolapi.dev/dE3FfW/contacts/${AddEditScreen.id}');
    Contact contact = Contact(
      phone: '${AddEditScreen.phoneController.text}',
      fullname: '${AddEditScreen.nameController.text}',
    );

    http.put(url, body: contact.toJson()).then((response) {
      print(response.body);
    });
  }

  void showErrorDialog() {
    CoolAlert.show(
      width: 100,
      context: context,
      type: CoolAlertType.error,
      title: 'خطا',
      confirmBtnText: 'باشه',
      confirmBtnTextStyle: TextStyle(fontSize: 16, color: Colors.white),
      confirmBtnColor: Colors.redAccent,
      text: "!شما به اینترنت متصل نیستید",
    );
  }

  @override
  void initState() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult status) {
      //
      if (status == ConnectivityResult.wifi ||
          status == ConnectivityResult.mobile) {
        isConnected = true;
      } else {
        isConnected = false;
        showErrorDialog();
      }
      //
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AddEditScreen.id == 0 ? 'مخاطب جدید' : 'ویرایش مخاطب',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              MyTextField(
                controller: AddEditScreen.nameController,
                hintText: 'نام',
                errorText: 'لطفا نام را وارد کنید',
              ),
              SizedBox(height: 15),
              MyTextField(
                controller: AddEditScreen.phoneController,
                inputType: TextInputType.phone,
                hintText: 'شماره',
                errorText: 'لطفا شماره را وارد کنید',
              ),
              SizedBox(height: 15),
              AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 500),
                width: isLoading ? 100 : 200,
                height: 45,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (isConnected) {
                        // POST
                        if (AddEditScreen.id == 0) {
                          postData();
                        }
                        // PUT
                        else {
                          putData();
                          Navigator.pop(context);
                        }
                      } else {
                        showErrorDialog();
                      }
                    }
                  },
                  child: isLoading
                      ? Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AddEditScreen.id == 0 ? 'اضافه کردن' : 'ویرایش کردن'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  //
  final TextInputType inputType;
  final TextEditingController controller;
  final String errorText;
  final String hintText;
  //
  MyTextField({
    this.inputType = TextInputType.text,
    required this.controller,
    required this.errorText,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      },
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.redAccent),
        ),
        contentPadding: EdgeInsets.all(10.0),
      ),
    );
  }
}
