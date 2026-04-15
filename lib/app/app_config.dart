import 'package:supabase_flutter/supabase_flutter.dart';

class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
  static const googleIosReversedClientId = String.fromEnvironment(
    'GOOGLE_IOS_REVERSED_CLIENT_ID',
  );

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get hasGoogleClientConfig =>
      googleIosClientId.isNotEmpty && googleWebClientId.isNotEmpty;
}

Future<void> initializeSupabaseIfConfigured() async {
  if (!AppConfig.hasSupabaseConfig) {
    return;
  }

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
}
