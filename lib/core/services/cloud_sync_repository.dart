/// Contract for future cloud synchronization.
///
/// App data remains local-first until an authenticated, RLS-protected backend
/// is introduced. Implementations must not make local saves depend on network
/// availability.
abstract interface class CloudSyncRepository {
  Future<void> synchronize();
}

/// Deliberately performs no network work while cloud data is not yet enabled.
class DisabledCloudSyncRepository implements CloudSyncRepository {
  const DisabledCloudSyncRepository();

  @override
  Future<void> synchronize() async {}
}
