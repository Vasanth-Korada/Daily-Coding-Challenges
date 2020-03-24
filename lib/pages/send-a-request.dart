import 'package:daily_coding_challenges/widgets/app-bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class SendARequest extends StatefulWidget {
  final userEmail;
  final userName;
  SendARequest({this.userEmail, this.userName});

  @override
  _SendARequestState createState() => _SendARequestState();
}

class _SendARequestState extends State<SendARequest> {
  String _value = "Request for a Challenge";
  TextEditingController controller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _validate = false;
  List<String> items = [
    "Request for a Challenge",
    "Request for a Concept",
    "Request for an Article"
  ];
  @override
  void initState() {
    controller.text = '';
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar("Send a Request"),
        body: Scrollbar(
          child: new ListView(
            children: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Choose a Request Type"),
              )),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border(
                    left: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                    top: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                    bottom: BorderSide(
                      color: Colors.green,
                      width: 10.0,
                    ),
                    right: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  )),
                  child: Container(
                    child: DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        isExpanded: true,
                        hint: Text("Choose a Request Type"),
                        items: items.map((item) {
                          return DropdownMenuItem(
                              value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _value = value;
                          });
                        },
                        value: _value,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Scrollbar(
                  child: TextFormField(
                    cursorColor: Colors.white,
                    autofocus: false,
                    controller: controller,
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        errorText:
                            _validate ? 'Request Field Cannot Be Empty!' : null,
                        hintText: "Write your request here ...",
                        fillColor: Colors.green,
                        focusColor: Colors.green,
                        hoverColor: Colors.green,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  child: Container(
                    height: 50.0,
                    child: new RaisedButton(
                      onPressed: () async {
                        setState(() {
                          controller.text.isEmpty
                              ? _validate = true
                              : _validate = false;
                        });
                        if (_validate == false) {
                          debugPrint(controller.text);
                          debugPrint(_value);
                          final Email email = Email(
                              subject: "$_value from ${widget.userName}",
                              body: "${controller.text}",
                              isHTML: false,
                              recipients: [
                                "infytech2019@gmail.com",
                              ]);
                          try {
                            await FlutterEmailSender.send(email);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                  "Request Submitted Successfully!\nThank You."),
                            ));
                          } catch (error) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Error, Please try again."),
                            ));
                          }
                        }
                      },
                      splashColor: Colors.green.shade400,
                      color: Colors.green,
                      child: Text(
                        "Submit Request",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
