import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:link/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:link/widget_utils/menu_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentLocation;
  String _currentCountry;
  List<Products> fetchedProducts;
  final menu = new CustomMenu();

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentLocation = "${place.locality}";
        _currentCountry = "${place.country}";
      });
      print(place.locality);
      print(place.postalCode);
      print(place.country);
    } catch (e) {
      print(e);
    }
  }

  getCurrentLocation() async {
    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  // ignore: missing_return
  Future<Products> getProduct() async {
    const url = 'http://hitwo-api.herokuapp.com/products';
    try{
      var response = await http.get(url);
      List<Products> allProducts = [];
      if (response.statusCode == 200) {
        print('decoding response');
        var products = json.decode(response.body);
        for (int i = 0; i < products.length; i++) {
          allProducts[i] = Products.fromJSON(products[i]);
        }
        setState(() {
          print('loading data on viewport');
          fetchedProducts = allProducts;
        });
      }
    }on Exception catch(e){
      print("$e");
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'VarelaRound'),
        home: SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.0, right: 0.0, left: 16.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        menu.showMenuOnScreen(context);
                                      },
                                      child: Icon(
                                        Icons.menu,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 16.0, right: 0.0, left: 16.0),
                                    child: Text(
                                      "Home",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 16.0, right: 0.0, left: 16.0),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 16.0,
                                  left: 8.0,
                                ),
                                child: _currentLocation != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("$_currentLocation",
                                              style: TextStyle(fontSize: 15)),
                                          Text("$_currentCountry",
                                              style: TextStyle(fontSize: 15))
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            getCurrentLocation();
                                          });
                                        },
                                        child: Text("Enable Location"),
                                      ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                            color: Color(0xFF6C00E9)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Text(
                                "What are you looking for?",
                                style: TextStyle(
                                    fontSize: 27,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      hintText: "e.g. Nike Airmax",
                                      hintStyle: TextStyle(color: Colors.white),
                                      labelText: "Search",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                          gapPadding: 3.5,
                                          borderRadius:
                                              BorderRadius.circular(8.0))),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.centerLeft,
                              height: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Near You",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            getProduct();
                                          },
                                          child: Icon(
                                            Icons.refresh,
                                            color: Colors.white,
                                          ))
                                    ],
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: 100,
                                      child: fetchedProducts != null
                                          ? ListView.builder(
                                              itemCount: fetchedProducts.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int i) {
                                                return Text(fetchedProducts[i]
                                                    .brandName);
                                              })
                                          : Center(
                                              child: SpinKitCircle(
                                                  color: Colors.white)))
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              alignment: Alignment.centerLeft,
                              height: 500,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Discover",
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))
                                  ]),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
