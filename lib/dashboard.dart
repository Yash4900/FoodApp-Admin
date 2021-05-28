import 'package:flutter/material.dart';
import 'package:food_delivery_app/backend/database.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/widgets/alert.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = true;
  Stream orders;

  fetchData() {
    orders = Database().getOrders();
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xfff5f5f5),
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
                      AlertMessage().logOutAlert(
                          context, "Are you sure you want to Logout");
                    })
              ],
            ),
            body: Container(
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Orders',
                          style: GoogleFonts.lexendDeca(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 12,
                    child: StreamBuilder(
                      stream: orders,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFF785B),
                              ),
                            ),
                          );
                        } else {
                          if (snapshot.hasData &&
                              snapshot.data.docs.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];
                                  bool visible = false;
                                  IconData id =
                                      Icons.keyboard_arrow_down_rounded;
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        // customer identity
                                        Row(children: [
                                          Icon(Icons.person,
                                              color: Colors.grey, size: 17),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            ds.data()['userName'],
                                            style: GoogleFonts.lexendDeca(
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(ds.data()['userPhone'],
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: 15,
                                                  color: Colors.grey[800])),
                                        ]),
                                        // customer address
                                        Row(
                                          children: [
                                            Icon(Icons.home,
                                                color: Colors.grey, size: 17),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              (ds.data()['address'].substring(
                                                      0,
                                                      ds
                                                                  .data()[
                                                                      'address']
                                                                  .length >
                                                              19
                                                          ? 20
                                                          : ds
                                                              .data()['address']
                                                              .length)) +
                                                  "...",
                                              style: GoogleFonts.lexendDeca(
                                                  fontSize: 15,
                                                  color: Colors.grey[700]),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  AlertMessage()
                                                      .showAlertDialog(
                                                          context,
                                                          'Address',
                                                          ds.data()['address']);
                                                },
                                                child: Text(
                                                  'View more',
                                                  style: GoogleFonts.lexendDeca(
                                                      color: Color(0xFFFF785B)),
                                                ))
                                          ],
                                        ),
                                        Container(
                                          child: StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter changeState) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.restaurant,
                                                            size: 17,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Text(
                                                            "View Items",
                                                            style: GoogleFonts
                                                                .lexendDeca(),
                                                          ),
                                                          Icon(id)
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        changeState(() {
                                                          visible = !visible;
                                                          if (id ==
                                                              Icons
                                                                  .keyboard_arrow_down_rounded) {
                                                            id = Icons
                                                                .keyboard_arrow_up_rounded;
                                                          } else {
                                                            id = Icons
                                                                .keyboard_arrow_down_rounded;
                                                          }
                                                        });
                                                      }),
                                                  Visibility(
                                                    visible: visible,
                                                    child: Column(children: [
                                                      Container(
                                                        color: Colors.grey[200],
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                                    "Dish",
                                                                    style: GoogleFonts
                                                                        .lexendDeca()),
                                                                flex: 3),
                                                            Expanded(
                                                                child: Text(
                                                                    "Price",
                                                                    style: GoogleFonts
                                                                        .lexendDeca()),
                                                                flex: 2),
                                                            Expanded(
                                                                child: Text(
                                                                    "Quantity",
                                                                    style: GoogleFonts
                                                                        .lexendDeca()),
                                                                flex: 2),
                                                            Expanded(
                                                                child: Text(
                                                                    "To be delivered before",
                                                                    style: GoogleFonts
                                                                        .lexendDeca()),
                                                                flex: 3)
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: ds
                                                            .data()['dishName']
                                                            .length,
                                                        itemBuilder:
                                                            (context, index1) {
                                                          if (ds.data()[
                                                                      'self_delivery']
                                                                  [index1] ==
                                                              false) {
                                                            return Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Text(
                                                                        ds.data()['dishName']
                                                                            [
                                                                            index1],
                                                                        style: GoogleFonts
                                                                            .lexendDeca()),
                                                                    flex: 3),
                                                                Expanded(
                                                                    child: Text(
                                                                        ds.data()['pricePerServing']
                                                                            [
                                                                            index1],
                                                                        style: GoogleFonts
                                                                            .lexendDeca()),
                                                                    flex: 2),
                                                                Expanded(
                                                                    child: Text(
                                                                        ds.data()['quantity']
                                                                            [
                                                                            index1],
                                                                        style: GoogleFonts
                                                                            .lexendDeca()),
                                                                    flex: 2),
                                                                Expanded(
                                                                    child: Text(
                                                                        "To be delivered before",
                                                                        style: GoogleFonts
                                                                            .lexendDeca()),
                                                                    flex: 3)
                                                              ],
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        },
                                                      ),
                                                    ]),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () => AlertMessage()
                                                  .showAlertDialog(
                                                      context,
                                                      "Address",
                                                      ds.data()["chefAddress"]),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text(
                                                    "View chef's address",
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            color: Colors
                                                                .blue[600])),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/no_sub.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "No Orders",
                                    style: GoogleFonts.lexendDeca(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
