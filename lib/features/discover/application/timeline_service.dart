import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiblicalEra {
  final String title;
  final String dateRange;
  final String description;
  final List<String> relevantBooks;
  final String whyItsHard;
  final List<String> readingKeys;
  final List<String> worldEvents;
  final String firstBook; // For "Read This Era" navigation

  const BiblicalEra({
    required this.title,
    required this.dateRange,
    required this.description,
    required this.relevantBooks,
    required this.whyItsHard,
    required this.readingKeys,
    required this.worldEvents,
    required this.firstBook,
  });
}

final timelineServiceProvider = Provider<TimelineService>((ref) {
  return TimelineService();
});

class TimelineService {
  List<BiblicalEra> getEras() {
    return const [
      BiblicalEra(
        title: "Creation & Fall",
        dateRange: "Undated - 2166 BC",
        description: "The origins of humanity, the entrance of sin, and the first covenant with Noah.",
        relevantBooks: ["Genesis 1-11"],
        whyItsHard: "Science vs. faith debates cloud the narrative. Ancient genealogies and lifespans (969 years?) feel mythical, not historical.",
        readingKeys: [
          "Genesis 1-2 is theology, not biology (who created, not how)",
          "The Fall explains why the world is broken, not 'where did sin come from?'",
          "Noah's flood prefigures baptism (1 Pet 3:20-21)—salvation through judgment"
        ],
        worldEvents: [
          "Sumerian civilization begins (3500 BC)",
          "Egyptian pyramids built (2500 BC)",
          "First written law codes appear in Mesopotamia"
        ],
        firstBook: "Genesis",
      ),
      BiblicalEra(
        title: "The Patriarchs",
        dateRange: "2166 - 1876 BC",
        description: "God chooses Abraham to found a nation through which the world will be blessed.",
        relevantBooks: ["Genesis 12-50", "Job"],
        whyItsHard: "Ancient Middle Eastern culture feels alien. Polygamy, tribal conflicts, and God's seeming silence during suffering can confuse modern readers.",
        readingKeys: [
          "Focus on God's promises (Gen 12:1-3), not cultural norms",
          "Notice the pattern: faith tested → failure → God still faithful",
          "Read as family drama, not moral instruction manual"
        ],
        worldEvents: [
          "Hammurabi's Code established in Babylon (1750 BC)",
          "Hyksos foreign rulers take over Egypt (1650 BC)",
          "Minoan civilization flourishes on Crete"
        ],
        firstBook: "Genesis",
      ),
      BiblicalEra(
        title: "Exodus & Wilderness",
        dateRange: "1446 - 1406 BC",
        description: "Deliverance from Egypt, the giving of the Law, and 40 years of wandering.",
        relevantBooks: ["Exodus", "Leviticus", "Numbers", "Deuteronomy"],
        whyItsHard: "613 laws about sacrifices, skin diseases, and fabric blends seem irrelevant. Why does God care about these details?",
        readingKeys: [
          "Laws are a 'visual gospel'—pointing to holiness and atonement",
          "Skip ritual details first; read Exodus 19-20, Deut 6-8 for the 'why'",
          "Think: 'What does this reveal about God's character?'"
        ],
        worldEvents: [
          "Egyptian New Kingdom at its peak (1550-1070 BC)",
          "Hittite Empire dominates Anatolia (modern Turkey)",
          "Bronze Age trade networks span Mediterranean"
        ],
        firstBook: "Exodus",
      ),
      BiblicalEra(
        title: "Conquest & Judges",
        dateRange: "1406 - 1050 BC",
        description: "Israel settles the Promised Land but descends into cycles of idolatry and rescue.",
        relevantBooks: ["Joshua", "Judges", "Ruth"],
        whyItsHard: "Violence (Jericho genocide), moral chaos (Judges 19-21), and God's command to 'kill everything' disturb modern sensibilities.",
        readingKeys: [
          "This is war against spiritual darkness, not ethnic cleansing",
          "Judges shows the cost of forgetting God (downward spiral)",
          "Ruth is the redemptive thread—grace in the midst of chaos"
        ],
        worldEvents: [
          "Trojan War (traditional date 1184 BC)",
          "Sea Peoples invade Mediterranean civilizations",
          "Mycenaean Greece collapses into Dark Ages"
        ],
        firstBook: "Joshua",
      ),
      BiblicalEra(
        title: "United Kingdom",
        dateRange: "1050 - 931 BC",
        description: "The golden age of Israel under Kings Saul, David, and Solomon.",
        relevantBooks: ["1-2 Samuel", "1 Kings 1-11", "Psalms", "Proverbs", "Ecclesiastes"],
        whyItsHard: "David (adulterer/murderer) is 'a man after God's heart.' Solomon (wisest man) becomes an idolater. The contradictions are jarring.",
        readingKeys: [
          "No human king is perfect—this points to the need for Jesus",
          "Psalms = David's honest prayers (model transparency with God)",
          "Watch the theme: 'Obey and flourish' vs. 'Disobey and fracture'"
        ],
        worldEvents: [
          "Phoenicians establish trade colonies across Mediterranean",
          "Zhou Dynasty begins in China (1046 BC)",
          "Homer writes the Iliad and Odyssey (800s BC)"
        ],
        firstBook: "1 Samuel",
      ),
      BiblicalEra(
        title: "Divided Kingdom",
        dateRange: "931 - 586 BC",
        description: "The nation splits into Israel (North) and Judah (South); prophets warn of exile.",
        relevantBooks: ["1-2 Kings", "Isaiah", "Jeremiah", "Hosea", "Amos"],
        whyItsHard: "19 kings of Israel, 20 of Judah—tracking alliances and betrayals is exhausting. Prophets feel repetitive and doom-filled.",
        readingKeys: [
          "Skip the king lists; focus on prophet speeches (Isa 40-55, Jer 31)",
          "Prophets are 'covenant lawyers'—indicting Israel for breaking vows",
          "Look for Messianic promises amid judgment (Isa 9:6, Jer 31:31)"
        ],
        worldEvents: [
          "Assyrian Empire conquers Northern Israel (722 BC)",
          "Rome founded (traditional date 753 BC)",
          "Greek city-states emerge (Athens, Sparta)"
        ],
        firstBook: "1 Kings",
      ),
      BiblicalEra(
        title: "Exile & Return",
        dateRange: "586 - 400 BC",
        description: "Babylonian captivity followed by the rebuilding of the Temple and walls.",
        relevantBooks: ["Ezekiel", "Daniel", "Ezra", "Nehemiah", "Esther"],
        whyItsHard: "Everything promised (land, temple, king) is gone. Ezekiel's visions are bizarre. How is this 'good news'?",
        readingKeys: [
          "Exile is discipline, not abandonment (Lam 3:22-23)",
          "Daniel shows how to live faithfully in a hostile empire",
          "Ezekiel's visions = God's glory leaving (ch 10) then returning (ch 43)"
        ],
        worldEvents: [
          "Babylon defeats Assyria, conquers Judah (586 BC)",
          "Persian Empire defeats Babylon (539 BC)",
          "Greek philosophy begins: Socrates, Plato, Aristotle"
        ],
        firstBook: "Ezekiel",
      ),
      BiblicalEra(
        title: "Life of Christ",
        dateRange: "6 BC - 33 AD",
        description: "The incarnation, ministry, death, and resurrection of Jesus the Messiah.",
        relevantBooks: ["Matthew", "Mark", "Luke", "John"],
        whyItsHard: "Four gospels repeat stories but contradict details (How many angels at the tomb? 1 or 2?). Jewish context (Pharisees, Sabbath laws) needs background.",
        readingKeys: [
          "Each gospel has a theme: Matthew=King, Mark=Servant, Luke=Human, John=God",
          "'Contradictions' are complementary perspectives, like witnesses at a trial",
          "Study parables for the kingdom, not just miracles for spectacle"
        ],
        worldEvents: [
          "Roman Empire at peak power under Augustus",
          "Herod the Great's massive building projects in Judea",
          "Pax Romana enables safe travel for gospel spread"
        ],
        firstBook: "Matthew",
      ),
      BiblicalEra(
        title: "Early Church",
        dateRange: "33 - 100 AD",
        description: "The Holy Spirit empowers the apostles to spread the Gospel to the nations.",
        relevantBooks: ["Acts", "Romans", "Epistles", "Revelation"],
        whyItsHard: "Paul's theology is dense (Romans 9-11). Church conflicts seem petty. Why so many letters about the same issues?",
        readingKeys: [
          "Start with Acts (the story) before Letters (the theology)",
          "Paul's re-explaining the gospel because early Christians were confused too",
          "Focus on core themes: grace, unity, mission—ignore rabbit holes"
        ],
        worldEvents: [
          "Roman persecution of Christians begins under Nero (64 AD)",
          "Jewish Revolt and destruction of Jerusalem Temple (70 AD)",
          "Gospel spreads to Asia Minor, Greece, Rome, Egypt, Africa"
        ],
        firstBook: "Acts",
      ),
    ];
  }
}
