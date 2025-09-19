import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:test_app/fifth_page.dart';
import 'package:test_app/fourth_page.dart';
import 'package:test_app/second_page.dart';
import 'package:test_app/third_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _player = AudioPlayer();
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SecondPage(),
    ThirdPage(),
    FourthPage(),
    FifthPage(),
  ];

  @override
  void initState() {
    super.initState();
    _player.play(AssetSource("audio/china.mp3"), volume: 1.0);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
          width: 40,
          child: Image.asset('assets/photo/flagChine.png'),
        ),
        centerTitle: true,
        actions: [
          const Text('为习近', style: TextStyle(color: Colors.yellow))
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '力量',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '学校',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '参数',
            backgroundColor: Colors.red,
          ),
        ],
        selectedItemColor: Colors.yellow,
      ),
    );
  }
}
