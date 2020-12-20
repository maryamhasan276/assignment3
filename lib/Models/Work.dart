class Work {
  int _Id;
  String _Title;
  int _Kind;

 Work(
    this._Title,
    this._Kind,
  );

  Work.withId(this._Id, this._Title, this._Kind);

  int get_id => _Id;

  String get_title => _Title;

  int get_Kind => _Kind;

  set Title(String newTitle) {
    if (newTitle.length <= 255) {
      this._Title = newTitle;
    }
  }

  set Kind(int newKind) {
    this._Kind = newKind;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (Id != null) {
      map['Id'] = _Id;
    }
    map['Title'] = _Title;
    map['Kind'] = _Kind;

    return map;
  }

 
  Work.fromMapObject(Map<String, dynamic> map) {
    this._Id = map['Id'];
    this._Title = map['Title'];
    this._Kind = map['Kind'];
  }
}
