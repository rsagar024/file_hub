import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vap_uploader/core/common/models/file_model.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/core/services/firestore_service/firestore_service.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final FirestoreService _firestoreService;

  VideoBloc(this._firestoreService) : super(const VideoState()) {
    on<InitialVideoEvent>(_onInitialVideo);
    on<GetAllVideosEvent>(_onGetAllVideos);
    on<GetVideosCountEvent>(_onGetVideosCount);
  }

  FutureOr<void> _onInitialVideo(InitialVideoEvent event, Emitter<VideoState> emit) {
    emit(state.copyWith(
      pageState: PageState.loading,
      videoModels: [],
      pageNo: 1,
      totalCount: 0,
      loadMore: false,
    ));
    add(GetVideosCountEvent());
    add(GetAllVideosEvent());
  }

  FutureOr<void> _onGetAllVideos(GetAllVideosEvent event, Emitter<VideoState> emit) async {
    try {
      if (state.totalCount == 0 || state.totalCount != state.videoModels.length) {
        List<FileModel> models = state.videoModels;
        List<FileModel> videoModels = await _firestoreService.getAllFiles('video', 1);
        emit(state.copyWith(
          pageState: PageState.success,
          videoModels: [...models, ...videoModels],
          loadMore: true,
          pageNo: state.pageNo + 1,
        ));
      }
    } catch (e) {
      emit(state.copyWith(pageState: PageState.error));
    }
  }

  FutureOr<void> _onGetVideosCount(GetVideosCountEvent event, Emitter<VideoState> emit) async {
    try {
      int totalCount = await _firestoreService.getFilesCount('video');
      emit(state.copyWith(totalCount: totalCount));
    } catch (e) {
      emit(state.copyWith(pageState: PageState.error));
    }
  }
}
