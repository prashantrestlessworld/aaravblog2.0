import 'package:aaravblog/views/post_screen.dart';
import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Import the ProfileScreen// Import the PostScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isDarkTheme = false;

  // List of pages to display for each navigation item, now including PostScreen
  final List<Widget> _pages = [
    PostScreen(), // Use PostScreen for the home tab
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
    ProfileScreen(), // Profile page is rendered directly here
    Center(child: Text('More Page 1', style: TextStyle(fontSize: 24))),
    Center(child: Text('More Page 2', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Switch to the selected tab/page
    });
  }

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Responsive App'),
          elevation: 4,
          backgroundColor: Colors.deepPurpleAccent,
          actions: [
            IconButton(
              icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
            if (isLargeScreen)
              PopupMenuButton<int>(
                onSelected: (int index) {
                  _onItemTapped(index + 3);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('More Page 1'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('More Page 2'),
                  ),
                ],
                icon: Icon(Icons.more_vert),
              ),
          ],
        ),
        drawer: !isLargeScreen
            ? Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                      ),
                      child: Center(
                        child: Text(
                          'Navigation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(0);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.search),
                      title: Text('Search'),
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(1);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(2);
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.pages),
                      title: Text('More Page 1'),
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(3);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.pages),
                      title: Text('More Page 2'),
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(4);
                      },
                    ),
                  ],
                ),
              )
            : null,
        body: Row(
          children: [
            if (isLargeScreen)
              Expanded(
                child: _pages[_selectedIndex],
              ),
            if (isLargeScreen)
              NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                labelType: NavigationRailLabelType.all,
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                selectedIconTheme: IconThemeData(color: Colors.deepPurple),
                selectedLabelTextStyle: TextStyle(color: Colors.deepPurple),
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    selectedIcon: Icon(Icons.home_filled),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    selectedIcon: Icon(Icons.search_rounded),
                    label: Text('Search'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: Text('Profile'),
                  ),
                ],
              ),
            if (!isLargeScreen)
              Expanded(
                child: _pages[_selectedIndex],
              ),
          ],
        ),
        bottomNavigationBar: isLargeScreen
            ? null
            : BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.deepPurple,
                onTap: _onItemTapped,
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleTheme,
          tooltip: 'Toggle Theme',
          child: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
          backgroundColor: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}
