import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:gallery_application/data/repository/media_repository.dart';

final mediaRepositoryProvider = Provider((ref) => MediaRepository());

final mediaProvider = FutureProvider<List<MediaModel>>((ref) async {
  final repository = ref.read(mediaRepositoryProvider);
  return repository.fetchMedia();
});