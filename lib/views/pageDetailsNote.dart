import 'package:flutter/material.dart';
import 'package:projetfinal/Outils/databaseManager.dart';
import 'package:projetfinal/models/note.dart';

class DetailsNote extends StatefulWidget {
  const DetailsNote({required this.note, super.key});

  final Note note;


  @override
  State<DetailsNote> createState() => _DetailsNoteState();
}

class _DetailsNoteState extends State<DetailsNote> {
  final _db = DatabaseManager.instance;
  final dataNote = null;


  Future<void> _modifierNote (Note note) async{
    final formKey = GlobalKey<FormState>();
    final  textControl = TextEditingController();
    final  titleControl = TextEditingController();
  
    textControl.text = note.note;
    titleControl.text = note.title;

    showDialog(context: context, builder: (BuildContext context){

      return AlertDialog(
        title: Text('Modifier Note'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleControl,
                decoration: InputDecoration(labelText: 'Entre une note', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Veillez remplir ce champ';
                  }
                  return null;
                },
                ),

                SizedBox(height: 10,),

                TextFormField(
                controller: textControl,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Entre une note', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Veillez remplir ce champ';
                  }
                  return null;
                },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            textControl.clear();
              titleControl.clear();
            Navigator.of(context).pop();
          }, child: Text('Annuler', style: TextStyle(color: Colors.red),)),

          ElevatedButton(onPressed: () async{
            if(formKey.currentState!.validate()){
              setState(() {
                note.note = textControl.text;
                note.title = titleControl.text;
              });
              
              await _db.updateNote(note);
              textControl.clear();
              titleControl.clear();
              _afficherMessage('Note modifiée avec succès');
              Navigator.of(context).pop();
            }
          }, child: Text('Sauvegarder', style: TextStyle(color: Colors.blue),))
        ],
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if(!didPop){
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.note.title, style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () async {_modifierNote(widget.note);}, icon: Icon(Icons.edit, color: Colors.white,)),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.all(20),
        child:  Card(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
              child: Text(widget.note.note, textAlign: TextAlign.justify, textWidthBasis: TextWidthBasis.parent, style: TextStyle(color: Colors.black, fontSize: 16, ),)
            ),
          ),
        ),
      ),
    );
  }

  void _afficherMessage (String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}