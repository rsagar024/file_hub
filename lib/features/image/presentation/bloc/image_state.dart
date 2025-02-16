part of 'image_bloc.dart';

class ImageState extends Equatable {
  final PageState pageState;
  final List<FileModel> imageModels;
  final int pageNo;
  final int totalCount;
  final bool loadMore;

  const ImageState({
    this.pageState = PageState.initial,
    this.imageModels = const [],
    this.pageNo = 1,
    this.totalCount = 0,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [pageState, imageModels, pageNo, totalCount, loadMore];

  ImageState copyWith({
    PageState? pageState,
    List<FileModel>? imageModels,
    int? pageNo,
    int? totalCount,
    bool? loadMore,
  }) {
    return ImageState(
      pageState: pageState ?? this.pageState,
      imageModels: imageModels ?? this.imageModels,
      pageNo: pageNo ?? this.pageNo,
      totalCount: totalCount ?? this.totalCount,
      loadMore: loadMore ?? this.loadMore,
    );
  }
}
