import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => NewPostScreenState();
}

class NewPostScreenState extends State<NewPostScreen> {
  List imagesAddress = [];
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();

  Future<void> loadImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: ["png", "jpg", "jpeg"]
    );

    if(result != null) {
      setState(() {
        imagesAddress = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Nouveau post"),
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                            Form(
                                key: _registerFormKey,
                                child: Column(
                                    children: [
                                      TextFormField(
                                          maxLines: 10,
                                          controller: descriptionController,
                                          style: GoogleFonts.rubik(),
                                          decoration: const InputDecoration(
                                              labelText: "Description *",
                                              labelStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey
                                              ),
                                              border: OutlineInputBorder()
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Ce champ est obligatoire';
                                            }
                                            return null;
                                          }
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                          style: GoogleFonts.rubik(),
                                          decoration: const InputDecoration(
                                              labelText: "Tags *",
                                              labelStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey
                                              ),
                                              border: OutlineInputBorder()
                                          ),
                                          validator: (value) {
                                            if(value == null || value.isEmpty) {
                                              return 'Ce champ est obligatoire';
                                            }
                                            return null;
                                          }
                                      )
                                    ]
                                )
                            ),
                            const SizedBox(height: 10),
                            imagesAddress.isNotEmpty ?
                            SizedBox(
                                height: 100,
                                child: ListView(
                                    key: Key(imagesAddress.length.toString()),
                                    scrollDirection: Axis.horizontal,
                                    children: imagesAddress.isNotEmpty ?
                                      imagesAddress.map((image) {
                                      return Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Colors.grey
                                                  )
                                              ),
                                              child:  ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.file(
                                                      image,
                                                      fit: BoxFit.fill
                                                  )
                                              )
                                          )
                                      );
                                    }).toList() : []
                                )
                            ) :
                            const SizedBox(),
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: loadImages,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        "Ajouter des images",
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black
                                            )
                                        )
                                    )
                                )
                            )
                          ]
                      )
                    )
                ),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            )
                        ),
                        child: const Text(
                            "Valider",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        onPressed: (){
                          if(_registerFormKey.currentState!.validate()){
                            String avatar = LocalData().getAvatar();
                            String pseudo = LocalData().getPseudo();
                            String description = descriptionController.text;
                            Navigator.pop(context, [avatar, pseudo, description, imagesAddress]);
                          }
                        }
                    )
                )
              ]
          )
        )
    );
  }
}