import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:file_hub/core/enums/app_enum/page_state_enum.dart';
import 'package:file_hub/core/services/firestore_service/firestore_service.dart';
import 'package:file_hub/core/utilities/file_type_checker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    emit(state.copyWith(pageState: PageState.initial, isButtonEnabled: true, files: state.files, isFileSelection: true));
  }

  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  FutureOr<void> _onFilesSelection(FilesSelectionEvent event, Emitter<UploadState> emit) async {
    if (!await requestStoragePermission()) return;
    if (!state.isFileSelection) return;
    emit(state.copyWith(pageState: PageState.initial, isFileSelection: false));
    bool isLoading = true;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withReadStream: true,
      onFileLoading: (item) {
        if (isLoading) {
          isLoading = false;
          emit(state.copyWith(pageState: PageState.loading, loadingFileSelection: true));
        }
      },
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      String firstFileType = await FileTypeChecker.getMimeType(files.first.path);
      emit(state.copyWith(
        pageState: PageState.initial,
        errorMessage: '',
        files: files,
        firstFileType: firstFileType,
        isFileSelection: true,
        isButtonEnabled: true,
        loadingFileSelection: false,
      ));
    } else {
      emit(state.copyWith(
        pageState: PageState.initial,
        errorMessage: '',
        files: [],
        isFileSelection: true,
        isButtonEnabled: true,
        loadingFileSelection: false,
      ));
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
      bool hasUploadedSuccessfully = false;
      await for (var uploadState in _firestoreService.uploadMultipleFiles(state.files)) {
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
          hasUploadedSuccessfully = true;
        }
      }

      emit(state.copyWith(
        pageState: PageState.success,
        isButtonEnabled: true,
        files: [],
        hasUploadedSuccessfully: hasUploadedSuccessfully,
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
