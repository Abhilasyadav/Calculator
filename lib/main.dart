import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interest calculator',
      theme:
          ThemeData(primarySwatch: Colors.teal, colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary:  Colors.tealAccent),),
      home: Form(),
    );
  }
}

class Form extends StatefulWidget {
  const Form({super.key});

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  //controller
  TextEditingController principalTextEditingController =
      TextEditingController();

  TextEditingController rateofInterestTextEditingController =
      TextEditingController();

  TextEditingController termTextEditingController = TextEditingController();

  //currencies
  var _currencies = ['Rupees', 'Dollers', 'Pounds'];

  String result = "";
  String _character = "";
  String currentValue = "";
  String nv = "";

  @override
  void initState() {
    currentValue = _currencies[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interest calculator"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            //image
            getImage(),

            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: ListTile(
                    title: Text("Simple Interest"),
                    leading: Radio(
                      value: "simple",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          //here it is simple
                          _character = value!;
                        });
                      },
                    ),
                  ),
                )),
                Container(width: 1,),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 0.0),
                  child: ListTile(
                    title: Text("Compound Interest"),
                    leading: Radio(
                      value: "Compound",
                      groupValue: _character,
                      onChanged: (value) {
                        setState(() {
                          //here it is simple
                          _character = value!;
                        });
                      },
                    ),
                  ),
                )),
                Container(
                  width: 5.0,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: principalTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Principal",
                    hintText: "Enter a Principal amount e.g, 1000",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                controller: rateofInterestTextEditingController,
                decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: "Rate of Interest",
                    hintText: "Enter rate of Interest per year",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      controller: termTextEditingController,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: "Term",
                          hintText: "Enter number of year",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                ),

                Container(
                  width: 10.0,
                ),

                //drop down menu
                Expanded(
                    child: DropdownButton<String>(
                  items: _currencies.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: currentValue,
                  onChanged: ((newvalue) {
                    _setSelectedValue(newvalue!);
                    this.nv = newvalue;
                    setState(() {});
                  }),
                ))
              ],
            ),
            Container(width: 5,
            height: 20,),

            Row(
              children: <Widget>[
                Expanded(
                    child: ElevatedButton(
                  // child: Color( Colors.tealAccent,
                  // textColor: Colors.black,),
                  child: Text(
                    "CALCULATE",
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    this.result = _getEffectiveAmount(this.nv);
                    onDailogOpen(context, this.result);
                  },
                )),
                Container(
                  width: 10.0,
                ),
                Expanded(
                    child: ElevatedButton(
                  // color: Colors.tealAccent,
                  // textColor: Colors.black,
                  child: Text(
                    "RESET",
                    textScaleFactor: 1.5,
                  ),
                  onPressed: () {
                    _reset();
                  },
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _setSelectedValue(String newValue) {
    setState(() {
      this.currentValue = newValue;
    });
  }

  String _getEffectiveAmount(String newValue) {
    String newResult;
    double principal = double.parse(principalTextEditingController.text);
    double rate = double.parse(rateofInterestTextEditingController.text);
    double term = double.parse(termTextEditingController.text);

    double netpayableAmount = 0;
    if (_character == "simple") {
      netpayableAmount = principal + (principal * rate * term) / 100;
    } else if (_character == "Compound") {
      netpayableAmount = principal * pow((1 + (rate / 100)), term);
    }

    if (term == 1) {
      newResult =
          "After $term year , you will have to pay total amount = $netpayableAmount $currentValue";
    } else {
      newResult =
          "After $term year , you will have to pay total amount = $netpayableAmount $currentValue";
    }

    return newResult;
  }

  void _reset() {
    principalTextEditingController.text = "";
    rateofInterestTextEditingController.text = "";
    termTextEditingController.text = "";
    result = "";
    currentValue = _currencies[0];
  }

  //dialog box

  void onDailogOpen(BuildContext context, String s) {
    var alertDialog = AlertDialog(
      title: Text("NP is a selected.... "),
      content: Text(s),
      backgroundColor: Colors.green,
      elevation: 8.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(s),
          );
        });
  }
}

Widget getImage() {
  AssetImage assetImage = AssetImage("assets/cal.jpg");
  Image image = Image(
    image: assetImage,
    width: 180,
    height: 180,
  );

  return Container(
    child: image,
    margin: EdgeInsets.all(10),
  );
}
