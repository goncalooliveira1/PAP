import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Português';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'Português';
    });
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Definições')),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Modo Escuro'),
            value: _darkMode,
            onChanged: (bool value) {
              setState(() {
                _darkMode = value;
              });
              _updateSetting('darkMode', value);
            },
          ),
          SwitchListTile(
            title: Text('Notificações'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _updateSetting('notificationsEnabled', value);
            },
          ),
          ListTile(
            title: Text('Idioma'),
            subtitle: Text(_selectedLanguage),
            onTap: () {
              _showLanguageDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecionar Idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['Português', 'Inglês', 'Espanhol'].map((String language) {
              return RadioListTile(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  _updateSetting('language', value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
