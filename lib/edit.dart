import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'display.dart';

class edit extends StatefulWidget {
  final Map<String, dynamic> data;
  final String documentID;
  const edit({super.key, required this.data, required this.documentID});

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  TextEditingController unamecont = TextEditingController();
  TextEditingController emailcont = TextEditingController();
  TextEditingController mobilenumbercont = TextEditingController();
  TextEditingController passwordcont = TextEditingController();
  TextEditingController cnfpasswordcont = TextEditingController();
  TextEditingController datecont = TextEditingController();
  TimeOfDay? edittime;

  bool _pswdvissible = false;
  bool _cnfpswdvissible = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    unamecont = TextEditingController(text: widget.data['uname']);
    emailcont = TextEditingController(text: widget.data['email']);
    mobilenumbercont = TextEditingController(text: widget.data['mobilenumber']);
    passwordcont = TextEditingController(text: widget.data['password']);
    datecont = TextEditingController(text: widget.data['_date']);
  }

  Future<void> update() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference nameCollection = firestore.collection('login');
      if (_formkey.currentState?.validate() ?? false) {
        print("Form is valid");
        await nameCollection.doc(widget.documentID).update({
          'uname': unamecont.text,
          'email': emailcont.text,
          'mobilenumber': mobilenumbercont.text,
          'password': passwordcont.text,
          '_date': datecont.text,
          '_time':
              edittime != null ? '${edittime!.hour}:${edittime!.minute}' : ''
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Updated")));
      }
    } catch (Error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error : $Error")));
    }
  }

  Future<void> newDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(currentDate.year - 50),
        lastDate: currentDate);
    if (selectedDate != null) {
      setState(() {
        datecont.text = formatdate(selectedDate);
      });
    }
  }

  String formatdate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> EditedTime(BuildContext context) async {
    final newtime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (newtime != null) {
      setState(() {
        edittime = newtime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: unamecont,
                      decoration: InputDecoration(
                          labelText: "name", hintText: "Enter name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid value.';
                        }
                        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                          return 'Please enter a valid name with only letters and spaces.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: emailcont,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "e-mail", hintText: "Enter email"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email address.';
                        }
                        if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: mobilenumbercont,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Mobile Number",
                          hintText: "Enter Mobile Number"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid value.';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a 10-digit number.';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: passwordcont,
                      decoration: InputDecoration(
                          labelText: "password",
                          hintText: "Enter password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _pswdvissible = !_pswdvissible;
                                });
                              },
                              icon: Icon(_pswdvissible
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter a valid input";
                        }
                        if (value.length < 8 ||
                            !RegExp(r'[0-9]').hasMatch(value) ||
                            !RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                          return 'Password should contain a minimum of 8 characters,\n one number, and one special character.';
                        }
                        return null;
                      },
                      obscureText: !_pswdvissible,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: cnfpasswordcont,
                      decoration: InputDecoration(
                          labelText: "Confirm password",
                          hintText: "Enter password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _cnfpswdvissible = !_cnfpswdvissible;
                                });
                              },
                              icon: Icon(_cnfpswdvissible
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter a valid input";
                        }
                        if (value != passwordcont.text) {
                          return 'Password doesnt match.';
                        }
                        return null;
                      },
                      obscureText: !_cnfpswdvissible,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: datecont,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select a date.';
                        }
                      },
                      onTap: () {
                        newDate(context);
                      },
                      decoration: InputDecoration(
                          labelText: "Date", hintText: "select date"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: TextEditingController(
                          text: edittime != null
                              ? DateFormat.Hm().format(DateTime(
                                  2023, 1, 1, edittime!.hour, edittime!.minute))
                              : ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select a time.';
                        }
                      },
                      onTap: () {
                        EditedTime(context);
                      },
                      decoration: InputDecoration(
                          labelText: "Time", hintText: "select time"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          update();
                        },
                        child: Text("Update")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayPage()));
                        },
                        child: Text("Display")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
