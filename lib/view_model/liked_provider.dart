import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final likedProvider = StateNotifierProvider<LikedNotifier, List<MediaModel>>(
  (ref) => LikedNotifier()
);

class LikedNotifier extends StateNotifier<List<MediaModel>> {
  LikedNotifier() : super([]) {
    loadliked();   // when app starts, load saved liked items from phone storage
  }

  void toggle(MediaModel media) {
    final isAlreadyLiked = state.any((item) => item.id == media.id);

    if (isAlreadyLiked) {
      state = state.where((item) => item.id != media.id).toList();
    } else {
      state = [...state, media];
    }

    saveLiked();  // save after every change // After adding/removing → save to storage
  }

  bool isLiked(String id) {
    return state.any((item) => item.id == id);
  }

  // This saves liked items to phone storage
  Future<void> saveLiked() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((media) => jsonEncode(media.toJson())).toList();

    await prefs.setStringList('liked_media', jsonList);
  }
  
  Future<void> loadliked() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('liked_media') ?? [];

    final loadedList = jsonList
      .map((item) => MediaModel.fromJson(jsonDecode(item))).toList();
      //  JSON String → Map → MediaModel object

    state = loadedList;  
  }    
}


//  What happens:
//  MediaModel → Map → JSON String
//  Example:
//  MediaModel(id: "1", url: "abc.jpg")
//  becomes:
//  {\"id\":\"1\",\"url\":\"abc.jpg\"}"