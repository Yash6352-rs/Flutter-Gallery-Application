import 'package:flutter/material.dart';
import 'package:gallery_application/utils/common_ui.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(), 
        ),
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 12),
        children: [

          buildTile(
            context, icon: Icons.backup_outlined, title: "Backup", subtitle: "This feature will be available soon"
          ),
          buildTile(
            context, icon: Icons.notifications_outlined, title: "Notifications", subtitle: "This feature will be available soon"
          ),
          buildTile(
            context, icon: Icons.tune_outlined, title: "Preferences", subtitle: "This feature will be available soon"
          ),
          buildTile(
            context, icon: Icons.share_outlined, title: "Sharing", subtitle: "This feature will be available soon"
          ),
          buildTile(
            context, icon: Icons.privacy_tip_outlined, title: "Privacy Policy", subtitle: "Read privacy policy"
          ),

          SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  context.pushNamed('about');
                }, 
                child: Text('About', style: TextStyle(fontSize: 16, decoration: TextDecoration.underline,)),
              ),
            ),
          ),
        ],
      )
    );
  }
}

Widget buildTile(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
  final theme = Theme.of(context);

  return ListTile (
    leading: Icon(icon, color: theme.iconTheme.color),
    title: Text(title, style: theme.textTheme.bodyLarge),
    subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
    trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16), 
    onTap: () {

      switch (title) {
        case 'Backup':
          CommonUI.showSnackBar(context, "Feature coming soon");
          break;

        case 'Notifications':
          CommonUI.showSnackBar(context, "Feature coming soon");
          break;

        case 'Preferences':
          CommonUI.showSnackBar(context, "Feature coming soon");
          break;

        case 'Sharing':
          CommonUI.showSnackBar(context, "Feature coming soon");
          break;  
        
        case 'Privacy Policy':
          context.pushNamed('privacy');
          break; 
      }
    },
  );
}