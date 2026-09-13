import 'package:flutter_test/flutter_test.dart';
import 'package:talib_al_jamia/core/services/cloud_sync_repository.dart';

void main() {
  test('disabled cloud sync is a safe no-op for local-first builds', () async {
    await expectLater(
      const DisabledCloudSyncRepository().synchronize(),
      completes,
    );
  });
}
