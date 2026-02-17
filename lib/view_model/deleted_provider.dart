import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final deletedProvider = StateNotifierProvider<DeletedNotifier, List<MediaModel>>(
  (ref) => DeletedNotifier());

class DeletedNotifier extends StateNotifier<List<MediaModel>>{
  DeletedNotifier() : super([]) {
    _loadDeleted();
  }

  static const _key = "deleted_media";
  
  Future<void> _loadDeleted() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);

    if (jsonList != null) {
      state = jsonList.map((e) => MediaModel.fromJson(jsonDecode(e))).toList();
    }
  }

  // Check if already deleted Prevent duplicates
  Future<void> delete(MediaModel media) async {
    if (!state.any((item) => item.id == media.id)) {
      state = [...state, media];
      await _saveDeleted();
    }
  }

  Future<void> restore(MediaModel media) async {
    state = state.where((item) => item.id != media.id).toList();
    await _saveDeleted();
  }

  Future<void> _saveDeleted() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((media) => jsonEncode(media.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }
  
  bool isDeleted(int id) {
    return state.any((item) => item.id == id);
  }
}