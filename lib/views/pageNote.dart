import 'package:flutter/material.dart';
import 'package:projetfinal/Outils/databaseManager.dart';
import 'package:projetfinal/models/note.dart';
import 'package:projetfinal/views/PageDetailsNote.dart';

class PageNote extends StatefulWidget {
  const PageNote({super.key});

  @override
  State<PageNote> createState() => _PageNoteState();
}

class _PageNoteState extends State<PageNote> {

  final TextEditingController _textControl = TextEditingController();
  final TextEditingController _titleControl = TextEditingController();
  final _db = DatabaseManager.instance;
  final List<Note> _list_note = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(()=> _rechargerListe());
  }

  Future<void> _rechargerListe () async{
    final List<Note> liste = await _db.getNotes();
    setState(() {
      _list_note.clear();
      _list_note.addAll(liste);
    });
  }

  Future<void> _ajouterNote () async{
    final formKey = GlobalKey<FormState>();
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Nouvelle Note'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                  TextFormField(
                    controller: _titleControl,
                    decoration: InputDecoration(labelText: 'Entre un titre', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Veillez remplir le champ';
                      }
                      return null;
                    },
                    ),

                    SizedBox(height: 10,),
                    TextFormField(
                    controller: _textControl,
                    maxLines: 5,
                    decoration: InputDecoration(labelText: 'Entre une note', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Veillez remplir le champ';
                      }
                      return null;
                    },
                    ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            _textControl.clear();
            Navigator.of(context).pop();
          }, child: Text('Annuler', style: TextStyle(color: Colors.red),)),
          
          //Logique pour ajouter quand le boutton est presse
          ElevatedButton(onPressed: () async{
            if(formKey.currentState!.validate()){
               await _db.insertNote(Note.sansId(note: _textControl.text, title: _titleControl.text));
               _textControl.clear();
               _titleControl.clear();
               _afficherMessage('Note ajoutée avec succès');
               _rechargerListe ();
                Navigator.of(context).pop();
            }
          }, child: Text('Ajouter', style: TextStyle(color: Colors.blue),))
        ],
      );
    });
  }

  

  Future<void> _supprimerNote (Note note) async{
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text(note.title),
        actions: [
          TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text('Annuler', style: TextStyle(color: Colors.blue),)),
          ElevatedButton(onPressed: () async{
            await _db.deleteNote(note.id);
            _afficherMessage('Note supprimée avec succès');
            _rechargerListe ();
            Navigator.of(context).pop();
          }, child: Text('Supprimer', style: TextStyle(color: Colors.red),)),
        ],
      );
    });
  }


  void _afficherMessage (String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    _titleControl.dispose();
    _textControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Liste de notes', style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: _list_note.isEmpty ? Center(child: Text('Aucune note disponible')) : Container(
          padding:  EdgeInsets.all(10),
          color: Colors.white,
          child: ListView.builder(
            itemCount: _list_note.length,
            itemBuilder: (context, index){
            final note = _list_note[index];
              return Card(
                child: Padding(padding: EdgeInsets.only(left: 10), child: Row(
                  children: [
                    Expanded(child: ListTile(title: Text(note.title,style: TextStyle(fontSize: 18),))),
                    IconButton(onPressed: () async{
                      final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsNote(note: note)));
                        if(result == true){
                          _rechargerListe();
                        }
                      }, icon: Icon(Icons.info_outline_rounded, color: Colors.blue,)
                    ),
                    IconButton(onPressed: (){_supprimerNote(note);}, icon: Icon(Icons.delete, color: Colors.red,)),
                  ],
                ),
                ),
              );
            }
          ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()=>_ajouterNote(), foregroundColor: Colors.blue,backgroundColor: Colors.blue, child: Icon(Icons.add, color: Colors.white,),),
    );
  }
}