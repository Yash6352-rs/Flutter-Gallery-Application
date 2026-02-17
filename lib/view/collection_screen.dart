import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/utils/common_ui.dart';
import 'package:gallery_application/view_model/deleted_provider.dart';
import 'package:gallery_application/view_model/grid_provider.dart';
import 'package:gallery_application/view_model/locked_provider.dart';
import 'package:gallery_application/view_model/media_provider.dart';
import 'package:go_router/go_router.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreen();
}

class _CollectionScreen extends ConsumerState<CollectionScreen> {
  String? selectedType;
  static const String fixedPassword = '1234';

  @override
  Widget build(BuildContext context) {
    final mediaAsync = ref.watch(mediaProvider);
    final deletedList = ref.watch(deletedProvider);
    final lockedList = ref.watch(lockedProvider);
    final gridCount = ref.watch(gridCountProvider);
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
                      selectedType == 'image'
                        ? "Images"
                        : selectedType == 'video'
                            ? "Videos"
                            : selectedType == 'camera'
                                ? "Camera"
                                : selectedType == 'download'
                                    ? "Download"
                                    : selectedType == 'screenshot'
                                        ? "Screenshot"
                                        : selectedType == 'other'
                                            ? "Others"
                                            : "Gallery",
                     
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
                              selectedType = "camera";
                            });
                          }, context), 
                          _folderCard("Download", Icons.download, () {
                            setState(() {
                              selectedType = "download";
                            });
                          }, context), 
                          _folderCard("Screenshot", Icons.screenshot_outlined, () {
                            setState(() {
                              selectedType = "screenshot";
                            });
                          }, context), 
                          _folderCard("Others", Icons.photo_album_outlined, () {
                            setState(() {
                              selectedType = "other";
                            });
                          }, context)            
                        ],
                      )
                    );
                  }
                          
                  // show filtered media               
                  final filteredMedia = mediaList.where((media) {
                    final isDeleted = deletedList.any((item) => item.id == media.id);
                    final isLocked = lockedList.any((item) => item.id == media.id);

                    if (isDeleted || isLocked) return false;

                    if (selectedType == "image") {
                      return media.type == MediaType.image;
                    }
                    if (selectedType == 'video') {
                      return media.type == MediaType.video;
                    }
                    if (selectedType == 'camera' || selectedType == ' download' || selectedType == ' screenshot' || selectedType == ' others') { 
                      return false;
                    }

                    return false;
                  }).toList();

                  if (filteredMedia.isEmpty) {
                    return Padding(padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text("No ${selectedType!.toUpperCase()} media yet", style: theme.textTheme.bodyLarge),
                      ),
                    );
                  }
                          
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    itemCount: filteredMedia.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8
                    ),
                    itemBuilder: (context, index) {
                      final media = filteredMedia[index];
                          
                      return InkWell(
                        onTap: () {
                          context.pushNamed('detail', extra: { 
                            'mediaList': filteredMedia, 'initialIndex': index, 'source': 'home',
                          });
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
                      subtitle: Text("This feature shows deleted media"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      onTap: () {
                        context.pushNamed('bin');
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
                      title: Text('Locked'),
                      subtitle: Text("This option shows locked media"),
                      trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16),
                      onTap: () {
                        openLockedFolder(context);
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

  void openLockedFolder(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter Password'
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text == fixedPassword) {
                  Navigator.pop(context);
                  context.pushNamed('lock');             
                } else {
                  CommonUI.showSnackBar(context, "Wrong Password");
                }
              }, 
              child: Text('OK')
            ),
          ],
        );
      }
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
