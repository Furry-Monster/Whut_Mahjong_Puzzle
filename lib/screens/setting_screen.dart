import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/setting_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingCard(
                  title: 'Graphics',
                  children: [
                    _buildSettingSwitch(
                      title: 'Using Shader',
                      subtitle: '使用内置渲染器',
                      value: settings.shaderEnabled,
                      onChanged: (value) => settings.toggleShader(),
                    ),
                    _buildSettingSwitch(
                      title: 'High Quality',
                      subtitle: '使用高质量纹理',
                      value: settings.highQualityEnabled,
                      onChanged: (value) => settings.toggleHighQuality(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingCard(
                  title: 'Audio',
                  children: [
                    _buildSettingSwitch(
                      title: 'Sound',
                      subtitle: '开启/关闭游戏音效',
                      value: settings.soundEnabled,
                      onChanged: (value) => settings.toggleSound(),
                    ),
                    _buildSettingSwitch(
                      title: 'Music',
                      subtitle: '开启/关闭背景音乐',
                      value: settings.musicEnabled,
                      onChanged: (value) => settings.toggleMusic(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSettingCard(
                  title: 'Other',
                  children: [
                    _buildSettingSwitch(
                      title: 'Vibration',
                      subtitle: '开启/关闭游戏震动',
                      value: settings.vibrationEnabled,
                      onChanged: (value) => settings.toggleVibration(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue[900],
      ),
    );
  }
}
