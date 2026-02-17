import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/view/collection_screen.dart';
import 'package:gallery_application/view/home_screen.dart';
import 'package:gallery_application/view/liked_screen.dart';
import 'package:gallery_application/view_model/grid_provider.dart';
import 'package:gallery_application/view_model/media_provider.dart';
import 'package:gallery_application/view_model/theme_provider.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentIndex = 0;

  final screens = const [HomeScreen(), CollectionScreen(), LikedScreen()];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch((themeProvider));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          Row(
            children: [
              // Dark mode toggle
              IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),

              // Grid Count change button
              IconButton(
                icon: Icon(Icons.grid_view),
                onPressed: () {
                  changeGridCount(context);
                },
                /*
                  final current = ref.read(gridCountProvider);
                  if(current == 2) {
                    ref.read(gridCountProvider.notifier).state = 3;
                  } else if (current == 3) {
                    ref.read(gridCountProvider.notifier).state = 4;
                  } else {
                    ref.read(gridCountProvider.notifier).state = 2;
                  }*/
              ),

              // 3 dots menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Theme.of(context).iconTheme.color,
                ),
                iconSize: 26,
                color: Theme.of(context).cardColor, // adapts to light/dark
                onSelected: (value) {
                  switch (value) {
                    case 'refresh':
                      ref.invalidate(mediaProvider);
                      break;

                    case 'settings':
                      context.pushNamed('settings');
                      break;

                    case 'about':
                      context.pushNamed('about');
                      break;

                    case 'privacy':
                      context.pushNamed('privacy');
                      break;
                  }
                },

                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 10),
                        Text(
                          'About',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: 'privacy',
                    child: Row(
                      children: [
                        Icon(Icons.privacy_tip_outlined),
                        SizedBox(width: 10),
                        Text(
                          'Privacy policy',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: 'refresh',
                    child: Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 10),
                        Text(
                          'Refresh',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // With IndexedStack State is preserved
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.photo), label: 'Photos'),
          NavigationDestination(icon: Icon(Icons.folder), label: 'Collection'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favourite'),
        ],
      ),
    );
  }

  Future<dynamic> changeGridCount(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final currentGrid = ref.watch(gridCountProvider);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 4,
                  width: 40,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
 
                Text( 'Select Grid Layout',style: Theme.of(context).textTheme.titleMedium,),

                SizedBox(height: 12),

                Divider(color: Theme.of(context).dividerColor),

                ListTile(
                  leading: Icon(Icons.grid_view_rounded),
                  title: Text('2 Columns'),
                  trailing: currentGrid == 2
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                  onTap: () {
                    ref.read(gridCountProvider.notifier).state = 2;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.grid_on),
                  title: Text('3 Columns'),
                  trailing: currentGrid == 3
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                  onTap: () {
                    ref.read(gridCountProvider.notifier).state = 3;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.apps),
                  title: Text('4 Columns'),
                  trailing: currentGrid == 4
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
                  onTap: () {
                    ref.read(gridCountProvider.notifier).state = 4;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// When using BottomNavigationBar:
//  If you use normal switching → screen rebuilds every time 
//  If you use IndexedStack → state is preserved 