import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedGoal = 2048;
  String selectedPalette = 'Classique';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Objectif'),
            trailing: DropdownButton<int>(
              value: selectedGoal,
              items: [256, 512, 1024, 2048, 4096].map((goal) {
                return DropdownMenuItem(value: goal, child: Text(goal.toString()));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedGoal = value!);
              },
            ),
          ),
          ListTile(
            title: const Text('Palette de Couleurs'),
            trailing: DropdownButton<String>(
              value: selectedPalette,
              items: ['Classique', 'Pastel', 'Sombre'].map((palette) {
                return DropdownMenuItem(value: palette, child: Text(palette));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedPalette = value!);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {'goal': selectedGoal, 'palette': selectedPalette});
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }
}
