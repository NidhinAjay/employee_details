import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'display.dart';
import 'map.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController uname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobilenumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController date = TextEditingController();
  TimeOfDay? time;

  bool pswdvissible = false;
  bool cnfpswdvissible = false;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Future<void> saveDetails() async {
    try {
      // if(uname.text.isEmpty||password.text.isEmpty||confirmpassword.text.isEmpty){
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(("please fill all fields"))));
      //   return;
      // }
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference nameCollection = firestore.collection('login');
      if (formkey.currentState?.validate() ?? false) {
        print("Form is valid");

        Map<String, dynamic> nameData = {
          'uname': uname.text,
          'email': email.text,
          'mobilenumber': mobilenumber.text,
          'password': password.text,
          '_date': date.text,
          '_time': time != null ? '${time!.hour}:${time!.minute}' : ''
        };
        await nameCollection.add(nameData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(("success"))));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:$error")));
    }
  }

  Future<void> Date(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(currentDate.year - 50),
        lastDate: currentDate);
    if (selectedDate != null) {
      setState(() {
        date.text = formatdate(selectedDate);
      });
    }
  }

  String formatdate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> SelectedTime(BuildContext context) async {
    final newtime = await showTimePicker(
        context: context, initialTime: time ?? TimeOfDay.now());
    if (newtime != null) {
      setState(() {
        time = newtime;
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
            key: formkey,
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: uname,
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
                      controller: email,
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
                      controller: mobilenumber,
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
                      controller: password,
                      decoration: InputDecoration(
                          labelText: "password",
                          hintText: "Enter password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pswdvissible = !pswdvissible;
                                });
                              },
                              icon: Icon(pswdvissible
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
                      obscureText: !pswdvissible,
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
                      controller: confirmpassword,
                      decoration: InputDecoration(
                          labelText: "Confirm password",
                          hintText: "Enter password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  cnfpswdvissible = !cnfpswdvissible;
                                });
                              },
                              icon: Icon(cnfpswdvissible
                                  ? Icons.visibility_sharp
                                  : Icons.visibility_off))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter a valid input";
                        }
                        if (value != password.text) {
                          return 'Password doesnt match.';
                        }
                        return null;
                      },
                      obscureText: !cnfpswdvissible,
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
                      controller: date,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select a date.';
                        }
                      },
                      onTap: () {
                        Date(context);
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
                          text: time != null
                              ? DateFormat.Hm().format(DateTime(
                              2023, 1, 1, time!.hour, time!.minute))
                              : ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Select a time.';
                        }
                      },
                      onTap: () {
                        SelectedTime(context);
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
                          saveDetails();
                        },
                        child: Text("submit")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DisplayPage()));
                        },
                        child: Text("Display")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapApp()));
                        },
                        child: Text("Map")),

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
