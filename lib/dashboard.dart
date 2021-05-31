import 'package:flutter/material.dart';
import 'package:food_delivery_app/backend/database.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loading = true;
  Stream orders;
  DateTime selectedDate = DateTime.now();

  fetchData() {
    orders = Database()
        .getOrders(DateFormat('dd MMM y').format(selectedDate).toString());
    loading = false;
    setState(() {});
  }

  bool display(List l1, List l2) {
    bool retVal = false;
    String date = DateFormat('dd MMM y').format(selectedDate).toString();
    for (int i = 0; i < l1.length; i++) {
      if (l1[i] == false && l2[i] == date) {
        retVal = true;
        break;
      }
    }
    return retVal;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 15)),
      lastDate: DateTime.now().add(Duration(days: 15)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF785B),
              onPrimary: Colors.white,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() => loading = true);
      orders = Database()
          .getOrders(DateFormat('dd MMM y').format(selectedDate).toString());
      setState(() => loading = false);
    }
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              DateFormat('dd MMM y')
                                  .format(selectedDate)
                                  .toString(),
                              style: GoogleFonts.lexendDeca(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500),
                            ),
                            Theme(
                              data: ThemeData.dark(),
                              child: Builder(
                                builder: (context) => TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xFFFF785B),
                                    ),
                                  ),
                                  child: Text(
                                    'Select Date',
                                    style: GoogleFonts.lexendDeca(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    await _selectDate(context);
                                    setState(() => loading = true);
                                    await fetchData();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Orders',
                                  style: GoogleFonts.lexendDeca(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 13,
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
                                  return display(ds.data()['self_delivery'],
                                          ds.data()['dateToBeDelivered'])
                                      ? Container(
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
                                              Row(
                                                children: [
                                                  Icon(Icons.person,
                                                      color: Colors.grey,
                                                      size: 17),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    ds.data()['userName'],
                                                    style:
                                                        GoogleFonts.lexendDeca(
                                                            fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(ds.data()['userPhone'],
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .grey[800])),
                                                ],
                                              ),
                                              SizedBox(height: 5),

                                              // customer address
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.home,
                                                      color: Colors.grey,
                                                      size: 17),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      ds.data()['address'],
                                                      style: GoogleFonts
                                                          .lexendDeca(
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .grey[700]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),

                                              Container(
                                                child: StatefulBuilder(
                                                  builder: (BuildContext
                                                          context,
                                                      StateSetter changeState) {
                                                    return Column(
                                                      children: [
                                                        GestureDetector(
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .restaurant,
                                                                  size: 17,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                SizedBox(
                                                                    width: 10),
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
                                                                visible =
                                                                    !visible;
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
                                                        SizedBox(height: 5),
                                                        Visibility(
                                                          visible: visible,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                color: Colors
                                                                    .grey[200],
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3.0),
                                                                          child: Text(
                                                                              "Dish",
                                                                              style: GoogleFonts.lexendDeca()),
                                                                        ),
                                                                        flex:
                                                                            3),
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3.0),
                                                                          child: Text(
                                                                              "Price x Quantity",
                                                                              style: GoogleFonts.lexendDeca()),
                                                                        ),
                                                                        flex:
                                                                            2),
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3.0),
                                                                          child: Text(
                                                                              "To be delivered before",
                                                                              style: GoogleFonts.lexendDeca()),
                                                                        ),
                                                                        flex:
                                                                            2),
                                                                    Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(3.0),
                                                                          child: Text(
                                                                              "Delivered",
                                                                              style: GoogleFonts.lexendDeca()),
                                                                        ),
                                                                        flex: 2)
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: ds
                                                                    .data()[
                                                                        'dishName']
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index1) {
                                                                  if (ds.data()['self_delivery']
                                                                              [
                                                                              index1] ==
                                                                          false &&
                                                                      ds.data()['dateToBeDelivered']
                                                                              [
                                                                              index1] ==
                                                                          DateFormat('dd MMM y')
                                                                              .format(selectedDate)
                                                                              .toString()) {
                                                                    return Row(
                                                                      children: [
                                                                        Expanded(
                                                                            child:
                                                                                Text(ds.data()['dishName'][index1], style: GoogleFonts.lexendDeca()),
                                                                            flex: 3),
                                                                        Expanded(
                                                                            child:
                                                                                Text('${ds.data()['pricePerServing'][index1]} x ${ds.data()['quantity'][index1]}', style: GoogleFonts.lexendDeca()),
                                                                            flex: 2),
                                                                        Expanded(
                                                                            child:
                                                                                Text(ds.data()['toTime'][index1], style: GoogleFonts.lexendDeca()),
                                                                            flex: 2),
                                                                        Expanded(
                                                                            child:
                                                                                Checkbox(
                                                                              value: ds.data()['isDelivered'][index1],
                                                                              onChanged: (value) async {
                                                                                List temp = ds.data()['isDelivered'];
                                                                                temp[index1] = !temp[index1];
                                                                                setState(() => loading = true);
                                                                                await Database().updateDeliveryStatus(ds.id, temp);
                                                                                setState(() => loading = false);
                                                                              },
                                                                            ),
                                                                            flex:
                                                                                2),
                                                                      ],
                                                                    );
                                                                  } else {
                                                                    return Container();
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
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
                                                            ds.data()[
                                                                "chefAddress"]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Text(
                                                          "View chef's address",
                                                          style: GoogleFonts
                                                              .lexendDeca(
                                                                  color: Color(
                                                                      0xFFFF785B))),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container();
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
