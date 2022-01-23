// ignore_for_file: unused_field
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_app/main.dart';
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/widgets/MyButton.dart';
import 'package:contacts_app/widgets/MyTextField.dart';
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
  //
  bool isLoading = false;
  //
  final _formKey = GlobalKey<FormState>();
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
              MyButton(
                width: isLoading ? 100 : 200,
                child: isLoading
                    ? Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        AddEditScreen.id == 0 ? 'اضافه کردن' : 'ویرایش کردن',
                      ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    MyApp.checkInternet().then(
                      (value) {
                        if (value) {
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
                          MyApp.showInternetError(context);
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
