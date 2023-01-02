import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/local_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/club_api.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({
    Key? key,
    required this.post
  }) : super(key: key);

  final Map post;

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {

  Map post = {};
  List comments = [];
  bool launch = false;
  String imagePath = "";
  bool seeDeleteConfirm = false;
  TextEditingController descriptionController = TextEditingController();

  Future getComments() async{
    List values = await ClubOnlineRequests().getComments(post["postId"]);
    setState(() {
      comments.addAll(values);
    });
  }

  Future addComment() async{
    setState(() { launch = true; });
    String uid = LocalData().getUid();
    String avatar = LocalData().getAvatar();
    String pseudo = LocalData().getPseudo();
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    if(description.isNotEmpty){
      await ClubOnlineRequests().addComment(post["postId"], description, date,
                                        uid, avatar, pseudo, imagePath);
      setState(() {
        imagePath = "";
        descriptionController.text = "";
        comments.insert(
          0,
          {
            'uid': uid,
            "date": date,
            'avatar': avatar,
            'pseudo': pseudo,
            "postId": post["postId"],
            "description": description
          }
        );
      });
    }

    setState(() { launch = false; });
  }

  Future deleteComment(String commentId, int index) async{
    await ClubOnlineRequests().deleteComment(commentId);
    setState(() {
      comments.removeAt(index);
      seeDeleteConfirm = false;
    });
  }

  Future<void> loadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: ["png", "jpg", "jpeg"]
    );

    if(result != null) {
      setState(() {
        imagePath = result.paths[0]!;
      });
    }
  }

  void modalSheet(String commentId, int index){
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10)
            )
        ),
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    Visibility(
                        visible: seeDeleteConfirm,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                  "Vous êtes sur le point de supprimer ce commentaire.".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.rubik(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              )
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                    child: TextButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                Colors.red
                                            ),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)
                                                )
                                            )
                                        ),
                                        child: Text(
                                            "Annuler",
                                            style: GoogleFonts.rubik(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            seeDeleteConfirm = false;
                                            Navigator.pop(context);
                                          });
                                        }
                                    )
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: TextButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                Colors.blue
                                            ),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)
                                                )
                                            )
                                        ),
                                        child: Text(
                                            "Valider",
                                            style: GoogleFonts.rubik(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        ),
                                        onPressed: (){
                                          deleteComment(commentId, index);
                                          Navigator.pop(context);
                                        }
                                    )
                                )
                              ]
                            )
                          ]
                        )
                    ),
                    Visibility(
                        visible: !seeDeleteConfirm,
                        child: ListTile(
                            leading: const Icon(Icons.delete_rounded),
                            title: Text(
                                'Supprimer ce commentaire',
                                style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            onTap: () {
                              setState(() {
                                seeDeleteConfirm = true;
                                Navigator.pop(context);
                                modalSheet(commentId, index);
                              });
                            }
                        )
                    ),
                    const SizedBox(height: 20)
                  ]
              )
          );
        });
  }

  @override
  initState() {
    super.initState();
    post = widget.post;
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
                "Publication",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                )
            )
        ),
        body: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                          color: Colors.white
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                                leading: Image.asset(
                                    'assets/images/avatar-${post["avatar"]}.png',
                                    width: 40
                                ),
                                title: Text(
                                    post["pseudo"],
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                ),
                                subtitle: Text(
                                    post["date"],
                                    style: GoogleFonts.rubik()
                                )
                            ),
                            const SizedBox(height: 5),
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                    post["description"],
                                    textAlign: TextAlign.justify,
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black
                                        )
                                    )
                                )
                            ),
                            post["images"] != null && post["images"].isNotEmpty ?
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: SizedBox(
                                    height: 100,
                                    child: ListView(
                                        key: Key(post["images"].length.toString()),
                                        scrollDirection: Axis.horizontal,
                                        children: post["images"].map<Widget>((image) {
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
                                                      child: Image.network(
                                                          image,
                                                          fit: BoxFit.fill
                                                      )
                                                  )
                                              )
                                          );
                                        }).toList()
                                    )
                                )
                            ) :
                            const SizedBox(),
                            Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 5,
                                    left: 15,
                                    right: 15,
                                    top: 20
                                ),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        "2 fichiers | 2 commentaires",
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey
                                            )
                                        )
                                    )
                                )
                            ),
                            const Divider(thickness: 5),
                            Text(
                                "Les commentaires",
                                style: GoogleFonts.rubik(
                                    textStyle: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )
                                )
                            ),
                            const Divider(thickness: 5, height: 15),
                            Column(
                                children: Iterable<int>.generate(comments.length).toList().map(
                                        (index) => Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            color: Colors.white
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                leading: Image.asset(
                                                    'assets/images/avatar-${comments[index]["avatar"]}.png',
                                                    width: 40
                                                ),
                                                title: Text(
                                                    comments[index]["pseudo"],
                                                    style: GoogleFonts.rubik(
                                                        textStyle: const TextStyle(
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    )
                                                ),
                                                subtitle: Text(
                                                    comments[index]["date"],
                                                    style: GoogleFonts.rubik()
                                                ),
                                                trailing: LocalData().getUid() == comments[index]["uid"] ?
                                                IconButton(
                                                    onPressed: (){
                                                      modalSheet(
                                                          comments[index]["commentId"],
                                                          index
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.more_horiz_rounded
                                                    )
                                                ) : null
                                              ),
                                              const SizedBox(height: 5),
                                              Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Text(
                                                      comments[index]["description"],
                                                      textAlign: TextAlign.justify,
                                                      style: GoogleFonts.rubik(
                                                          textStyle: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black
                                                          )
                                                      )
                                                  )
                                              ),
                                              imagePath.isNotEmpty ?
                                              Padding(
                                                padding: const EdgeInsets.all(10),
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
                                                            File(imagePath),
                                                            fit: BoxFit.fill
                                                        )
                                                    )
                                                )
                                              ) :
                                              const SizedBox(),
                                              const Divider(thickness: 2)
                                            ]
                                        )
                                    )
                                ).toList()
                            )
                          ]
                      )
                  )
                )
            ), // File(path!)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imagePath.isNotEmpty ?
                  Container(
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
                              File(imagePath),
                              fit: BoxFit.fill
                          )
                      )
                  ) :
                  const SizedBox(),
                  const SizedBox(height: 10),
                  Row(
                      children: [
                        Expanded(
                            child: TextField(
                                controller: descriptionController,
                                style: GoogleFonts.rubik(),
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(4),
                                    labelText: "Votre commentaire *",
                                    labelStyle: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey
                                    ),
                                    border: OutlineInputBorder()
                                )
                            )
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                            width: 45,
                            height: 45,
                            child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        )
                                    )
                                ),
                                onPressed: (){
                                  loadImage();
                                },
                                child: const Icon(
                                  Icons.image_rounded,
                                  color: Colors.white,
                                )
                            )
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                            width: 45,
                            height: 45,
                            child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5)
                                        )
                                    )
                                ),
                                onPressed: !launch ? addComment : null,
                                child: !launch ?
                                const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ) :
                                const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white
                                    )
                                )
                            )
                        )
                      ]
                  )
                ]
              )
            )
          ]
        )
    );
  }
}