import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_hub/core/common/models/file_model.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/services/firestore_service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final FirestoreService _firestoreService;
  final ScrollController itemListScrollController = ScrollController();

  AudioBloc(this._firestoreService) : super(const AudioState()) {
    on<InitialAudioEvent>(_onInitialAudio);
    on<GetAllAudiosEvent>(_onGetAllAudios);
    on<GetAudiosCountEvent>(_onGetAudiosCount);
    on<ScrollEvent>(_onScroll);
    on<RefreshEvent>(_onRefresh);
  }

  FutureOr<void> _onInitialAudio(InitialAudioEvent event, Emitter<AudioState> emit) {
    emit(state.copyWith(
      pageState: PageState.loading,
      audioModels: [],
      pageNo: 1,
      totalCount: 0,
      loadMore: false,
    ));
    add(GetAudiosCountEvent());
    add(GetAllAudiosEvent());
  }

  FutureOr<void> _onGetAllAudios(GetAllAudiosEvent event, Emitter<AudioState> emit) async {
    try {
      if (state.totalCount == 0 || state.totalCount != state.audioModels.length) {
        List<FileModel> models = state.audioModels;
        List<FileModel> audioModels = await _firestoreService.getAllFiles('audio', 1);
        emit(state.copyWith(
          pageState: PageState.success,
          audioModels: [...models, ...audioModels],
          loadMore: true,
          pageNo: state.pageNo + 1,
        ));
      }
    } catch (e) {
      emit(state.copyWith(pageState: PageState.error));
    }
  }

  FutureOr<void> _onGetAudiosCount(GetAudiosCountEvent event, Emitter<AudioState> emit) async {
    try {
      int totalCount = await _firestoreService.getFilesCount('audio');
      emit(state.copyWith(totalCount: totalCount));
    } catch (e) {
      emit(state.copyWith(pageState: PageState.error));
    }
  }

  FutureOr<void> _onScroll(ScrollEvent event, Emitter<AudioState> emit) async {
    if (!state.loadMore) return;
    if (itemListScrollController.position.pixels >= itemListScrollController.position.maxScrollExtent * 0.4) {
      emit(state.copyWith(loadMore: false));
      add(GetAllAudiosEvent());
    }
  }

  FutureOr<void> _onRefresh(RefreshEvent event, Emitter<AudioState> emit) {
    add(InitialAudioEvent());
  }

  @override
  Future<void> close() {
    itemListScrollController.dispose();
    return super.close();
  }
}
