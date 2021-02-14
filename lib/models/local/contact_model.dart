class Contact {
int id;
String name;
String number;
Contact.withId({this.id, this.name, this.number});
Contact({ this.name, this.number});

Map toMap() {
var map = {
'id': id,
'name': name,
'number' : number,
};
return map;
}

Contact.fromMap(Map map) {
id = map['id'];
name = map['name'];
number = map['number'];
}
}