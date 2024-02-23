import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_set_demo_nov/edit.dart';
import 'package:flutter/material.dart';

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  Future<void> delete(BuildContext context, String documentID) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("confirm delete"),
          content: Text("are u sure to delete the account"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("cancel")),
            TextButton(
                onPressed: () {
                  remove(context, documentID);
                  Navigator.pop(context);
                },
                child: Text("delete"))
          ],
        );
      },
    );
  }

  void remove(context, String documentID) async {
    try {
      await FirebaseFirestore.instance
          .collection("login")
          .doc(documentID)
          .delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Deleted")));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error : $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('login').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("error:${snapshot.error}");
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Card(
                        elevation: 5.0,
                        child: ListTile(
                          title: Text('uname : ${data['uname']}'),
                          subtitle: Text('password : ${data['password']}' +
                              '\n' +
                              'Date : ${data['_date']}' +
                              '\n' +
                              'e-mail : ${data['email']}' +
                              '\n' +
                              'Mobile No : ${data['mobilenumber']}' +
                              '\n' +
                              'Time : ${data['_time']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => edit(
                                                data: data,
                                                documentID: snapshot
                                                    .data!.docs[index].id)));
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    delete(
                                        context, snapshot.data!.docs[index].id);
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
