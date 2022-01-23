// ignore_for_file: must_be_immutable
import 'package:contacts_app/models/contact.dart';
import 'package:contacts_app/screens/add_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  //
  List<Contact> contacts = [];
  //
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    //
    contacts.clear();
    //
    Uri url = Uri.parse('https://retoolapi.dev/dE3FfW/contacts');
    http.get(url).then(
      (response) {
        if (response.statusCode == 200) {
          List jsonDecode = convert.jsonDecode(response.body);
          jsonDecode.forEach(
            (item) {
              setState(() {
                contacts.add(Contact.fromJson(item));
              });
            },
          );
        }
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future<void> deleteContact(int id) async {
    Uri url = Uri.parse('https://retoolapi.dev/dE3FfW/contacts/$id');
    http.delete(url).then((value) {
      getData();
      setState(() {});
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddEditScreen.id = 0;
          AddEditScreen.nameController.text = '';
          AddEditScreen.phoneController.text = '';
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEditScreen()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      appBar: AppBar(
        title: Text(
          'دفترچه تلفن آنلاین',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: Icon(Icons.import_contacts_sharp),
        actions: [
          IconButton(
            onPressed: getData,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    deleteContact(contacts[index].id);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      AddEditScreen.nameController.text =
                          contacts[index].fullname;
                      AddEditScreen.phoneController.text =
                          contacts[index].phone;
                      AddEditScreen.id = contacts[index].id;
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEditScreen()))
                          .then((value) async {
                        Future.delayed(Duration(seconds: 3)).then((value) {
                          getData();
                          setState(() {});
                        });
                      });
                    },
                    icon: Icon(Icons.edit),
                  ),
                  title: Text(contacts[index].fullname),
                  subtitle: Text(contacts[index].phone),
                );
              },
            ),
    );
  }
}
