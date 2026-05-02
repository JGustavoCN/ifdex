import 'package:flutter/material.dart';

import '../helpers/gamification.dart';
import 'app_text.dart';

class XpHeader extends StatelessWidget {
  final int totalCertificados;
  final int xp;

  const XpHeader({
    super.key,
    required this.totalCertificados,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    final g = Gamification(xp);
    final progresso = g.progressoPercent.clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF355E3B), Color(0xFF4C6F49)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/logo_transparent.png', height: 24, width: 24),
              const SizedBox(width: 8),
              const AppText(
                'IFdex',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppText(
            'LVL ${g.nivel} • ${g.nomeNivel.toUpperCase()}',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.white70,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              AppText(
                '${g.xp < 0 ? 0 : g.xp} XP',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: AppText(
                  '${g.xpRestante < 0 ? 0 : g.xpRestante} XP Restante',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF3A2B00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              color: Colors.lightGreenAccent,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.folder_outlined,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 8),
              AppText(
                'PORTFÓLIO ($totalCertificados)',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
