//Raw JSON -> Converted to MediaModel
//Images + Static Videos -> Combined list

import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/data/services/api_service.dart';

class MediaRepository {

  final ApiService _apiService = ApiService();

  Future<List<MediaModel>> fetchMedia() async {
    final response = await _apiService.fetchPhotos();

    // Convert API images
    final images = response.map<MediaModel>((json) {
      return MediaModel(
        id: json['id'], 
        title: json['title'], 
        url: 'https://picsum.photos/id/${json['id']}/600/600', 
        thumbnailUrl: 'https://picsum.photos/id/${json['id']}/300/300', 
        type: MediaType.image,
      );
    });

    // Add static videos
    final videos = [

      MediaModel(
        id: 1001, 
        title: 'Sample Video 1', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee/.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video1/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1002, 
        title: 'Sample Video 2', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video4/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1003, 
        title: 'Sample Video 3', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video6/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1004, 
        title: 'Sample Video 4', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video8/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1005, 
        title: 'Sample Video 5', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video9/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1006, 
        title: 'Sample Video 6', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video10/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1007, 
        title: 'Sample Video 7', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video11/300/300', 
        type: MediaType.video,
      ),

      MediaModel(
        id: 1008, 
        title: 'Sample Video 8', 
        url:  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4', 
        thumbnailUrl: 'https://picsum.photos/seed/video13/300/300', 
        type: MediaType.video,
      ),
    ];

    return [...images, ...videos];
  }
}