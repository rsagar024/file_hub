import 'package:cloud_firestore/cloud_firestore.dart';

class FileModel {
  final String? fileName;
  final String? fileType;
  final String? fileId;
  final String? fileUrl;
  final String? thumbnail;
  final String? createdOn;
  final String? createdBy;
  final String? modifiedOn;
  final String? modifiedBy;
  final bool isDeleted;

  FileModel({
    this.fileName,
    this.fileType,
    this.fileId,
    this.fileUrl,
    this.thumbnail,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'fileType': fileType,
        'fileId': fileId,
        'fileUrl': fileUrl,
        'thumbnail': thumbnail,
        'createdOn': createdOn,
        'createdBy': createdBy,
        'modifiedOn': modifiedOn,
        'modifiedBy': modifiedBy,
        'isDeleted': isDeleted,
      };

  static FileModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FileModel(
      fileName: snapshot['fileName']?.toString() ?? '',
      fileType: snapshot['fileType']?.toString() ?? '',
      fileId: snapshot['fileId']?.toString() ?? '',
      fileUrl: snapshot['fileUrl']?.toString() ?? '',
      thumbnail: snapshot['thumbnail']?.toString(),
      createdOn: snapshot['createdOn']?.toString() ?? '',
      createdBy: snapshot['createdBy']?.toString() ?? '',
      modifiedOn: snapshot['modifiedOn']?.toString() ?? '',
      modifiedBy: snapshot['modifiedBy']?.toString() ?? '',
      isDeleted: snapshot['isDeleted'] ?? false,
    );
  }

  FileModel copyWith({
    String? fileName,
    String? fileType,
    String? fileId,
    String? fileUrl,
    String? thumbnail,
    String? createdOn,
    String? createdBy,
    String? modifiedOn,
    String? modifiedBy,
    bool? isDeleted,
  }) {
    return FileModel(
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileId: fileId ?? this.fileId,
      fileUrl: fileUrl ?? this.fileUrl,
      thumbnail: thumbnail ?? this.thumbnail,
      createdOn: createdOn ?? this.createdOn,
      createdBy: createdBy ?? this.createdBy,
      modifiedOn: modifiedOn ?? this.modifiedOn,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
