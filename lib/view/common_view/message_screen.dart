import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_management/controller/firebase_controller.dart';
import 'package:monkey_management/model/message.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = "/message-screen";

  // final String otherPersonId;
  //
  // MessageScreen(this.otherPersonId);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  Controller? con;
  var formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  String myName = '';
  String otherName = '';

  @override
  void initState() {
    super.initState();
    con = Controller(this);
  }

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    myName = args!['my_name'] ?? '';
    otherName = args['other_name'] ?? '';
    con?.otherId = args['other_id'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('$myName - $otherName'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseController.messageStream(FirebaseAuth.instance.currentUser!.uid, con!.otherId),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> stream) {
                    if (stream.connectionState == ConnectionState.waiting) {
                      return Text('fetching messages ... [0%]');
                    }
                    if (stream.hasData) {
                      List<Message> myMessages = Message.deserializeToList(stream.data!);

                      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseController.messageStream(con!.otherId, FirebaseAuth.instance.currentUser!.uid),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> stream) {
                            if (stream.connectionState == ConnectionState.waiting) {
                              return Text('fetching messages ... [50%]');
                            }
                            if (stream.hasData) {
                              List<Message> otherMessages = Message.deserializeToList(stream.data!);

                              List<Message> messages = Message.combine(myMessages, otherMessages);

                              return ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, index) => Container(
                                  // padding: EdgeInsets.all(2.0),
                                  // margin: EdgeInsets.all(2.0),
                                  // decoration: BoxDecoration(
                                  //   color: messages[index].senderId == FirebaseAuth.instance.currentUser!.uid
                                  //       ? Colors.blue
                                  //       : Colors.black12,
                                  //   borderRadius: BorderRadius.circular(15),
                                  // ),
                                  child: Text(
                                    '  ${messages[index].text}  ',
                                    textAlign: messages[index].senderId == FirebaseAuth.instance.currentUser!.uid
                                        ? TextAlign.left
                                        : TextAlign.right,
                                    style: TextStyle(
                                      color: messages[index].senderId == FirebaseAuth.instance.currentUser!.uid
                                          ? Colors.pink
                                          : Colors.black54,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              );
                            }
                            print(stream.error);
                            return Text('other stream error');
                          });
                    }

                    print(stream.error);
                    return Text('my stream error');
                  }),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter your messages ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send_rounded),
                      onPressed: con?.send,
                    ),
                  ),
                  controller: textController,
                  autocorrect: true,
                  keyboardType: TextInputType.text,
                  validator: con?.validateText,
                  onSaved: con?.onSaveText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Controller {
  _MessageScreenState state;

  Controller(this.state);

  String text = '';
  String otherId = '';

  Future<void> send() async {
    if (!state.formKey.currentState!.validate()) {
      return;
    }
    state.formKey.currentState!.save();

    Message message = Message();
    message.receiverId = otherId;
    message.senderId = FirebaseAuth.instance.currentUser!.uid;
    message.text = text;

    await FirebaseController.addMessage(message);

    state.textController.clear();
  }

  String? validateText(String? value) {
    if (value == null || value.length == 0) {
      return 'Empty message!!!';
    }
    return null;
  }

  void onSaveText(String? value) {
    this.text = value!;
  }
}
