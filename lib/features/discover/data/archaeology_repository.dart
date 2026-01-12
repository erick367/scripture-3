import 'package:flutter_riverpod/flutter_riverpod.dart';

class Discovery {
  final String id;
  final String title;
  final String location;
  final String dateFound;
  final String connectedVerse;
  final String description;
  final String imageUrl;
  final String? articleUrl; // Link to full article
  final String? whyItMatters; // Theological significance

  const Discovery({
    required this.id,
    required this.title,
    required this.location,
    required this.dateFound,
    required this.connectedVerse,
    required this.description,
    required this.imageUrl,
    this.articleUrl,
    this.whyItMatters,
  });
}

final archaeologyRepositoryProvider = Provider<ArchaeologyRepository>((ref) {
  return ArchaeologyRepository();
});

class ArchaeologyRepository {
  List<Discovery> getDiscoveries() {
    return const [
      Discovery(
        id: "d1",
        title: "Dead Sea Scrolls",
        location: "Qumran Caves",
        dateFound: "1947",
        connectedVerse: "Isaiah 40:8",
        description: "Ancient manuscripts confirming the accuracy of the Hebrew Bible over a millennium.",
        imageUrl: "assets/discoveries/scrolls.jpg",
        whyItMatters: "Before 1947, skeptics claimed the Bible was corrupted through centuries of copying. The Dead Sea Scrolls (1,000 years older than any previous manuscript) proved the Hebrew Bible was preserved with stunning accuracy—99.5% identical to modern texts. This demolishes the 'telephone game' critique of Scripture.",
      ),
      Discovery(
        id: "d2",
        title: "Tel Dan Stele",
        location: "Northern Israel",
        dateFound: "1993",
        connectedVerse: "2 Samuel 7:12",
        description: "The first extra-biblical reference to the 'House of David', confirming King David's historicity.",
        imageUrl: "assets/discoveries/tel_dan.jpg",
        whyItMatters: "Critics once dismissed David as mythical folklore—a King Arthur figure. This 9th-century BC inscription by an Aramean king mentions defeating the \"King of the House of David.\" It's external, hostile testimony to David's dynasty, silencing the myth theory.",
      ),
      Discovery(
        id: "d3",
        title: "Pool of Siloam",
        location: "Jerusalem",
        dateFound: "2004",
        connectedVerse: "John 9:7",
        description: "The actual site where Jesus healed the blind man, discovered during sewage works.",
        imageUrl: "assets/discoveries/siloam.jpg",
        whyItMatters: "John's Gospel records granular details: \"Go, wash in the Pool of Siloam (which means Sent).\" For 1,900 years, the exact pool was lost. Its rediscovery—with steps matching the Gospel description—shows John was writing eyewitness history, not religious fiction.",
      ),
      Discovery(
        id: "d4",
        title: "Pilate Stone",
        location: "Caesarea Maritima",
        dateFound: "1961",
        connectedVerse: "Matthew 27:2",
        description: "Limestone block inscribed with the name of Pontius Pilate, Prefect of Judea.",
        imageUrl: "assets/discoveries/pilate.jpg",
        whyItMatters: "Before this, Pilate appeared only in the Gospels and Josephus—some called him a Christian invention. This dedication stone proves he was the Roman prefect of Judea, exactly as the New Testament describes. The Crucifixion has a historical anchor.",
      ),
      Discovery(
        id: "d5",
        title: "Cyrus Cylinder",
        location: "Babylon",
        dateFound: "1879",
        connectedVerse: "Ezra 1:1-3",
        description: "Persian artifact corroborating the biblical account of Cyrus allowing exiles to return.",
        imageUrl: "assets/discoveries/cyrus.jpg",
        whyItMatters: "Isaiah 44:28 names Cyrus 150 years before his birth, promising he'd let exiles rebuild Jerusalem. Skeptics called this impossible—clearly written after the fact. Yet the Cyrus Cylinder (539 BC) confirms this policy was real. The prophecy remains stunning.",
      ),
    ];
  }
}
