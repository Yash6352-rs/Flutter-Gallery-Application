import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/liked_provider.dart';
import 'package:go_router/go_router.dart';

class LikedScreen extends ConsumerWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedList = ref.watch(likedProvider);
    final theme = Theme.of(context);

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
            child: likedList.isEmpty
                ? Center(
                    child: Text("No liked items yet ❤️",style: TextStyle(fontSize: 18,
                      color: theme.textTheme.bodyMedium?.color)),
                  )
                : GridView.builder(
            
                    padding: EdgeInsets.all(8),
                    itemCount: likedList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final media = likedList[index];
            
                      return InkWell(
                        onTap: () {
                          context.pushNamed('detail', extra: {'media': media, 'tag': 'liked_${media.id}'});
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
                                    color: theme.colorScheme.onSurface,
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
