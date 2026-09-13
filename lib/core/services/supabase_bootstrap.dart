import 'package:supabase_flutter/supabase_flutter.dart';

/// Build-time Supabase settings. Neither a service-role nor secret key belongs
/// in a mobile application.
abstract final class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const publishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}

/// Initializes the client only for builds that explicitly provide public
/// Supabase settings. Normal development builds remain fully local-first.
Future<void> initializeSupabaseIfConfigured() async {
  if (!SupabaseConfig.isConfigured) return;

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
}
