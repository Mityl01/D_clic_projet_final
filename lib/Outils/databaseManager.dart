
import 'package:projetfinal/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gestionNotes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }
    
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE utilisateurs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        note TEXT NOT NULL
      )
    ''');
  }


  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    //
  }

    Future<int> insertNote(Note note) async {
        Database db = await instance.database;
        return await db.rawInsert(
            'INSERT INTO notes(title, note) VALUES(?, ?)',
            [note.title, note.note],
        );
    }

    Future<int> updateNote(Note note) async {
        Database db = await instance.database;
        return await db.update(
            'notes',
            note.toMap(),
            where: 'id = ?',
            whereArgs: [note.id],
        );
    }

    Future<int> deleteNote(id) async {
        Database db = await instance.database;
        return await db.delete(
            'notes',
            where: 'id = ?',
            whereArgs: [id],
        );
    }

    Future<List<Note>> getNotes() async {
        Database db = await instance.database;
        final List<Map<String, dynamic>> maps = await db.query('notes');
        return maps.map((note) => Note.fromMap(note)).toList();
    }


    //pour la connexion 
    Future<bool> chkLogin({required String username, required String password}) async {
      Database db = await instance.database;

      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM utilisateurs WHERE username = ? AND password = ?',
        [username, password],
      );

      return result.isNotEmpty; // true si trouvé, false sinon
    }
    
    //pour l'enregistrement de nouvel utilisateur
    Future<int> insertUtilisateur(String username, String password) async {
        Database db = await instance.database;
        return await db.rawInsert(
            'INSERT INTO utilisateurs(username, password) VALUES(?, ?)',
            [username, password],
        );
    }

    // Fermer la base de données
    Future<void> close() async {
        Database db = await instance.database;
        db.close();
    }
}