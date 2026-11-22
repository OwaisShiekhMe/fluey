import 'package:flutter/material.dart';

class EnrolmentItem {
  final String initials;
  final String name;
  final String meta;
  final String timeLabel;
  final Color badgeBg;
  final Color badgeFg;

  const EnrolmentItem({
    required this.initials,
    required this.name,
    required this.meta,
    required this.timeLabel,
    required this.badgeBg,
    required this.badgeFg,
  });

  factory EnrolmentItem.fromJson(Map<String, dynamic> json) {
    final fullName = (json['name'] ?? '').toString().trim();
    final parts = fullName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final computedInitials = parts.isEmpty
        ? '?'
        : parts.length == 1
            ? parts.first.substring(0, 1).toUpperCase()
            : '${parts.first[0]}${parts.last[0]}'.toUpperCase();

    return EnrolmentItem(
      initials: json['initials'] ?? computedInitials,
      name: fullName,
      meta: json['meta'] ?? '',
      timeLabel: json['timeLabel'] ?? '',
      badgeBg: json['badgeBg'] is Color ? json['badgeBg'] : const Color(0xFFE8EEFF),
      badgeFg: json['badgeFg'] is Color ? json['badgeFg'] : const Color(0xFF2E5BFF),
    );
  }
}