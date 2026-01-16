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

  const stats = [
    { label: "Total\nEntries", value: "127", icon: BookOpen, color: "from-orange-500 via-pink-600 to-red-600" },
    { label: "This\nWeek", value: "7", icon: Calendar, color: "from-purple-500 via-pink-600 to-fuchsia-600" },
    { label: "Day\nStreak", value: "12", icon: Flame, color: "from-amber-500 via-orange-600 to-red-600" },
    { label: "AI\nInsights", value: "24", icon: Sparkles, color: "from-blue-500 via-purple-600 to-pink-600" }
  ];

  const journalEntries = [
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
      accentColor: "from-emerald-500 to-teal-600"
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
      accentColor: "from-violet-500 to-fuchsia-600"
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
      accentColor: "from-amber-500 to-red-600"
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
      context: "Isaiah 40",
      contextType: "scripture" as const,
      mood: "hopeful",
      isPrivate: false,
      aiInsights: true,
      gradient: "from-blue-500/20 via-indigo-600/15 to-purple-600/20",
      borderColor: "border-blue-400/40",
      accentColor: "from-blue-500 to-purple-600"
    }
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
        {/* Creative Hero Section */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-6 relative"
        >
          {/* Glassmorphic Hero Container */}
          <div className={`rounded-[36px] ${
            isDark ? "bg-gradient-to-br from-white/10 via-white/5 to-white/10" : "bg-gradient-to-br from-white/90 via-orange-50/50 to-pink-50/50"
          } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-white/60"} shadow-2xl p-7 relative overflow-hidden`}>
            
            {/* Floating Orb Decorations */}
            <motion.div
              animate={{
                x: [0, 30, 0],
                y: [0, -20, 0],
                scale: [1, 1.1, 1],
                opacity: [0.3, 0.5, 0.3],
              }}
              transition={{
                duration: 12,
                repeat: Infinity,
                ease: "easeInOut"
              }}
              className={`absolute -top-12 -right-12 w-48 h-48 rounded-full ${
                isDark 
                  ? "bg-gradient-to-br from-orange-500/30 via-pink-600/30 to-purple-600/30" 
                  : "bg-gradient-to-br from-orange-400/40 via-pink-500/40 to-purple-500/40"
              } blur-3xl`}
            />
            <motion.div
              animate={{
                x: [0, -20, 0],
                y: [0, 30, 0],
                scale: [1, 1.2, 1],
                opacity: [0.2, 0.4, 0.2],
              }}
              transition={{
                duration: 15,
                repeat: Infinity,
                ease: "easeInOut"
              }}
              className={`absolute -bottom-8 -left-8 w-40 h-40 rounded-full ${
                isDark 
                  ? "bg-gradient-to-tr from-purple-500/30 via-fuchsia-600/30 to-pink-600/30" 
                  : "bg-gradient-to-tr from-purple-400/40 via-fuchsia-500/40 to-pink-500/40"
              } blur-3xl`}
            />

            <div className="relative z-10">
              {/* Top Bar: User Profile & Tab Switcher */}
              <div className="flex items-center justify-between mb-7">
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

                {/* Tab Switcher */}
                <motion.div
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.2 }}
                  className={`flex gap-1 p-1.5 rounded-[18px] ${
                    isDark ? "bg-black/30 border border-white/20" : "bg-white/80 border border-gray-200 shadow-xl"
                  } backdrop-blur-2xl`}
                >
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => setActiveTab("journals")}
                    className={`relative px-4 py-2 rounded-[14px] text-xs font-bold transition-all ${
                      activeTab === "journals"
                        ? "text-white"
                        : isDark ? "text-white/50" : "text-gray-500"
                    }`}
                  >
                    {activeTab === "journals" && (
                      <motion.div
                        layoutId="activeTab"
                        className="absolute inset-0 bg-gradient-to-r from-orange-500 to-pink-600 rounded-[14px] shadow-lg"
                        transition={{ type: "spring", stiffness: 400, damping: 30 }}
                      />
                    )}
                    <span className="relative z-10 flex items-center gap-1.5">
                      <BookOpen className="w-3.5 h-3.5" />
                      Journals
                    </span>
                  </motion.button>
                  
                  <motion.button
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    onClick={() => {
                      if (!aiEnabled) {
                        setShowAIConsent(true);
                      } else {
                        setActiveTab("mentor");
                      }
                    }}
                    className={`relative px-4 py-2 rounded-[14px] text-xs font-bold transition-all ${
                      activeTab === "mentor"
                        ? "text-white"
                        : isDark ? "text-white/50" : "text-gray-500"
                    }`}
                  >
                    {activeTab === "mentor" && (
                      <motion.div
                        layoutId="activeTab"
                        className="absolute inset-0 bg-gradient-to-r from-purple-500 to-pink-600 rounded-[14px] shadow-lg"
                        transition={{ type: "spring", stiffness: 400, damping: 30 }}
                      />
                    )}
                    <span className="relative z-10 flex items-center gap-1.5">
                      <Bot className="w-3.5 h-3.5" />
                      AI
                      {!aiEnabled && (
                        <motion.div
                          animate={{ scale: [1, 1.2, 1] }}
                          transition={{ duration: 1.5, repeat: Infinity }}
                          className="w-1.5 h-1.5 rounded-full bg-pink-500"
                        />
                      )}
                    </span>
                  </motion.button>
                </motion.div>
              </div>

              {/* Title Section */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.15 }}
                className="mb-7"
              >
                <div className="flex items-center gap-3">
                  {/* Animated Icon Badge */}
                  <motion.div
                    animate={{
                      rotate: [0, 5, -5, 0],
                    }}
                    transition={{
                      duration: 6,
                      repeat: Infinity,
                      ease: "easeInOut"
                    }}
                    className="w-12 h-12 rounded-[16px] bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-xl relative"
                  >
                    <Pen className="w-6 h-6 text-white" />
                    <motion.div
                      animate={{
                        scale: [1, 1.2, 1],
                        opacity: [0.5, 0, 0.5],
                      }}
                      transition={{
                        duration: 2,
                        repeat: Infinity,
                      }}
                      className="absolute inset-0 rounded-[16px] bg-gradient-to-br from-orange-500 to-pink-600"
                    />
                  </motion.div>

                  <div>
                    <h1 className={`text-2xl font-black leading-tight ${
                      isDark ? "text-white" : "text-gray-900"
                    }`}>
                      <span className="bg-gradient-to-r from-orange-500 via-pink-600 to-purple-600 bg-clip-text text-transparent">
                        Spiritual
                      </span>{" "}
                      <span className={isDark ? "text-white" : "text-gray-900"}>Mentor</span>
                    </h1>
                    <p className={`text-xs font-medium mt-0.5 ${isDark ? "text-white/60" : "text-gray-600"}`}>
                      {activeTab === "journals" ? "Your journey with God" : "AI-powered guidance"}
                    </p>
                  </div>
                </div>
              </motion.div>

              {/* Stats Container - 2x2 Grid */}
              {activeTab === "journals" && (
                <motion.div
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.25 }}
                  className={`rounded-[24px] ${
                    isDark ? "bg-black/20 border border-white/10" : "bg-white/60 border border-gray-200 shadow-lg"
                  } backdrop-blur-xl p-4 mb-6`}
                >
                  <div className="grid grid-cols-2 gap-3">
                    {stats.map((stat, index) => {
                      const Icon = stat.icon;
                      return (
                        <motion.div
                          key={index}
                          initial={{ opacity: 0, scale: 0.8 }}
                          animate={{ opacity: 1, scale: 1 }}
                          transition={{
                            delay: 0.3 + index * 0.05,
                            type: "spring",
                            stiffness: 300,
                            damping: 20
                          }}
                          whileHover={{ scale: 1.03, y: -2 }}
                          whileTap={{ scale: 0.98 }}
                          className={`relative rounded-[18px] ${
                            isDark ? "bg-white/5" : "bg-white/80"
                          } backdrop-blur-xl p-3.5 overflow-hidden cursor-pointer group`}
                        >
                          {/* Animated Background Gradient */}
                          <motion.div
                            animate={{
                              rotate: [0, 360],
                              scale: [1, 1.2, 1],
                            }}
                            transition={{
                              duration: 20,
                              repeat: Infinity,
                              ease: "linear",
                              delay: index * 2,
                            }}
                            className={`absolute -top-4 -right-4 w-24 h-24 rounded-full bg-gradient-to-br ${stat.color} opacity-20 blur-2xl`}
                          />
                          
                          {/* Shine Effect */}
                          <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />

                          <div className="relative z-10 flex items-center gap-3">
                            {/* Icon with Pulse */}
                            <motion.div
                              animate={{
                                boxShadow: [
                                  "0 0 0 0 rgba(251, 146, 60, 0)",
                                  "0 0 0 6px rgba(251, 146, 60, 0.1)",
                                  "0 0 0 0 rgba(251, 146, 60, 0)"
                                ],
                              }}
                              transition={{
                                duration: 2,
                                repeat: Infinity,
                                delay: index * 0.3,
                              }}
                              className={`w-10 h-10 rounded-[13px] bg-gradient-to-br ${stat.color} flex items-center justify-center shadow-lg flex-shrink-0`}
                            >
                              <Icon className="w-5 h-5 text-white" />
                            </motion.div>

                            <div className="flex-1">
                              {/* Animated Number */}
                              <motion.p
                                initial={{ scale: 0, opacity: 0 }}
                                animate={{ scale: 1, opacity: 1 }}
                                transition={{
                                  delay: 0.45 + index * 0.05,
                                  type: "spring",
                                  stiffness: 400
                                }}
                                className={`text-2xl font-black leading-none mb-0.5 bg-gradient-to-r ${stat.color} bg-clip-text text-transparent`}
                              >
                                {stat.value}
                              </motion.p>

                              {/* Label */}
                              <p className={`text-[9px] font-bold ${
                                isDark ? "text-white/60" : "text-gray-600"
                              } uppercase tracking-wide leading-tight whitespace-pre-line`}>
                                {stat.label}
                              </p>
                            </div>
                          </div>
                        </motion.div>
                      );
                    })}
                  </div>
                </motion.div>
              )}

              {/* Search & Filter */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.35 }}
                className="flex gap-3"
              >
                <div className={`flex-1 ${
                  isDark ? "bg-black/20 border border-white/10" : "bg-white/60 border border-gray-200 shadow-lg"
                } backdrop-blur-xl rounded-[18px] p-3.5 flex items-center gap-3`}>
                  <Search className={`w-4.5 h-4.5 ${isDark ? "text-white/40" : "text-gray-400"}`} />
                  <input
                    type="text"
                    placeholder="Search your reflections..."
                    className={`flex-1 bg-transparent outline-none text-sm font-medium ${
                      isDark ? "text-white placeholder:text-white/40" : "text-gray-900 placeholder:text-gray-400"
                    }`}
                  />
                </div>
                <motion.button
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setShowFilterMenu(!showFilterMenu)}
                  className={`relative w-12 h-12 rounded-[16px] ${
                    isDark ? "bg-black/20 border border-white/10" : "bg-white/60 border border-gray-200 shadow-lg"
                  } backdrop-blur-xl flex items-center justify-center`}
                >
                  <Filter className={`w-4.5 h-4.5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                  {selectedFilter !== "all" && (
                    <div className="absolute -top-1 -right-1 w-3 h-3 rounded-full bg-gradient-to-br from-pink-500 to-red-600" />
                  )}
                </motion.button>
              </motion.div>
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
              } backdrop-blur-xl p-4`}>
                <div className="grid grid-cols-2 gap-2">
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

        {/* Content */}
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
              <div className="space-y-4">
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
                    
                    <div className="relative z-10 p-6">
                      {/* Header */}
                      <div className="flex items-start justify-between mb-4">
                        <div className="flex-1">
                          <div className="flex items-center gap-2 mb-2 flex-wrap">
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
                          
                          <h3 className={`text-xl font-black mb-2 leading-tight ${isDark ? "text-white" : "text-gray-900"}`}>
                            {entry.title}
                          </h3>
                        </div>

                        <div className="text-2xl flex-shrink-0 ml-4">
                          {moodEmojis[entry.mood]}
                        </div>
                      </div>

                      {/* Content Preview */}
                      <p className={`text-sm leading-relaxed mb-4 line-clamp-2 ${ isDark ? "text-white/70" : "text-gray-600"
                      } font-scripture`} style={{ fontFamily: "'Crimson Text', serif" }}>
                        {entry.content}
                      </p>

                      {/* Context Badge - Plan or Scripture */}
                      <div className="mb-4">
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
                      <div className="flex flex-wrap gap-2 mb-4">
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
                        <div className={`flex items-center justify-between gap-3 px-4 py-3 rounded-[20px] ${
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

                      {/* Quick Actions on Hover */}
                      <div className="absolute top-6 right-6 opacity-0 group-hover:opacity-100 transition-opacity flex gap-2">
                        <motion.button
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={(e) => {
                            e.stopPropagation();
                          }}
                          className={`w-9 h-9 rounded-[14px] ${
                            isDark ? "bg-white/10" : "bg-white"
                          } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-gray-200"} shadow-xl flex items-center justify-center`}
                        >
                          <Edit3 className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        </motion.button>
                        <motion.button
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={(e) => {
                            e.stopPropagation();
                          }}
                          className={`w-9 h-9 rounded-[14px] ${
                            isDark ? "bg-white/10" : "bg-white"
                          } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-gray-200"} shadow-xl flex items-center justify-center`}
                        >
                          <Heart className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        </motion.button>
                      </div>
                    </div>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          ) : (
            <motion.div
              key="mentor"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
              className="h-[calc(100vh-420px)]"
            >
              {/* AI Mentor Chat Interface */}
              <div className={`h-full rounded-[32px] ${
                isDark ? "bg-white/5 border border-white/10" : "bg-white border border-gray-200 shadow-2xl"
              } backdrop-blur-xl overflow-hidden flex flex-col`}>
                
                {/* AI Suggestions Header */}
                {chatMessages.length === 1 && (
                  <div className="p-6 space-y-3">
                    <h3 className={`text-sm font-bold ${isDark ? "text-white/70" : "text-gray-600"} uppercase tracking-wide mb-4`}>
                      💡 Suggested Topics
                    </h3>
                    {aiSuggestions.map((suggestion, index) => {
                      const Icon = suggestion.icon;
                      return (
                        <motion.div
                          key={index}
                          initial={{ opacity: 0, x: -20 }}
                          animate={{ opacity: 1, x: 0 }}
                          transition={{ delay: 0.1 + index * 0.1 }}
                          whileHover={{ scale: 1.02 }}
                          whileTap={{ scale: 0.98 }}
                          onClick={() => {
                            setChatInput(suggestion.content);
                          }}
                          className={`p-4 rounded-[20px] ${
                            isDark ? "bg-white/5 hover:bg-white/10" : "bg-gray-50 hover:bg-gray-100"
                          } border ${isDark ? "border-white/10" : "border-gray-200"} cursor-pointer transition-all`}
                        >
                          <div className="flex items-start gap-3">
                            <div className={`w-10 h-10 rounded-[14px] bg-gradient-to-br ${suggestion.color} flex items-center justify-center shadow-lg flex-shrink-0`}>
                              <Icon className="w-5 h-5 text-white" />
                            </div>
                            <div className="flex-1">
                              <h4 className={`text-sm font-bold mb-1 ${isDark ? "text-white" : "text-gray-900"}`}>
                                {suggestion.title}
                              </h4>
                              <p className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                                {suggestion.content}
                              </p>
                            </div>
                          </div>
                        </motion.div>
                      );
                    })}
                  </div>
                )}

                {/* Chat Messages */}
                <div className="flex-1 overflow-y-auto p-6 space-y-4">
                  {chatMessages.map((message, index) => (
                    <motion.div
                      key={index}
                      initial={{ opacity: 0, y: 20 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.1 }}
                      className={`flex ${message.role === "user" ? "justify-end" : "justify-start"}`}
                    >
                      <div className={`max-w-[80%] ${
                        message.role === "user"
                          ? "bg-gradient-to-r from-orange-500 to-pink-600 text-white"
                          : isDark ? "bg-white/10 border border-white/20" : "bg-gray-100 border border-gray-200"
                      } rounded-[24px] p-4 backdrop-blur-xl`}>
                        {message.role === "ai" && (
                          <div className="flex items-center gap-2 mb-2">
                            <div className="w-6 h-6 rounded-full bg-gradient-to-br from-purple-500 to-pink-600 flex items-center justify-center">
                              <Bot className="w-3.5 h-3.5 text-white" />
                            </div>
                            <span className={`text-xs font-bold ${isDark ? "text-white/70" : "text-gray-600"}`}>
                              AI Mentor
                            </span>
                          </div>
                        )}
                        <p className={`text-sm leading-relaxed ${
                          message.role === "user" ? "text-white" : isDark ? "text-white/90" : "text-gray-900"
                        }`}>
                          {message.content}
                        </p>
                        <p className={`text-xs mt-2 ${
                          message.role === "user" ? "text-white/60" : isDark ? "text-white/40" : "text-gray-500"
                        }`}>
                          {message.time}
                        </p>
                      </div>
                    </motion.div>
                  ))}

                  {/* Typing Indicator */}
                  {isTyping && (
                    <motion.div
                      initial={{ opacity: 0 }}
                      animate={{ opacity: 1 }}
                      className="flex justify-start"
                    >
                      <div className={`${
                        isDark ? "bg-white/10 border border-white/20" : "bg-gray-100 border border-gray-200"
                      } rounded-[24px] px-6 py-4 backdrop-blur-xl`}>
                        <div className="flex gap-2">
                          {[0, 1, 2].map((i) => (
                            <motion.div
                              key={i}
                              animate={{ scale: [1, 1.2, 1], opacity: [0.5, 1, 0.5] }}
                              transition={{ duration: 1, repeat: Infinity, delay: i * 0.2 }}
                              className={`w-2 h-2 rounded-full ${isDark ? "bg-white/50" : "bg-gray-400"}`}
                            />
                          ))}
                        </div>
                      </div>
                    </motion.div>
                  )}

                  <div ref={chatEndRef} />
                </div>

                {/* Quick Prompts */}
                {chatMessages.length > 1 && (
                  <div className={`px-6 py-3 border-t ${isDark ? "border-white/10" : "border-gray-200"}`}>
                    <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide">
                      {quickPrompts.map((prompt, index) => (
                        <motion.button
                          key={index}
                          whileHover={{ scale: 1.05 }}
                          whileTap={{ scale: 0.95 }}
                          onClick={() => setChatInput(prompt)}
                          className={`px-4 py-2 rounded-[14px] text-xs font-bold whitespace-nowrap ${
                            isDark ? "bg-white/5 text-white/70 border border-white/10" : "bg-gray-100 text-gray-700 border border-gray-200"
                          } backdrop-blur-xl`}
                        >
                          {prompt}
                        </motion.button>
                      ))}
                    </div>
                  </div>
                )}

                {/* Chat Input */}
                <div className={`p-4 border-t ${isDark ? "border-white/10" : "border-gray-200"}`}>
                  <div className={`flex gap-3 items-end ${
                    isDark ? "bg-white/5" : "bg-gray-50"
                  } rounded-[24px] p-4 border ${isDark ? "border-white/10" : "border-gray-200"}`}>
                    <textarea
                      value={chatInput}
                      onChange={(e) => setChatInput(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === "Enter" && !e.shiftKey) {
                          e.preventDefault();
                          handleSendMessage();
                        }
                      }}
                      placeholder="Ask about your spiritual journey..."
                      rows={1}
                      className={`flex-1 bg-transparent outline-none text-sm resize-none ${
                        isDark ? "text-white placeholder:text-white/40" : "text-gray-900 placeholder:text-gray-400"
                      }`}
                      style={{ maxHeight: "120px" }}
                    />
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={handleSendMessage}
                      disabled={!chatInput.trim()}
                      className={`w-11 h-11 rounded-[18px] flex items-center justify-center ${
                        chatInput.trim()
                          ? "bg-gradient-to-r from-purple-500 to-pink-600"
                          : isDark ? "bg-white/10" : "bg-gray-200"
                      } shadow-lg transition-all`}
                    >
                      <Send className={`w-5 h-5 ${
                        chatInput.trim() ? "text-white" : isDark ? "text-white/30" : "text-gray-400"
                      }`} />
                    </motion.button>
                  </div>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Floating New Entry Button - Only on Journals Tab */}
        {activeTab === "journals" && (
          <motion.button
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.5, type: "spring", stiffness: 300 }}
            whileHover={{ scale: 1.1, rotate: 90 }}
            whileTap={{ scale: 0.9 }}
            onClick={() => setShowNewEntry(!showNewEntry)}
            className="fixed bottom-36 right-6 w-16 h-16 rounded-[22px] bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-2xl z-30"
          >
            <Plus className={`w-7 h-7 text-white transition-transform ${showNewEntry ? "rotate-45" : ""}`} />
          </motion.button>
        )}
      </div>

      {/* AI Consent Modal */}
      <AnimatePresence>
        {showAIConsent && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[999]"
              onClick={() => setShowAIConsent(false)}
            />

            {/* Modal */}
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
                
                {/* Gradient Orb */}
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
                  {/* Icon */}
                  <div className="w-16 h-16 rounded-[22px] bg-gradient-to-br from-purple-500 via-pink-600 to-fuchsia-600 flex items-center justify-center mb-6 shadow-2xl">
                    <Brain className="w-8 h-8 text-white" />
                  </div>

                  {/* Content */}
                  <h2 className={`text-2xl font-black mb-3 ${isDark ? "text-white" : "text-gray-900"}`}>
                    Enable AI Spiritual Mentor?
                  </h2>
                  <p className={`text-sm leading-relaxed mb-6 ${isDark ? "text-white/70" : "text-gray-600"}`}>
                    Your AI mentor will analyze your journal entries, reading history, and spiritual journey to provide personalized insights, reflection prompts, and scripture recommendations. All data stays private and is used solely to enhance your experience.
                  </p>

                  {/* Features */}
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

                  {/* Actions */}
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

      {/* New Entry Modal */}
      <AnimatePresence>
        {showNewEntry && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[999]"
              onClick={() => setShowNewEntry(false)}
            />

            <motion.div
              initial={{ opacity: 0, y: 100 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 100 }}
              transition={{ type: "spring", damping: 25 }}
              className="fixed inset-x-6 bottom-6 top-32 z-[1000]"
            >
              <div className={`h-full rounded-[32px] ${
                isDark ? "bg-gray-900/95 border border-white/10" : "bg-white/95 border border-gray-200"
              } backdrop-blur-xl shadow-2xl overflow-hidden flex flex-col`}>
                
                {/* Header */}
                <div className={`px-6 py-5 border-b ${isDark ? "border-white/10" : "border-gray-200"}`}>
                  <div className="flex items-center justify-between">
                    <h3 className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                      New Journal Entry
                    </h3>
                    <motion.button
                      whileHover={{ scale: 1.05, rotate: 90 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setShowNewEntry(false)}
                      className={`w-9 h-9 rounded-full ${
                        isDark ? "bg-white/10" : "bg-gray-100"
                      } flex items-center justify-center`}
                    >
                      <X className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                    </motion.button>
                  </div>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-6">
                  <input
                    type="text"
                    placeholder="Give your entry a beautiful title..."
                    className={`w-full bg-transparent text-2xl font-black mb-5 outline-none ${
                      isDark ? "text-white placeholder:text-white/30" : "text-gray-900 placeholder:text-gray-400"
                    }`}
                  />
                  
                  <textarea
                    placeholder="Pour out your heart to God. He's listening..."
                    className={`w-full h-64 bg-transparent text-base leading-relaxed outline-none resize-none font-scripture mb-5 ${
                      isDark ? "text-white/90 placeholder:text-white/30" : "text-gray-900 placeholder:text-gray-400"
                    }`}
                    style={{ fontFamily: "'Crimson Text', serif" }}
                  />

                  {/* Action Bar */}
                  <div className={`flex items-center gap-3 pt-5 border-t ${isDark ? "border-white/10" : "border-gray-200"}`}>
                    {[
                      { icon: Mic, label: "Voice" },
                      { icon: Image, label: "Image" },
                      { icon: Smile, label: "Mood" },
                      { icon: Tag, label: "Tags" },
                      { icon: BookOpen, label: "Verse" }
                    ].map((action, index) => {
                      const Icon = action.icon;
                      return (
                        <motion.button
                          key={index}
                          whileHover={{ scale: 1.05, y: -2 }}
                          whileTap={{ scale: 0.95 }}
                          className={`p-3 rounded-[16px] ${
                            isDark ? "bg-white/5 hover:bg-white/10" : "bg-gray-100 hover:bg-gray-200"
                          } transition-all`}
                          title={action.label}
                        >
                          <Icon className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        </motion.button>
                      );
                    })}
                    
                    <div className="flex-1" />
                    
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      className="px-8 py-3.5 rounded-[20px] bg-gradient-to-r from-orange-500 via-pink-600 to-purple-600 text-white font-bold shadow-2xl"
                    >
                      Save Entry
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
