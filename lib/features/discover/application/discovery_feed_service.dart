import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../data/archaeology_repository.dart';

final discoveryFeedServiceProvider = Provider((ref) => DiscoveryFeedService());

final liveArchaeologyProvider = FutureProvider<List<Discovery>>((ref) async {
  final service = ref.watch(discoveryFeedServiceProvider);
  return service.fetchBASFeed();
});

class DiscoveryFeedService {
  static const String basFeedUrl = 'https://www.biblicalarchaeology.org/feed/';

  Future<List<Discovery>> fetchBASFeed() async {
    try {
      final response = await http.get(Uri.parse(basFeedUrl));
      if (response.statusCode == 200) {
        return _parseRSS(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching BAS Feed: $e');
      return [];
    }
  }

  List<Discovery> _parseRSS(String xmlString) {
    final List<Discovery> discoveries = [];
    final document = XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    for (var item in items) {
      try {
        final title = item.findElements('title').first.innerText;
        final link = item.findElements('link').first.innerText;
        final description = item.findElements('description').first.innerText;
        
        // Robust Image Extraction
        String imageUrl = 'https://images.unsplash.com/photo-1571597438222-9df58ed27e6a?q=80&w=600'; // Default
        
        // 1. Try media:content or media:thumbnail (via local name)
        final mediaElements = item.descendants.whereType<XmlElement>().where(
          (e) => e.name.local == 'content' || e.name.local == 'thumbnail'
        );
        
        // 2. Try to find content:encoded for embedded images
        final contentEncoded = item.descendants.whereType<XmlElement>().where((e) => e.name.local == 'encoded');
        String fullContent = description;
        if (contentEncoded.isNotEmpty) {
          fullContent = contentEncoded.first.innerText;
        }

        if (mediaElements.isNotEmpty) {
           final firstMedia = mediaElements.firstWhere(
             (e) => e.getAttribute('url') != null, 
             orElse: () => mediaElements.first
           );
           imageUrl = firstMedia.getAttribute('url') ?? imageUrl;
        } else {
          // 3. Try to find an <img> tag in the description/content
          final imgRegex = RegExp(r'<img[^>]+src="([^">]+)"');
          final match = imgRegex.firstMatch(fullContent);
          if (match != null) {
            imageUrl = match.group(1)!;
          }
        }

        discoveries.add(Discovery(
          id: link,
          title: title,
          location: "Recent Research",
          dateFound: "Live Feed",
          connectedVerse: "Scripture Insight",
          description: _stripHtml(description),
          imageUrl: imageUrl,
          articleUrl: link,
        ));
      } catch (e) {
        print('Error parsing discovery item: $e');
        continue;
      }
    }

    return discoveries;
  }

  String _stripHtml(String html) {
    // Simple regex to remove HTML tags for preview
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
