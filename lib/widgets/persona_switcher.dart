import 'package:flutter/material.dart';
import '../core/colors.dart';
import '../core/state.dart';
import '../models/app_user.dart';

class PersonaSwitcher extends StatelessWidget {
  const PersonaSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ConvivaState.instance;
    final currentRole = state.currentUser?.role ?? UserRole.senior;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFECE4D0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ConvivaColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildRoleButton(
              context: context,
              label: '👵 Idosa',
              isActive: currentRole == UserRole.senior,
              onTap: () => state.switchRole(UserRole.senior),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildRoleButton(
              context: context,
              label: '📋 Organizador',
              isActive: currentRole == UserRole.organizer,
              onTap: () => state.switchRole(UserRole.organizer),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildRoleButton(
              context: context,
              label: '🚗 Motorista',
              isActive: currentRole == UserRole.driver,
              onTap: () => state.switchRole(UserRole.driver),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? ConvivaColors.pineGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : ConvivaColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
