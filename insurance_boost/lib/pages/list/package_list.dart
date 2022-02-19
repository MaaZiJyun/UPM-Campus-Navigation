import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insurance_boost/pages/detail_pages/package_detail_page.dart';

class PackageList extends StatefulWidget {
  const PackageList({Key? key}) : super(key: key);

  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  late Stream<QuerySnapshot> packages;
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  // final List<Map<String, dynamic>> _allUsers = [
  //   {
  //     "id": 1,
  //     "name": 'GX8090',
  //     "price": 20,
  //     "detail":
  //         '·this is the detail of package 1\n·this is the detail of package 1\n·this is the detail of package 1\n',
  //     "category": 'health care',
  //     "point": 10,
  //   },
  // ];

  // This list holds the data for the list view
  // List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    packages = FirebaseFirestore.instance.collection("package").snapshots();
    // _foundUsers = _allUsers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: packages,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return Text('Something nodata ');
                  } else if (snapshot.hasError) {
                    return Text('Something error ');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('Something noconn ');
                  } else {
                    final data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return Card(
                          key: ValueKey(data.docs[index].reference.id),
                          color: Colors.white,
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PackageDetailPage(
                                    id: data.docs[index].reference.id,
                                    category: data.docs[index]['category'],
                                    code: data.docs[index]['code'],
                                    detail: data.docs[index]['detail'],
                                    point: data.docs[index]['point'],
                                    price: data.docs[index]['price'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        data.docs[index]['code'],
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      StatusTag(
                                          text: data.docs[index]['category']),
                                      SizedBox(
                                        width: width / 8,
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 15),
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(40.0),
                                          ),
                                          primary: Colors.teal, // background
                                          backgroundColor:
                                              Colors.white, // foreground
                                          elevation: 0,
                                          side: BorderSide(
                                              color: Colors.teal, width: 2),
                                        ),
                                        onPressed: () {},
                                        child: Text('Buy Now'),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'CNY ${data.docs[index]['price'].toString()} / Year',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    data.docs[index]['detail'],
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTag extends StatelessWidget {
  final String text;
  late Color color;
  StatusTag({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (text == 'Life') {
      color = Colors.red;
    } else if (text == 'Health') {
      color = Colors.green;
    } else {
      color = Colors.orange;
    }
    return Container(
      alignment: Alignment.center,
      width: 90,
      height: 20,
      decoration: BoxDecoration(
          color: color,
          // border: Border.all(color: Colors.teal, width: 0.5),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
