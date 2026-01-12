import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

final videoFeedServiceProvider = Provider((ref) => VideoFeedService());

final bibleProjectVideosProvider = FutureProvider<List<VideoData>>((ref) async {
  final service = ref.watch(videoFeedServiceProvider);
  return service.fetchBibleProjectVideos();
});

class VideoData {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String publishedAt;

  VideoData({
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.publishedAt,
  });
}

class VideoFeedService {
  // BibleProject Channel ID (Corrected)
  static const String channelId = 'UCVfwlh9XpX2Y_tQfjeln9QA';
  static const String rssUrl = 'https://www.youtube.com/feeds/videos.xml?channel_id=$channelId';

  Future<List<VideoData>> fetchBibleProjectVideos() async {
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        return _parseYouTubeRSS(response.body);
      } else {
        print('Video Feed Error: Status ${response.statusCode}');
      }
      return [];
    } catch (e) {
      print('Error fetching Video Feed: $e');
      return [];
    }
  }

  List<VideoData> _parseYouTubeRSS(String xmlString) {
    final List<VideoData> videos = [];
    try {
      final document = XmlDocument.parse(xmlString);
      final entries = document.findAllElements('entry');

      for (var entry in entries) {
        try {
          final title = entry.findElements('title').first.innerText;
          final link = entry.findElements('link').first.getAttribute('href') ?? '';
          final published = entry.findElements('published').first.innerText;
          
          // YouTube RSS uses 'media:group' containing 'media:thumbnail'
          // We look for the local name 'thumbnail'
          String thumbnail = '';
          final thumbnails = entry.findAllElements('media:thumbnail');
          if (thumbnails.isNotEmpty) {
            thumbnail = thumbnails.first.getAttribute('url') ?? '';
          } else {
             // Fallback to any element with local name 'thumbnail'
             final anyThumbnail = entry.descendants.whereType<XmlElement>().where((e) => e.name.local == 'thumbnail');
             if (anyThumbnail.isNotEmpty) {
               thumbnail = anyThumbnail.first.getAttribute('url') ?? '';
             }
          }

          videos.add(VideoData(
            title: title,
            videoUrl: link,
            thumbnailUrl: thumbnail,
            publishedAt: published,
          ));
        } catch (e) {
          print('Error parsing video entry: $e');
          continue;
        }
      }
    } catch (e) {
      print('Error parsing YouTube RSS XML: $e');
    }
    return videos;
  }
}
