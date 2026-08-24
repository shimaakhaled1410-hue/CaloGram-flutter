// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppNotificationModelAdapter extends TypeAdapter<AppNotificationModel> {
  @override
  final int typeId = 6;

  @override
  AppNotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppNotificationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      message: fields[2] as String,
      type: fields[3] as String,
      createdAt: fields[4] as DateTime,
      isRead: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AppNotificationModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
