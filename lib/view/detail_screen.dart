import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/view_model/liked_provider.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final MediaModel media;
  final String heroTag;

  const DetailScreen({super.key, required this.media, required this.heroTag});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    if (widget.media.type == MediaType.video) {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.media.url))
            ..initialize().then((_) {
              setState(() {
                _controller!.play();
                _startHideTimer(); //start auto-hide timer
              });
            });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
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
      _startHideTimer(); // restart auto-hide timer
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
    final media = widget.media;
    final likedList = ref.watch(likedProvider);
    final isLiked = likedList.any((item) => item.id == media.id);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: Hero(
          tag: widget.heroTag,
          child: media.type == MediaType.image
              ? Image.network(media.url)
              : Stack(
                  alignment: Alignment.center,
                  children: [

                    // Show video when initialized, else loading spinner
                    _controller != null && _controller!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          )
                        : CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),

                    // Full-screen GestureDetector to toggle play/pause
                    if (_controller != null && _controller!.value.isInitialized)
                      GestureDetector(
                        onTap: togglePlayPause,
                        child: Container(color: Theme.of(context).colorScheme.onSurface.withAlpha((0.2 * 255).round()),
                      ),
                      ),

                    // Centered play/pause icon
                    if (_controller != null && _controller!.value.isInitialized && _showControls)
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
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Heart button
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

            // Properties button
            IconButton(
              iconSize: 35,
              icon: Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color),
              onPressed: () {
                showMediaProperties(context, media, _controller);
              },
            ),
          ],
        ),
     
      ),
    );
  }
  
  void showMediaProperties(BuildContext context, MediaModel media, VideoPlayerController? controller) {

    showModalBottomSheet(
      context: context, 
      backgroundColor: Theme.of(context).cardColor,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("Properties", style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: 12),

              Text("Title: ${media.title}", style: Theme.of(context).textTheme.bodyMedium),
              Text("Type: ${media.type.name.toUpperCase()}", style: Theme.of(context).textTheme.bodyMedium),
              Text("URL: ${media.url}", style: Theme.of(context).textTheme.bodyMedium),

              if (media.type == MediaType.video && controller != null && controller.value.isInitialized)
                Text(
                  "Duration: ${controller.value.duration.inSeconds}s",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

              SizedBox(height: 16,)         
            ],
          ),       
        );
      }
    );
  }
}
