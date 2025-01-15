// home_screen.dart

import 'package:fyp2/config/size_config.dart';
import 'package:fyp2/provider/base_view.dart';
import 'package:fyp2/view/home_screen_view_model.dart';
import 'package:fyp2/screens/menu_page/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home-screen';
  const HomeScreen({super.key});

  // Function to fetch display name
  Future<String> _fetchDisplayName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch the user's document from Firestore
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          // Ensure the field 'name' exists in the document
          return doc['name'] ?? 'User'; 
        }
      }
    } catch (e) {
      print("Error fetching display name: $e");
    }
    return 'User'; // Fallback in case of an error
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseView<HomeScreenViewModel>(
      onModelReady: (model) => {
        model.generateRandomNumber(),
      },
      builder: (context, model, child) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: getProportionateScreenHeight(60),
              elevation: 0,
              iconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 255, 255, 255)),
              title: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(4),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Use FutureBuilder to fetch and display the display name
                    FutureBuilder<String>(
                      future: _fetchDisplayName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Show loading indicator while waiting for data
                          return CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else if (snapshot.hasError) {
                          // In case of error, show a fallback message
                          return Text(
                            'Welcome, User',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        } else if (snapshot.hasData) {
                          // If data is fetched, display the username
                          return Text(
                            'Welcome, ${snapshot.data}', // Displays the actual username
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        } else {
                          // Fallback message if no data found
                          return Text(
                            'Welcome, User',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                          );
                        }
                      },
                    ),
                    Spacer(),
                    Row(
                      // Additional widgets if needed
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                  getProportionateScreenHeight(5),
                ),
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: const Color(0xFF464646),
                    tabs: [
                      Tab(
                        child: Text(
                          '',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ]),
              ),
            ),
            drawer: SizedBox(
                width: getProportionateScreenWidth(270),
                child: const Menu()),
            body: TabBarView(
              children: <Widget>[
                Body(
                  model: model,
                ),
                Center(
                  child: Text(
                    'To be Built Soon',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                const Center(
                  child: Text('Under Construction'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
