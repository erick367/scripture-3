import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';

import '../../search/presentation/search_screen.dart';
import '../../profile/presentation/profile_settings_screen.dart';

/// Search & Settings - Tab 3
/// 
/// Utility screen combining:
/// - Global FTS5 search (verses, journals, history)
/// - Key Vault management
/// - Privacy controls
/// - Sync settings
class SearchSettingsScreen extends ConsumerStatefulWidget {
  const SearchSettingsScreen({super.key});

  @override
  ConsumerState<SearchSettingsScreen> createState() => _SearchSettingsScreenState();
}

class _SearchSettingsScreenState extends ConsumerState<SearchSettingsScreen>
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
                // Tab 1: Search
                SearchScreen(),
                // Tab 2: Settings
                ProfileSettingsScreen(),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SEARCH & SETTINGS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
              color: Colors.white38,
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
          Tab(text: 'SEARCH'),
          Tab(text: 'SETTINGS'),
        ],
      ),
    );
  }
}
