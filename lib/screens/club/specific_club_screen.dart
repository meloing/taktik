import '../../services/club_api.dart';
import 'comment_screen.dart';
import 'new_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:totale_reussite/services/local_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.club
  });

  final Map club;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  late Map club;
  List posts = [];
  bool firstLaunch = true;
  bool launchAddPost = false;
  bool seeDeleteConfirm = false;
  late TabController _tabController;

  Future addClubMember() async{
    String clubMemberClubId = club["clubId"];
    String clubMemberUid = LocalData().getUid();
    String clubMemberDate = DateTime.now().toString().split(".")[0];
    await ClubOnlineRequests().addClubMember(clubMemberUid, clubMemberClubId, clubMemberDate);
    await ClubOfflineRequests().updateClubIsMember("yes", club["clubId"]);

    setState(() { club["isMember"] = "yes"; });
  }

  Future addPost(String avatar, String pseudo, String description, List images) async{
    setState(() { launchAddPost = true; });
    String uid = LocalData().getUid();
    String date = DateTime.now().toString().split(".")[0];

    await ClubOnlineRequests().addPost(club["clubId"], avatar, pseudo,
        description, date, uid, images);
    setState(() {
      Map element = {
        "uid": uid,
        "date": date,
        "avatar": avatar,
        "pseudo": pseudo,
        "clubId": club["clubId"],
        "description": description
      };
      posts.insert(0, element);
      launchAddPost = false;
    });
  }

  Future getPosts() async{
    List values = await ClubOnlineRequests().getPosts(club["clubId"]);

    setState(() {
      posts.addAll(values);
      firstLaunch = false;
    });
  }

  Future deletePost(String postId, int index) async{
    await ClubOnlineRequests().deletePost(postId);
    setState(() {
      posts.removeAt(index);
      seeDeleteConfirm = false;
    });
  }

  void modalSheet(String postId, int index){
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
                          Text(
                              "Vous êtes sur le point de supprimer ce post.".toUpperCase(),
                              style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold
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
                                        deletePost(postId, index);
                                        Navigator.pop(context);
                                      }
                                  )
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                  Visibility(
                      visible: !seeDeleteConfirm,
                      child: ListTile(
                          leading: const Icon(Icons.delete_rounded),
                          title: Text(
                              'Supprimer ce post',
                              style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          onTap: () {
                            setState(() {
                              seeDeleteConfirm = true;
                              Navigator.pop(context);
                              modalSheet(postId, index);
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
    club = widget.club;
    _tabController = TabController(length: 2, vsync: this);

    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
                onPressed: (){},
                icon: const Icon(
                  Icons.share_rounded
                )
            )
          ]
        ),
        backgroundColor: Colors.grey[200],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/${club["clubIcon"]}"),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(.7),
                                  Colors.black.withOpacity(.2)
                                ]
                            )
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  club["clubName"],
                                  style: const TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "230 membres",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "Club créé le ${club['clubDate']}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                  )
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  "Club public",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                  )
                              ),
                              const SizedBox(height: 10),
                              club["isMember"] != "yes" ?
                              SizedBox(
                                  height: 50,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              Colors.blue
                                          ),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          )
                                      ),
                                      child: const Text(
                                          "REJOINDRE",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          )
                                      ),
                                      onPressed: (){
                                        addClubMember();
                                      }
                                  )
                              ) :
                              const SizedBox()
                            ]
                        )
                    )
                )
              )
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        child: Text(
                            "Discussions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            )
                        )
                      ),
                      Tab(
                        child: Text(
                          "Apropos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                        )
                      )
                    ]
                  )
                ]
              )
            ),
            SliverFillViewport(
              delegate: SliverChildListDelegate.fixed([
                TabBarView(
                  controller: _tabController,
                  children: [
                    firstLaunch ?
                    const Center(
                      child: CircularProgressIndicator()
                    ) :
                    posts.isEmpty ?
                    Center(
                      child: Text(
                          "Aucun post dans ce club.",
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500
                          )
                      )
                    ) :
                    SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            launchAddPost ?
                            Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.computer_rounded,
                                        size: 40
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "POST EN COURS D'ENVOI",
                                              style: GoogleFonts.rubik(
                                                  fontWeight: FontWeight.w500
                                              )
                                          ),
                                          const SizedBox(height: 7),
                                          SizedBox(
                                              height: 5,
                                              width: MediaQuery.of(context).size.width-75,
                                              child: const LinearProgressIndicator()
                                          )
                                        ]
                                    )
                                  ],
                                )
                            ) :
                            const SizedBox(),
                            const Divider(height: 0),
                            Column(
                                children: Iterable<int>.generate(posts.length).toList().map(
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
                                                      'assets/images/avatar-${posts[index]["avatar"]}.png',
                                                      width: 40
                                                  ),
                                                  title: Text(
                                                      posts[index]["pseudo"],
                                                      style: GoogleFonts.rubik(
                                                          textStyle: const TextStyle(
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      )
                                                  ),
                                                  subtitle: Text(
                                                      posts[index]["date"],
                                                      style: GoogleFonts.rubik()
                                                  ),
                                                  trailing: LocalData().getUid() == posts[index]["uid"] ?
                                                  IconButton(
                                                      onPressed: (){
                                                        modalSheet(
                                                            posts[index]["postId"],
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
                                                      posts[index]["description"],
                                                      textAlign: TextAlign.justify,
                                                      style: GoogleFonts.rubik(
                                                          textStyle: const TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black
                                                          )
                                                      )
                                                  )
                                              ),
                                              posts[index]["images"] != null && posts[index]["images"].isNotEmpty ?
                                              Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: SizedBox(
                                                      height: 100,
                                                      child: ListView(
                                                          key: Key(posts[index]["images"].length.toString()),
                                                          scrollDirection: Axis.horizontal,
                                                          children: posts[index]["images"].map<Widget>((image) {
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
                                              const Divider(height: 0),
                                              Row(
                                                  children: [
                                                    Expanded(
                                                        child: TextButton(
                                                            onPressed: (){
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) =>
                                                                      CommentScreen(
                                                                          post: posts[index]
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const Icon(
                                                                      Icons.chat_bubble_rounded,
                                                                      color: Colors.grey
                                                                  ),
                                                                  const SizedBox(width: 5),
                                                                  Text(
                                                                      "Commenter",
                                                                      style: GoogleFonts.rubik(
                                                                          textStyle: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w500
                                                                          )
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    ),
                                                    Expanded(
                                                        child: TextButton(
                                                            onPressed: ()async{
                                                              String text = "${posts[index]["description"]} Télécharger l'application à cette adresse : "
                                                                  "https://play.google.com/store/apps/details?id=com.archetechnology.gest_chap "
                                                                  "pour répondre à cette question.";
                                                              await SocialShare.shareOptions(text).then((data) async{});
                                                            },
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  const Icon(
                                                                      Icons.share_rounded,
                                                                      color: Colors.grey
                                                                  ),
                                                                  const SizedBox(width: 5),
                                                                  Text(
                                                                      "Partager",
                                                                      style: GoogleFonts.rubik(
                                                                          textStyle: const TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.w500
                                                                          )
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        )
                                                    )
                                                  ]
                                              )
                                            ]
                                        )
                                    )
                                ).toList()
                            )
                          ]
                        )
                    ),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Text(club["clubDescription"])
                    )
                  ]
                )
              ])
            )
          ]
        ),
        floatingActionButton: club["isMember"] == "yes" ?
        FloatingActionButton(
          onPressed: () async{
            var values = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NewPostScreen()
                )
            );

            if(values != null){
              addPost(values[0], values[1], values[2], values[3]);
            }
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.edit_rounded)
        ) : null
    );
  }
}