import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificPointMethodScreen extends StatefulWidget {
  const SpecificPointMethodScreen({
    super.key,
    required this.method
  });

  final Map method;

  @override
  State<SpecificPointMethodScreen> createState() => SpecificPointMethodScreenState();
}

class SpecificPointMethodScreenState extends State<SpecificPointMethodScreen> {
  Map method = {};

  @override
  initState() {
    super.initState();
    method = widget.method;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Color(0xff0b65c2)
            ),
            elevation: 1,
            title: Text(
                "Point Methode",
                style: GoogleFonts.quicksand(
                    color: const Color(0xff0b65c2),
                    fontWeight: FontWeight.bold
                )
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.share_rounded)
              )
            ]
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              method["title"],
                              style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff0b65c2)
                              )
                          ),
                          const SizedBox(height: 8),
                          Text(
                              method["subtitle"],
                              style: GoogleFonts.rubik(
                                  fontSize: 16,
                                  color: Colors.grey
                              )
                          )
                        ]
                    )
                  ),
                  MarkDown().body(method["description"])
                ]
            )
        )
    );
  }
}