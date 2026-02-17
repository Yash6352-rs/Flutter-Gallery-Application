import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/deleted_provider.dart';
import 'package:gallery_application/view_model/grid_provider.dart';
import 'package:gallery_application/view_model/locked_provider.dart';
import 'package:gallery_application/view_model/media_provider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(mediaProvider);
    final deletedList = ref.watch(deletedProvider);
    final lockedList = ref.watch(lockedProvider);
    final gridCount = ref.watch(gridCountProvider);
    final theme = Theme.of(context);

    return Scaffold(

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              
              child: Text('Gallery', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400,
                color: theme.textTheme.headlineSmall?.color))),
          ),
      
          SizedBox(height: 12,),
        
          Expanded(
            child: mediaAsync.when(
            
            loading: () => Center(child: CircularProgressIndicator(color: theme.colorScheme.primary,)),
            error: (error, stack) => Center(
                child: Text('Error: $error', style: TextStyle(color: theme.textTheme.bodyMedium?.color),)), 

            data: (mediaList) {    
              
              // Show only media that is NOT in deleted and locked list    
              final visibleMedia = mediaList.where((media) { 
                final isDeleted = deletedList.any((item) => item.id == media.id);
                final isLocked = lockedList.any((item) => item.id == media.id);

                return !isDeleted && !isLocked;
              }).toList();

              return GridView.builder(
                itemCount: visibleMedia.length,
                padding: EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount, 
                  crossAxisSpacing: 8, 
                  mainAxisSpacing: 8
                ), 
                
                itemBuilder: (context, index) {   
                  final media = visibleMedia[index];
            
                  return InkWell(
                    onTap: () { 
                      context.pushNamed('detail', extra: { 
                        'mediaList': visibleMedia, 'initialIndex': index, 'source': 'home',
                      });
                    },
                    child: ClipRRect(               
                      borderRadius: BorderRadius.circular(12),                
                      child: Stack(
                        children: [ 
                          Hero(
                            tag: "home_${media.id}",
                            child: Image.network(
                              media.thumbnailUrl, 
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null ) return child;
                                return Center(child: CircularProgressIndicator());                         
                              },
                            ),
                          ),
                        
                        // Show play icon if it is video
                        if(media.type == MediaType.video) 
                          Center(
                            child: Icon(Icons.play_circle_fill, size: 45, color: Colors.white),
                          )
                        ]
                      ),
                    ),
                  ); 
                 
                }
              );
            },      
            ),
          ),          
       ]
      ),        
    );
  }
}