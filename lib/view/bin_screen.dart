import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/deleted_provider.dart';

class BinScreen extends ConsumerWidget {
  const BinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedList = ref.watch(deletedProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        title: Text('Bin'),
      ),
      body: deletedList.isEmpty
        ? Center(child: Text('Bin is empty', style: TextStyle(
            fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color))
          )
        : GridView.builder(
            padding: EdgeInsets.all(8),
            itemCount: deletedList.length ,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final media = deletedList[index];

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      media.thumbnailUrl, fit: BoxFit.cover,
                    ),
                  ),

                  // show video icon if item is video
                  if (media.type == MediaType.video) 
                    Center(
                      child: Icon(Icons.play_circle_fill, size: 45, color: Colors.white),
                    ),

                  // restore button (top right)
                  Positioned(
                    child: IconButton(
                      icon: Icon(
                        Icons.restore, color: Colors.white,
                      ),
                      onPressed: () {
                        ref.read(deletedProvider.notifier).restore(media);
                      },
                    )
                  ),
                ],
              );
            }
          )
    );
  }
}

