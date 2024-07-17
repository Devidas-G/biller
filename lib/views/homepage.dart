import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/bill/presentation/views/billing.dart';
import '../providers/homeprovider.dart';
import 'manage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageViewController = PageController();
  late HomeProvider homeState;

  @override
  Widget build(BuildContext context) {
    homeState = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: PageView(
        controller: _pageViewController,
        onPageChanged: (index) {
          homeState.pageindex = index;
        },
        children: const [Billing(), Manage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: homeState.pageindex,
        onTap: (index) {
          _pageViewController.animateToPage(index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceOut);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Billing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage',
          ),
        ],
      ),
    );
  }
}
