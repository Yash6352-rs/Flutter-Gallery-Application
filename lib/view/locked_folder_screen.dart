import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/locked_provider.dart';

class LockedFolderScreen extends ConsumerWidget {
  const LockedFolderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lockedList = ref.watch(lockedProvider);
    return Scaffold(
      appBar:  AppBar(
        title: Text('Locked Folder'),
      ),
      body: lockedList.isEmpty
        ? Center(child: Text('No Locked media', style: TextStyle(fontSize: 18,
            color: Theme.of(context).textTheme.bodyMedium?.color,),) )
        : GridView.builder(
            padding: EdgeInsets.all(8),
            itemCount: lockedList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
          itemBuilder: (context, index) {
            final media = lockedList[index];

            return Stack(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    media.thumbnailUrl, fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                
                // Video icon if video
                if (media.type == MediaType.video)
                  Center(
                    child: Icon(
                      Icons.play_circle_fill, size: 45, color: Colors.white,
                    ),
                  ),

                // Unlock button (top right)
                Positioned(
                  child: IconButton(
                    icon: Icon(Icons.lock_open_outlined),
                    color: Colors.white,
                    onPressed: () {
                      ref.read(lockedProvider.notifier).unlock(media);
                    },                   
                  ),
                )
              ],
            );
          },

        )     
    );
  }
}