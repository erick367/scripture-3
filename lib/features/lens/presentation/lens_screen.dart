import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../bible/presentation/widgets/bible_content_widget.dart';
import '../../discover/presentation/discover_screen.dart';

/// The Lens - Tab 1
/// 
/// Unified immersive reader merging Bible Reader and Discover screens.
/// Features:
/// - Scripture reading with verse selection
/// - Archaeological overlay toggle
/// - Chronological timeline
/// - AI Mentor Panel with 3-tab insights
class LensScreen extends ConsumerStatefulWidget {
  const LensScreen({super.key});

  @override
  ConsumerState<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends ConsumerState<LensScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _showArchaeologyOverlay = false;
  
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
          // Header with toggle
          _buildHeader(),
          
          // Tab Bar
          _buildTabBar(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Tab 1: Read (Bible Content)
                BibleContentWidget(),
                // Tab 2: Discover (Archaeological/Historical)
                DiscoverScreen(),
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
            'THE LENS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: Colors.white38,
            ),
          ),
          
          // Archaeology overlay toggle
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _showArchaeologyOverlay = !_showArchaeologyOverlay;
              });
              // If toggling on, switch to Discover tab
              if (_showArchaeologyOverlay) {
                _tabController.animateTo(1);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _showArchaeologyOverlay
                    ? const Color(0xFF00F2FF).withOpacity(0.15)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showArchaeologyOverlay
                      ? const Color(0xFF00F2FF).withOpacity(0.3)
                      : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.landmark,
                    size: 14,
                    color: _showArchaeologyOverlay
                        ? const Color(0xFF00F2FF)
                        : Colors.white54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'CONTEXT',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: _showArchaeologyOverlay
                          ? const Color(0xFF00F2FF)
                          : Colors.white54,
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
          Tab(text: 'READ'),
          Tab(text: 'DISCOVER'),
        ],
      ),
    );
  }
}
