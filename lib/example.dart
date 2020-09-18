import 'package:flutter/material.dart';
import 'package:todo_app/utilitis/db.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/model/todos.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Try(),
  ));
}

class Try extends StatefulWidget {
  @override
  _TryState createState() => _TryState();
}

class _TryState extends State<Try> {
  List<int> sayi = [1];
  List<Todos> tumtodos;
  DataBaseHelper db;
  var value;
  var silinen;

  @override
  void initState() {
    super.initState();
    debugPrint("init");
    tumtodos = List<Todos>();
    db = DataBaseHelper();
  }

  Future<List<Todos>> listodo() async {
    List<Todos> todoslist = List<Todos>();
    List<Map<String, dynamic>> list = await db.alltodo();
    for (Map value in list) {
      todoslist.add(Todos.fromMap(value));
    }
    return todoslist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "TODO LİST",
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
                            MaterialPageRoute(builder: (context) => Cal()));
                      },
                      child: Icon(
                        Icons.arrow_right,
                        color: Colors.amber,
                      ),
                    ))
              ]),
        ),
        body: Container(
            color: Color.fromARGB(0xFF, 0x2B, 0x31, 0x45),
            child: FutureBuilder(
                future: listodo(),
                builder: (context, value) {
                  if (value.connectionState == ConnectionState.done) {
                    tumtodos = value.data;

                    return ListView.builder(
                        itemCount: tumtodos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, //Color.fromARGB(0xFF, 0x2B, 0x31, 0x45),
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(color: Colors.amber, width: 5),
                            ),
                            width: 100,
                            height:
                                MediaQuery.of(context).size.height * 2.50 / 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      4 /
                                      10,
                                  height: MediaQuery.of(context).size.height *
                                      0.3 /
                                      10,
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.1 /
                                        10,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.1 /
                                        10,
                                  ),
                                  child: Center(child: Text("AHAHAHHAHAHAH")),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                            color: Colors.amber, width: 3)),
                                    height: MediaQuery.of(context).size.height *
                                        1.15 /
                                        10,
                                    width: MediaQuery.of(context).size.width *
                                        8.75 /
                                        10,
                                    child: SingleChildScrollView(
                                        child: Text(
                                            tumtodos[index].todo.toString()))),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Color.fromARGB(
                                              0xFF, 0x2B, 0x31, 0x45),
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      onPressed: () async {
                                        await db.todoDelete(tumtodos[index].id);
                                        tumtodos.remove(tumtodos[index]);
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                  0xFF, 0x2B, 0x31, 0x45),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Cal.internal(
                                                          tumtodos[index])));
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })));
  }
}
