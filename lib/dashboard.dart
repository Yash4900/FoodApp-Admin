import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/widgets/alert.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Dashboard",
          style: GoogleFonts.lexendDeca(
              color: Color(0xff002140),
              fontWeight: FontWeight.w800,
              fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout, color: Colors.black, size: 25),
              onPressed: () async {
                AlertMessage()
                    .logOutAlert(context, "Are you sure you want to Logout");
              })
        ],
      ),
      body: Container(
        child: Text('Welcome Admin'),
      ),
    );
  }
}
