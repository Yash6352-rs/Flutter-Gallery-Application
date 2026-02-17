import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';
import 'package:gallery_application/data/models/media_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lockedProvider = StateNotifierProvider<LockedNotifier, List<MediaModel>>(
  (ref) => LockedNotifier());

class LockedNotifier extends StateNotifier<List<MediaModel>> {
  LockedNotifier() : super([]) {
    _loadLocked();
  }

  static const _key = 'locked_media';

  // load locked items from storage
  Future<void> _loadLocked() async {
    final prefs = await  SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);

    if (jsonList != null) {
      state = jsonList.map((e) => MediaModel.fromJson(jsonDecode(e))).toList();
    }
  }

  // lock media
  Future<void> lock(MediaModel media) async {
    if (!state.any((item) => item.id == media.id)) {
      state = [...state, media];
      await _saveLocked();     
    }
  }

  // unlock media
  Future<void> unlock(MediaModel media) async {
    state = state.where((item) => item.id != media.id).toList();
    await _saveLocked();
  }

  //  Save locked list to storage
  Future<void> _saveLocked() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((media) => jsonEncode(media.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  // Check if media is locked
  bool isLocked (int id) {
    return state.any((item) => item.id == id);
  }

}