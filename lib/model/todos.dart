class Todos {
  int _id;
  int _secim;
  String _todo;

  set id(int id) => this._id = id;
  get id => this._id;

  set secim(int secim) => this._secim = secim;
  get secim => this._secim;

  set todo(String todo) => this._todo = todo;
  get todo => this._todo;

  Todos(this._todo, this._secim);
  Todos.withId(this._id, this._todo, this._secim);

  Map<String, dynamic> tomap() {
    Map<String, dynamic> come = Map<String, dynamic>();
    come["id"] = this._id;
    come["todo"] = this._todo;
    come["secim"] = this._secim;

    return come;
  }

  Todos.fromMap(Map<String, dynamic> value) {
    this.id = value["id"];
    this._secim = value["secim"];
    this._todo = value["todo"];
  }
}
