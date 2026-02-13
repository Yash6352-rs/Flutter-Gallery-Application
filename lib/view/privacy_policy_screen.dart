import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(), 
        ),
        title: Text('Privacy Policy'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("1. Data Collection", style: theme.textTheme.titleLarge,),
            SizedBox(height: 6,),
            Text("This app does not collect, store, or share any personal user data.", style: theme.textTheme.bodyMedium,),
            
            SizedBox(height: 20,),

            Text("2. Local Storage", style: theme.textTheme.titleLarge,),
            SizedBox(height: 6,),
            Text("Liked media is stored locally on your device using secure local storage. "
              "No data is transmitted to external servers.", style: theme.textTheme.bodyMedium,),
            
            SizedBox(height: 20,),

            Text("3. Network Usage", style: theme.textTheme.titleLarge,),
            SizedBox(height: 6,),
            Text( "Media content is fetched from publicly available APIs "
              "for viewing purposes only.", style: theme.textTheme.bodyMedium,),
            
            SizedBox(height: 20,),

            Text("4. Third-Party Services", style: theme.textTheme.titleLarge,),
            SizedBox(height: 6,),
            Text(  "This app may use third-party libraries such as Flutter plugins "
              "for functionality like video playback.", style: theme.textTheme.bodyMedium,),
            
            SizedBox(height: 20,),

            Text("5. Contact", style: theme.textTheme.titleLarge,),
            SizedBox(height: 6,),
            Text( "For any questions regarding this privacy policy, "
              "please contact the developer.", style: theme.textTheme.bodyMedium,),

            SizedBox(height: 90,),
            Center(
              child: Text("Last updated: February 2026", style: theme.textTheme.bodySmall,),
            )     
          ],
        ),
      )
    );
  }
}