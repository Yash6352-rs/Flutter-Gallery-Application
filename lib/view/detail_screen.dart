import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/deleted_provider.dart';
import 'package:gallery_application/view_model/liked_provider.dart';
import 'package:gallery_application/view_model/locked_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final List<MediaModel> mediaList;
  final int initialIndex;
  final String source;

  const DetailScreen({super.key, required this.mediaList, required this.initialIndex, required this.source});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late PageController _pageController;
  late int currentIndex;

  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);

    _initializeVideoIfNeeded(widget.mediaList[currentIndex]);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Initialize video when page changes
  void _initializeVideoIfNeeded(MediaModel media) {
    _controller?.dispose();
    _controller = null;

    if (media.type == MediaType.video) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(media.url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _controller!.play();
              _startHideTimer();
            });
          }
      });
    }
  } 

  void togglePlayPause() {
    if (_controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _showControls = true;
      _startHideTimer();    // restart auto-hide timer
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 1), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.mediaList[currentIndex];
    final likedList = ref.watch(likedProvider);
    final isLiked = likedList.any((item) => item.id == media.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        title: Text('${currentIndex + 1} / ${widget.mediaList.length}'),
      ),

      // swipe view
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaList.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
          final newMedia = widget.mediaList[index];
          _initializeVideoIfNeeded(newMedia);
        },

        itemBuilder: (context, index) {
          final media = widget.mediaList[index];

          return Center(
          child: Hero(
            tag: '${widget.source}_${media.id}',
            child: media.type == MediaType.image
                ? Image.network(media.url)
                : Stack(
                    alignment: Alignment.center,
                    children: [
        
                      // Show video when initialized, else loading spinner
                      _controller != null && _controller!.value.isInitialized && currentIndex == index
                          ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: VideoPlayer(_controller!),
                            )
                          : CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
        
                      // Full-screen GestureDetector to toggle play/pause
                      if (_controller != null && _controller!.value.isInitialized && currentIndex == index)
                        GestureDetector(
                          onTap: togglePlayPause,
                          child: Container(
                            color: Theme.of(context).colorScheme.onSurface
                                .withAlpha((0.2 * 255).round()),
                          ),
                        ),
        
                      // Centered play/pause icon
                      if (_controller != null &&  _controller!.value.isInitialized && _showControls && currentIndex == index)
                        Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          size: 65,
                          color: Colors.white,
                        ),
                    ],
                  ),
          ),
        );
        },
      ),
      
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // Info Properties button
            IconButton(
              iconSize: 35,
              icon: Icon(
                Icons.info_outline,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                showMediaProperties(context, media, _controller);
              },
            ),

            // Like button
            IconButton(
              iconSize: 35,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                ref.read(likedProvider.notifier).toggle(media);
              },
            ),

            // Delete Button
            IconButton(
              iconSize: 35,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                confirmDelete(media);
              },              
            ),

            // Lock button
            IconButton(
              iconSize: 35,
              icon: Icon(
                Icons.lock_outline_sharp,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                confirmLock(media);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- DELETE ----------------
  void confirmDelete(MediaModel media) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Move to Bin?"),
          content: Text("This item will be moved to Bin."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // add to deleted
                await ref.read(deletedProvider.notifier).delete(media);

                // remove from liked screen
                ref.read(likedProvider.notifier).removeById(media.id);
                Navigator.pop(context);
                context.pop();                
              }, 
              child: Text('Delete'),
            ),
          ],
        );
      }
    ); 
  }

  // ---------------- LOCK ----------------
  void confirmLock(MediaModel media) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text('Lock this media?'),
          content: Text('This item will be moved to Locked folder.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: () async {
                await ref.read(lockedProvider.notifier).lock(media);
                ref.read(likedProvider.notifier).removeById(media.id);

                Navigator.pop(context);
                if (mounted) context.pop();
              }, 
              child: Text('Lock')
            ),
          ],
        );
      }
    );
  }

  void showMediaProperties(BuildContext context, MediaModel media, VideoPlayerController? controller) {

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Center(child: Text( "Properties", style: Theme.of(context).textTheme.titleLarge)),
                SizedBox(height: 12),

                Divider(color: Theme.of(context).dividerColor),
                SizedBox(height: 12),
          
                Text("Title: ${media.title}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 6),
                Text("Type: ${media.type.name.toUpperCase()}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 6),
                Text("URL: ${media.url}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 6),
          
                if (media.type == MediaType.video && controller != null &&  controller.value.isInitialized)
                  Text("Duration: ${controller.value.duration.inSeconds}s",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
