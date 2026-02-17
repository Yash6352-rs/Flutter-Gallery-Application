import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/deleted_provider.dart';
import 'package:gallery_application/view_model/grid_provider.dart';
import 'package:gallery_application/view_model/liked_provider.dart';
import 'package:gallery_application/view_model/locked_provider.dart';
import 'package:go_router/go_router.dart';

class LikedScreen extends ConsumerWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedList = ref.watch(likedProvider);
    final deletedList = ref.watch(deletedProvider);
    final lockedList = ref.watch(lockedProvider);
    final gridCount = ref.watch(gridCountProvider);
    final theme = Theme.of(context);

    //  Filter Deleted Items
    final visibleLiked = likedList .where((media) {
      final isDeleted = deletedList.any((item) => item.id == media.id);
      final isLocked = lockedList.any((item) => item.id == media.id);

      return !isDeleted && !isLocked;     
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Liked', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400,
                color: theme.textTheme.headlineSmall?.color))),
          ),
      
          SizedBox(height: 12,),
      
          Expanded(
            child: visibleLiked.isEmpty
                ? Center(
                    child: Text("No liked items yet ❤️", style: TextStyle(fontSize: 18,
                      color: theme.textTheme.bodyMedium?.color)),
                  )
                : GridView.builder(
            
                    padding: EdgeInsets.all(8),
                    itemCount: visibleLiked.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final media = visibleLiked[index];
            
                      return InkWell(
                        onTap: () {
                          context.pushNamed('detail', extra: { 
                            'mediaList': visibleLiked, 'initialIndex': index, 'source': 'home',
                      });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Hero(
                                tag: "liked_${media.id}",
                                child: Image.network(
                                  media.thumbnailUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
            
                              // Show play icon if video
                              if (media.type == MediaType.video)
                                Center(child: Icon(
                                    Icons.play_circle_fill,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ])
    );
  }
}
