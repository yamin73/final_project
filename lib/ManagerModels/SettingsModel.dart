class SettingsModel {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool automaticBackup;
  final String selectedLanguage;

  SettingsModel({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.automaticBackup = true,
    this.selectedLanguage = 'English',
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      isDarkMode: json['isDarkMode'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      automaticBackup: json['automaticBackup'] ?? true,
      selectedLanguage: json['selectedLanguage'] ?? 'English',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'automaticBackup': automaticBackup,
      'selectedLanguage': selectedLanguage,
    };
  }

  // Create a copy of the current settings with updated values
  SettingsModel copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? automaticBackup,
    String? selectedLanguage,
  }) {
    return SettingsModel(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      automaticBackup: automaticBackup ?? this.automaticBackup,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}