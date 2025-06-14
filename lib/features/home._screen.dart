import 'package:flex_mobile/features/auth/screens/login_screen.dart';
import 'package:flex_mobile/features/profile/screens/profile_screen.dart';
import 'package:flex_mobile/features/projects/project_list/screens/project_list_screen.dart';
import 'package:flutter/material.dart';
import '../core/services/navigation_service.dart';
import '../core/widgets/custom_bottom_bar_widget.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'helper/screens/helper_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      NavigationService.popUntilFirst(index);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab = !await NavigationService
            .navigatorKeys[_selectedIndex].currentState!
            .maybePop();
        if (!isFirstRouteInCurrentTab) return false;
        return true;
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildOffstageNavigator(0, const DashboardScreen()),
            _buildOffstageNavigator(1, const ProfileScreen()),
            _buildOffstageNavigator(2, const HelperScreen()),
          ],
        ),

        bottomNavigationBar: Material(
          type: MaterialType.transparency,  // This removes all elevation effects
          elevation: 0,  // Explicitly set to 0 for clarity
          child: CustomBottomBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget screen) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: NavigationService.navigatorKeys[index],
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => screen;
              break;
            case '/home':
              builder = (BuildContext context) => const HomeScreen();
              break;
            case '/login':
              builder = (BuildContext context) => const LoginScreen();
            case '/dashboard':
              builder = (BuildContext context) => const DashboardScreen();
              break;
            case '/projects':
              builder = (BuildContext context) => const ProjectListScreen();
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }

}
