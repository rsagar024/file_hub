import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_hub/core/common/models/file_model.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/services/firestore_service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final FirestoreService _firestoreService;
  final ScrollController itemListScrollController = ScrollController();

  ImageBloc(this._firestoreService) : super(const ImageState()) {
    on<InitialImageEvent>(_onInitialImage);
    on<GetAllImagesEvent>(_onGetAllImages);
    on<GetImagesCountEvent>(_onGetImagesCount);
    on<ScrollEvent>(_onScroll);
    on<RefreshEvent>(_onRefresh);
  }

  FutureOr<void> _onInitialImage(InitialImageEvent event, Emitter<ImageState> emit) {
    emit(state.copyWith(
      pageState: PageState.loading,
      imageModels: [],
      pageNo: 1,
      totalCount: 0,
      loadMore: false,
    ));
    add(GetImagesCountEvent());
    add(GetAllImagesEvent());
  }

  FutureOr<void> _onGetAllImages(GetAllImagesEvent event, Emitter<ImageState> emit) async {
    try {
      if (state.totalCount == 0 || state.totalCount != state.imageModels.length) {
        List<FileModel> models = state.imageModels;
        List<FileModel> imageModels = await _firestoreService.getAllFiles('photo', state.pageNo);
        emit(state.copyWith(
          pageState: PageState.success,
          imageModels: [...models, ...imageModels],
          loadMore: true,
          pageNo: state.pageNo + 1,
        ));
      }
    } catch (e) {
      emit(state.copyWith(pageState: PageState.error));
    }
  }

  FutureOr<void> _onGetImagesCount(GetImagesCountEvent event, Emitter<ImageState> emit) async {
    try {
      int totalCount = await _firestoreService.getFilesCount('photo');
      emit(state.copyWith(totalCount: totalCount));
    } catch (e) {
      emit(state.copyWith(pageState: PageState.error));
    }
  }

  FutureOr<void> _onScroll(ScrollEvent event, Emitter<ImageState> emit) async {
    if (!state.loadMore) return;
    if (itemListScrollController.position.pixels >= itemListScrollController.position.maxScrollExtent * 0.4) {
      emit(state.copyWith(loadMore: false));
      add(GetAllImagesEvent());
    }
  }

  FutureOr<void> _onRefresh(RefreshEvent event, Emitter<ImageState> emit) {
    add(InitialImageEvent());
  }

  @override
  Future<void> close() {
    itemListScrollController.dispose();
    return super.close();
  }
}
