import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/utils/common_ui.dart';
import 'package:gallery_application/view_model/media_provider.dart';
import 'package:go_router/go_router.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreen();
}

class _CollectionScreen extends ConsumerState<CollectionScreen> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(mediaProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (selectedType !=null) 
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new), color: theme.iconTheme.color,
                      onPressed: () {
                        setState(() {
                          selectedType = null;
                        });
                      },                  
                    ),
                    Text(
                      selectedType == null
                        ? "Collection"
                        : selectedType == "image"
                            ? "Images"
                            : "Videos",
                      style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.w400, color: theme.textTheme.headlineSmall?.color
                        ),
                    )
                ],
              )
            ),
        
            SizedBox(height: 12,),
          
            mediaAsync.when(
                loading: () => Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(
                  child: Text('Error', style: TextStyle(color: theme.textTheme.bodyMedium?.color),)
                ), 
                data: (mediaList) {
                          
                  if (selectedType == null) {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        children: [
                          _folderCard("Images", Icons.photo, () {
                            setState(() {
                              selectedType = "image";
                            });
                          }, context),
                          _folderCard("Videos", Icons.videocam, () {
                            setState(() {
                              selectedType = "video";
                            });
                          }, context),   
                          _folderCard("Camera", Icons.photo_camera, () {
                            setState(() {
                              selectedType = "screenshot";
                            });
                          }, context), 
                          _folderCard("Download", Icons.download, () {
                            setState(() {
                              selectedType = "others";
                            });
                          }, context), 
                          _folderCard("Screenshot", Icons.screenshot_outlined, () {
                            setState(() {
                              selectedType = "screenshot";
                            });
                          }, context), 
                          _folderCard("Others", Icons.photo_album_outlined, () {
                            setState(() {
                              selectedType = "others";
                            });
                          }, context)            
                        ],
                      )
                    );
                  }
                          
                  // show filtered media
                  final filtered = mediaList.where((media) {
                    return selectedType == "image"
                      ? media.type == MediaType.image
                      : media.type == MediaType.video;
                  }).toList();
                          
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    itemCount: filtered.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8
                    ), 
                    itemBuilder: (context, index) {
                      final media = filtered[index];
                          
                      return InkWell(
                        onTap: () {
                          context.pushNamed('detail', extra: {'media': media, 'tag': 'collection_${media.id}'});
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(                         
                            children: [                   
                              Hero(
                                tag: "collection_${media.id}",
                                child: Image.network(media.thumbnailUrl, fit: BoxFit.cover)
                              ),
                            
                              if(media.type == MediaType.video) 
                                Center(
                                  child: Icon(Icons.play_circle_fill, size: 45, color: Colors.white,)
                                )
                            ],
                          ),
                        ),
                      );
                    }
                  );
                }              
              ),
            
            if (selectedType == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.delete_outline_rounded),
                      title: Text('Bin'),
                      subtitle: Text("This feature will be available soon"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      onTap: () {
                        CommonUI.showSnackBar(context, "Feature coming soon");                      
                      }
                    ),
                      
                    ListTile(
                      leading: Icon(Icons.document_scanner),
                      title: Text('Documents'),
                      subtitle: Text("This feature will be available soon"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      onTap: () {
                        CommonUI.showSnackBar(context, "Feature coming soon");
                      }
                    ),

                    ListTile(
                      leading: Icon(Icons.archive_outlined),
                      title: Text('Archive'),
                      subtitle: Text("This feature will be available soon"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      onTap: () {
                        CommonUI.showSnackBar(context, "Feature coming soon");
                      }
                    ),
                      
                    ListTile(
                      leading: Icon(Icons.lock_outline_sharp),
                      subtitle: Text("This feature will be available soon"),
                      title: Text('Locked'),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      onTap: () {
                        CommonUI.showSnackBar(context, "Feature coming soon");
                      }
                    ),                      
                    SizedBox(height: 20,)
                  ]
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

Widget _folderCard(String title, IconData icon,VoidCallback onTap, BuildContext context) {
  final folderColor = Theme.of(context).brightness == Brightness.light
    ? Color(0xFFE0E4FF)
    : Color(0xFF2A2A3D);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: folderColor,  
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).iconTheme.color,),
            SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyMedium?.color))
          ],
        ),
      ),
    );
}
