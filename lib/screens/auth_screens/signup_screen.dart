// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core /firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kokozaki_seller_panel/controllers/firestore_helper.dart';
import 'package:kokozaki_seller_panel/helper/colors.dart';
import 'package:kokozaki_seller_panel/models/market_model.dart';
import 'package:kokozaki_seller_panel/models/subscription_model.dart';
import 'package:kokozaki_seller_panel/screens/auth_screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const routeName = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? address;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  html.Geoposition? locationData;
  Uint8List? imageFile;
  bool isLoading = false;
  List<String> items = [
    'Fashion & Cosmetics',
    'Sport',
    'Kids',
    'Electronics',
    'Home'
  ];
  String selectedCategory = 'Fashion & Cosmetics';
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String name = _nameController.text;
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String url =
          await FirestoreHelper().uploadFile('sellers', imageFile!, context);

      MarketModel market = MarketModel(
          uid: userCredential.user!.uid,
          marketName: name,
          email: email,
          password: password,
          coupons: [],
          couponDiscount: [{}],
          hmRatings: 0,
          sellerBalance: 0,
          imageUrl: url,
          category: selectedCategory,
          status: false,
          isAdmin: false,
          location: {
            'latitude': locationData!.coords!.latitude,
            'longitude': locationData!.coords!.longitude,
            'address': address
          },
          ratings: 0,
          subscription: SubscriptionModel(
              id: '',
              title: '',
              description: '',
              price: 0,
              duration: DateTime.now(),
              status: false));

      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(userCredential.user!.uid)
          .set(market.toMap());
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Sign Up Successfull now login with same credentials..')));
    } catch (e) {
      print('Error signing in: $e');
      // Handle sign-in errors, e.g., show a snackbar with an error message
    }
  }

  Future<String> getAddress(
      double latitude, double longitude, String apiKey) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];

      if (results.isNotEmpty) {
        return results[0]['formatted_address'];
      } else {
        return 'Address not found';
      }
    } else {
      throw Exception('Failed to load address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kokzaki'),
        backgroundColor: secondaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Signup Section
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Container(
                  // margin: const EdgeInsets.all(40.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 2),
                            blurRadius: 5),
                      ]),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imageFile == null
                            ? CircleAvatar(
                                radius: 60,
                                child: Positioned(
                                    bottom: 30,
                                    left: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt),
                                      onPressed: () async {
                                        imageFile =
                                            await FirestoreHelper().pickImage();
                                        setState(() {});
                                      },
                                    )),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: MemoryImage(imageFile!),
                              ),
                        CustomTextFormFIeld(
                          text: "Market Name",
                          controller: _nameController,
                          focusNode: nameFocusNode,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Name cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Choose Category in which you want to sell',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Sofia-pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            DropdownButton(
                                value: selectedCategory,
                                items: items
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (String? item) {
                                  setState(() {
                                    selectedCategory = item!;
                                  });
                                }),
                          ],
                        ),
                        // const SizedBox(height: 16.0),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 12),
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child:
                        //   ),
                        // ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(locationData == null
                                ? 'No Location Picked'
                                : '$address'),
                            if (locationData == null)
                              InkWell(
                                onTap: () async {
                                  try {
                                    html.Geoposition position = await html
                                        .window.navigator.geolocation
                                        .getCurrentPosition();
                                    locationData = position;
                                    print(
                                        'latitude ${position.coords!.latitude},longitude ${position.coords!.longitude}');
                                    address = await getAddress(
                                        position.coords!.latitude!.toDouble(),
                                        position.coords!.longitude!.toDouble(),
                                        'AIzaSyAeprVS-dONDXpY-ZBTuWk1rjNgCad7VnQ');
                                    setState(() {});
                                  } catch (e) {
                                    print(e.toString());
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(7)),
                                  child: const Text(
                                    'Choose Location',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Sofia-pro',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        CustomTextFormFIeld(
                          text: "Email",
                          controller: _emailController,
                          focusNode: emailFocusNode,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Email cannot be empty";
                            } else if (!(val.contains("@"))) {
                              return "Enter a valid email address";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        CustomTextFormFIeld(
                          text: "Password",
                          controller: _passwordController,
                          obscureText: true,
                          focusNode: passwordFocusNode,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "The password cannot be empty";
                            } else if (val.length <= 7) {
                              return "at least 8 characters";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 16.0),
                        isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: "SignUp",
                                icon: Icons.login,
                                callBack: () {
                                  if (formKey.currentState!.validate()) {
                                    _signInWithEmailAndPassword();
                                  }
                                }),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Already have an account?',
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Hind'),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushNamed(LoginScreen.routeName),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: secondaryColor,
                                    fontFamily: 'Hind'),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Company Image Section
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(40),
                // padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.black.withOpacity(.2),
                ),
                child: const Image(
                  image: NetworkImage(
                      'https://images.pexels.com/photos/264636/pexels-photo-264636.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                  // image: AssetImage("assets/icons/App icon.webp"),
                  // 'https://images.unsplash.com/photo-1598528738936-c50861cc75a9?q=80&w=1760&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), // Replace with your company image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
