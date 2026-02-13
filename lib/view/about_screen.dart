import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
        title: Text('About'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Gallery Application", style: theme.textTheme.headlineSmall,),
            SizedBox(height: 6,),

            Text("Version 1.0.0", style: theme.textTheme.bodyMedium,),
            SizedBox(height: 20,),

            Text( "A modern gallery app built using Flutter, Riverpod and Dio with clean architecture (MVVM). "
              "You can view images, videos and manage your media easily.",
               style: theme.textTheme.bodyLarge,
            ),

            SizedBox(height: 30,),
            Divider(),

            SizedBox(height: 20,),

            Text("Developer", style: theme.textTheme.titleMedium,),
            SizedBox(height: 6,),

            Text("ABC", style: theme.textTheme.bodyLarge,),
            SizedBox(height: 6,),
            
            Text("Built with Flutter 💙", style: theme.textTheme.bodyMedium,),
          ],
        ),
      )
    );
  }
}