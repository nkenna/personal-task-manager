import 'package:flutter_test/flutter_test.dart';
import 'package:ptm/features/profile/data/models/profile_model.dart';
import 'package:ptm/features/profile/domain/entities/profile.dart';
import 'package:ptm/features/task/data/models/task_history_model.dart';
import 'package:ptm/features/task/data/models/task_model.dart';
import 'package:ptm/features/task/domain/entities/task.dart';
import 'package:ptm/features/task/domain/entities/task_history.dart';

void main() {
  group('TaskModel', () {
    test('toMap omits id when null so sqlite autoincrements', () {
      final model = TaskModel(
        id: null,
        title: 'Title',
        description: 'Desc',
        status: TaskStatus.ongoing,
        profileId: 3,
      );

      final map = model.toMap();
      expect(map.containsKey('id'), isFalse);
      expect(map['title'], 'Title');
      expect(map['status'], 'ongoing');
      expect(map['profile_id'], 3);
    });

    test('fromMap/toMap and entity round-trip', () {
      final entity = Task(
        id: 7,
        title: 'Buy milk',
        description: '2 liters',
        status: TaskStatus.completed,
        profileId: 1,
      );

      final model = TaskModel.fromEntity(entity);
      final map = model.toMap();
      final restored = TaskModel.fromMap(map).toEntity();

      expect(restored.id, 7);
      expect(restored.title, 'Buy milk');
      expect(restored.status, TaskStatus.completed);
      expect(restored.profileId, 1);
    });
  });

  group('ProfileModel', () {
    test('is_active maps to 0/1', () {
      expect(
        const ProfileModel(
          id: 1,
          name: 'A',
          email: 'a@b.com',
          isActive: true,
        ).toMap()['is_active'],
        1,
      );
      expect(
        const ProfileModel(
          id: 1,
          name: 'A',
          email: 'a@b.com',
          isActive: false,
        ).toMap()['is_active'],
        0,
      );
    });

    test('fromMap reads is_active as int', () {
      final model = ProfileModel.fromMap({
        'id': 2,
        'name': 'Bob',
        'email': 'bob@x.com',
        'is_active': 1,
      });
      expect(model.isActive, isTrue);
      expect(model.toEntity().name, 'Bob');
    });
  });

  group('TaskHistoryModel', () {
    test('date and task_id mapping', () {
      final date = DateTime(2026, 7, 15, 10, 30);
      final model = TaskHistoryModel(
        id: 4,
        taskId: 9,
        date: date,
        remark: 'Status changed to pending',
      );

      final map = model.toMap();
      expect(map['task_id'], 9);
      expect(map['date'], date.toIso8601String());

      final restored = TaskHistoryModel.fromMap(map);
      expect(restored.taskId, 9);
      expect(restored.remark, 'Status changed to pending');
      expect(restored.date, date);
    });
  });
}
