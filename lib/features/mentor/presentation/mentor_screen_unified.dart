import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../journal/presentation/journal_screen.dart';
import 'mentor_hub_screen.dart';

/// The Mentor - Tab 2
/// 
/// Unified journaling and DBS mentorship screen.
/// Features:
/// - Journal entries with seasonal threading
/// - DBS workflow (Look Back / Look Up / Look Forward)
/// - Privacy toggle for AI access
/// - Threaded reflections
class MentorScreenUnified extends ConsumerStatefulWidget {
  const MentorScreenUnified({super.key});

  @override
  ConsumerState<MentorScreenUnified> createState() => _MentorScreenUnifiedState();
}

class _MentorScreenUnifiedState extends ConsumerState<MentorScreenUnified>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Tab Bar
          _buildTabBar(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Tab 1: Journal
                JournalScreen(),
                // Tab 2: DBS Sessions
                MentorHubScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 8,
        20,
        12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF12121E),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'THE MENTOR',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: Colors.white38,
            ),
          ),
          
          // New entry button
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO: Open journal entry editor
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00F2FF).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00F2FF).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.plus,
                    size: 14,
                    color: Color(0xFF00F2FF),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'REFLECT',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: const Color(0xFF00F2FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF12121E),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF00F2FF),
        indicatorWeight: 2,
        labelColor: const Color(0xFF00F2FF),
        unselectedLabelColor: Colors.white54,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        onTap: (_) => HapticFeedback.selectionClick(),
        tabs: const [
          Tab(text: 'JOURNAL'),
          Tab(text: 'DBS'),
        ],
      ),
    );
  }
}
