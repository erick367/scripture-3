import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../application/timeline_service.dart';
import '../data/archaeology_repository.dart';
import '../application/discovery_feed_service.dart';
import '../application/devotional_service.dart';
import '../application/video_feed_service.dart';
import 'widgets/discovery_deep_dive_sheet.dart';
import 'widgets/chronological_context_slider.dart';
import 'widgets/dbs_module_widget.dart';
import 'widgets/unifying_thread_visualizer.dart';
import 'widgets/context_breakthrough_card.dart';
import '../../../services/stuck_detector_service.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eras = ref.read(timelineServiceProvider).getEras();
    final staticDiscoveries = ref.read(archaeologyRepositoryProvider).getDiscoveries();
    
    // Live Providers
    final liveArchaeologyAsync = ref.watch(liveArchaeologyProvider);
    final dailyDevotionalAsync = ref.watch(dailyDevotionalProvider);
    final bpVideosAsync = ref.watch(bibleProjectVideosProvider);
    final stuckStatusAsync = ref.watch(stuckStatusProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background Gradient
           Container(
             decoration: const BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
                 colors: [
                   Color(0xFF151515),
                   Color(0xFF030303),
                 ],
               ),
             ),
           ),

           CustomScrollView(
             slivers: [
               // 1. Header & Daily Insight
               SliverPadding(
                 padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
                 sliver: SliverToBoxAdapter(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         "Discover",
                         style: GoogleFonts.lora(
                           fontSize: 32,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                       ),
                       const SizedBox(height: 16),
                       _buildDailyInsightCard(context, dailyDevotionalAsync),
                     ],
                   ),
                 ),
               ),

                // 1.5 Context Breakthrough (if stuck)
                if (stuckStatusAsync.valueOrNull != null)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ContextBreakthroughCard(
                            stuckStatus: stuckStatusAsync.value!,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

               // 2. Deep Navigation (Chronological Context)
               SliverPadding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 sliver: SliverToBoxAdapter(
                   child: Text(
                     "DEEP NAVIGATION",
                     style: GoogleFonts.inter(
                       fontSize: 10,
                       fontWeight: FontWeight.w800,
                       letterSpacing: 2.0,
                       color: Colors.amber.withValues(alpha: 0.7),
                     ),
                   ),
                 ),
               ),
               
               // Chronological Context Slider
               const SliverToBoxAdapter(
                 child: ChronologicalContextSlider(),
               ),
               
               const SliverToBoxAdapter(child: SizedBox(height: 32)),

               // 2.5 DBS (Discovery Bible Study) Module
               SliverPadding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 sliver: SliverToBoxAdapter(
                   child: Text(
                     "INTERACTIVE STUDY",
                     style: GoogleFonts.inter(
                       fontSize: 10,
                       fontWeight: FontWeight.w800,
                       letterSpacing: 2.0,
                       color: Colors.indigo.withValues(alpha: 0.7),
                     ),
                   ),
                 ),
               ),

               const SliverPadding(
                 padding: EdgeInsets.symmetric(horizontal: 16),
                 sliver: SliverToBoxAdapter(
                   child: DBSModuleWidget(),
                 ),
               ),

               const SliverToBoxAdapter(child: SizedBox(height: 32)),

               // 2.6 Thematic Tracing
               SliverPadding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 sliver: SliverToBoxAdapter(
                   child: Text(
                     "UNIFYING THREADS",
                     style: GoogleFonts.inter(
                       fontSize: 10,
                       fontWeight: FontWeight.w800,
                       letterSpacing: 2.0,
                       color: Colors.purple.withValues(alpha: 0.7),
                     ),
                   ),
                 ),
               ),

               const SliverToBoxAdapter(
                 child: UnifyingThreadVisualizer(),
               ),
               
               const SliverToBoxAdapter(child: SizedBox(height: 32)),

               // 3. Archaeological Gallery
               SliverPadding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 sliver: SliverToBoxAdapter(
                   child: Row(
                     children: [
                       Text(
                         "RECENT RESEARCH",
                         style: GoogleFonts.inter(
                           fontSize: 10,
                           fontWeight: FontWeight.w800,
                           letterSpacing: 2.0,
                           color: Colors.blueAccent.withValues(alpha: 0.7),
                         ),
                       ),
                       const SizedBox(width: 12),
                       _buildLiveBadge(),
                     ],
                   ),
                 ),
               ),

               liveArchaeologyAsync.when(
                 data: (liveData) {
                   final recentItems = liveData.take(3).toList();
                   if (recentItems.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                   return SliverToBoxAdapter(
                     child: SizedBox(
                       height: 220,
                       child: ListView.builder(
                         padding: const EdgeInsets.symmetric(horizontal: 16),
                         scrollDirection: Axis.horizontal,
                         itemCount: recentItems.length,
                         itemBuilder: (context, index) => _buildDiscoveryCard(context, recentItems[index], isHorizontal: true),
                       ),
                     ),
                   );
                 },
                 loading: () => const SliverToBoxAdapter(
                   child: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
                 ),
                 error: (err, stack) => const SliverToBoxAdapter(child: SizedBox.shrink()),
               ),

               const SliverToBoxAdapter(child: SizedBox(height: 24)),

               // 4. Classic Discoveries (Most Visited)
               SliverPadding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 sliver: SliverToBoxAdapter(
                   child: Text(
                     "MOST VISITED",
                     style: GoogleFonts.inter(
                       fontSize: 10,
                       fontWeight: FontWeight.w800,
                       letterSpacing: 2.0,
                       color: Colors.amberAccent.withValues(alpha: 0.7),
                     ),
                   ),
                 ),
               ),

               SliverToBoxAdapter(
                 child: SizedBox(
                   height: 220,
                   child: ListView.builder(
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     scrollDirection: Axis.horizontal,
                     itemCount: staticDiscoveries.length.clamp(0, 3), // Show first 3 as classic
                     itemBuilder: (context, index) => _buildDiscoveryCard(context, staticDiscoveries[index], isHorizontal: true),
                   ),
                 ),
               ),
               
               const SliverToBoxAdapter(child: SizedBox(height: 32)),

               // 5. Featured Visuals (BibleProject)
               SliverPadding(
                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 sliver: SliverToBoxAdapter(
                   child: Text(
                     "THEOLOGY IN MOTION",
                     style: GoogleFonts.inter(
                       fontSize: 10,
                       fontWeight: FontWeight.w800,
                       letterSpacing: 2.0,
                       color: Colors.purpleAccent.withValues(alpha: 0.7),
                     ),
                   ),
                 ),
               ),

               bpVideosAsync.when(
                 data: (videos) => SliverToBoxAdapter(
                   child: _buildVideosSection(context, bpVideosAsync),
                 ),
                 loading: () => const SliverToBoxAdapter(
                   child: Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
                 ),
                 error: (err, stack) => SliverToBoxAdapter(
                   child: Center(child: Text("Video Error: $err", style: const TextStyle(color: Colors.red))),
                 ),
               ),
               
               const SliverToBoxAdapter(child: SizedBox(height: 100)), // Bottom padding
             ],
           ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoData video) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(video.videoUrl)),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  video.thumbnailUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    const Center(child: Icon(LucideIcons.video, color: Colors.white12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                video.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
               ),
             ),
           ],
         ),
       ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            "LIVE",
            style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInsightCard(BuildContext context, AsyncValue<DevotionalData?> insightAsync) {
    return insightAsync.when(
      data: (insight) => insight == null 
        ? const Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No insight available today.", style: TextStyle(color: Colors.white54)),
          ))
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(LucideIcons.sparkles, color: Colors.blueAccent, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      "DAILY ANCIENT INSIGHT",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "\"${insight.text}\"",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lora(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "— ${insight.reference} (${insight.version})",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
      loading: () => Container(
        height: 100, 
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(24)),
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (e, s) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Text("Insight Error: $e", style: const TextStyle(color: Colors.red, fontSize: 10)),
      ),
    );
  }

  Widget _buildVideosSection(BuildContext context, AsyncValue<List<VideoData>> videosAsync) {
    return videosAsync.when(
      data: (videos) => videos.isEmpty 
        ? const Center(child: Text("No videos found.", style: TextStyle(color: Colors.white24)))
        : SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: videos.length,
              itemBuilder: (context, index) => _buildVideoCard(context, videos[index]),
            ),
          ),
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(color: Colors.purpleAccent, strokeWidth: 2),
      )),
      error: (err, stack) => Center(child: Text("Video Error: $err", style: const TextStyle(color: Colors.red, fontSize: 10))),
    );
  }

  Widget _buildEraCard(BuildContext context, BiblicalEra era) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            HapticFeedback.lightImpact();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1E1E1E),
                title: Text(era.title, style: GoogleFonts.lora(color: Colors.white)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(era.dateRange, style: GoogleFonts.inter(color: Colors.amber, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(era.description, style: GoogleFonts.inter(color: Colors.white70)),
                    const SizedBox(height: 12),
                    Text("Key Books:", style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                    Text(era.relevantBooks.join(", "), style: GoogleFonts.inter(color: Colors.white)),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close", style: TextStyle(color: Colors.blueAccent)),
                  ),
                ],
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        era.dateRange,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      era.title,
                      style: GoogleFonts.lora(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    era.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveryCard(BuildContext context, Discovery discovery, {bool isHorizontal = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (discovery.articleUrl != null && discovery.dateFound == "Live Feed") {
           launchUrl(Uri.parse(discovery.articleUrl!));
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DiscoveryDeepDiveSheet(discovery: discovery),
          );
        }
      },
      child: Container(
        width: isHorizontal ? 180 : null,
        margin: isHorizontal ? const EdgeInsets.only(right: 12) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[900]),
                      child: discovery.imageUrl.startsWith('http') 
                        ? Image.network(
                            discovery.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              const Center(child: Icon(LucideIcons.image, color: Colors.white24, size: 32)),
                          )
                        : Image.asset(
                            discovery.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              const Center(child: Icon(LucideIcons.image, color: Colors.white24, size: 32)),
                          ),
                    ),
                    if (discovery.dateFound == "Live Feed")
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildLiveBadge(),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discovery.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lora(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        discovery.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  Widget _buildDiscoveryGridCard(BuildContext context, Discovery discovery, {required bool isLive}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => DiscoveryDeepDiveSheet(discovery: discovery),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: discovery.imageUrl.startsWith('http')
                  ? Image.network(discovery.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover)
                  : Image.asset(discovery.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('LIVE', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.blueAccent)),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    discovery.title,
                    style: GoogleFonts.lora(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discovery.connectedVerse,
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.amberAccent),
                  ),
                  const SizedBox(height: 8),
                  // Go to Evidence Button
                  ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Navigate to Bible Reader with verse
                      // TODO: Implement navigation to BibleReaderScreen with verse parameter
                    },
                    icon: const Icon(Icons.arrow_forward, size: 14),
                    label: Text('Go to Evidence', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      minimumSize: const Size(double.infinity, 32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
