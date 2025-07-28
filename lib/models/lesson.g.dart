// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final int typeId = 0;

  @override
  Lesson read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      enrollmentFrom: fields[0] as DateTime,
      enrollmentUntil: fields[1] as DateTime,
      cancelationUntil: fields[2] as DateTime,
      starts: fields[3] as DateTime,
      ends: fields[4] as DateTime,
      participantsMax: fields[5] as int,
      participantCount: fields[6] as int,
      instructors: (fields[7] as List).cast<String>(),
      facility: fields[8] as String,
      room: fields[9] as String,
      id: fields[10] as int,
      number: fields[11] as String,
      sportName: fields[12] as String,
    )..managed = fields[13] as bool;
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.enrollmentFrom)
      ..writeByte(1)
      ..write(obj.enrollmentUntil)
      ..writeByte(2)
      ..write(obj.cancelationUntil)
      ..writeByte(3)
      ..write(obj.starts)
      ..writeByte(4)
      ..write(obj.ends)
      ..writeByte(5)
      ..write(obj.participantsMax)
      ..writeByte(6)
      ..write(obj.participantCount)
      ..writeByte(7)
      ..write(obj.instructors)
      ..writeByte(8)
      ..write(obj.facility)
      ..writeByte(9)
      ..write(obj.room)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(11)
      ..write(obj.number)
      ..writeByte(12)
      ..write(obj.sportName)
      ..writeByte(13)
      ..write(obj.managed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
