part of 'video_bloc.dart';

class VideoState extends Equatable {
  final PageState pageState;
  final List<FileModel> videoModels;
  final int pageNo;
  final int totalCount;
  final bool loadMore;

  const VideoState({
    this.pageState = PageState.initial,
    this.videoModels = const [],
    this.pageNo = 1,
    this.totalCount = 0,
    this.loadMore = false,
  });

  @override
  List<Object> get props => [pageState, videoModels, pageNo, totalCount, loadMore];

  VideoState copyWith({
    PageState? pageState,
    List<FileModel>? videoModels,
    int? pageNo,
    int? totalCount,
    bool? loadMore,
  }) {
    return VideoState(
      pageState: pageState ?? this.pageState,
      videoModels: videoModels ?? this.videoModels,
      pageNo: pageNo ?? this.pageNo,
      totalCount: totalCount ?? this.totalCount,
      loadMore: loadMore ?? this.loadMore,
    );
  }
}
