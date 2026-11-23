import 'package:flutter/material.dart';

class CenterCard extends StatelessWidget {
  final String code;
  final String name;
  final String statusText;
  final String address;
  final String contactName;
  final String contactPhone;
  final int studentCount;
  final int facultyCount;
  final VoidCallback onTap;
  final bool isActive;
  final Color? codeBadgeColor;
  final Color? codeTextColor;
  final Color? statusBadgeColor;
  final Color? statusTextColor;

  const CenterCard({
    super.key,
    required this.code,
    required this.name,
    required this.statusText,
    required this.address,
    required this.contactName,
    required this.contactPhone,
    required this.studentCount,
    required this.facultyCount,
    required this.onTap,
    this.isActive = true,
    this.codeBadgeColor,
    this.codeTextColor,
    this.statusBadgeColor,
    this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedCodeBg = codeBadgeColor ?? const Color(0xFFE8EEFF);
    final resolvedCodeFg = codeTextColor ?? const Color(0xFF2E5BFF);

    final resolvedStatusBg =
        statusBadgeColor ??
        (isActive ? const Color(0xFFDDF3FF) : const Color(0xFFFCE6CD));
    final resolvedStatusFg =
        statusTextColor ??
        (isActive ? const Color(0xFF005A8D) : const Color(0xFF8C4A08));

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF1F3F6), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Center Code Pill + Center Name + Status Pill
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: resolvedCodeBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      code,
                      style: TextStyle(
                        color: resolvedCodeFg,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF101828),
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: resolvedStatusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 6,
                          color: resolvedStatusFg,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: resolvedStatusFg,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Address Row
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Color(0xFF98A2B3),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Contact Person & Phone Row
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 16,
                    color: Color(0xFF98A2B3),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '$contactName • $contactPhone',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Subtle Divider
              const Divider(height: 1, thickness: 1, color: Color(0xFFF2F4F7)),
              const SizedBox(height: 12),

              // Bottom Metrics Row: Students • Faculty + Chevron
              Row(
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 17,
                    color: Color(0xFF2E5BFF),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$studentCount Students',
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.circle,
                      size: 4,
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  const Icon(
                    Icons.badge_outlined,
                    size: 17,
                    color: Color(0xFF8C4A08),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$facultyCount Faculty',
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFF98A2B3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
