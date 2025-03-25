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
  String _username = 'Utilizador';

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
      _username = prefs.getString('username') ?? 'Utilizador';
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecionar a Linguagem'),
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

  void _changeUsername() {
    TextEditingController _controller = TextEditingController(text: _username);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Alterar Nome de Utilizador'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Digite seu nome'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _username = _controller.text;
                  });
                  _updateSetting('username', _controller.text);
                  Navigator.pop(context);
                },
                child: Text('Salvar'),
              ),
            ],
          ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Excluir Conta'),
            content: Text(
              'Tem certeza que deseja excluir sua conta? Esta ação é irreversível.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pop(context);
                },
                child: Text('Excluir', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Definições')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Nome de Utilizador'),
            subtitle: Text(_username),
            trailing: Icon(Icons.edit),
            onTap: _changeUsername,
          ),
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
            onTap: _showLanguageDialog,
          ),
          ListTile(
            title: Text('Alterar Senha'),
            trailing: Icon(Icons.lock),
            onTap: () {}, // Adicione lógica para alteração de senha
          ),
          ListTile(
            title: Text('Excluir Conta', style: TextStyle(color: Colors.red)),
            trailing: Icon(Icons.delete, color: Colors.red),
            onTap: _deleteAccount,
          ),
        ],
      ),
    );
  }
}
