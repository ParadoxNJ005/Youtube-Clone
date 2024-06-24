import 'package:supabase/supabase.dart';

class Credentials {
  static const String APIKEY =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhvdmNvaWdldWpsdnJwa3Jnd2F5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkxOTQxMjMsImV4cCI6MjAzNDc3MDEyM30.j1r9kuBpPDWiFMCPQ-zW2W3Jkrk9BiTCyVm-tDBIFuM";
  static const String APIURL = "https://hovcoigeujlvrpkrgway.supabase.co";

  static SupabaseClient supabaseClient = SupabaseClient(APIURL, APIKEY);
}
