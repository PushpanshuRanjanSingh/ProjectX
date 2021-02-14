import 'package:projectx/models/local/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
static Database _db;
Future<Database> get db async {
if (_db != null) {
return _db;
}
_db = await initDatabase();
return _db;
}

initDatabase() async {
io.Directory documentDirectory = await getApplicationDocumentsDirectory();
String path = join(documentDirectory.path, 'contact.db');

 

var db = await openDatabase(path, version: 2, onCreate: _onCreate);
return db;
}

_onCreate(Database db, int version) async {
await db
.execute('CREATE TABLE contact (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, number TEXT)');
}

Future<Contact> add(Contact contact) async {
var dbClient = await db;
contact.id = await dbClient.insert('contact', contact.toMap());
return contact;
}

Future<List<Contact>> getContacts() async {
var dbClient = await db;
List<Map> maps = await dbClient.query('contact', columns: ['id', 'name', 'number']);
List<Contact> contacts = [];
if (maps.length > 0) {
for (int i = 0; i < maps.length; i++) {
contacts.add(Contact.fromMap(maps[i]));
}
}
return contacts;
}

Future<int> delete(int id) async {
var dbClient = await db;
return await dbClient.delete(
'contact',
where: 'id = ?',
whereArgs: [id],
);
}

Future<int> update(Contact contact) async {
var dbClient = await db;
return await dbClient.update(
'contact',
contact.toMap(),
where: 'id = ?',
whereArgs: [contact.id],
);
}

Future close() async {
var dbClient = await db;
dbClient.close();
}
}