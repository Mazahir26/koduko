// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskEventAdapter extends TypeAdapter<TaskEvent> {
  @override
  final int typeId = 3;

  @override
  TaskEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskEvent(
      id: fields[0] as String,
      taskName: fields[1] as String,
      time: fields[2] as DateTime,
      taskId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskEvent obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.taskName)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.taskId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
