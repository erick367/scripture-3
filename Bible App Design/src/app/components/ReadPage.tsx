import { useState, useEffect, useRef } from "react";
import { ChevronLeft, Bookmark, MoreVertical, Type, Menu, ChevronRight, Volume2, Share2, MessageCircle, Eye, EyeOff, StickyNote, X } from "lucide-react";
import { motion, AnimatePresence, useScroll, useTransform } from "motion/react";

interface ReadPageProps {
  timeOfDay: "morning" | "day" | "evening" | "night";
  readingContext?: {
    book: string;
    chapter: string;
    planTitle?: string;
  } | null;
}

type TypographyPreset = "classic" | "modern" | "elegant";

export function ReadPage({ timeOfDay, readingContext }: ReadPageProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [fontSize, setFontSize] = useState(18);
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [showControls, setShowControls] = useState(true);
  const [selectedVerse, setSelectedVerse] = useState<number | null>(null);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [immersiveMode, setImmersiveMode] = useState(false);
  const [scrollProgress, setScrollProgress] = useState(0);
  const [typographyPreset, setTypographyPreset] = useState<TypographyPreset>("classic");
  const [noteModalOpen, setNoteModalOpen] = useState(false);
  const [activeNoteVerse, setActiveNoteVerse] = useState<number | null>(null);
  const [verseNotes, setVerseNotes] = useState<Record<number, string>>({});
  const [currentNoteText, setCurrentNoteText] = useState("");
  
  const contentRef = useRef<HTMLDivElement>(null);
  const verseRefs = useRef<(HTMLDivElement | null)[]>([]);

  // Typography preset configurations
  const typographyPresets = {
    classic: {
      name: "Classic",
      scriptureFont: "'Crimson Text', serif",
      uiFont: "'Inter', sans-serif",
      description: "Traditional serif for timeless reading"
    },
    modern: {
      name: "Modern",
      scriptureFont: "'Inter', sans-serif",
      uiFont: "'Inter', sans-serif",
      description: "Clean sans-serif for contemporary feel"
    },
    elegant: {
      name: "Elegant",
      scriptureFont: "'EB Garamond', serif",
      uiFont: "'Inter', sans-serif",
      description: "Refined serif for sophisticated style"
    }
  };

  const openNoteModal = (verseNumber: number) => {
    setActiveNoteVerse(verseNumber);
    setCurrentNoteText(verseNotes[verseNumber] || "");
    setNoteModalOpen(true);
  };

  const saveNote = () => {
    if (activeNoteVerse !== null) {
      setVerseNotes({
        ...verseNotes,
        [activeNoteVerse]: currentNoteText
      });
    }
    setNoteModalOpen(false);
    setActiveNoteVerse(null);
    setCurrentNoteText("");
  };

  const deleteNote = () => {
    if (activeNoteVerse !== null) {
      const newNotes = { ...verseNotes };
      delete newNotes[activeNoteVerse];
      setVerseNotes(newNotes);
    }
    setNoteModalOpen(false);
    setActiveNoteVerse(null);
    setCurrentNoteText("");
  };

  // Track scroll progress
  useEffect(() => {
    const handleScroll = () => {
      const windowHeight = window.innerHeight;
      const documentHeight = document.documentElement.scrollHeight;
      const scrollTop = window.scrollY;
      const maxScroll = documentHeight - windowHeight;
      const progress = (scrollTop / maxScroll) * 100;
      setScrollProgress(Math.min(progress, 100));
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  // Observe verses as they enter viewport
  useEffect(() => {
    const observers: IntersectionObserver[] = [];
    
    verseRefs.current.forEach((verseElement) => {
      if (verseElement) {
        const observer = new IntersectionObserver(
          (entries) => {
            entries.forEach((entry) => {
              if (entry.isIntersecting) {
                entry.target.classList.add('verse-in-view');
              }
            });
          },
          { threshold: 0.3, rootMargin: '-10% 0px -10% 0px' }
        );
        
        observer.observe(verseElement);
        observers.push(observer);
      }
    });

    return () => {
      observers.forEach(observer => observer.disconnect());
    };
  }, []);
  
  const psalm23 = {
    book: "Psalms",
    chapter: 23,
    totalChapters: 150,
    reference: "PSALM 23",
    title: ["A", "PSALM", "OF", "DAVID"],
    subtitle: "The LORD is my shepherd",
    firstVerse: "The LORD is my shepherd; I shall not want.",
    verses: [
      { number: 1, text: "He makes me to lie down in green pastures; He leads me beside the still waters." },
      { number: 2, text: "He restores my soul; He leads me in the paths of righteousness for His name's sake." },
      { number: 3, text: "Yea, though I walk through the valley of the shadow of death, I will fear no evil; for You are with me; Your rod and Your staff, they comfort me." },
      { number: 4, text: "You prepare a table before me in the presence of my enemies; You anoint my head with oil; my cup runs over." },
      { number: 5, text: "Surely goodness and mercy shall follow me all the days of my life; and I will dwell in the house of the LORD forever." }
    ]
  };

  return (
    <div 
      className={`min-h-screen pb-32 transition-colors duration-700 ${
        isDark 
          ? "bg-gradient-to-br from-[#1A1410] via-[#0F0A08] to-[#0A0605]" 
          : "bg-gradient-to-br from-[#FFF8F0] via-[#FFF4E8] to-[#FFE8D6]"
      }`}
      onClick={() => setShowControls(!showControls)}
    >
      {/* Reading Progress Bar */}
      <motion.div
        className="fixed top-0 left-0 right-0 h-1 z-[60] pointer-events-none"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
      >
        <motion.div
          className="h-full bg-gradient-to-r from-orange-500 via-pink-500 to-purple-600 shadow-lg shadow-orange-500/50"
          style={{ width: `${scrollProgress}%` }}
          transition={{ duration: 0.1 }}
        />
      </motion.div>

      {/* Animated Gradient Mesh Background */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <motion.div
          animate={{
            x: [0, 100, 0],
            y: [0, -100, 0],
            scale: [1, 1.2, 1],
          }}
          transition={{
            duration: 20,
            repeat: Infinity,
            ease: "linear"
          }}
          className={`absolute -top-1/2 -left-1/4 w-[800px] h-[800px] rounded-full blur-3xl ${
            isDark 
              ? "bg-gradient-to-br from-orange-500/20 via-pink-500/20 to-purple-500/20" 
              : "bg-gradient-to-br from-orange-300/30 via-pink-300/30 to-purple-300/30"
          }`}
        />
        <motion.div
          animate={{
            x: [0, -120, 0],
            y: [0, 120, 0],
            scale: [1, 1.3, 1],
          }}
          transition={{
            duration: 25,
            repeat: Infinity,
            ease: "linear"
          }}
          className={`absolute -bottom-1/2 -right-1/4 w-[700px] h-[700px] rounded-full blur-3xl ${
            isDark 
              ? "bg-gradient-to-br from-blue-500/20 via-cyan-500/20 to-teal-500/20" 
              : "bg-gradient-to-br from-blue-300/30 via-cyan-300/30 to-teal-300/30"
          }`}
        />
      </div>

      {/* Premium Floating Header */}
      <AnimatePresence>
        {showControls && (
          <motion.div
            initial={{ y: -20, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            exit={{ y: -20, opacity: 0 }}
            transition={{ type: "spring", stiffness: 300, damping: 30 }}
            className="fixed top-6 left-1/2 -translate-x-1/2 z-50 w-full max-w-4xl px-6"
            onClick={(e) => e.stopPropagation()}
          >
            <motion.div
              className={`rounded-full ${
                isDark
                  ? "bg-white/10 border border-white/20"
                  : "bg-white border border-gray-200 shadow-xl"
              } backdrop-blur-2xl px-6 py-3 flex items-center justify-between`}
            >
              {/* Left: Back */}
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className={`w-10 h-10 rounded-full ${
                  isDark ? "hover:bg-white/10" : "hover:bg-gray-100"
                } flex items-center justify-center transition-colors`}
              >
                <ChevronLeft className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
              </motion.button>

              {/* Center: Book Info */}
              <div className="text-center">
                <h3 className={`text-sm font-semibold ${isDark ? "text-white" : "text-gray-900"}`}>
                  {readingContext?.book || psalm23.book}
                </h3>
                <p className={`text-xs ${isDark ? "text-white/60" : "text-gray-500"}`}>
                  {readingContext ? (
                    <>Chapter {readingContext.chapter}</>
                  ) : (
                    <>Chapter {psalm23.chapter} of {psalm23.totalChapters}</>
                  )}
                </p>
                {readingContext?.planTitle && (
                  <p className={`text-[10px] mt-0.5 ${isDark ? "text-orange-400" : "text-orange-600"}`}>
                    From: {readingContext.planTitle}
                  </p>
                )}
              </div>

              {/* Right: Actions */}
              <div className="flex items-center gap-1">
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={(e) => {
                    e.stopPropagation();
                    setIsBookmarked(!isBookmarked);
                  }}
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${
                    isBookmarked
                      ? isDark
                        ? "bg-gradient-to-br from-orange-500/20 to-pink-500/20 border border-orange-400/20"
                        : "bg-gradient-to-br from-orange-50 to-pink-50 border border-orange-200"
                      : isDark 
                      ? "hover:bg-white/10" 
                      : "hover:bg-gray-100"
                  }`}
                >
                  <Bookmark 
                    className={`w-4.5 h-4.5 ${
                      isBookmarked 
                        ? "text-orange-500 fill-orange-500" 
                        : isDark ? "text-white" : "text-gray-900"
                    }`} 
                  />
                </motion.button>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${
                    isDark ? "hover:bg-white/10" : "hover:bg-gray-100"
                  }`}
                >
                  <MoreVertical className={`w-4.5 h-4.5 ${isDark ? "text-white" : "text-gray-900"}`} />
                </motion.button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Main Content */}
      <div className="relative z-10">
        {/* Hero Section - Clean Glassmorphic Card */}
        <div className="mx-auto max-w-4xl px-6 pt-28 pb-12">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, type: "spring", stiffness: 150 }}
            className="relative group"
          >
            {/* Glassmorphic Card */}
            <div className="relative rounded-[32px] overflow-hidden shadow-2xl shadow-black/5">
              {/* Glass Background with Blur */}
              <div className={`absolute inset-0 ${
                isDark 
                  ? "bg-white/10" 
                  : "bg-white/80"
              } backdrop-blur-xl`} />
              
              {/* Subtle border */}
              <div className={`absolute inset-0 rounded-[32px] ring-1 ring-inset ${
                isDark ? "ring-white/20" : "ring-gray-200"
              }`} />

              {/* Content */}
              <div className="relative z-10 px-8 md:px-16 py-20">
                {/* Top: Small Reference */}
                <motion.p
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.2 }}
                  className={`text-center text-[11px] font-bold tracking-[0.25em] uppercase mb-16 ${
                    isDark ? "text-white/30" : "text-gray-400"
                  }`}
                >
                  {psalm23.reference}
                </motion.p>

                {/* Center: Title */}
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.3, duration: 0.8 }}
                  className="text-center mb-20"
                >
                  <h1
                    className={isDark ? "text-white" : "text-gray-900"}
                    style={{
                      fontFamily: "'Crimson Text', serif",
                      fontSize: "clamp(2.5rem, 8vw, 5rem)",
                      fontWeight: 400,
                      lineHeight: 1.15,
                      letterSpacing: "0.05em"
                    }}
                  >
                    A Psalm of David
                  </h1>
                </motion.div>

                {/* Decorative Divider */}
                <motion.div
                  initial={{ scaleX: 0 }}
                  animate={{ scaleX: 1 }}
                  transition={{ delay: 0.6, duration: 0.8 }}
                  className={`w-16 h-[2px] mx-auto mb-12 bg-gradient-to-r from-transparent ${
                    isDark 
                      ? "via-[#C9A66B]" 
                      : "via-orange-400"
                  } to-transparent`}
                />

                {/* Bottom: First Verse */}
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  transition={{ delay: 0.7 }}
                  className="max-w-xl mx-auto"
                >
                  <p
                    className={`text-left leading-relaxed ${
                      isDark ? "text-[#C9A66B]" : "text-orange-700"
                    }`}
                    style={{
                      fontFamily: "'Crimson Text', serif",
                      fontSize: "clamp(1.1rem, 2vw, 1.35rem)",
                      letterSpacing: "0.01em",
                      lineHeight: 1.8
                    }}
                  >
                    {psalm23.firstVerse}
                  </p>
                </motion.div>
              </div>
            </div>
          </motion.div>
        </div>

        {/* Verses Section - Glassmorphic Cards */}
        <div className="mx-auto max-w-4xl px-6 space-y-4 mb-12">
          {psalm23.verses.map((verse, index) => {
            // Different subtle glow colors for each verse
            const glowColors = [
              "from-blue-500/10 via-cyan-500/5 to-transparent",      // Verse 1
              "from-purple-500/10 via-pink-500/5 to-transparent",    // Verse 2
              "from-orange-500/10 via-amber-500/5 to-transparent",   // Verse 3
              "from-teal-500/10 via-emerald-500/5 to-transparent",   // Verse 4
              "from-rose-500/10 via-pink-500/5 to-transparent"       // Verse 5
            ];
            
            return (
            <motion.div
              key={verse.number}
              ref={(el) => (verseRefs.current[index] = el)}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.9 + index * 0.1, type: "spring", stiffness: 200 }}
              onClick={(e) => {
                e.stopPropagation();
                setSelectedVerse(selectedVerse === verse.number ? null : verse.number);
              }}
              whileHover={{ scale: 1.01, y: -2 }}
              className={`verse-card group relative rounded-[32px] overflow-hidden cursor-pointer transition-all duration-500 ${
                isDark
                  ? "bg-white/5 border border-white/10 hover:bg-white/10"
                  : "bg-white/80 border border-white/60 hover:bg-white/95 shadow-lg hover:shadow-xl"
              } backdrop-blur-xl ${
                selectedVerse === verse.number 
                  ? "ring-2 ring-orange-500/50" 
                  : ""
              }`}
            >
              {/* Subtle colored glow - always visible */}
              <div className={`absolute inset-0 bg-gradient-to-br ${glowColors[index]} pointer-events-none opacity-60`} />
              
              {/* Shimmer on hover */}
              <motion.div
                className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent opacity-0 group-hover:opacity-100"
                animate={{ x: ["-100%", "200%"] }}
                transition={{ duration: 1.5, ease: "easeInOut" }}
              />

              {/* Ambient glow when selected */}
              {selectedVerse === verse.number && (
                <div className="absolute inset-0 bg-gradient-to-br from-orange-500/10 via-pink-500/5 to-purple-500/10 pointer-events-none" />
              )}

              <div className="relative z-10 px-6 py-5 flex items-start gap-5">
                {/* Verse Number */}
                <motion.div
                  whileHover={{ scale: 1.05 }}
                  className={`flex-shrink-0 w-12 h-12 rounded-[18px] flex items-center justify-center font-bold text-base shadow-lg transition-all ${
                    selectedVerse === verse.number
                      ? "bg-gradient-to-br from-orange-500 to-pink-600 text-white"
                      : isDark
                      ? "bg-gradient-to-br from-white/10 to-white/5 text-gray-400"
                      : "bg-gradient-to-br from-gray-100 to-gray-200 text-gray-700"
                  }`}
                >
                  {String(verse.number).padStart(2, '0')}
                </motion.div>

                {/* Verse Text */}
                <p
                  className={`flex-1 leading-relaxed pt-2 ${
                    isDark ? "text-gray-200" : "text-gray-900"
                  }`}
                  style={{
                    fontFamily: typographyPresets[typographyPreset].scriptureFont,
                    fontSize: `${fontSize}px`,
                    lineHeight: 1.75,
                    letterSpacing: "0.005em"
                  }}
                >
                  {verse.text}
                </p>

                {/* Action Buttons - Vertical Stack */}
                <div className="flex-shrink-0 flex flex-col items-center gap-2">
                  {/* Notes Button */}
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={(e) => {
                      e.stopPropagation();
                      openNoteModal(verse.number);
                    }}
                    className={`relative w-11 h-11 rounded-full flex items-center justify-center transition-all shadow-md ${
                      verseNotes[verse.number]
                        ? isDark
                          ? "bg-gradient-to-br from-purple-500/30 to-indigo-500/30 border-2 border-purple-400/40"
                          : "bg-gradient-to-br from-purple-100 to-indigo-100 border-2 border-purple-300"
                        : isDark
                        ? "bg-gradient-to-br from-purple-500/20 to-indigo-500/20 hover:from-purple-500/30 hover:to-indigo-500/30 border border-purple-400/20"
                        : "bg-gradient-to-br from-purple-50 to-indigo-50 hover:from-purple-100 hover:to-indigo-100 border border-purple-200"
                    }`}
                  >
                    <StickyNote className={`w-4.5 h-4.5 ${
                      verseNotes[verse.number]
                        ? isDark ? "text-purple-300" : "text-purple-600"
                        : isDark ? "text-purple-400" : "text-purple-600"
                    }`} />
                    {verseNotes[verse.number] && (
                      <motion.div
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        className="absolute -top-1 -right-1 w-3 h-3 rounded-full bg-gradient-to-br from-purple-500 to-indigo-600 border-2 border-white"
                      />
                    )}
                  </motion.button>

                  {/* Bookmark Button */}
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={(e) => e.stopPropagation()}
                    className={`w-11 h-11 rounded-full flex items-center justify-center transition-all shadow-md ${
                      isDark
                        ? "bg-gradient-to-br from-orange-500/20 to-pink-500/20 hover:from-orange-500/30 hover:to-pink-500/30 border border-orange-400/20"
                        : "bg-gradient-to-br from-orange-50 to-pink-50 hover:from-orange-100 hover:to-pink-100 border border-orange-200"
                    }`}
                  >
                    <Bookmark className={`w-4.5 h-4.5 ${isDark ? "text-orange-400" : "text-orange-600"}`} />
                  </motion.button>
                </div>
              </div>

              {/* Verse Actions - Expanded */}
              <AnimatePresence>
                {selectedVerse === verse.number && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    transition={{ type: "spring", stiffness: 300, damping: 30 }}
                    className={`border-t ${isDark ? "border-white/10" : "border-gray-200"} px-6 pb-5`}
                    onClick={(e) => e.stopPropagation()}
                  >
                    <div className="flex items-center gap-2 pt-4">
                      <motion.button
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        onClick={() => openNoteModal(verse.number)}
                        className="flex items-center gap-2 px-4 py-2.5 rounded-[18px] bg-gradient-to-r from-orange-500 to-pink-600 text-white text-sm font-bold shadow-lg"
                      >
                        <MessageCircle className="w-4 h-4" />
                        Note
                      </motion.button>
                      <motion.button
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        className={`flex items-center gap-2 px-4 py-2.5 rounded-[18px] text-sm font-bold border ${
                          isDark
                            ? "bg-white/5 border-white/10 text-white"
                            : "bg-gray-100 border-gray-200 text-gray-900"
                        }`}
                      >
                        <Share2 className="w-4 h-4" />
                        Share
                      </motion.button>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
            );
          })}
        </div>

        {/* Unified Chapter Navigation & Progress Card */}
        <div className="mx-auto max-w-4xl px-6 mb-8">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.5 }}
            className={`rounded-[32px] overflow-hidden shadow-xl ${
              isDark
                ? "bg-white/5 border border-white/10"
                : "bg-white/90 border border-white/60"
            } backdrop-blur-xl`}
          >
            {/* Navigation Section */}
            <div className="flex items-center p-4 gap-3">
              {/* Previous Button */}
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className={`flex-1 group rounded-[20px] p-4 transition-all ${
                  isDark
                    ? "bg-white/5 hover:bg-white/10"
                    : "bg-gray-50 hover:bg-gray-100"
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform">
                    <ChevronLeft className="w-5 h-5 text-white" />
                  </div>
                  <div className="text-left">
                    <p className={`text-[10px] font-bold uppercase tracking-wider ${
                      isDark ? "text-white/40" : "text-gray-400"
                    }`}>
                      Previous
                    </p>
                    <p className={`text-sm font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                      Psalm 22
                    </p>
                  </div>
                </div>
              </motion.button>

              {/* Next Button */}
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                className={`flex-1 group rounded-[20px] p-4 transition-all ${
                  isDark
                    ? "bg-white/5 hover:bg-white/10"
                    : "bg-gray-50 hover:bg-gray-100"
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className="text-right flex-1">
                    <p className={`text-[10px] font-bold uppercase tracking-wider ${
                      isDark ? "text-white/40" : "text-gray-400"
                    }`}>
                      Next
                    </p>
                    <p className={`text-sm font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                      Psalm 24
                    </p>
                  </div>
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center shadow-md group-hover:scale-110 transition-transform">
                    <ChevronRight className="w-5 h-5 text-white" />
                  </div>
                </div>
              </motion.button>
            </div>

            {/* Divider */}
            <div className={`h-px mx-4 ${isDark ? "bg-white/10" : "bg-gray-200"}`} />

            {/* Progress Section */}
            <div className="p-6">
              <div className="flex items-center justify-between mb-3">
                <p className={`text-xs font-bold uppercase tracking-wider ${
                  isDark ? "text-white/50" : "text-gray-500"
                }`}>
                  Your Progress
                </p>
                <p className={`text-xs font-bold ${
                  isDark ? "text-orange-400" : "text-orange-600"
                }`}>
                  23 of 150 Chapters
                </p>
              </div>

              {/* Progress Bar */}
              <div className={`relative h-2 rounded-full mb-5 ${
                isDark ? "bg-white/5" : "bg-gray-200"
              }`}>
                <motion.div
                  initial={{ width: 0 }}
                  animate={{ width: "15%" }}
                  transition={{ delay: 1.7, duration: 1, ease: "easeOut" }}
                  className="absolute inset-y-0 left-0 rounded-full bg-gradient-to-r from-orange-500 to-pink-600"
                />
              </div>

              {/* Stats Grid */}
              <div className="grid grid-cols-3 gap-4">
                <div className="text-center">
                  <p className={`text-2xl font-bold mb-1 ${
                    isDark ? "text-white" : "text-gray-900"
                  }`}>
                    23
                  </p>
                  <p className={`text-xs ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Chapters Read
                  </p>
                </div>
                <div className="text-center">
                  <p className={`text-2xl font-bold mb-1 ${
                    isDark ? "text-white" : "text-gray-900"
                  }`}>
                    7
                  </p>
                  <p className={`text-xs ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Day Streak
                  </p>
                </div>
                <div className="text-center">
                  <p className={`text-2xl font-bold mb-1 ${
                    isDark ? "text-white" : "text-gray-900"
                  }`}>
                    12
                  </p>
                  <p className={`text-xs ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Bookmarks
                  </p>
                </div>
              </div>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Right Drawer Trigger Button */}
      <AnimatePresence>
        {showControls && !drawerOpen && (
          <motion.button
            initial={{ x: 100, opacity: 0 }}
            animate={{ x: 0, opacity: 1 }}
            exit={{ x: 100, opacity: 0 }}
            transition={{ type: "spring", stiffness: 300, damping: 30 }}
            onClick={(e) => {
              e.stopPropagation();
              setDrawerOpen(true);
            }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className={`fixed right-0 top-1/2 -translate-y-1/2 z-40 w-10 h-24 rounded-l-[16px] flex items-center justify-center shadow-xl ${
              isDark
                ? "bg-gradient-to-br from-orange-500/10 to-pink-500/10 border-l border-t border-b border-orange-400/20"
                : "bg-gradient-to-br from-orange-50/80 to-pink-50/80 border-l border-t border-b border-orange-200/60"
            } backdrop-blur-xl`}
          >
            <Menu className={`w-4.5 h-4.5 ${isDark ? "text-orange-400" : "text-orange-600"}`} />
          </motion.button>
        )}
      </AnimatePresence>

      {/* Right Drawer */}
      <AnimatePresence>
        {drawerOpen && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setDrawerOpen(false)}
              className="fixed inset-0 bg-black/40 backdrop-blur-sm z-40"
            />
            
            {/* Drawer */}
            <motion.div
              initial={{ x: 240 }}
              animate={{ x: 0 }}
              exit={{ x: 240 }}
              transition={{ type: "spring", stiffness: 300, damping: 30 }}
              className={`fixed right-0 top-0 bottom-0 w-[220px] z-50 flex flex-col ${
                isDark
                  ? "bg-[#1A1A1A]/95 border-l border-white/10"
                  : "bg-white/95 border-l border-gray-200"
              } backdrop-blur-2xl shadow-2xl`}
              onClick={(e) => e.stopPropagation()}
            >
              {/* Close Button */}
              <div className="flex justify-end p-4">
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setDrawerOpen(false)}
                  className={`w-9 h-9 rounded-full flex items-center justify-center transition-colors ${
                    isDark ? "bg-white/10 hover:bg-white/15" : "bg-gray-100 hover:bg-gray-200"
                  }`}
                >
                  <ChevronRight className={`w-4.5 h-4.5 ${isDark ? "text-white" : "text-gray-900"}`} />
                </motion.button>
              </div>

              {/* Content */}
              <div className="flex-1 px-5 pb-8 space-y-8">
                {/* Font Controls Section */}
                <div>
                  <p className={`text-[10px] font-bold uppercase tracking-wider mb-4 ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Font Size
                  </p>
                  <div className="flex flex-col items-center gap-3">
                    {/* Increase Font */}
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setFontSize(Math.min(fontSize + 2, 32))}
                      className={`w-full h-14 rounded-[16px] flex items-center justify-center transition-all shadow-md ${
                        isDark
                          ? "bg-white/10 hover:bg-white/15 border border-white/10"
                          : "bg-gray-100 hover:bg-gray-200 border border-gray-200"
                      }`}
                    >
                      <span className={`text-xl font-bold ${isDark ? "text-white" : "text-gray-900"}`}>A</span>
                    </motion.button>

                    {/* Font Size Display */}
                    <div className="text-lg font-bold px-5 py-2.5 rounded-[14px] bg-gradient-to-br from-orange-500 to-pink-600 text-white shadow-md">
                      {fontSize}
                    </div>

                    {/* Decrease Font */}
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setFontSize(Math.max(fontSize - 2, 14))}
                      className={`w-full h-14 rounded-[16px] flex items-center justify-center transition-all shadow-md ${
                        isDark
                          ? "bg-white/10 hover:bg-white/15 border border-white/10"
                          : "bg-gray-100 hover:bg-gray-200 border border-gray-200"
                      }`}
                    >
                      <span className={`text-sm font-bold ${isDark ? "text-white" : "text-gray-900"}`}>A</span>
                    </motion.button>
                  </div>
                </div>

                {/* Divider */}
                <div className={`h-px ${isDark ? "bg-white/10" : "bg-gray-200"}`} />

                {/* Typography Preset Selector */}
                <div>
                  <p className={`text-[10px] font-bold uppercase tracking-wider mb-3 ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Typography
                  </p>
                  <div className="space-y-2">
                    {Object.keys(typographyPresets).map((preset) => (
                      <motion.button
                        key={preset}
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => setTypographyPreset(preset as TypographyPreset)}
                        className={`w-full py-3 px-3 rounded-[14px] flex items-center gap-2.5 transition-all ${
                          typographyPreset === preset
                            ? "bg-gradient-to-br from-orange-500 to-pink-600 text-white shadow-lg"
                            : isDark
                            ? "bg-white/10 hover:bg-white/15 text-white"
                            : "bg-gray-100 hover:bg-gray-200 text-gray-900"
                        }`}
                      >
                        <Type className="w-4.5 h-4.5" />
                        <span className="text-xs font-semibold">{typographyPresets[preset as TypographyPreset].name}</span>
                      </motion.button>
                    ))}
                  </div>
                </div>

                {/* Divider */}
                <div className={`h-px ${isDark ? "bg-white/10" : "bg-gray-200"}`} />

                {/* Immersive Mode Toggle */}
                <div>
                  <p className={`text-[10px] font-bold uppercase tracking-wider mb-3 ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Reading Mode
                  </p>
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={(e) => {
                      e.stopPropagation();
                      setImmersiveMode(!immersiveMode);
                      if (!immersiveMode) {
                        setShowControls(false);
                        setDrawerOpen(false);
                      }
                    }}
                    className={`w-full py-3 px-3 rounded-[14px] flex items-center gap-2.5 transition-all ${
                      immersiveMode
                        ? "bg-gradient-to-br from-orange-500 to-pink-600 text-white shadow-lg"
                        : isDark
                        ? "bg-white/10 hover:bg-white/15 text-white"
                        : "bg-gray-100 hover:bg-gray-200 text-gray-900"
                    }`}
                  >
                    {immersiveMode ? (
                      <EyeOff className="w-4.5 h-4.5" />
                    ) : (
                      <Eye className="w-4.5 h-4.5" />
                    )}
                    <span className="text-xs font-semibold">
                      {immersiveMode ? "Exit Immersive" : "Immersive Mode"}
                    </span>
                  </motion.button>
                </div>

                {/* Divider */}
                <div className={`h-px ${isDark ? "bg-white/10" : "bg-gray-200"}`} />

                {/* Quick Actions */}
                <div>
                  <p className={`text-[10px] font-bold uppercase tracking-wider mb-3 ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Quick Actions
                  </p>
                  <div className="space-y-2">
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      className={`w-full py-3 px-3 rounded-[14px] flex items-center gap-2.5 transition-all ${
                        isDark
                          ? "bg-white/10 hover:bg-white/15 text-white"
                          : "bg-gray-100 hover:bg-gray-200 text-gray-900"
                      }`}
                    >
                      <Bookmark className="w-4.5 h-4.5" />
                      <span className="text-xs font-semibold">Bookmarks</span>
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      className={`w-full py-3 px-3 rounded-[14px] flex items-center gap-2.5 transition-all ${
                        isDark
                          ? "bg-white/10 hover:bg-white/15 text-white"
                          : "bg-gray-100 hover:bg-gray-200 text-gray-900"
                      }`}
                    >
                      <Menu className="w-4.5 h-4.5" />
                      <span className="text-xs font-semibold">Chapters</span>
                    </motion.button>
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* Note Modal */}
      <AnimatePresence>
        {noteModalOpen && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setNoteModalOpen(false)}
              className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50"
            />
            
            {/* Modal */}
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              transition={{ type: "spring", stiffness: 300, damping: 30 }}
              className={`fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full max-w-md z-[60] rounded-[32px] ${
                isDark
                  ? "bg-[#1A1A1A]/95 border border-white/10"
                  : "bg-white/95 border border-gray-200"
              } backdrop-blur-2xl shadow-2xl`}
              onClick={(e) => e.stopPropagation()}
            >
              {/* Header */}
              <div className={`flex items-center justify-between p-6 border-b ${isDark ? 'border-white/10' : 'border-gray-200'}`}>
                <div>
                  <h3 className={`text-lg font-bold ${isDark ? 'text-white' : 'text-gray-900'}`}>
                    Verse Note
                  </h3>
                  <p className={`text-xs ${isDark ? 'text-white/50' : 'text-gray-500'}`}>
                    Verse {activeNoteVerse}
                  </p>
                </div>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setNoteModalOpen(false)}
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-colors ${
                    isDark ? "bg-white/10 hover:bg-white/15" : "bg-gray-100 hover:bg-gray-200"
                  }`}
                >
                  <X className={`w-4.5 h-4.5 ${isDark ? "text-white" : "text-gray-900"}`} />
                </motion.button>
              </div>

              {/* Content */}
              <div className="p-6 space-y-4">
                {/* Note Textarea */}
                <textarea
                  value={currentNoteText}
                  onChange={(e) => setCurrentNoteText(e.target.value)}
                  placeholder="Write your thoughts, reflections, or insights..."
                  className={`w-full h-48 rounded-[20px] px-4 py-3 text-sm resize-none focus:outline-none focus:ring-2 focus:ring-orange-500/50 transition-all ${
                    isDark 
                      ? "bg-white/10 text-white placeholder:text-white/40 border border-white/10" 
                      : "bg-gray-50 text-gray-900 placeholder:text-gray-400 border border-gray-200"
                  }`}
                  style={{ fontFamily: "'Inter', sans-serif" }}
                />

                {/* Action Buttons */}
                <div className="flex items-center gap-3">
                  {verseNotes[activeNoteVerse!] && (
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={deleteNote}
                      className={`flex-1 py-3 px-4 rounded-[18px] flex items-center justify-center gap-2 transition-all ${
                        isDark
                          ? "bg-red-500/20 hover:bg-red-500/30 text-red-400 border border-red-500/30"
                          : "bg-red-50 hover:bg-red-100 text-red-600 border border-red-200"
                      }`}
                    >
                      <X className="w-4 h-4" />
                      <span className="text-sm font-semibold">Delete</span>
                    </motion.button>
                  )}
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={saveNote}
                    className={`flex-1 py-3 px-4 rounded-[18px] flex items-center justify-center gap-2 transition-all bg-gradient-to-br from-orange-500 to-pink-600 text-white shadow-lg hover:shadow-xl`}
                  >
                    <StickyNote className="w-4 h-4" />
                    <span className="text-sm font-semibold">Save Note</span>
                  </motion.button>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}