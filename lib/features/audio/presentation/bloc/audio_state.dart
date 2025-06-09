part of 'audio_bloc.dart';

class AudioState extends Equatable {
  final PageState pageState;
  final List<FileModel> audioModels;
  final int pageNo;
  final int totalCount;
  final bool loadMore;

  const AudioState({
    this.pageState = PageState.initial,
    this.audioModels = const [],
    this.pageNo = 1,
    this.totalCount = 0,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [pageState, audioModels, pageNo, totalCount, loadMore];

  AudioState copyWith({
    PageState? pageState,
    List<FileModel>? audioModels,
    int? pageNo,
    int? totalCount,
    bool? loadMore,
  }) {
    return AudioState(
      pageState: pageState ?? this.pageState,
      audioModels: audioModels ?? this.audioModels,
      pageNo: pageNo ?? this.pageNo,
      totalCount: totalCount ?? this.totalCount,
      loadMore: loadMore ?? this.loadMore,
    );
  }
}
