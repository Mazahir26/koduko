// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoutineAdapter extends TypeAdapter<Routine> {
  @override
  final int typeId = 2;

  @override
  Routine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Routine(
      name: fields[1] as String,
      tasks: (fields[2] as List).cast<Task>(),
      inCompletedTasks: (fields[3] as List).cast<Task>(),
      history: (fields[4] as List).cast<TaskEvent>(),
      id: fields[0] as String,
      days: (fields[6] as List).cast<String>(),
      isDaily: fields[5] == null ? true : fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Routine obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.tasks)
      ..writeByte(3)
      ..write(obj.inCompletedTasks)
      ..writeByte(4)
      ..write(obj.history)
      ..writeByte(5)
      ..write(obj.isDaily)
      ..writeByte(6)
      ..write(obj.days);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoutineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
