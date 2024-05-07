// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadAdapter extends TypeAdapter<Download> {
  @override
  final int typeId = 0;

  @override
  Download read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Download(
      id: fields[0] as String?,
      location: fields[1] as String?,
      podcastName: fields[2] as String?,
      podcastOwner: fields[3] as String?,
      podcastEpisodePhoto: fields[4] as String?,
      podcastEpisodeAbout: fields[5] as String?,
      podcastEpisodeName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Download obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.podcastName)
      ..writeByte(3)
      ..write(obj.podcastOwner)
      ..writeByte(4)
      ..write(obj.podcastEpisodePhoto)
      ..writeByte(5)
      ..write(obj.podcastEpisodeAbout)
      ..writeByte(6)
      ..write(obj.podcastEpisodeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
