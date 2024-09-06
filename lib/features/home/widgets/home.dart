import 'package:flutter/material.dart';
import 'package:movie_app/features/movie/presentation/pages/now_playing_movies.dart';
import 'package:movie_app/features/movie/presentation/pages/search_movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 5,
          iconTheme: const IconThemeData(size: 25),
          leading: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Icon(
              Icons.movie_rounded,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Testflix',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchMoviesPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: const NowPlayingMoviesPage()),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('New movie out today!'),
                    subtitle: Text('Find out where to whatch your movies'),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notifications_sharp),
                    title: Text('Alert!'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: null,
            margin: const EdgeInsets.all(10),
            elevation: 5,
            semanticContainer: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: 600,
                        maxWidth: MediaQuery.sizeOf(context).width - 20),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 15,),
                        const SizedBox(child: Text('Teste'),),
                        SizedBox(
                          height: 200,
                          child: CarouselView(
                              elevation: 5,
                              itemExtent: 350,
                              itemSnapping: true,
                              children: <Widget>[
                                Container(color: Colors.amber),
                                Container(color: Colors.blueAccent),
                                Container(
                                    color: const Color.fromARGB(255, 71, 67, 11)),
                                Container(
                                    color: const Color.fromARGB(255, 35, 50, 75)),
                                Container(
                                    color: const Color.fromARGB(255, 39, 85, 46)),
                                Container(color: Colors.redAccent),
                                Container(color: Colors.lightGreenAccent)
                              ]),
                        ),
                        const SizedBox(height: 50,),
                        const SizedBox(child: Text('Teste'),),
                        SizedBox(
                          height: 200,
                          child: CarouselView(
                              elevation: 5,
                              itemExtent: 300,
                              itemSnapping: true,
                              children: <Widget>[
                                Container(color: Colors.amber),
                                Container(color: Colors.blueAccent),
                                Container(
                                    color: const Color.fromARGB(255, 71, 67, 11)),
                                Container(
                                    color: const Color.fromARGB(255, 35, 50, 75)),
                                Container(
                                    color: const Color.fromARGB(255, 39, 85, 46)),
                                Container(color: Colors.redAccent),
                                Container(color: Colors.lightGreenAccent)
                              ]),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ][currentPageIndex],
        floatingActionButton: FloatingActionButton.extended(
          label: const Icon(Icons.search, color: Colors.white),
          foregroundColor: Colors.black,
          hoverColor: Colors.red,
          backgroundColor: const Color.fromARGB(255, 83, 83, 83),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchMoviesPage(),
              ),
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 168, 168, 168),
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('2'),
                child: Icon(Icons.notifications_sharp)),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Badge(
                child: Icon(Icons.person),
              ),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
        ),
      ),
    );
  }
}
