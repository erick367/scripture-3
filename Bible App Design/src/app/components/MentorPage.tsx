import { motion, AnimatePresence } from "motion/react";
import { Plus, Calendar, Tag, Heart, Sparkles, BookOpen, Lock, Mic, Image, Smile, TrendingUp, MessageCircle, Search, Filter, MoreVertical, Edit3, Pen, ChevronRight, Bot, Send, X, Book, Lightbulb, Target, Zap, Clock, Award, ChevronDown, Share2, Trash2, Copy, CheckCircle2, Brain, Flame, Star } from "lucide-react";
import { useState, useRef, useEffect } from "react";

interface MentorPageProps {
  timeOfDay: "morning" | "day" | "evening" | "night";
  onNavigateToRead?: (book: string, chapter: string) => void;
}

export function MentorPage({ timeOfDay, onNavigateToRead }: MentorPageProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [activeTab, setActiveTab] = useState<"journals" | "mentor">("journals");
  const [showNewEntry, setShowNewEntry] = useState(false);
  const [selectedEntry, setSelectedEntry] = useState<number | null>(null);
  const [showAIConsent, setShowAIConsent] = useState(false);
  const [aiEnabled, setAiEnabled] = useState(false);
  const [chatMessages, setChatMessages] = useState<Array<{role: "user" | "ai", content: string, time: string}>>([]);
  const [chatInput, setChatInput] = useState("");
  const [isTyping, setIsTyping] = useState(false);
  const chatEndRef = useRef<HTMLDivElement>(null);
  const [selectedJournalContext, setSelectedJournalContext] = useState<string | null>(null);
  const [showFilterMenu, setShowFilterMenu] = useState(false);
  const [selectedFilter, setSelectedFilter] = useState<"all" | "this-week" | "this-month" | "plans" | "scriptures">("all");
  const [editMode, setEditMode] = useState(false);
  const [followUpMode, setFollowUpMode] = useState(false);
  const [editTitle, setEditTitle] = useState("");
  const [editContent, setEditContent] = useState("");
  const [editTags, setEditTags] = useState<string[]>([]);
  const [newTag, setNewTag] = useState("");
  const [selectedMood, setSelectedMood] = useState<string>("peaceful");
  const [showFab, setShowFab] = useState(true);
  const [lastScrollY, setLastScrollY] = useState(0);
  const [isPrivate, setIsPrivate] = useState(false);
  const [hasAIInsights, setHasAIInsights] = useState(true);
  const [journalEntries, setJournalEntries] = useState([
    {
      id: 1,
      date: "Today, 9:42 AM",
      title: "Morning Reflections on Grace",
      content: "Lord, today I'm overwhelmed by Your grace. As I read Ephesians 2:8-9, I'm reminded that salvation is Your gift, not something I can earn. Help me extend this same grace to others, especially when it's difficult. Let me be a vessel of Your unconditional love...",
      tags: ["Grace", "Gratitude", "Prayer"],
      verse: "Ephesians 2:8-9",
      book: "Ephesians",
      chapter: "2",
      context: "30 Days of Prayer - Day 17",
      contextType: "plan" as const,
      mood: "peaceful",
      isPrivate: false,
      aiInsights: true,
      gradient: "from-emerald-500/20 via-green-600/15 to-teal-600/20",
      borderColor: "border-emerald-400/40",
      accentColor: "from-emerald-500 to-teal-600",
      followUps: [
        { date: "Today, 2:15 PM", content: "I had the opportunity to show grace today when my coworker made a mistake. Instead of getting frustrated, I remembered this morning's reflection and chose to respond with kindness. It felt so good to live out what I've been learning!", mood: "joyful" }
      ] as Array<{date: string, content: string, mood: string}>
    },
    {
      id: 2,
      date: "Yesterday, 8:15 PM",
      title: "Wrestling with Doubt",
      content: "Sometimes I struggle to trust Your plan. Today was hard. But I'm choosing to remember how You've been faithful before. Like Peter walking on water, help me keep my eyes on You when the storms of life threaten to overwhelm me. You are my anchor...",
      tags: ["Faith", "Trust", "Struggle"],
      verse: "Matthew 14:29-31",
      book: "Matthew",
      chapter: "14",
      context: "Matthew 14",
      contextType: "scripture" as const,
      mood: "contemplative",
      isPrivate: true,
      aiInsights: false,
      gradient: "from-violet-500/20 via-purple-600/15 to-fuchsia-600/20",
      borderColor: "border-violet-400/40",
      accentColor: "from-violet-500 to-fuchsia-600",
      followUps: [] as Array<{date: string, content: string, mood: string}>
    },
    {
      id: 3,
      date: "Jan 12, 2:30 PM",
      title: "Answered Prayer!",
      content: "You did it again! That situation I've been praying about for months - You came through in the most unexpected way. Just like You always do. Thank You for hearing me, for caring about the details of my life. Your timing is perfect, even when I can't see it...",
      tags: ["Answered Prayer", "Thanksgiving", "Testimony"],
      verse: "Philippians 4:6",
      book: "Philippians",
      chapter: "4",
      context: "Gospel of John - Day 21",
      contextType: "plan" as const,
      mood: "joyful",
      isPrivate: false,
      aiInsights: true,
      gradient: "from-amber-500/20 via-orange-600/15 to-red-600/20",
      borderColor: "border-amber-400/40",
      accentColor: "from-amber-500 to-red-600",
      followUps: [] as Array<{date: string, content: string, mood: string}>
    },
    {
      id: 4,
      date: "Jan 10, 7:20 AM",
      title: "Learning to Wait on God",
      content: "Patience has never been my strength, but You're teaching me through this season. Just like Abraham waited for Isaac, just like Hannah waited for Samuel - You work in Your perfect timing. Help me trust Your process and not rush ahead...",
      tags: ["Patience", "Trust", "Growth"],
      verse: "Isaiah 40:31",
      book: "Isaiah",
      chapter: "40",
      context: "30 Days of Prayer - Day 12",
      contextType: "plan" as const,
      mood: "hopeful",
      isPrivate: false,
      aiInsights: true,
      gradient: "from-blue-500/20 via-indigo-600/15 to-purple-600/20",
      borderColor: "border-blue-400/40",
      accentColor: "from-blue-500 to-purple-600",
      followUps: [] as Array<{date: string, content: string, mood: string}>
    }
  ]);

  const stats = [
    { label: "Total Entries", value: "127", icon: BookOpen, color: "from-orange-500 via-pink-600 to-red-600" },
    { label: "This Week", value: "7", icon: Calendar, color: "from-purple-500 via-pink-600 to-fuchsia-600" },
    { label: "Day Streak", value: "12", icon: Flame, color: "from-amber-500 via-orange-600 to-red-600" },
    { label: "AI Insights", value: "24", icon: Sparkles, color: "from-blue-500 via-purple-600 to-pink-600" }
  ];

  const aiSuggestions = [
    {
      icon: Lightbulb,
      title: "Reflection Prompt",
      content: "Based on your recent journals, how has your understanding of grace grown?",
      color: "from-amber-500 to-orange-600"
    },
    {
      icon: BookOpen,
      title: "Scripture Recommendation",
      content: "Since you're reflecting on patience, try reading James 1:2-4",
      color: "from-blue-500 to-purple-600"
    },
    {
      icon: Target,
      title: "Growth Insight",
      content: "You've journaled about faith 8 times this month - a clear theme in your walk!",
      color: "from-emerald-500 to-teal-600"
    }
  ];

  const quickPrompts = [
    "What patterns do you see in my journals?",
    "Give me a reflection prompt",
    "What scripture relates to my recent thoughts?",
    "How am I growing spiritually?"
  ];

  const moodEmojis: Record<string, string> = {
    peaceful: "😌",
    contemplative: "🤔",
    joyful: "😊",
    grateful: "🙏",
    hopeful: "✨"
  };

  const handleSendMessage = () => {
    if (!chatInput.trim()) return;

    const newMessage = {
      role: "user" as const,
      content: chatInput,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };

    setChatMessages([...chatMessages, newMessage]);
    setChatInput("");
    setIsTyping(true);

    // Simulate AI response
    setTimeout(() => {
      const aiResponse = {
        role: "ai" as const,
        content: generateAIResponse(chatInput),
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      };
      setChatMessages(prev => [...prev, aiResponse]);
      setIsTyping(false);
    }, 2000);
  };

  const generateAIResponse = (input: string): string => {
    const responses = [
      "Based on your recent journals about grace and faith, I notice a beautiful pattern of growth. Your heart is learning to trust God's timing more deeply. Consider meditating on Proverbs 3:5-6 as you continue this journey.",
      "That's a powerful reflection! Your journal entries show increasing awareness of God's faithfulness. Have you considered how this relates to the theme of patience you wrote about earlier?",
      "I see you're wrestling with important questions. This is actually a sign of spiritual maturity - asking difficult questions shows you're taking your faith seriously. Would you like to explore any specific scripture that addresses this?",
      "Your gratitude practice has been consistent! Research shows that regular thanksgiving journaling deepens our awareness of God's presence. What specific moment from today are you most grateful for?"
    ];
    return responses[Math.floor(Math.random() * responses.length)];
  };

  useEffect(() => {
    if (chatMessages.length > 0) {
      chatEndRef.current?.scrollIntoView({ behavior: "smooth" });
    }
  }, [chatMessages]);

  // Scroll detection for FAB visibility
  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      const scrollHeight = document.documentElement.scrollHeight;
      const clientHeight = window.innerHeight;
      const isAtBottom = currentScrollY + clientHeight >= scrollHeight - 50;
      
      if (isAtBottom) {
        // Show FAB when at bottom
        setShowFab(true);
      } else if (currentScrollY < lastScrollY) {
        // Scrolling up - show FAB
        setShowFab(true);
      } else if (currentScrollY > lastScrollY && currentScrollY > 100) {
        // Scrolling down - hide FAB
        setShowFab(false);
      }
      
      setLastScrollY(currentScrollY);
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    return () => window.removeEventListener('scroll', handleScroll);
  }, [lastScrollY]);

  const enableAI = () => {
    setAiEnabled(true);
    setShowAIConsent(false);
    setChatMessages([
      {
        role: "ai",
        content: "Hello! I'm your AI spiritual companion. I've reviewed your journal entries and reading history to better understand your journey. How can I support you today?",
        time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      }
    ]);
  };

  const filteredEntries = journalEntries.filter(entry => {
    if (selectedFilter === "all") return true;
    if (selectedFilter === "this-week") {
      return entry.date.includes("Today") || entry.date.includes("Yesterday");
    }
    if (selectedFilter === "this-month") {
      return entry.date.includes("Jan") || entry.date.includes("Today") || entry.date.includes("Yesterday");
    }
    if (selectedFilter === "plans") {
      return entry.contextType === "plan";
    }
    if (selectedFilter === "scriptures") {
      return entry.contextType === "scripture";
    }
    return true;
  });

  return (
    <div className={`min-h-screen pb-32 relative overflow-hidden ${isDark ? "bg-[#0A0A0A]" : "bg-gradient-to-br from-slate-50 via-orange-50 to-pink-50"}`}>
      {/* Animated Gradient Orbs */}
      <motion.div
        animate={{
          x: [0, 120, 0],
          y: [0, -100, 0],
          scale: [1, 1.3, 1],
        }}
        transition={{
          duration: 22,
          repeat: Infinity,
          ease: "linear"
        }}
        className={`fixed -top-1/2 -left-1/4 w-[800px] h-[800px] rounded-full blur-3xl ${
          isDark 
            ? "bg-gradient-to-br from-purple-500/20 via-pink-500/20 to-orange-500/20" 
            : "bg-gradient-to-br from-purple-300/30 via-pink-300/30 to-orange-300/30"
        } pointer-events-none`}
      />
      <motion.div
        animate={{
          x: [0, -100, 0],
          y: [0, 120, 0],
          scale: [1, 1.2, 1],
        }}
        transition={{
          duration: 28,
          repeat: Infinity,
          ease: "linear"
        }}
        className={`fixed -bottom-1/2 -right-1/4 w-[700px] h-[700px] rounded-full blur-3xl ${
          isDark 
            ? "bg-gradient-to-br from-orange-500/20 via-red-500/20 to-pink-500/20" 
            : "bg-gradient-to-br from-orange-300/30 via-red-300/30 to-pink-300/30"
        } pointer-events-none`}
      />

      <div className="relative z-10 px-6 pt-6">
        {/* Top Navigation Card - Unified Glassmorphic Container */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className={`rounded-[28px] ${
            isDark 
              ? "bg-white/5 border border-white/10" 
              : "bg-white/70 border border-white/50"
          } backdrop-blur-2xl shadow-xl p-5 mb-5 relative overflow-hidden`}
        >
          {/* Subtle background gradient */}
          <div className={`absolute inset-0 bg-gradient-to-br ${
            isDark 
              ? "from-purple-500/5 via-transparent to-pink-500/5" 
              : "from-orange-500/5 via-transparent to-pink-500/5"
          }`} />
          
          <div className="relative z-10">
            {/* Profile + Search/Filter */}
            <div className="flex items-center justify-between">
              {/* User Profile */}
              <motion.div
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.1 }}
                className="flex items-center gap-3"
              >
                <div className="w-11 h-11 rounded-full bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-lg">
                  <span className="text-white text-base font-black">JD</span>
                </div>
                <div>
                  <p className={`text-sm font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                    John Doe
                  </p>
                  <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                    Welcome back
                  </p>
                </div>
              </motion.div>

              {/* Right Side: Search + Filter */}
              <div className="flex items-center gap-2">
                {/* Search Icon Button */}
                <motion.button
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.15 }}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  className={`w-10 h-10 rounded-[14px] ${
                    isDark ? "bg-white/10 border border-white/20" : "bg-white/80 border border-gray-200 shadow-md"
                  } backdrop-blur-xl flex items-center justify-center`}
                >
                  <Search className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                </motion.button>

                {/* Filter Icon Button */}
                <motion.button
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.2 }}
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setShowFilterMenu(!showFilterMenu)}
                  className={`relative w-10 h-10 rounded-[14px] ${
                    isDark ? "bg-white/10 border border-white/20" : "bg-white/80 border border-gray-200 shadow-md"
                  } backdrop-blur-xl flex items-center justify-center`}
                >
                  <Filter className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                  {selectedFilter !== "all" && (
                    <div className="absolute -top-1 -right-1 w-2.5 h-2.5 rounded-full bg-gradient-to-br from-pink-500 to-red-600" />
                  )}
                </motion.button>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Tab Switcher - Standalone Between Navbar and Content */}
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.15 }}
          className="flex justify-center mb-6"
        >
          <div className={`flex gap-1.5 p-1.5 rounded-[20px] ${
            isDark ? "bg-white/5 border border-white/10" : "bg-white/70 border border-white/50"
          } backdrop-blur-2xl shadow-lg`}>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => setActiveTab("journals")}
              className={`relative px-6 py-2.5 rounded-[16px] text-sm font-bold transition-all ${
                activeTab === "journals"
                  ? "text-white"
                  : isDark ? "text-white/50" : "text-gray-500"
              }`}
            >
              {activeTab === "journals" && (
                <motion.div
                  layoutId="activeTab"
                  className="absolute inset-0 bg-gradient-to-r from-orange-500 to-pink-600 rounded-[16px] shadow-lg"
                  transition={{ type: "spring", stiffness: 400, damping: 30 }}
                />
              )}
              <span className="relative z-10 flex items-center gap-2">
                <BookOpen className="w-4 h-4" />
                Journals
              </span>
            </motion.button>
            
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => setActiveTab("mentor")}
              className={`relative px-6 py-2.5 rounded-[16px] text-sm font-bold transition-all ${
                activeTab === "mentor"
                  ? "text-white"
                  : isDark ? "text-white/50" : "text-gray-500"
              }`}
            >
              {activeTab === "mentor" && (
                <motion.div
                  layoutId="activeTab"
                  className="absolute inset-0 bg-gradient-to-r from-purple-500 to-pink-600 rounded-[16px] shadow-lg"
                  transition={{ type: "spring", stiffness: 400, damping: 30 }}
                />
              )}
              <span className="relative z-10 flex items-center gap-2">
                <Bot className="w-4 h-4" />
                AI
              </span>
            </motion.button>
          </div>
        </motion.div>

        {/* Creative Hero Section */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="mb-8 relative"
        >
          {/* Glassmorphic Hero Container */}
          <div className={`rounded-[28px] ${
            isDark 
              ? "bg-gradient-to-br from-purple-900/40 via-fuchsia-900/30 to-purple-900/40 border border-white/10" 
              : "bg-gradient-to-br from-white/90 via-pink-50/80 to-purple-50/80 border border-white/60"
          } backdrop-blur-2xl shadow-2xl p-7 relative overflow-hidden`}>
            
            {/* Floating Orb Decorations */}
            <motion.div
              animate={{
                x: [0, 30, 0],
                y: [0, -20, 0],
                scale: [1, 1.2, 1],
                opacity: [0.15, 0.25, 0.15],
              }}
              transition={{
                duration: 12,
                repeat: Infinity,
                ease: "easeInOut"
              }}
              className={`absolute -top-16 -right-16 w-56 h-56 rounded-full ${
                isDark 
                  ? "bg-gradient-to-br from-pink-500/40 via-purple-600/40 to-fuchsia-600/40" 
                  : "bg-gradient-to-br from-orange-400/40 via-pink-500/40 to-purple-500/40"
              } blur-3xl`}
            />
            <motion.div
              animate={{
                x: [0, -20, 0],
                y: [0, 30, 0],
                scale: [1, 1.3, 1],
                opacity: [0.15, 0.25, 0.15],
              }}
              transition={{
                duration: 15,
                repeat: Infinity,
                ease: "easeInOut"
              }}
              className={`absolute -bottom-12 -left-12 w-48 h-48 rounded-full ${
                isDark 
                  ? "bg-gradient-to-tr from-orange-500/40 via-pink-600/40 to-purple-600/40" 
                  : "bg-gradient-to-tr from-purple-400/40 via-fuchsia-500/40 to-pink-500/40"
              } blur-3xl`}
            />

            <div className="relative z-10">
              {/* Title Section - Compact */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.15 }}
                className="mb-6"
              >
                <div className="flex items-center gap-2.5 mb-1">
                  {/* Animated Icon Badge */}
                  <motion.div
                    animate={{
                      rotate: [0, 5, -5, 0],
                      boxShadow: [
                        "0 0 0 0 rgba(236, 72, 153, 0)",
                        "0 0 0 8px rgba(236, 72, 153, 0.2)",
                        "0 0 0 0 rgba(236, 72, 153, 0)"
                      ]
                    }}
                    transition={{
                      duration: 6,
                      repeat: Infinity,
                      ease: "easeInOut"
                    }}
                    className="w-9 h-9 rounded-[12px] bg-gradient-to-br from-pink-500 via-pink-600 to-red-600 flex items-center justify-center shadow-xl flex-shrink-0"
                  >
                    <Pen className="w-4.5 h-4.5 text-white" />
                  </motion.div>

                  {/* Title inline with icon */}
                  <h1 className="text-lg font-black leading-none">
                    <span className={isDark ? "text-white" : "text-gray-900"}>
                      Journey with
                    </span>{" "}
                    <span className="bg-gradient-to-r from-pink-500 via-pink-600 to-red-600 bg-clip-text text-transparent">
                      GOD
                    </span>
                  </h1>
                </div>
                <p className={`text-[10px] font-medium ${isDark ? "text-white/40" : "text-gray-500"}`}>
                  {activeTab === "journals" ? "Spiritual Mentor" : "AI-powered guidance"}
                </p>
              </motion.div>

              {/* Stats Container - Compact 2x2 Grid */}
              {activeTab === "journals" && (
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.25 }}
                  className="grid grid-cols-2 gap-4"
                >
                  {stats.map((stat, index) => {
                    const Icon = stat.icon;
                    return (
                      <motion.div
                        key={index}
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{
                          delay: 0.3 + index * 0.05,
                          type: "spring",
                          stiffness: 200,
                          damping: 20
                        }}
                        whileHover={{ scale: 1.03 }}
                        whileTap={{ scale: 0.98 }}
                        className={`relative rounded-[20px] ${
                          isDark 
                            ? "bg-white/5 border border-white/10" 
                            : "bg-white/90 border border-gray-200"
                        } backdrop-blur-xl p-5 overflow-hidden cursor-pointer group shadow-lg`}
                      >
                        {/* Subtle gradient background */}
                        <div className={`absolute inset-0 bg-gradient-to-br ${stat.color} opacity-[0.03]`} />

                        <div className="relative z-10 flex flex-col gap-4">
                          {/* Icon - Small & Minimal */}
                          <div className={`w-9 h-9 rounded-[12px] bg-gradient-to-br ${stat.color} flex items-center justify-center shadow-md`}>
                            <Icon className="w-4.5 h-4.5 text-white" strokeWidth={2.5} />
                          </div>

                          {/* Stats */}
                          <div className="space-y-0.5">
                            {/* Number */}
                            <p className={`text-[28px] font-black leading-none ${
                              isDark ? "text-white" : "text-gray-900"
                            } tracking-tight`}>
                              {stat.value}
                            </p>

                            {/* Label */}
                            <p className={`text-[11px] font-semibold ${
                              isDark ? "text-white/50" : "text-gray-500"
                            } leading-tight`}>
                              {stat.label}
                            </p>
                          </div>
                        </div>
                      </motion.div>
                    );
                  })}
                </motion.div>
              )}
            </div>
          </div>
        </motion.div>

        {/* Filter Menu - Outside Hero Container */}
        <AnimatePresence>
          {showFilterMenu && (
            <motion.div
              initial={{ opacity: 0, height: 0, marginBottom: 0 }}
              animate={{ opacity: 1, height: "auto", marginBottom: 24 }}
              exit={{ opacity: 0, height: 0, marginBottom: 0 }}
              className="overflow-hidden"
            >
              <div className={`rounded-[24px] ${
                isDark ? "bg-white/5 border border-white/10" : "bg-white border border-gray-200 shadow-lg"
              } backdrop-blur-xl p-5`}>
                <div className="grid grid-cols-2 gap-3">
                  {[
                    { key: "all", label: "All Entries", icon: BookOpen },
                    { key: "this-week", label: "This Week", icon: Calendar },
                    { key: "this-month", label: "This Month", icon: Clock },
                    { key: "plans", label: "From Plans", icon: Target },
                    { key: "scriptures", label: "From Scripture", icon: Book }
                  ].map((filter) => {
                    const Icon = filter.icon;
                    return (
                      <motion.button
                        key={filter.key}
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => {
                          setSelectedFilter(filter.key as any);
                          setShowFilterMenu(false);
                        }}
                        className={`p-3 rounded-[16px] flex items-center gap-2 text-left transition-all ${
                          selectedFilter === filter.key
                            ? "bg-gradient-to-r from-orange-500 to-pink-600 text-white"
                            : isDark 
                            ? "bg-white/5 text-white/70 hover:bg-white/10"
                            : "bg-gray-50 text-gray-700 hover:bg-gray-100"
                        }`}
                      >
                        <Icon className="w-4 h-4" />
                        <span className="text-sm font-bold">{filter.label}</span>
                      </motion.button>
                    );
                  })}
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Content - Continuing with journal entries and AI chat... */}
        <AnimatePresence mode="wait">
          {activeTab === "journals" ? (
            <motion.div
              key="journals"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20 }}
              transition={{ duration: 0.3 }}
            >
              {/* Journal Entries */}
              <div className="space-y-6">
                {filteredEntries.map((entry, index) => (
                  <motion.div
                    key={entry.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                    whileHover={{ scale: 1.01, y: -2 }}
                    onClick={() => setSelectedEntry(selectedEntry === entry.id ? null : entry.id)}
                    className={`relative overflow-hidden rounded-[28px] ${
                      isDark ? "bg-white/5" : "bg-white"
                    } backdrop-blur-xl border ${isDark ? "border-white/10" : "border-gray-200"} shadow-xl cursor-pointer group`}
                  >
                    {/* Gradient overlay */}
                    <div className={`absolute inset-0 bg-gradient-to-br ${entry.gradient} pointer-events-none`} />
                    
                    {/* Shimmer effect */}
                    <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity -translate-x-full group-hover:translate-x-full duration-1000" />
                    
                    <div className="relative z-10 p-7">
                      {/* Header */}
                      <div className="flex items-start justify-between mb-5">
                        <div className="flex-1 pr-28">
                          {/* Date */}
                          <div className="mb-3">
                            <span className={`text-xs font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider`}>
                              {entry.date}
                            </span>
                          </div>
                          
                          {/* Badges Row */}
                          {(entry.isPrivate || entry.aiInsights || (entry.followUps && entry.followUps.length > 0)) && (
                            <div className="flex items-center gap-2 mb-4 flex-wrap">
                              {entry.isPrivate && (
                                <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-[10px] bg-gray-500/20 backdrop-blur-xl border border-gray-500/30">
                                  <Lock className="w-3 h-3" />
                                  <span className="text-[10px] font-bold">Private</span>
                                </div>
                              )}
                              {entry.aiInsights && (
                                <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-[10px] bg-purple-500/20 backdrop-blur-xl border border-purple-500/30">
                                  <Sparkles className="w-3 h-3 text-purple-400" />
                                  <span className="text-[10px] font-bold text-purple-400">AI Access</span>
                                </div>
                              )}
                              {entry.followUps && entry.followUps.length > 0 && (
                                <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-[10px] bg-gradient-to-r from-orange-500/20 to-pink-500/20 backdrop-blur-xl border border-orange-400/40">
                                  <MessageCircle className="w-3 h-3 text-orange-400" />
                                  <span className="text-[10px] font-bold text-orange-400">{entry.followUps.length} Follow-Up{entry.followUps.length > 1 ? 's' : ''}</span>
                                </div>
                              )}
                            </div>
                          )}
                          
                          {/* Title */}
                          <h3 className={`text-xl font-black mb-4 leading-tight ${isDark ? "text-white" : "text-gray-900"}`}>
                            {entry.title}
                          </h3>
                        </div>
                      </div>

                      {/* Content Preview */}
                      <p className={`text-sm leading-relaxed mb-6 line-clamp-2 ${ isDark ? "text-white/70" : "text-gray-600"} font-scripture`} style={{ fontFamily: "'Crimson Text', serif" }}>
                        {entry.content}
                      </p>

                      {/* Context Badge - Plan or Scripture */}
                      <div className="mb-6">
                        <div className={`inline-flex items-center gap-2 px-3 py-2 rounded-[14px] ${
                          entry.contextType === "plan"
                            ? isDark ? "bg-blue-500/20 border border-blue-400/30" : "bg-blue-50 border border-blue-200"
                            : isDark ? "bg-emerald-500/20 border border-emerald-400/30" : "bg-emerald-50 border border-emerald-200"
                        } backdrop-blur-xl`}>
                          {entry.contextType === "plan" ? (
                            <Target className={`w-3.5 h-3.5 ${isDark ? "text-blue-400" : "text-blue-600"}`} />
                          ) : (
                            <Book className={`w-3.5 h-3.5 ${isDark ? "text-emerald-400" : "text-emerald-600"}`} />
                          )}
                          <span className={`text-xs font-bold ${
                            entry.contextType === "plan"
                              ? isDark ? "text-blue-400" : "text-blue-600"
                              : isDark ? "text-emerald-400" : "text-emerald-600"
                          }`}>
                            {entry.context}
                          </span>
                        </div>
                      </div>

                      {/* Tags */}
                      <div className="flex flex-wrap gap-2 mb-6">
                        {entry.tags.map((tag, i) => (
                          <span
                            key={i}
                            className={`px-3 py-1.5 rounded-[12px] text-xs font-bold ${
                              isDark 
                                ? "bg-white/10 text-white/80 border border-white/20" 
                                : "bg-gray-50 text-gray-700 border border-gray-200"
                            } backdrop-blur-xl`}
                          >
                            #{tag}
                          </span>
                        ))}
                      </div>

                      {/* Verse Reference */}
                      {entry.verse && (
                        <div className={`flex items-center justify-between gap-3 px-4 py-3.5 rounded-[20px] ${
                          isDark ? "bg-white/5" : "bg-gray-50"
                        } border ${entry.borderColor} backdrop-blur-xl`}>
                          <div className="flex items-center gap-3 flex-1">
                            <div className={`w-9 h-9 rounded-[12px] bg-gradient-to-br ${entry.accentColor} flex items-center justify-center shadow-lg`}>
                              <BookOpen className="w-4.5 h-4.5 text-white" />
                            </div>
                            <span className={`text-sm font-bold bg-gradient-to-r ${entry.accentColor} bg-clip-text text-transparent`}>
                              {entry.verse}
                            </span>
                          </div>
                          <motion.button
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.9 }}
                            onClick={(e) => {
                              e.stopPropagation();
                              onNavigateToRead?.(entry.book, entry.chapter);
                            }}
                            className={`w-8 h-8 rounded-[12px] ${
                              isDark ? "bg-white/10" : "bg-white"
                            } backdrop-blur-xl flex items-center justify-center shadow-md`}
                          >
                            <ChevronRight className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                          </motion.button>
                        </div>
                      )}

                      {/* Mood Emoji & Edit Icon - Always Visible in Top Right */}
                      <div className="absolute top-6 right-6 flex items-center gap-2">
                        {/* Mood Emoji */}
                        <div className="text-2xl">
                          {moodEmojis[entry.mood]}
                        </div>
                        
                        {/* Follow Up Button */}
                        <motion.button
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={(e) => {
                            e.stopPropagation();
                            setSelectedEntry(entry.id);
                            setEditTitle("");
                            setEditContent("");
                            setEditTags(entry.tags);
                            setSelectedMood(entry.mood);
                            setFollowUpMode(true);
                          }}
                          className={`w-9 h-9 rounded-[14px] bg-gradient-to-br from-orange-500 to-pink-600 backdrop-blur-2xl border border-orange-400/30 shadow-xl flex items-center justify-center`}
                        >
                          <Pen className="w-4 h-4 text-white" />
                        </motion.button>
                        
                        {/* Edit Button */}
                        <motion.button
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={(e) => {
                            e.stopPropagation();
                            setSelectedEntry(entry.id);
                          }}
                          className={`w-9 h-9 rounded-[14px] ${
                            isDark ? "bg-white/10" : "bg-white"
                          } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-gray-200"} shadow-xl flex items-center justify-center`}
                        >
                          <Edit3 className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        </motion.button>
                      </div>
                    </div>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          ) : (
            <motion.div
              key="ai-mentor"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
              className="space-y-6"
            >
              {/* AI Suggestions Cards - Only show if chat is empty */}
              {chatMessages.length === 0 && (
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.1 }}
                  className="space-y-5"
                >
                  <h3 className={`text-[11px] font-black ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-widest px-1`}>
                    Suggested Prompts
                  </h3>
                  <div className="space-y-3">
                    {aiSuggestions.map((suggestion, index) => {
                      const Icon = suggestion.icon;
                      return (
                        <motion.button
                          key={index}
                          initial={{ opacity: 0, x: -20 }}
                          animate={{ opacity: 1, x: 0 }}
                          transition={{ delay: 0.1 + index * 0.05 }}
                          whileHover={{ x: 4 }}
                          whileTap={{ scale: 0.98 }}
                          onClick={() => {
                            setChatInput(suggestion.content);
                            setTimeout(() => handleSendMessage(), 100);
                          }}
                          className={`w-full relative overflow-hidden rounded-[18px] ${
                            isDark ? "bg-white/5 border border-white/10 hover:bg-white/10" : "bg-gray-800/80 border border-gray-700/50 hover:bg-gray-800"
                          } backdrop-blur-xl shadow-md p-4 text-left group transition-all`}
                        >
                          <div className="relative z-10 flex items-center gap-3">
                            <div className={`w-10 h-10 rounded-[14px] bg-gradient-to-br ${suggestion.color} flex items-center justify-center shadow-lg flex-shrink-0`}>
                              <Icon className="w-5 h-5 text-white" strokeWidth={2.5} />
                            </div>
                            <div className="flex-1 min-w-0">
                              <h4 className={`text-[13px] font-bold mb-0.5 ${isDark ? "text-white" : "text-white"}`}>
                                {suggestion.title}
                              </h4>
                              <p className={`text-[11px] leading-snug ${isDark ? "text-white/50" : "text-gray-400"} line-clamp-2`}>
                                {suggestion.content}
                              </p>
                            </div>
                            <ChevronRight className={`w-4 h-4 ${isDark ? "text-white/30" : "text-gray-500"} flex-shrink-0 group-hover:translate-x-1 transition-transform`} />
                          </div>
                        </motion.button>
                      );
                    })}
                  </div>
                </motion.div>
              )}

              {/* Chat Messages Container */}
              {chatMessages.length > 0 && (
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  className={`rounded-[28px] ${
                    isDark ? "bg-white/5 border border-white/10" : "bg-white border border-gray-200"
                  } backdrop-blur-xl shadow-xl p-5 max-h-[600px] overflow-y-auto space-y-4`}
                  style={{
                    scrollbarWidth: 'none',
                    msOverflowStyle: 'none',
                  }}
                >
                  {chatMessages.map((message, index) => (
                    <motion.div
                      key={index}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.05 }}
                      className={`flex ${message.role === "user" ? "justify-end" : "justify-start"}`}
                    >
                      <div className={`max-w-[85%] ${message.role === "user" ? "items-end" : "items-start"} flex flex-col gap-2`}>
                        {/* Message Bubble */}
                        <div className={`rounded-[20px] px-5 py-4 ${
                          message.role === "user"
                            ? "bg-gradient-to-r from-purple-500 to-pink-600 text-white"
                            : isDark 
                            ? "bg-white/10 border border-white/20 text-white" 
                            : "bg-gray-100 border border-gray-200 text-gray-900"
                        } backdrop-blur-xl shadow-lg`}>
                          <p className="text-sm leading-relaxed whitespace-pre-wrap">
                            {message.content}
                          </p>
                        </div>
                        {/* Timestamp */}
                        <span className={`text-[10px] font-medium px-2 ${
                          isDark ? "text-white/40" : "text-gray-500"
                        }`}>
                          {message.time}
                        </span>
                      </div>
                    </motion.div>
                  ))}
                  
                  {/* Typing Indicator */}
                  {isTyping && (
                    <motion.div
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="flex justify-start"
                    >
                      <div className={`rounded-[20px] px-5 py-4 ${
                        isDark ? "bg-white/10 border border-white/20" : "bg-gray-100 border border-gray-200"
                      } backdrop-blur-xl shadow-lg`}>
                        <div className="flex gap-1.5">
                          <motion.div
                            animate={{ scale: [1, 1.3, 1], opacity: [0.5, 1, 0.5] }}
                            transition={{ duration: 1, repeat: Infinity, delay: 0 }}
                            className={`w-2 h-2 rounded-full ${isDark ? "bg-white/60" : "bg-gray-600"}`}
                          />
                          <motion.div
                            animate={{ scale: [1, 1.3, 1], opacity: [0.5, 1, 0.5] }}
                            transition={{ duration: 1, repeat: Infinity, delay: 0.2 }}
                            className={`w-2 h-2 rounded-full ${isDark ? "bg-white/60" : "bg-gray-600"}`}
                          />
                          <motion.div
                            animate={{ scale: [1, 1.3, 1], opacity: [0.5, 1, 0.5] }}
                            transition={{ duration: 1, repeat: Infinity, delay: 0.4 }}
                            className={`w-2 h-2 rounded-full ${isDark ? "bg-white/60" : "bg-gray-600"}`}
                          />
                        </div>
                      </div>
                    </motion.div>
                  )}
                  <div ref={chatEndRef} />
                </motion.div>
              )}

              {/* Quick Prompts - Only show if no chat yet */}
              {chatMessages.length === 0 && (
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.3 }}
                  className="space-y-3"
                >
                  <h3 className={`text-[11px] font-black ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-widest px-1`}>
                    Quick Questions
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {quickPrompts.map((prompt, index) => (
                      <motion.button
                        key={index}
                        initial={{ opacity: 0, scale: 0.9 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ delay: 0.35 + index * 0.03 }}
                        whileHover={{ scale: 1.03, y: -2 }}
                        whileTap={{ scale: 0.97 }}
                        onClick={() => {
                          setChatInput(prompt);
                          setTimeout(() => handleSendMessage(), 100);
                        }}
                        className={`px-4 py-2 rounded-[14px] text-[11px] font-bold ${
                          isDark 
                            ? "bg-white/5 text-white/70 border border-white/10 hover:bg-white/10 hover:text-white" 
                            : "bg-gray-800/60 text-gray-300 border border-gray-700/50 hover:bg-gray-800 shadow-sm"
                        } backdrop-blur-xl transition-all`}
                      >
                        {prompt}
                      </motion.button>
                    ))}
                  </div>
                </motion.div>
              )}

              {/* Chat Input Box - Modern Fixed Bottom */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 }}
                className="mt-6"
              >
                <div className={`rounded-[22px] ${
                  isDark ? "bg-gradient-to-br from-gray-800/50 to-gray-900/50 border border-white/10" : "bg-gray-800/90 border border-gray-700/50"
                } backdrop-blur-xl shadow-2xl p-3.5`}>
                  <div className="flex items-center gap-2.5">
                    {/* Voice Input Button */}
                    <motion.button
                      whileHover={{ scale: 1.08 }}
                      whileTap={{ scale: 0.92 }}
                      className={`w-11 h-11 rounded-[16px] ${
                        isDark ? "bg-white/10 hover:bg-white/15 border border-white/10" : "bg-gray-700/80 hover:bg-gray-700 border border-gray-600/50"
                      } backdrop-blur-xl flex items-center justify-center flex-shrink-0 transition-all`}
                    >
                      <Mic className={`w-4.5 h-4.5 ${isDark ? "text-white/70" : "text-gray-300"}`} strokeWidth={2.5} />
                    </motion.button>

                    {/* Text Input - More Compact */}
                    <div className="flex-1 relative">
                      <input
                        type="text"
                        value={chatInput}
                        onChange={(e) => setChatInput(e.target.value)}
                        onKeyDown={(e) => {
                          if (e.key === 'Enter' && !e.shiftKey) {
                            e.preventDefault();
                            handleSendMessage();
                          }
                        }}
                        placeholder="Ask about your spiritual journey..."
                        className={`w-full h-11 px-4 pr-12 rounded-[16px] text-[13px] ${
                          isDark 
                            ? "bg-white/5 border border-white/10 text-white placeholder:text-white/40" 
                            : "bg-gray-700/80 border border-gray-600/50 text-white placeholder:text-gray-400"
                        } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-purple-500/40 focus:border-purple-500/40 transition-all`}
                      />
                      {/* Character count or status indicator can go here */}
                    </div>

                    {/* Send Button - Integrated Design */}
                    <motion.button
                      whileHover={{ scale: chatInput.trim() ? 1.08 : 1 }}
                      whileTap={{ scale: chatInput.trim() ? 0.92 : 1 }}
                      onClick={handleSendMessage}
                      disabled={!chatInput.trim()}
                      className={`w-11 h-11 rounded-[16px] flex items-center justify-center flex-shrink-0 transition-all ${
                        chatInput.trim()
                          ? "bg-gradient-to-br from-purple-500 to-pink-600 shadow-lg shadow-purple-500/30 hover:shadow-xl hover:shadow-purple-500/40"
                          : isDark 
                          ? "bg-white/5 border border-white/10 cursor-not-allowed" 
                          : "bg-gray-700/60 border border-gray-600/30 cursor-not-allowed"
                      }`}
                    >
                      <Send className={`w-4.5 h-4.5 ${chatInput.trim() ? "text-white" : isDark ? "text-white/30" : "text-gray-500"}`} strokeWidth={2.5} />
                    </motion.button>
                  </div>
                </div>
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Floating New Entry Button - Only on Journals Tab */}
        {activeTab === "journals" && (
          <motion.button
            initial={{ scale: 0, opacity: 0 }}
            animate={{ 
              scale: showFab ? 1 : 0,
              opacity: showFab ? 1 : 0,
              y: showFab ? 0 : 20
            }}
            transition={{ type: "spring", stiffness: 300, damping: 25 }}
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.9 }}
            onClick={() => setShowNewEntry(!showNewEntry)}
            className="fixed bottom-8 right-8 w-14 h-14 rounded-full bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-2xl z-30"
          >
            <Plus className="w-6 h-6 text-white" />
            
            {/* Pulse Ring Animation */}
            {!showNewEntry && (
              <motion.div
                animate={{
                  scale: [1, 1.4, 1],
                  opacity: [0.5, 0, 0.5]
                }}
                transition={{
                  duration: 2,
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
                className="absolute inset-0 rounded-full bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600"
              />
            )}
          </motion.button>
        )}
      </div>

      {/* Expanded Journal Entry Modal */}
      <AnimatePresence>
        {selectedEntry !== null && (() => {
          const entry = journalEntries.find(e => e.id === selectedEntry);
          if (!entry) return null;
          
          return (
            <>
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="fixed inset-0 bg-black/70 backdrop-blur-md z-[999]"
                onClick={() => setSelectedEntry(null)}
              />

              <motion.div
                initial={{ opacity: 0, scale: 0.95, y: 50 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95, y: 50 }}
                transition={{ type: "spring", damping: 30, stiffness: 300 }}
                className="fixed inset-x-4 top-20 bottom-36 z-[1000] overflow-hidden"
              >
                <div className={`h-full rounded-[32px] ${
                  isDark ? "bg-gray-900/98 border border-white/10" : "bg-white/98 border border-gray-200"
                } backdrop-blur-2xl shadow-2xl overflow-y-auto relative`}>
                  
                  {/* Gradient Background */}
                  <div className={`absolute inset-0 bg-gradient-to-br ${entry.gradient} pointer-events-none`} />
                  
                  <div className="relative z-10 p-6 pb-8">
                    {/* Header with Close Button */}
                    <div className="flex items-start justify-between mb-6">
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-3 flex-wrap">
                          <span className={`text-xs font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider`}>
                            {entry.date}
                          </span>
                          {entry.isPrivate && (
                            <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-[10px] bg-gray-500/20 backdrop-blur-xl border border-gray-500/30">
                              <Lock className="w-3 h-3" />
                              <span className="text-[10px] font-bold">Private</span>
                            </div>
                          )}
                          {entry.aiInsights && (
                            <div className="flex items-center gap-1.5 px-2.5 py-1 rounded-[10px] bg-purple-500/20 backdrop-blur-xl border border-purple-500/30">
                              <Sparkles className="w-3 h-3 text-purple-400" />
                              <span className="text-[10px] font-bold text-purple-400">AI Insights</span>
                            </div>
                          )}
                        </div>
                        
                        <h2 className={`text-2xl font-black leading-tight ${isDark ? "text-white" : "text-gray-900"}`}>
                          {entry.title}
                        </h2>
                      </div>

                      {/* Close Button */}
                      <motion.button
                        whileHover={{ scale: 1.1, rotate: 90 }}
                        whileTap={{ scale: 0.9 }}
                        onClick={() => setSelectedEntry(null)}
                        className={`w-10 h-10 rounded-[16px] ${
                          isDark ? "bg-white/10 border border-white/20" : "bg-white border border-gray-200"
                        } backdrop-blur-xl flex items-center justify-center shadow-lg flex-shrink-0`}
                      >
                        <X className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                      </motion.button>
                    </div>

                    {/* Full Content */}
                    <div className={`mb-6 p-5 rounded-[24px] ${
                      isDark ? "bg-white/5 border border-white/10" : "bg-gray-50/80 border border-gray-200"
                    } backdrop-blur-xl`}>
                      <p className={`text-base leading-relaxed ${isDark ? "text-white/80" : "text-gray-700"} font-scripture whitespace-pre-wrap`} style={{ fontFamily: "'Crimson Text', serif" }}>
                        {entry.content}
                      </p>
                    </div>

                    {/* Metadata Grid */}
                    <div className="grid grid-cols-2 gap-3 mb-6">
                      {/* Mood */}
                      <div className={`p-4 rounded-[20px] ${
                        isDark ? "bg-white/5 border border-white/10" : "bg-gray-50 border border-gray-200"
                      } backdrop-blur-xl`}>
                        <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2`}>
                          Mood
                        </p>
                        <div className="flex items-center gap-2">
                          <span className="text-2xl">{moodEmojis[entry.mood]}</span>
                          <span className={`text-sm font-bold capitalize ${isDark ? "text-white" : "text-gray-900"}`}>
                            {entry.mood}
                          </span>
                        </div>
                      </div>

                      {/* Context Type */}
                      <div className={`p-4 rounded-[20px] ${
                        isDark ? "bg-white/5 border border-white/10" : "bg-gray-50 border border-gray-200"
                      } backdrop-blur-xl`}>
                        <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2`}>
                          Source
                        </p>
                        <div className="flex items-center gap-2">
                          {entry.contextType === "plan" ? (
                            <Target className={`w-5 h-5 ${isDark ? "text-blue-400" : "text-blue-600"}`} />
                          ) : (
                            <Book className={`w-5 h-5 ${isDark ? "text-emerald-400" : "text-emerald-600"}`} />
                          )}
                          <span className={`text-sm font-bold ${
                            entry.contextType === "plan"
                              ? isDark ? "text-blue-400" : "text-blue-600"
                              : isDark ? "text-emerald-400" : "text-emerald-600"
                          }`}>
                            {entry.contextType === "plan" ? "Plan" : "Scripture"}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Context Badge */}
                    {entry.context && (
                      <div className="mb-6">
                        <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3`}>
                          Written During
                        </p>
                        <div className={`inline-flex items-center gap-2 px-4 py-3 rounded-[16px] ${
                          entry.contextType === "plan"
                            ? isDark ? "bg-blue-500/20 border border-blue-400/30" : "bg-blue-50 border border-blue-200"
                            : isDark ? "bg-emerald-500/20 border border-emerald-400/30" : "bg-emerald-50 border border-emerald-200"
                        } backdrop-blur-xl`}>
                          <span className={`text-sm font-bold ${
                            entry.contextType === "plan"
                              ? isDark ? "text-blue-400" : "text-blue-600"
                              : isDark ? "text-emerald-400" : "text-emerald-600"
                          }`}>
                            {entry.context}
                          </span>
                        </div>
                      </div>
                    )}

                    {/* Verse Reference */}
                    {entry.verse && (
                      <div className="mb-6">
                        <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3`}>
                          Scripture Reference
                        </p>
                        <div className={`flex items-center justify-between gap-3 px-4 py-4 rounded-[20px] ${
                          isDark ? "bg-white/5" : "bg-gray-50"
                        } border ${entry.borderColor} backdrop-blur-xl`}>
                          <div className="flex items-center gap-3 flex-1">
                            <div className={`w-10 h-10 rounded-[14px] bg-gradient-to-br ${entry.accentColor} flex items-center justify-center shadow-lg`}>
                              <BookOpen className="w-5 h-5 text-white" />
                            </div>
                            <span className={`text-base font-bold bg-gradient-to-r ${entry.accentColor} bg-clip-text text-transparent`}>
                              {entry.verse}
                            </span>
                          </div>
                          <motion.button
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.9 }}
                            onClick={(e) => {
                              e.stopPropagation();
                              setSelectedEntry(null);
                              onNavigateToRead?.(entry.book, entry.chapter);
                            }}
                            className={`w-9 h-9 rounded-[14px] ${
                              isDark ? "bg-white/10" : "bg-white"
                            } backdrop-blur-xl flex items-center justify-center shadow-md`}
                          >
                            <ChevronRight className={`w-4.5 h-4.5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                          </motion.button>
                        </div>
                      </div>
                    )}

                    {/* Tags */}
                    {entry.tags && entry.tags.length > 0 && (
                      <div className="mb-6">
                        <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3`}>
                          Tags
                        </p>
                        <div className="flex flex-wrap gap-2">
                          {entry.tags.map((tag, i) => (
                            <span
                              key={i}
                              className={`px-3 py-2 rounded-[14px] text-xs font-bold ${
                                isDark 
                                  ? "bg-white/10 text-white/80 border border-white/20" 
                                  : "bg-gray-100 text-gray-700 border border-gray-200"
                              } backdrop-blur-xl`}
                            >
                              #{tag}
                            </span>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* Follow-Up Entries */}
                    {entry.followUps && entry.followUps.length > 0 && (
                      <div className="mb-6">
                        <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3`}>
                          Follow-Up Reflections ({entry.followUps.length})
                        </p>
                        <div className="space-y-3">
                          {entry.followUps.map((followUp, i) => (
                            <motion.div
                              key={i}
                              initial={{ opacity: 0, y: 10 }}
                              animate={{ opacity: 1, y: 0 }}
                              transition={{ delay: i * 0.1 }}
                              className={`p-4 rounded-[20px] ${isDark ? "bg-gradient-to-br from-orange-500/10 to-pink-500/10 border border-orange-400/30" : "bg-gradient-to-br from-orange-50 to-pink-50 border border-orange-200"} backdrop-blur-xl`}
                            >
                              <div className="flex items-center justify-between mb-2">
                                <span className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider`}>
                                  {followUp.date}
                                </span>
                                <span className="text-lg">
                                  {moodEmojis[followUp.mood]}
                                </span>
                              </div>
                              <p className={`text-sm leading-relaxed ${isDark ? "text-white/80" : "text-gray-700"} font-scripture`} style={{ fontFamily: "'Crimson Text', serif" }}>
                                {followUp.content}
                              </p>
                            </motion.div>
                          ))}
                        </div>
                      </div>
                    )}

                    {/* AI Access Toggle */}
                    <div className={`p-5 rounded-[24px] ${
                      isDark ? "bg-purple-500/10 border border-purple-400/30" : "bg-purple-50 border border-purple-200"
                    } backdrop-blur-xl mb-6`}>
                      <div className="flex items-start justify-between gap-4">
                        <div className="flex-1">
                          <div className="flex items-center gap-2 mb-2">
                            <Sparkles className={`w-4.5 h-4.5 ${isDark ? "text-purple-400" : "text-purple-600"}`} />
                            <h4 className={`text-sm font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                              AI Access
                            </h4>
                          </div>
                          <p className={`text-xs leading-relaxed ${isDark ? "text-white/60" : "text-gray-600"}`}>
                            Allow AI to analyze this entry for personalized insights and spiritual growth patterns
                          </p>
                        </div>
                        <motion.button
                          whileTap={{ scale: 0.95 }}
                          onClick={() => {
                            // Toggle AI access for this entry
                          }}
                          className={`relative w-14 h-8 rounded-full flex-shrink-0 transition-colors ${
                            entry.aiInsights 
                              ? "bg-gradient-to-r from-purple-500 to-pink-600" 
                              : isDark ? "bg-white/10" : "bg-gray-300"
                          }`}
                        >
                          <motion.div
                            animate={{ x: entry.aiInsights ? 26 : 2 }}
                            transition={{ type: "spring", stiffness: 500, damping: 30 }}
                            className="absolute top-1 w-6 h-6 rounded-full bg-white shadow-lg"
                          />
                        </motion.button>
                      </div>
                    </div>

                    {/* Action Buttons */}
                    <div className="grid grid-cols-2 gap-3">
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => {
                          setEditTitle(entry.title);
                          setEditContent(entry.content);
                          setEditTags(entry.tags);
                          setSelectedMood(entry.mood);
                          setEditMode(true);
                        }}
                        className={`flex items-center justify-center gap-2 px-5 py-4 rounded-[20px] font-bold ${
                          isDark 
                            ? "bg-white/10 text-white border border-white/20" 
                            : "bg-gray-100 text-gray-900 border border-gray-200"
                        } backdrop-blur-xl shadow-lg`}
                      >
                        <Edit3 className="w-4.5 h-4.5" />
                        Edit
                      </motion.button>
                      
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => {
                          setEditTitle("");
                          setEditContent("");
                          setEditTags(entry.tags);
                          setSelectedMood(entry.mood);
                          setFollowUpMode(true);
                        }}
                        className="flex items-center justify-center gap-2 px-5 py-4 rounded-[20px] bg-gradient-to-r from-orange-500 via-pink-600 to-purple-600 text-white font-bold shadow-xl"
                      >
                        <Pen className="w-4.5 h-4.5" />
                        Follow Up
                      </motion.button>
                    </div>

                    {/* Additional Actions */}
                    <div className="grid grid-cols-3 gap-2 mt-3">
                      <motion.button
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        className={`flex items-center justify-center gap-1.5 px-3 py-3 rounded-[16px] ${
                          isDark ? "bg-white/5 border border-white/10" : "bg-gray-50 border border-gray-200"
                        } backdrop-blur-xl`}
                      >
                        <Share2 className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        <span className={`text-xs font-bold ${isDark ? "text-white/70" : "text-gray-600"}`}>Share</span>
                      </motion.button>
                      
                      <motion.button
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        className={`flex items-center justify-center gap-1.5 px-3 py-3 rounded-[16px] ${
                          isDark ? "bg-white/5 border border-white/10" : "bg-gray-50 border border-gray-200"
                        } backdrop-blur-xl`}
                      >
                        <Copy className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        <span className={`text-xs font-bold ${isDark ? "text-white/70" : "text-gray-600"}`}>Copy</span>
                      </motion.button>
                      
                      <motion.button
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        className={`flex items-center justify-center gap-1.5 px-3 py-3 rounded-[16px] ${
                          isDark ? "bg-red-500/10 border border-red-500/30" : "bg-red-50 border border-red-200"
                        } backdrop-blur-xl`}
                      >
                        <Trash2 className={`w-4 h-4 ${isDark ? "text-red-400" : "text-red-600"}`} />
                        <span className={`text-xs font-bold ${isDark ? "text-red-400" : "text-red-600"}`}>Delete</span>
                      </motion.button>
                    </div>
                  </div>
                </div>
              </motion.div>
            </>
          );
        })()}
      </AnimatePresence>

      {/* Edit Journal Entry Modal */}
      <AnimatePresence>
        {editMode && selectedEntry !== null && (() => {
          const entry = journalEntries.find(e => e.id === selectedEntry);
          if (!entry) return null;
          
          return (
            <>
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="fixed inset-0 bg-black/70 backdrop-blur-md z-[1001]"
                onClick={() => setEditMode(false)}
              />

              <motion.div
                initial={{ opacity: 0, scale: 0.95, y: 50 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95, y: 50 }}
                transition={{ type: "spring", damping: 30, stiffness: 300 }}
                className="fixed inset-x-4 top-16 bottom-32 z-[1002] overflow-hidden"
              >
                <div className={`h-full rounded-[32px] ${
                  isDark ? "bg-gray-900/98 border border-white/10" : "bg-white/98 border border-gray-200"
                } backdrop-blur-2xl shadow-2xl overflow-y-auto relative`}>
                  
                  {/* Gradient Background */}
                  <div className={`absolute inset-0 bg-gradient-to-br ${entry.gradient} pointer-events-none opacity-50`} />
                  
                  <div className="relative z-10 p-6 pb-8">
                    {/* Header */}
                    <div className="flex items-center justify-between mb-6">
                      <div className="flex items-center gap-3">
                        <div className="w-11 h-11 rounded-[16px] bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-lg">
                          <Edit3 className="w-5 h-5 text-white" />
                        </div>
                        <div>
                          <h2 className={`text-xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                            Edit Journal Entry
                          </h2>
                          <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                            {entry.date}
                          </p>
                        </div>
                      </div>

                      <motion.button
                        whileHover={{ scale: 1.1, rotate: 90 }}
                        whileTap={{ scale: 0.9 }}
                        onClick={() => setEditMode(false)}
                        className={`w-10 h-10 rounded-[16px] ${
                          isDark ? "bg-white/10 border border-white/20" : "bg-white border border-gray-200"
                        } backdrop-blur-xl flex items-center justify-center shadow-lg`}
                      >
                        <X className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                      </motion.button>
                    </div>

                    {/* Mood Selector */}
                    <div className="mb-5">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3 block`}>
                        How are you feeling?
                      </label>
                      <div className="flex gap-2 flex-wrap">
                        {Object.entries(moodEmojis).map(([mood, emoji]) => (
                          <motion.button
                            key={mood}
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.95 }}
                            onClick={() => setSelectedMood(mood)}
                            className={`px-4 py-3 rounded-[16px] text-2xl flex items-center gap-2 transition-all ${
                              selectedMood === mood
                                ? "bg-gradient-to-r from-orange-500 to-pink-600 shadow-lg scale-105"
                                : isDark 
                                ? "bg-white/5 border border-white/10 hover:bg-white/10" 
                                : "bg-gray-50 border border-gray-200 hover:bg-gray-100"
                            } backdrop-blur-xl`}
                          >
                            <span>{emoji}</span>
                            {selectedMood === mood && (
                              <span className={`text-xs font-bold capitalize ${selectedMood === mood ? "text-white" : isDark ? "text-white/70" : "text-gray-600"}`}>
                                {mood}
                              </span>
                            )}
                          </motion.button>
                        ))}
                      </div>
                    </div>

                    {/* Title Input */}
                    <div className="mb-5">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                        Title
                      </label>
                      <input
                        type="text"
                        value={editTitle}
                        onChange={(e) => setEditTitle(e.target.value)}
                        placeholder="Enter journal title..."
                        className={`w-full px-4 py-3.5 rounded-[20px] text-base font-bold ${
                          isDark 
                            ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                            : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                        } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all`}
                      />
                    </div>

                    {/* Content Textarea */}
                    <div className="mb-5">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                        Content
                      </label>
                      <textarea
                        value={editContent}
                        onChange={(e) => setEditContent(e.target.value)}
                        placeholder="Write your thoughts..."
                        rows={12}
                        className={`w-full px-4 py-4 rounded-[20px] text-base leading-relaxed resize-none ${
                          isDark 
                            ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                            : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                        } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all font-scripture`}
                        style={{ fontFamily: "'Crimson Text', serif" }}
                      />
                    </div>

                    {/* Tags Section */}
                    <div className="mb-8">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3 block`}>
                        Tags
                      </label>
                      
                      {/* Existing Tags */}
                      <div className="flex flex-wrap gap-2 mb-3">
                        {editTags.map((tag, i) => (
                          <motion.div
                            key={i}
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            exit={{ scale: 0 }}
                            className={`flex items-center gap-2 px-3 py-2 rounded-[14px] ${
                              isDark 
                                ? "bg-white/10 text-white/80 border border-white/20" 
                                : "bg-gray-100 text-gray-700 border border-gray-200"
                            } backdrop-blur-xl`}
                          >
                            <span className="text-xs font-bold">#{tag}</span>
                            <button
                              onClick={() => setEditTags(editTags.filter((_, idx) => idx !== i))}
                              className={`w-4 h-4 rounded-full ${
                                isDark ? "bg-white/20 hover:bg-white/30" : "bg-gray-200 hover:bg-gray-300"
                              } flex items-center justify-center transition-colors`}
                            >
                              <X className="w-3 h-3" />
                            </button>
                          </motion.div>
                        ))}
                      </div>

                      {/* Add New Tag */}
                      <div className="flex gap-2">
                        <input
                          type="text"
                          value={newTag}
                          onChange={(e) => setNewTag(e.target.value)}
                          onKeyDown={(e) => {
                            if (e.key === 'Enter' && newTag.trim()) {
                              setEditTags([...editTags, newTag.trim()]);
                              setNewTag("");
                            }
                          }}
                          placeholder="Add a tag..."
                          className={`flex-1 px-4 py-2.5 rounded-[14px] text-sm ${
                            isDark 
                              ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                              : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                          } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 transition-all`}
                        />
                        <motion.button
                          whileHover={{ scale: 1.05 }}
                          whileTap={{ scale: 0.95 }}
                          onClick={() => {
                            if (newTag.trim()) {
                              setEditTags([...editTags, newTag.trim()]);
                              setNewTag("");
                            }
                          }}
                          className="px-4 py-2.5 rounded-[14px] bg-gradient-to-r from-orange-500 to-pink-600 text-white font-bold text-sm shadow-lg"
                        >
                          <Plus className="w-4 h-4" />
                        </motion.button>
                      </div>
                    </div>

                    {/* Action Buttons */}
                    <div className="grid grid-cols-2 gap-3">
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => setEditMode(false)}
                        className={`px-5 py-4 rounded-[20px] font-bold ${
                          isDark 
                            ? "bg-white/10 text-white border border-white/20" 
                            : "bg-gray-100 text-gray-900 border border-gray-200"
                        } backdrop-blur-xl shadow-lg`}
                      >
                        Cancel
                      </motion.button>
                      
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => {
                          // Save logic here
                          setEditMode(false);
                        }}
                        className="px-5 py-4 rounded-[20px] bg-gradient-to-r from-orange-500 via-pink-600 to-purple-600 text-white font-bold shadow-xl"
                      >
                        <div className="flex items-center justify-center gap-2">
                          <CheckCircle2 className="w-5 h-5" />
                          Save Changes
                        </div>
                      </motion.button>
                    </div>
                  </div>
                </div>
              </motion.div>
            </>
          );
        })()}
      </AnimatePresence>

      {/* Follow Up Entry Modal */}
      <AnimatePresence>
        {followUpMode && selectedEntry !== null && (() => {
          const entry = journalEntries.find(e => e.id === selectedEntry);
          if (!entry) return null;
          
          return (
            <>
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="fixed inset-0 bg-black/70 backdrop-blur-md z-[1001]"
                onClick={() => setFollowUpMode(false)}
              />

              <motion.div
                initial={{ opacity: 0, scale: 0.95, y: 50 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.95, y: 50 }}
                transition={{ type: "spring", damping: 30, stiffness: 300 }}
                className="fixed inset-x-4 top-16 bottom-32 z-[1002] overflow-hidden"
              >
                <div className={`h-full rounded-[32px] ${
                  isDark ? "bg-gray-900/98 border border-white/10" : "bg-white/98 border border-gray-200"
                } backdrop-blur-2xl shadow-2xl overflow-y-auto relative`}>
                  
                  {/* Gradient Background */}
                  <div className="absolute inset-0 bg-gradient-to-br from-orange-500/10 via-pink-500/10 to-purple-500/10 pointer-events-none" />
                  
                  <div className="relative z-10 p-6 pb-8">
                    {/* Header */}
                    <div className="flex items-center justify-between mb-6">
                      <div className="flex items-center gap-3">
                        <div className="w-11 h-11 rounded-[16px] bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-lg">
                          <Pen className="w-5 h-5 text-white" />
                        </div>
                        <div>
                          <h2 className={`text-xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                            Follow Up Entry
                          </h2>
                          <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                            Continuing from "{entry.title}"
                          </p>
                        </div>
                      </div>

                      <motion.button
                        whileHover={{ scale: 1.1, rotate: 90 }}
                        whileTap={{ scale: 0.9 }}
                        onClick={() => setFollowUpMode(false)}
                        className={`w-10 h-10 rounded-[16px] ${
                          isDark ? "bg-white/10 border border-white/20" : "bg-white border border-gray-200"
                        } backdrop-blur-xl flex items-center justify-center shadow-lg`}
                      >
                        <X className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                      </motion.button>
                    </div>

                    {/* Original Entry Reference */}
                    <div className={`mb-6 p-4 rounded-[20px] ${
                      isDark ? "bg-white/5 border border-white/10" : "bg-gray-50 border border-gray-200"
                    } backdrop-blur-xl`}>
                      <div className="flex items-start gap-3">
                        <div className={`w-8 h-8 rounded-[12px] bg-gradient-to-br ${entry.accentColor} flex items-center justify-center shadow-md flex-shrink-0`}>
                          <BookOpen className="w-4 h-4 text-white" />
                        </div>
                        <div className="flex-1 min-w-0">
                          <p className={`text-xs font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-1`}>
                            Original Entry
                          </p>
                          <h4 className={`text-sm font-black ${isDark ? "text-white" : "text-gray-900"} mb-2`}>
                            {entry.title}
                          </h4>
                          <p className={`text-xs leading-relaxed ${isDark ? "text-white/60" : "text-gray-600"} line-clamp-2 font-scripture`} style={{ fontFamily: "'Crimson Text', serif" }}>
                            {entry.content}
                          </p>
                        </div>
                      </div>
                    </div>

                    {/* Mood Selector */}
                    <div className="mb-5">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3 block`}>
                        How are you feeling now?
                      </label>
                      <div className="flex gap-2 flex-wrap">
                        {Object.entries(moodEmojis).map(([mood, emoji]) => (
                          <motion.button
                            key={mood}
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.95 }}
                            onClick={() => setSelectedMood(mood)}
                            className={`px-4 py-3 rounded-[16px] text-2xl flex items-center gap-2 transition-all ${
                              selectedMood === mood
                                ? "bg-gradient-to-r from-orange-500 to-pink-600 shadow-lg scale-105"
                                : isDark 
                                ? "bg-white/5 border border-white/10 hover:bg-white/10" 
                                : "bg-gray-50 border border-gray-200 hover:bg-gray-100"
                            } backdrop-blur-xl`}
                          >
                            <span>{emoji}</span>
                            {selectedMood === mood && (
                              <span className={`text-xs font-bold capitalize ${selectedMood === mood ? "text-white" : isDark ? "text-white/70" : "text-gray-600"}`}>
                                {mood}
                              </span>
                            )}
                          </motion.button>
                        ))}
                      </div>
                    </div>

                    {/* New Title Input (Optional) */}
                    <div className="mb-5">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                        Title (Optional)
                      </label>
                      <input
                        type="text"
                        value={editTitle}
                        onChange={(e) => setEditTitle(e.target.value)}
                        placeholder="Enter a title for this follow-up..."
                        className={`w-full px-4 py-3.5 rounded-[20px] text-base font-bold ${
                          isDark 
                            ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                            : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                        } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all`}
                      />
                    </div>

                    {/* Content Textarea */}
                    <div className="mb-5">
                      <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                        Your Thoughts
                      </label>
                      <textarea
                        value={editContent}
                        onChange={(e) => setEditContent(e.target.value)}
                        placeholder="What new insights or reflections do you have?"
                        rows={12}
                        className={`w-full px-4 py-4 rounded-[20px] text-base leading-relaxed resize-none ${
                          isDark 
                            ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                            : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                        } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all font-scripture`}
                        style={{ fontFamily: "'Crimson Text', serif" }}
                      />
                    </div>

                    {/* Context Info */}
                    <div className={`mb-6 p-4 rounded-[18px] ${
                      isDark ? "bg-blue-500/10 border border-blue-400/30" : "bg-blue-50 border border-blue-200"
                    } backdrop-blur-xl`}>
                      <div className="flex items-center gap-2 mb-2">
                        <Target className={`w-4 h-4 ${isDark ? "text-blue-400" : "text-blue-600"}`} />
                        <p className={`text-xs font-bold ${isDark ? "text-blue-400" : "text-blue-600"}`}>
                          Linked Context
                        </p>
                      </div>
                      <p className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                        This follow-up will be linked to the same context: <span className="font-bold">{entry.context}</span>
                      </p>
                    </div>

                    {/* Action Buttons */}
                    <div className="grid grid-cols-2 gap-3">
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => setFollowUpMode(false)}
                        className={`px-5 py-4 rounded-[20px] font-bold ${
                          isDark 
                            ? "bg-white/10 text-white border border-white/20" 
                            : "bg-gray-100 text-gray-900 border border-gray-200"
                        } backdrop-blur-xl shadow-lg`}
                      >
                        Cancel
                      </motion.button>
                      
                      <motion.button
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => {
                          if (editContent.trim()) {
                            const now = new Date();
                            const timeStr = now.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
                            const dateStr = `Today, ${timeStr}`;
                            
                            setJournalEntries(prevEntries =>
                              prevEntries.map(e =>
                                e.id === selectedEntry
                                  ? {
                                      ...e,
                                      followUps: [
                                        ...e.followUps,
                                        {
                                          date: dateStr,
                                          content: editContent,
                                          mood: selectedMood
                                        }
                                      ]
                                    }
                                  : e
                              )
                            );
                            setEditContent("");
                            setFollowUpMode(false);
                          }
                        }}
                        className="px-5 py-4 rounded-[20px] bg-gradient-to-r from-orange-500 via-pink-600 to-purple-600 text-white font-bold shadow-xl"
                      >
                        <div className="flex items-center justify-center gap-2">
                          <CheckCircle2 className="w-5 h-5" />
                          Save Follow Up
                        </div>
                      </motion.button>
                    </div>
                  </div>
                </div>
              </motion.div>
            </>
          );
        })()}
      </AnimatePresence>

      {/* AI Consent Modal */}
      <AnimatePresence>
        {showAIConsent && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[999]"
              onClick={() => setShowAIConsent(false)}
            />

            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 50 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 50 }}
              transition={{ type: "spring", damping: 25 }}
              className="fixed inset-x-6 top-1/2 -translate-y-1/2 z-[1000]"
            >
              <div className={`rounded-[32px] ${
                isDark ? "bg-gray-900/95 border border-white/10" : "bg-white/95 border border-gray-200"
              } backdrop-blur-xl shadow-2xl p-8 relative overflow-hidden`}>
                
                <motion.div
                  animate={{
                    scale: [1, 1.2, 1],
                    opacity: [0.2, 0.3, 0.2],
                  }}
                  transition={{
                    duration: 8,
                    repeat: Infinity,
                  }}
                  className="absolute top-0 right-0 w-64 h-64 rounded-full blur-3xl bg-gradient-to-br from-purple-500/30 via-pink-500/30 to-orange-500/30"
                />

                <div className="relative z-10">
                  <div className="w-16 h-16 rounded-[22px] bg-gradient-to-br from-purple-500 via-pink-600 to-fuchsia-600 flex items-center justify-center mb-6 shadow-2xl">
                    <Brain className="w-8 h-8 text-white" />
                  </div>

                  <h2 className={`text-2xl font-black mb-3 ${isDark ? "text-white" : "text-gray-900"}`}>
                    Enable AI Spiritual Mentor?
                  </h2>
                  <p className={`text-sm leading-relaxed mb-6 ${isDark ? "text-white/70" : "text-gray-600"}`}>
                    Your AI mentor will analyze your journal entries, reading history, and spiritual journey to provide personalized insights, reflection prompts, and scripture recommendations. All data stays private and is used solely to enhance your experience.
                  </p>

                  <div className="space-y-3 mb-8">
                    {[
                      { icon: Lightbulb, text: "Personalized reflection prompts based on your journals" },
                      { icon: BookOpen, text: "Scripture recommendations aligned with your journey" },
                      { icon: TrendingUp, text: "Track spiritual growth patterns and insights" },
                      { icon: Lock, text: "Your data remains private and secure" }
                    ].map((feature, index) => {
                      const Icon = feature.icon;
                      return (
                        <motion.div
                          key={index}
                          initial={{ opacity: 0, x: -20 }}
                          animate={{ opacity: 1, x: 0 }}
                          transition={{ delay: 0.1 + index * 0.05 }}
                          className="flex items-center gap-3"
                        >
                          <div className={`w-8 h-8 rounded-[12px] ${
                            isDark ? "bg-white/10" : "bg-gray-100"
                          } flex items-center justify-center flex-shrink-0`}>
                            <Icon className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                          </div>
                          <p className={`text-sm ${isDark ? "text-white/80" : "text-gray-700"}`}>
                            {feature.text}
                          </p>
                        </motion.div>
                      );
                    })}
                  </div>

                  <div className="flex gap-3">
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => setShowAIConsent(false)}
                      className={`flex-1 py-4 rounded-[20px] font-bold ${
                        isDark ? "bg-white/10 text-white border border-white/20" : "bg-gray-100 text-gray-900 border border-gray-200"
                      } backdrop-blur-xl`}
                    >
                      Not Now
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={enableAI}
                      className="flex-1 py-4 rounded-[20px] bg-gradient-to-r from-purple-500 via-pink-600 to-fuchsia-600 text-white font-bold shadow-xl"
                    >
                      Enable AI Mentor
                    </motion.button>
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* New Journal Entry Modal */}
      <AnimatePresence>
        {showNewEntry && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/70 backdrop-blur-md z-[1001]"
              onClick={() => setShowNewEntry(false)}
            />

            <motion.div
              initial={{ opacity: 0, scale: 0.95, y: 50 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 50 }}
              transition={{ type: "spring", damping: 30, stiffness: 300 }}
              className="fixed inset-x-4 top-16 bottom-32 z-[1002] overflow-hidden"
            >
              <div className={`h-full rounded-[32px] ${
                isDark ? "bg-gray-900/98 border border-white/10" : "bg-white/98 border border-gray-200"
              } backdrop-blur-2xl shadow-2xl overflow-y-auto relative`}>
                
                {/* Animated Gradient Background */}
                <motion.div
                  animate={{
                    scale: [1, 1.2, 1],
                    opacity: [0.15, 0.25, 0.15],
                  }}
                  transition={{
                    duration: 8,
                    repeat: Infinity,
                    ease: "easeInOut"
                  }}
                  className="absolute top-0 right-0 w-96 h-96 rounded-full blur-3xl bg-gradient-to-br from-orange-500/40 via-pink-600/40 to-purple-600/40 pointer-events-none"
                />
                
                <div className="relative z-10 p-6 pb-8">
                  {/* Header */}
                  <div className="flex items-center justify-between mb-6">
                    <div className="flex items-center gap-3">
                      <motion.div
                        animate={{
                          rotate: [0, 5, -5, 0],
                        }}
                        transition={{
                          duration: 3,
                          repeat: Infinity,
                          ease: "easeInOut"
                        }}
                        className="w-11 h-11 rounded-[16px] bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-lg"
                      >
                        <Pen className="w-5 h-5 text-white" />
                      </motion.div>
                      <div>
                        <h2 className={`text-xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                          New Journal Entry
                        </h2>
                        <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                          {new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'short', day: 'numeric' })}
                        </p>
                      </div>
                    </div>

                    <motion.button
                      whileHover={{ scale: 1.1, rotate: 90 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setShowNewEntry(false)}
                      className={`w-10 h-10 rounded-[16px] ${
                        isDark ? "bg-white/10 border border-white/20" : "bg-white border border-gray-200"
                      } backdrop-blur-xl flex items-center justify-center shadow-lg`}
                    >
                      <X className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                  </div>

                  {/* Title Input */}
                  <div className="mb-5">
                    <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                      Title
                    </label>
                    <input
                      type="text"
                      value={editTitle}
                      onChange={(e) => setEditTitle(e.target.value)}
                      placeholder="What's on your heart?"
                      className={`w-full px-4 py-3.5 rounded-[20px] text-base font-bold ${
                        isDark 
                          ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                          : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                      } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all`}
                    />
                  </div>

                  {/* Mood Selector */}
                  <div className="mb-5">
                    <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-3 block`}>
                      How are you feeling?
                    </label>
                    <div className="flex gap-2 flex-wrap">
                      {Object.entries(moodEmojis).map(([mood, emoji]) => (
                        <motion.button
                          key={mood}
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.95 }}
                          onClick={() => setSelectedMood(mood)}
                          className={`px-4 py-3 rounded-[16px] text-2xl flex items-center gap-2 transition-all ${
                            selectedMood === mood
                              ? "bg-gradient-to-r from-orange-500 to-pink-600 shadow-lg scale-105"
                              : isDark 
                              ? "bg-white/5 border border-white/10 hover:bg-white/10" 
                              : "bg-gray-50 border border-gray-200 hover:bg-gray-100"
                          } backdrop-blur-xl`}
                        >
                          <span>{emoji}</span>
                          {selectedMood === mood && (
                            <span className={`text-xs font-bold capitalize ${selectedMood === mood ? "text-white" : isDark ? "text-white/70" : "text-gray-600"}`}>
                              {mood}
                            </span>
                          )}
                        </motion.button>
                      ))}
                    </div>
                  </div>

                  {/* Content Textarea */}
                  <div className="mb-5">
                    <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                      Your Thoughts
                    </label>
                    <textarea
                      value={editContent}
                      onChange={(e) => setEditContent(e.target.value)}
                      placeholder="Pour out your heart to God..."
                      rows={14}
                      className={`w-full px-4 py-4 rounded-[20px] text-base leading-relaxed resize-none ${
                        isDark 
                          ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                          : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                      } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all font-scripture`}
                      style={{ fontFamily: "'Crimson Text', serif" }}
                    />
                  </div>

                  {/* Tags Input */}
                  <div className="mb-5">
                    <label className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider mb-2 block`}>
                      Tags (Optional)
                    </label>
                    <div className="flex flex-wrap gap-2 mb-3">
                      {editTags.map((tag, i) => (
                        <motion.div
                          key={i}
                          initial={{ scale: 0 }}
                          animate={{ scale: 1 }}
                          exit={{ scale: 0 }}
                          className={`flex items-center gap-2 px-3 py-2 rounded-[14px] ${
                            isDark 
                              ? "bg-white/10 text-white/80 border border-white/20" 
                              : "bg-gray-100 text-gray-700 border border-gray-200"
                          } backdrop-blur-xl`}
                        >
                          <span className="text-xs font-bold">#{tag}</span>
                          <button
                            onClick={() => setEditTags(editTags.filter((_, index) => index !== i))}
                            className={`hover:bg-white/20 rounded-full p-0.5 transition-colors`}
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </motion.div>
                      ))}
                    </div>
                    <div className="flex gap-2">
                      <input
                        type="text"
                        value={newTag}
                        onChange={(e) => setNewTag(e.target.value)}
                        onKeyDown={(e) => {
                          if (e.key === 'Enter' && newTag.trim()) {
                            setEditTags([...editTags, newTag.trim()]);
                            setNewTag("");
                          }
                        }}
                        placeholder="Add a tag..."
                        className={`flex-1 px-4 py-2.5 rounded-[16px] text-sm ${
                          isDark 
                            ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30" 
                            : "bg-gray-50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                        } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/40 focus:border-orange-500/40 transition-all`}
                      />
                      <motion.button
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                        onClick={() => {
                          if (newTag.trim()) {
                            setEditTags([...editTags, newTag.trim()]);
                            setNewTag("");
                          }
                        }}
                        className="px-4 py-2.5 rounded-[16px] bg-gradient-to-r from-orange-500 to-pink-600 text-white text-sm font-bold shadow-lg"
                      >
                        <Plus className="w-4 h-4" />
                      </motion.button>
                    </div>
                  </div>

                  {/* Privacy & AI Toggle Section */}
                  <div className="grid grid-cols-2 gap-3 mb-6">
                    {/* Privacy Toggle */}
                    <div className={`p-4 rounded-[20px] ${
                      isDark ? "bg-white/5 border border-white/10" : "bg-gray-50 border border-gray-200"
                    } backdrop-blur-xl`}>
                      <div className="flex items-center justify-between mb-2">
                        <Lock className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        <motion.button
                          whileTap={{ scale: 0.95 }}
                          onClick={() => {
                            if (!isPrivate) {
                              setIsPrivate(true);
                              setHasAIInsights(false);
                            } else {
                              setIsPrivate(false);
                            }
                          }}
                          className={`relative w-11 h-6 rounded-full flex-shrink-0 transition-colors ${
                            isPrivate 
                              ? "bg-gradient-to-r from-purple-500 to-pink-600" 
                              : isDark ? "bg-white/10" : "bg-gray-300"
                          }`}
                        >
                          <motion.div
                            animate={{ x: isPrivate ? 20 : 2 }}
                            transition={{ type: "spring", stiffness: 500, damping: 30 }}
                            className="absolute top-1 w-4 h-4 rounded-full bg-white shadow-lg"
                          />
                        </motion.button>
                      </div>
                      <p className={`text-[10px] font-bold ${isDark ? "text-white/50" : "text-gray-500"}`}>
                        Private Entry
                      </p>
                    </div>

                    {/* AI Insights Toggle */}
                    <div className={`p-4 rounded-[20px] ${
                      isDark ? "bg-purple-500/10 border border-purple-400/30" : "bg-purple-50 border border-purple-200"
                    } backdrop-blur-xl`}>
                      <div className="flex items-center justify-between mb-2">
                        <Sparkles className={`w-4 h-4 ${isDark ? "text-purple-400" : "text-purple-600"}`} />
                        <motion.button
                          whileTap={{ scale: 0.95 }}
                          onClick={() => {
                            if (!hasAIInsights) {
                              setHasAIInsights(true);
                              setIsPrivate(false);
                            } else {
                              setHasAIInsights(false);
                            }
                          }}
                          className={`relative w-11 h-6 rounded-full flex-shrink-0 transition-colors ${
                            hasAIInsights 
                              ? "bg-gradient-to-r from-purple-500 to-pink-600" 
                              : isDark ? "bg-white/10" : "bg-gray-300"
                          }`}
                        >
                          <motion.div
                            animate={{ x: hasAIInsights ? 20 : 2 }}
                            transition={{ type: "spring", stiffness: 500, damping: 30 }}
                            className="absolute top-1 w-4 h-4 rounded-full bg-white shadow-lg"
                          />
                        </motion.button>
                      </div>
                      <p className={`text-[10px] font-bold ${isDark ? "text-purple-400" : "text-purple-600"}`}>
                        AI Insights
                      </p>
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className="grid grid-cols-2 gap-3">
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => {
                        setShowNewEntry(false);
                        setEditTitle("");
                        setEditContent("");
                        setEditTags([]);
                        setSelectedMood("peaceful");
                        setIsPrivate(false);
                        setHasAIInsights(true);
                      }}
                      className={`px-5 py-4 rounded-[20px] font-bold ${
                        isDark 
                          ? "bg-white/10 text-white border border-white/20" 
                          : "bg-gray-100 text-gray-900 border border-gray-200"
                      } backdrop-blur-xl shadow-lg`}
                    >
                      Cancel
                    </motion.button>
                    
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => {
                        if (editTitle.trim() && editContent.trim()) {
                          // Generate timestamp
                          const now = new Date();
                          const timeStr = now.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' });
                          const dateStr = `Today, ${timeStr}`;
                          
                          // Generate mood-based gradients
                          const moodGradients = {
                            peaceful: {
                              gradient: "from-emerald-500/20 via-green-600/15 to-teal-600/20",
                              borderColor: "border-emerald-400/40",
                              accentColor: "from-emerald-500 to-teal-600"
                            },
                            joyful: {
                              gradient: "from-amber-500/20 via-orange-600/15 to-red-600/20",
                              borderColor: "border-amber-400/40",
                              accentColor: "from-amber-500 to-red-600"
                            },
                            contemplative: {
                              gradient: "from-violet-500/20 via-purple-600/15 to-fuchsia-600/20",
                              borderColor: "border-violet-400/40",
                              accentColor: "from-violet-500 to-fuchsia-600"
                            },
                            grateful: {
                              gradient: "from-rose-500/20 via-pink-600/15 to-purple-600/20",
                              borderColor: "border-rose-400/40",
                              accentColor: "from-rose-500 to-purple-600"
                            },
                            struggling: {
                              gradient: "from-slate-500/20 via-gray-600/15 to-zinc-600/20",
                              borderColor: "border-slate-400/40",
                              accentColor: "from-slate-500 to-zinc-600"
                            },
                            hopeful: {
                              gradient: "from-blue-500/20 via-indigo-600/15 to-purple-600/20",
                              borderColor: "border-blue-400/40",
                              accentColor: "from-blue-500 to-purple-600"
                            }
                          };
                          
                          const selectedGradient = moodGradients[selectedMood as keyof typeof moodGradients] || moodGradients.peaceful;
                          
                          // Create new journal entry
                          const newEntry = {
                            id: journalEntries.length > 0 ? Math.max(...journalEntries.map(e => e.id)) + 1 : 1,
                            date: dateStr,
                            title: editTitle.trim(),
                            content: editContent.trim(),
                            tags: editTags,
                            verse: "",
                            book: "",
                            chapter: "",
                            context: "",
                            contextType: "scripture" as const,
                            mood: selectedMood,
                            isPrivate: isPrivate,
                            aiInsights: hasAIInsights,
                            gradient: selectedGradient.gradient,
                            borderColor: selectedGradient.borderColor,
                            accentColor: selectedGradient.accentColor,
                            followUps: [] as Array<{date: string, content: string, mood: string}>
                          };
                          
                          // Add to beginning of journal entries array
                          setJournalEntries([newEntry, ...journalEntries]);
                          
                          // Reset form
                          setShowNewEntry(false);
                          setEditTitle("");
                          setEditContent("");
                          setEditTags([]);
                          setSelectedMood("peaceful");
                          setIsPrivate(false);
                          setHasAIInsights(true);
                        }
                      }}
                      className="px-5 py-4 rounded-[20px] bg-gradient-to-r from-orange-500 via-pink-600 to-purple-600 text-white font-bold shadow-xl"
                    >
                      <div className="flex items-center justify-center gap-2">
                        <CheckCircle2 className="w-5 h-5" />
                        Save Entry
                      </div>
                    </motion.button>
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  );
}