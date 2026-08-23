import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            trailing: Switch(
              value: true, 
              onChanged: (val) {
                // TODO: Implement Theme Toggle
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsTile(
            icon: Icons.notifications_active_rounded,
            title: 'Notifications',
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, required Widget trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        trailing: trailing,
      ),
    );
  }
}