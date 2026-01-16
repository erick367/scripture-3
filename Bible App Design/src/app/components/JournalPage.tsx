import { motion, AnimatePresence } from "motion/react";
import { Plus, Calendar, Tag, Heart, Sparkles, BookOpen, Lock, Mic, Image, Smile, TrendingUp, MessageCircle, Search, Filter, MoreVertical, Edit3, Pen, ChevronRight } from "lucide-react";
import { useState } from "react";

interface JournalPageProps {
  timeOfDay: "morning" | "day" | "evening" | "night";
}

export function JournalPage({ timeOfDay }: JournalPageProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [showNewEntry, setShowNewEntry] = useState(false);
  const [selectedEntry, setSelectedEntry] = useState<number | null>(null);

  const stats = [
    { label: "Total Entries", value: "127", icon: BookOpen, color: "from-blue-500 via-cyan-600 to-teal-600" },
    { label: "This Month", value: "24", icon: Calendar, color: "from-purple-500 via-pink-600 to-fuchsia-600" },
    { label: "Day Streak", value: "12", icon: TrendingUp, color: "from-orange-500 via-red-600 to-pink-600" }
  ];

  const journalEntries = [
    {
      id: 1,
      date: "Today, 9:42 AM",
      title: "Morning Reflections on Grace",
      content: "Lord, today I'm overwhelmed by Your grace. As I read Ephesians 2:8-9, I'm reminded that salvation is Your gift, not something I can earn. Help me extend this same grace to others, especially when it's difficult. Let me be a vessel of Your unconditional love...",
      tags: ["Grace", "Gratitude", "Prayer"],
      verse: "Ephesians 2:8-9",
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
      mood: "joyful",
      isPrivate: false,
      aiInsights: true,
      gradient: "from-amber-500/20 via-orange-600/15 to-red-600/20",
      borderColor: "border-amber-400/40",
      accentColor: "from-amber-500 to-red-600"
    }
  ];

  const moodEmojis: Record<string, string> = {
    peaceful: "😌",
    contemplative: "🤔",
    joyful: "😊",
    grateful: "🙏",
    hopeful: "✨"
  };

  return (
    <div className={`min-h-screen pb-32 relative overflow-hidden ${isDark ? "bg-[#0A0A0A]" : "bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50"}`}>
      {/* Ambient Background Gradients */}
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
            ? "bg-gradient-to-br from-blue-500/20 via-cyan-500/20 to-teal-500/20" 
            : "bg-gradient-to-br from-blue-300/30 via-cyan-300/30 to-teal-300/30"
        } pointer-events-none`}
      />

      <div className="relative z-10 px-6 pt-6">
        {/* Premium Header */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between mb-6">
            <div>
              <motion.h1
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.1 }}
                className={`text-4xl font-black mb-2 ${isDark ? "text-white" : "text-gray-900"}`}
              >
                Prayer Journal
              </motion.h1>
              <motion.p
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.15 }}
                className={`text-sm font-medium ${isDark ? "text-white/60" : "text-gray-500"}`}
              >
                Your sacred conversations with God
              </motion.p>
            </div>

            <motion.button
              onClick={() => setShowNewEntry(!showNewEntry)}
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.2, type: "spring", stiffness: 300 }}
              whileHover={{ scale: 1.05, rotate: showNewEntry ? 135 : 0 }}
              whileTap={{ scale: 0.95 }}
              className="w-16 h-16 rounded-[22px] bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-2xl"
            >
              <Plus className="w-8 h-8 text-white" />
            </motion.button>
          </div>

          {/* Search & Filter */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.25 }}
            className="flex gap-3 mb-6"
          >
            <div className={`flex-1 ${
              isDark ? "bg-white/5" : "bg-white"
            } backdrop-blur-xl rounded-[24px] border ${isDark ? "border-white/10" : "border-black/5"} shadow-lg p-4 flex items-center gap-3`}>
              <Search className={`w-5 h-5 ${isDark ? "text-white/40" : "text-gray-400"}`} />
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
              className={`w-14 h-14 rounded-[20px] ${
                isDark ? "bg-white/5" : "bg-white"
              } backdrop-blur-xl border ${isDark ? "border-white/10" : "border-black/5"} shadow-lg flex items-center justify-center`}
            >
              <Filter className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
            </motion.button>
          </motion.div>
        </motion.div>

        {/* New Entry Form */}
        <AnimatePresence>
          {showNewEntry && (
            <motion.div
              initial={{ opacity: 0, height: 0, marginBottom: 0 }}
              animate={{ opacity: 1, height: "auto", marginBottom: 32 }}
              exit={{ opacity: 0, height: 0, marginBottom: 0 }}
              transition={{ type: "spring", stiffness: 300, damping: 30 }}
              className="overflow-hidden"
            >
              <motion.div
                initial={{ y: -20 }}
                animate={{ y: 0 }}
                className={`rounded-[36px] ${
                  isDark 
                    ? "bg-gradient-to-br from-white/10 via-white/5 to-white/10" 
                    : "bg-gradient-to-br from-white via-blue-50/30 to-purple-50/30"
                } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-black/10"} shadow-2xl p-8 relative overflow-hidden`}
              >
                {/* Ambient orb */}
                <motion.div
                  animate={{
                    scale: [1, 1.2, 1],
                    opacity: [0.2, 0.3, 0.2],
                  }}
                  transition={{
                    duration: 10,
                    repeat: Infinity,
                  }}
                  className={`absolute top-0 right-0 w-64 h-64 rounded-full blur-3xl ${
                    isDark 
                      ? "bg-gradient-to-br from-orange-500/20 via-pink-500/20 to-purple-500/20"
                      : "bg-gradient-to-br from-orange-400/30 via-pink-400/30 to-purple-400/30"
                  }`}
                />

                <div className="relative z-10">
                  <input
                    type="text"
                    placeholder="Give your entry a beautiful title..."
                    className={`w-full bg-transparent text-2xl font-black mb-5 outline-none ${
                      isDark ? "text-white placeholder:text-white/30" : "text-gray-900 placeholder:text-gray-400"
                    }`}
                  />
                  
                  <textarea
                    placeholder="Pour out your heart to God. He's listening..."
                    rows={8}
                    className={`w-full bg-transparent text-base leading-relaxed outline-none resize-none font-scripture mb-5 ${
                      isDark ? "text-white/90 placeholder:text-white/30" : "text-gray-900 placeholder:text-gray-400"
                    }`}
                    style={{ fontFamily: "'Crimson Text', serif" }}
                  />

                  {/* Action Bar */}
                  <div className={`flex items-center gap-3 pt-5 border-t ${isDark ? "border-white/10" : "border-black/10"}`}>
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      className={`p-3.5 rounded-[18px] ${isDark ? "bg-white/5 hover:bg-white/10" : "bg-black/5 hover:bg-black/10"} transition-all`}
                    >
                      <Mic className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      className={`p-3.5 rounded-[18px] ${isDark ? "bg-white/5 hover:bg-white/10" : "bg-black/5 hover:bg-black/10"} transition-all`}
                    >
                      <Image className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      className={`p-3.5 rounded-[18px] ${isDark ? "bg-white/5 hover:bg-white/10" : "bg-black/5 hover:bg-black/10"} transition-all`}
                    >
                      <Smile className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.05 }}
                      whileTap={{ scale: 0.95 }}
                      className={`p-3.5 rounded-[18px] ${isDark ? "bg-white/5 hover:bg-white/10" : "bg-black/5 hover:bg-black/10"} transition-all`}
                    >
                      <Tag className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                    
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
              </motion.div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Quick Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="grid grid-cols-3 gap-4 mb-8"
        >
          {stats.map((stat, index) => {
            const Icon = stat.icon;
            return (
              <motion.div
                key={index}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.35 + index * 0.05, type: "spring", stiffness: 300 }}
                whileHover={{ scale: 1.03, y: -4 }}
                className={`rounded-[28px] ${
                  isDark ? "bg-white/5" : "bg-white"
                } backdrop-blur-xl border ${isDark ? "border-white/10" : "border-black/5"} shadow-xl p-6 relative overflow-hidden`}
              >
                {/* Mini gradient orb */}
                <motion.div
                  animate={{
                    scale: [1, 1.2, 1],
                    opacity: [0.1, 0.2, 0.1],
                  }}
                  transition={{
                    duration: 8,
                    repeat: Infinity,
                    delay: index * 0.5,
                  }}
                  className={`absolute top-0 right-0 w-32 h-32 rounded-full blur-2xl bg-gradient-to-br ${stat.color} opacity-30`}
                />
                
                <div className="relative z-10">
                  <div className={`w-12 h-12 rounded-[18px] bg-gradient-to-br ${stat.color} flex items-center justify-center mb-4 shadow-lg`}>
                    <Icon className="w-6 h-6 text-white" />
                  </div>
                  <motion.p
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.5 + index * 0.05, type: "spring", stiffness: 300 }}
                    className={`text-3xl font-black mb-1 bg-gradient-to-r ${stat.color} bg-clip-text text-transparent`}
                  >
                    {stat.value}
                  </motion.p>
                  <p className={`text-xs font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wide`}>
                    {stat.label}
                  </p>
                </div>
              </motion.div>
            );
          })}
        </motion.div>

        {/* Journal Entries */}
        <div className="space-y-5">
          {journalEntries.map((entry, index) => (
            <motion.div
              key={entry.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 + index * 0.1, type: "spring", stiffness: 200 }}
              whileHover={{ scale: 1.01, y: -4 }}
              onClick={() => setSelectedEntry(selectedEntry === entry.id ? null : entry.id)}
              className={`relative overflow-hidden rounded-[36px] ${
                isDark ? "bg-white/5" : "bg-white"
              } backdrop-blur-xl border ${isDark ? "border-white/10" : "border-black/5"} shadow-xl cursor-pointer group`}
            >
              {/* Gradient overlay */}
              <div className={`absolute inset-0 bg-gradient-to-br ${entry.gradient} pointer-events-none`} />
              
              {/* Shimmer effect */}
              <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity -translate-x-full group-hover:translate-x-full duration-1000" />
              
              <div className="relative z-10 p-7">
                {/* Header */}
                <div className="flex items-start justify-between mb-5">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2 flex-wrap">
                      <span className={`text-xs font-bold ${isDark ? "text-white/50" : "text-gray-500"} uppercase tracking-wider`}>
                        {entry.date}
                      </span>
                      {entry.isPrivate && (
                        <div className="flex items-center gap-1.5 px-3 py-1 rounded-[12px] bg-gray-500/20 backdrop-blur-xl border border-gray-500/30">
                          <Lock className="w-3 h-3" />
                          <span className="text-xs font-bold">Private</span>
                        </div>
                      )}
                      {entry.aiInsights && (
                        <div className="flex items-center gap-1.5 px-3 py-1 rounded-[12px] bg-purple-500/20 backdrop-blur-xl border border-purple-500/30">
                          <Sparkles className="w-3 h-3 text-purple-400" />
                          <span className="text-xs font-bold text-purple-400">AI Insights</span>
                        </div>
                      )}
                    </div>
                    
                    <h3 className={`text-2xl font-black mb-3 leading-tight ${isDark ? "text-white" : "text-gray-900"}`}>
                      {entry.title}
                    </h3>
                  </div>

                  <div className="text-3xl flex-shrink-0 ml-4">
                    {moodEmojis[entry.mood]}
                  </div>
                </div>

                {/* Content Preview */}
                <p className={`text-base leading-relaxed mb-5 line-clamp-3 ${
                  isDark ? "text-white/70" : "text-gray-600"
                } font-scripture`} style={{ fontFamily: "'Crimson Text', serif" }}>
                  {entry.content}
                </p>

                {/* Tags */}
                <div className="flex flex-wrap gap-2 mb-5">
                  {entry.tags.map((tag, i) => (
                    <motion.span
                      key={i}
                      whileHover={{ scale: 1.05 }}
                      className={`px-4 py-2 rounded-[14px] text-xs font-bold ${
                        isDark 
                          ? "bg-white/10 text-white/80 border border-white/20" 
                          : "bg-black/5 text-gray-700 border border-black/10"
                      } backdrop-blur-xl`}
                    >
                      #{tag}
                    </motion.span>
                  ))}
                </div>

                {/* Verse Reference */}
                {entry.verse && (
                  <div className={`flex items-center justify-between gap-3 px-5 py-4 rounded-[24px] ${
                    isDark ? "bg-white/5" : "bg-gray-50"
                  } border ${entry.borderColor} backdrop-blur-xl`}>
                    <div className="flex items-center gap-3 flex-1">
                      <div className={`w-10 h-10 rounded-[14px] bg-gradient-to-br ${entry.accentColor} flex items-center justify-center shadow-lg`}>
                        <BookOpen className="w-5 h-5 text-white" />
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
                      }}
                      className={`w-9 h-9 rounded-[14px] ${
                        isDark ? "bg-white/10" : "bg-black/5"
                      } backdrop-blur-xl flex items-center justify-center`}
                    >
                      <ChevronRight className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                  </div>
                )}

                {/* Hover Quick Actions */}
                <div className="absolute top-7 right-7 opacity-0 group-hover:opacity-100 transition-opacity">
                  <div className="flex items-center gap-2">
                    <motion.button
                      whileHover={{ scale: 1.1, y: -2 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={(e) => {
                        e.stopPropagation();
                      }}
                      className={`w-10 h-10 rounded-[16px] ${
                        isDark ? "bg-white/10" : "bg-white"
                      } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-black/10"} shadow-xl flex items-center justify-center`}
                    >
                      <Heart className={`w-4.5 h-4.5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.1, y: -2 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={(e) => {
                        e.stopPropagation();
                      }}
                      className={`w-10 h-10 rounded-[16px] ${
                        isDark ? "bg-white/10" : "bg-white"
                      } backdrop-blur-2xl border ${isDark ? "border-white/20" : "border-black/10"} shadow-xl flex items-center justify-center`}
                    >
                      <Edit3 className={`w-4.5 h-4.5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                    </motion.button>
                  </div>
                </div>
              </div>

              {/* Subtle shine on hover */}
              <div className="absolute inset-0 bg-gradient-to-br from-white/0 via-white/5 to-white/0 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />
            </motion.div>
          ))}
        </div>

        {/* Floating AI Insights Button */}
        <motion.div
          initial={{ scale: 0, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ delay: 0.7, type: "spring", stiffness: 300 }}
          className="fixed bottom-36 right-6 z-30"
        >
          <motion.button
            whileHover={{ scale: 1.1, rotate: 5 }}
            whileTap={{ scale: 0.9 }}
            className="w-16 h-16 rounded-[22px] bg-gradient-to-br from-purple-500 via-pink-600 to-fuchsia-600 flex items-center justify-center shadow-2xl relative overflow-hidden"
          >
            <motion.div
              animate={{
                scale: [1, 1.5, 1],
                opacity: [0.5, 0, 0.5],
              }}
              transition={{
                duration: 2,
                repeat: Infinity,
              }}
              className="absolute inset-0 bg-purple-400 rounded-[22px]"
            />
            <Sparkles className="w-7 h-7 text-white relative z-10" />
            <motion.div
              animate={{ scale: [1, 1.1, 1] }}
              transition={{ duration: 2, repeat: Infinity }}
              className="absolute -top-1 -right-1 w-6 h-6 rounded-full bg-red-500 border-2 border-white flex items-center justify-center shadow-xl"
            >
              <span className="text-xs text-white font-bold">3</span>
            </motion.div>
          </motion.button>
        </motion.div>
      </div>
    </div>
  );
}