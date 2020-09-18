import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:date_util/date_util.dart';
import 'example.dart';
import 'model/todos.dart';
import 'utilitis/db.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      //appBar: AppBar(),
      body: Cal(),
    ),
  ));
}

class Cal extends StatefulWidget {
  Cal();
  int id;
  int secim;
  int firstday;
  String todos;

  Cal.internal(Todos todo) {
    this.firstday = 28;
    this.secim = todo.secim;
    this.todos = todo.todo;
    this.id = todo.id;
  }

  @override
  _CalState createState() => _CalState();
}

class _CalState extends State<Cal> {
  var dateUtility = DateUtil();
  String todom;
  int secim;
  GlobalKey<FormState> key;
  DataBaseHelper db;
  @override
  void initState() {
    super.initState();
    key = GlobalKey<FormState>();
    db = DataBaseHelper();
  }

  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  int currentMonth = int.parse(DateTime.now().toString().substring(6, 7));
  int currentYear = int.parse(DateTime.now().toString().substring(0, 4));
  int days;

  int secondday;
  int location;
  int purpose = 1;

  void ggg() {
    location = currentMonth;
    days = dateUtility.daysInMonth(location--, currentYear);
    debugPrint(currentMonth.toString());
    debugPrint(location.toString());
  }

  String findsecondday() {
    if (days - widget.firstday < 7) {
      int fark = 7 - (days - widget.firstday);
      int nextmonths;

      if (currentMonth == 12) {
        nextmonths = location;
      } else {
        nextmonths = location;
        nextmonths++;
      }

      return fark.toString() + " " + months[nextmonths];
    } else {
      return (widget.firstday + 7).toString();
    }
  }

  void save() {
    key.currentState.save();
    db.todoekle(Todos(todom, secim));

    setState(() {
      todom = "";
    });
  }

  void upgrade() async {
    key.currentState.save();
    await db.todoupdate(Todos.withId(widget.id, todom, widget.secim));
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Try();
    }));
  }

  Widget todo(int value) {
    if (purpose == 1) {
      return Container(
        //height: MediaQuery.of(context).size.height * 2 / 10,
        child: Form(
            key: key,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.2 / 10),
                  child: Text(
                    widget.firstday == null
                        ? "Gün seçiniz"
                        : widget.firstday.toString() + "   " + months[location],
                    style: TextStyle(color: Colors.red, fontSize: 30),
                  ),
                ),
                TextFormField(
                  initialValue: this.widget.todos != null ? widget.todos : null,
                  onSaved: (value) {
                    todom = value;
                    secim = 1;
                  },
                ),
                RaisedButton(
                    child: Text(widget.id != null ? "Güncelle" : "Kaydet"),
                    onPressed: () {
                      if (widget.id != null) {
                        upgrade();
                      } else {
                        save();
                        setState(() {
                          widget.todos = "";
                        });
                      }
                    })
              ],
            )),
      );
    }
    if (purpose == 2) {
      return Container(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2 / 10),
            child: Text(
              widget.firstday == null
                  ? "Başlanğıç günü belirleyin"
                  : widget.firstday.toString() +
                      " " +
                      months[location] +
                      " " +
                      findsecondday(),
              style: TextStyle(color: Colors.blue, fontSize: 30),
            ),
          ),
          Form(
              key: key,
              child: TextFormField(
                onSaved: (value) {
                  todom = value;
                  secim = 2;
                },
              )),
          RaisedButton(onPressed: () {}, child: Text("Kaydet"))
        ]),
      );
    } else {
      return Container(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2 / 10),
            child: Text(
              months[location],
              style: TextStyle(color: Colors.green, fontSize: 30),
            ),
          ),
          Form(child: TextFormField()),
          RaisedButton(child: Text("Kaydet"), onPressed: () {})
        ],
      ));
    }
  }

  @override
  void dispose() {
    //_calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ggg();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "TODO ADD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 100),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Try()));
                      },
                      child: Icon(
                        Icons.arrow_left,
                        color: Colors.amber,
                      ),
                    ))
              ]),
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            Container(
                color: Colors.amber,
                height: MediaQuery.of(context).size.height * 1 / 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.height * 0.2 / 10,
                            top: MediaQuery.of(context).size.height * 0.1 / 10),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {
                            if (currentMonth == 1) {
                            } else {
                              setState(() {
                                currentMonth--;
                              });
                            }
                            ;
                          },
                          child: Icon(Icons.arrow_left,
                              color: Colors.blue,
                              size: MediaQuery.of(context).size.height *
                                  0.8 /
                                  10),
                        )),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2 / 10),
                      child: Text(
                        months[location],
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            right:
                                MediaQuery.of(context).size.height * 0.2 / 10,
                            top: MediaQuery.of(context).size.height * 0.1 / 10),
                        child: RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {
                            if (currentMonth == 12) {
                            } else {
                              setState(() {
                                currentMonth++;
                                debugPrint(currentMonth.toString());
                              });
                            }
                          },
                          child: Icon(Icons.arrow_right,
                              color: Colors.blue,
                              size: MediaQuery.of(context).size.height *
                                  0.8 /
                                  10),
                        )),
                  ],
                )),
            Container(
              height: MediaQuery.of(context).size.height * 4.50 / 10,
              child: GridView.builder(
                itemCount: days,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6, childAspectRatio: 1.30),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: RaisedButton(
                          color: widget.firstday == (index + 1) ||
                                  secondday == (index + 1)
                              ? Color.fromARGB(0xFF, 0x2B, 0x31, 0x45)
                              : Colors.white,
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.firstday == (index + 1) ||
                                      secondday == (index + 1)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              widget.firstday = index + 1;
                            });
                          }));
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 3.34 / 10,
              decoration: BoxDecoration(
                  color: Color.fromARGB(0xFF, 0x2B, 0x31, 0x45),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              // height: MediaQuery.of(context).size.height * 4.30 / 10,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: EdgeInsets.all(2),
                  child: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      side: BorderSide(
                                          color: Colors.white, width: 2)),
                                  color: Color.fromARGB(0xFF, 0x2B, 0x31, 0x45),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              10,
                                      child: Center(
                                          child: Text("Günlük",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold)))),
                                  onPressed: () {
                                    setState(() {
                                      purpose = 1;
                                    });
                                  })),
                          Container(
                              child: RaisedButton(
                                  color: Color.fromARGB(0xFF, 0x2B, 0x31, 0x45),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                          color: Colors.white, width: 2)),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              10,
                                      child: Center(
                                          child: Text(
                                        "Haftalık",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ))),
                                  onPressed: () {
                                    setState(() {
                                      purpose = 2;
                                    });
                                  })),
                          Container(
                            child: RaisedButton(
                                color: Color.fromARGB(0xFF, 0x2B, 0x31, 0x45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                        color: Colors.white, width: 2)),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        1 /
                                        10,
                                    child: Center(
                                        child: Text(
                                      "Aylık",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ))),
                                onPressed: () {
                                  setState(() {
                                    purpose = 3;
                                  });
                                }),
                          ),
                        ],
                      ),
                      Container(

                          // margin: EdgeInsets.only(bottom: 100),
                          child: todo(purpose)),
                    ],
                  ))),
            ),
          ],
        ))));
  }
}
