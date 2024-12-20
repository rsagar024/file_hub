import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vap_uploader/core/enums/app_enum/page_state_enum.dart';
import 'package:vap_uploader/core/services/firestore_service/firestore_service.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final FirestoreService _firestoreService;

  UploadBloc(this._firestoreService) : super(const UploadState()) {
    on<InitialUploadEvent>(_onInitialUpload);
    on<FilesSelectionEvent>(_onFilesSelection);
    on<FilesRemoveEvent>(_onFilesRemove);
    on<FilesUploadEvent>(_onFilesUpload);
    on<ClearAppCacheEvent>(_onClearAppCache);
  }

  FutureOr<void> _onInitialUpload(InitialUploadEvent event, Emitter<UploadState> emit) {
    emit(state.copyWith(pageState: PageState.initial, isButtonEnabled: true, files: [], isFileSelection: true));
    add(ClearAppCacheEvent());
  }

  FutureOr<void> _onFilesSelection(FilesSelectionEvent event, Emitter<UploadState> emit) async {
    if (!state.isFileSelection) return;
    emit(state.copyWith(pageState: PageState.initial, isFileSelection: false));
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      withReadStream: true,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      emit(state.copyWith(pageState: PageState.initial, errorMessage: '', files: files, isFileSelection: true, isButtonEnabled: true));
    } else {
      emit(state.copyWith(pageState: PageState.error, errorMessage: 'No files are selected', files: [], isFileSelection: true, isButtonEnabled: true));
    }
  }

  FutureOr<void> _onFilesRemove(FilesRemoveEvent event, Emitter<UploadState> emit) {
    emit(state.copyWith(pageState: PageState.initial, files: [], isFileSelection: true, isButtonEnabled: true));
    add(ClearAppCacheEvent());
  }

  FutureOr<void> _onFilesUpload(FilesUploadEvent event, Emitter<UploadState> emit) async {
    if (!state.isButtonEnabled) return;
    emit(state.copyWith(pageState: PageState.initial, isButtonEnabled: false));

    if (state.files.isNotEmpty) {
      emit(state.copyWith(pageState: PageState.loading));
      int uploadedFile = 0;
      /*await for (var uploadState in _firestoreService.uploadMultipleFiles(state.files)) {
        if (uploadState.showPopup) {
          emit(state.copyWith(
            pageState: PageState.popup,
            errorMessage: uploadState.message,
          ));
          await Future.delayed(const Duration(seconds: 1));
        } else if (!uploadState.isSuccess) {
          emit(state.copyWith(
            pageState: PageState.error,
            errorMessage: uploadState.message,
          ));
        } else {
          uploadedFile++;
        }
      }*/
      uploadedFile = 1;
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(
        pageState: PageState.success,
        isButtonEnabled: true,
        files: [],
        uploadedFile: uploadedFile,
      ));
    } else {
      emit(state.copyWith(
        pageState: PageState.error,
        errorMessage: 'No files are selected',
        isButtonEnabled: true,
      ));
    }
    add(ClearAppCacheEvent());
  }

  FutureOr<void> _onClearAppCache(ClearAppCacheEvent event, Emitter<UploadState> emit) async {
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
  }
}
