import 'package:flutter/material.dart';
import 'package:movie_app/screens/now_playing_movies.dart';
import 'package:movie_app/screens/search_movies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    const String firstName = 'Leandro';
    const String lastName = 'Morais Neves';

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
          const Card(
            shadowColor: Colors.transparent,
            margin: EdgeInsets.all(8.0),
            child: SizedBox.expand(
              child: Column(
                children: [
                  Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      FittedBox(
                         fit: BoxFit.contain,
                        alignment: Alignment.topLeft,
                        child: 
                          Text('Profile',
                              style:
                                  TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      Column(
                        children: [
                          Text(
                            'Nome: $firstName $lastName',
                          ),
                        ],
                      ),
                      Text('Endereço'),
                      Text('Telefone')
                    ],
                  ),
                ],
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
              icon: Badge(child: Icon(Icons.notifications_sharp)),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('2'),
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
