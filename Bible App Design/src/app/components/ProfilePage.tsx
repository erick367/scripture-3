import { Search, TrendingUp, BookOpen, Clock, Heart, Sparkles, ChevronRight, X, Zap } from "lucide-react";
import { motion } from "motion/react";
import { useState } from "react";

interface ProfilePageProps {
  onClose: () => void;
  timeOfDay: "morning" | "day" | "evening" | "night";
}

export function ProfilePage({ onClose, timeOfDay }: ProfilePageProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [searchQuery, setSearchQuery] = useState("");

  const recentSearches = [
    { query: "faith", type: "Keyword", icon: Sparkles },
    { query: "Psalm 23", type: "Chapter", icon: BookOpen },
    { query: "love", type: "Topic", icon: Heart }
  ];

  const popularVerses = [
    { text: "For God so loved the world...", reference: "John 3:16", reads: "12.4k", gradient: "from-blue-500 to-cyan-600" },
    { text: "I can do all things through Christ...", reference: "Philippians 4:13", reads: "8.2k", gradient: "from-purple-500 to-pink-600" },
    { text: "The Lord is my shepherd...", reference: "Psalm 23:1", reads: "9.8k", gradient: "from-emerald-500 to-teal-600" }
  ];

  const trendingTopics = [
    { name: "Prayer", verses: "245 verses", icon: Heart, color: "from-rose-500 to-pink-600" },
    { name: "Faith", verses: "189 verses", icon: Sparkles, color: "from-amber-500 to-orange-600" },
    { name: "Hope", verses: "167 verses", icon: Zap, color: "from-violet-500 to-purple-600" }
  ];

  return (
    <div className={`min-h-screen pb-32 px-6 pt-6 ${isDark ? "text-white" : "text-gray-900"}`}>
      {/* Header with Close Button */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8 flex items-start justify-between"
      >
        <div>
          <h1 className="text-3xl mb-2 font-scripture">Search Scripture</h1>
          <p className="text-white/60 text-sm font-ui">Find wisdom in God's Word</p>
        </div>
        <button
          onClick={onClose}
          className="w-10 h-10 rounded-full bg-white/5 backdrop-blur-sm flex items-center justify-center hover:bg-white/10 transition-colors"
        >
          <X className="w-5 h-5" />
        </button>
      </motion.div>

      {/* Search Bar */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="mb-8"
      >
        <div className="relative">
          <Search className="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-white/40" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            placeholder="Search verses, topics, or books..."
            className="w-full bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl pl-14 pr-5 py-4 text-white placeholder:text-white/40 focus:outline-none focus:border-[#D4A574]/50 focus:bg-white/10 transition-all font-ui"
          />
        </div>
      </motion.div>

      {/* Recent Searches */}
      {!searchQuery && (
        <div className="mb-8">
          <h2 className="text-sm text-white/80 font-ui tracking-wide mb-4">RECENT SEARCHES</h2>
          <div className="flex flex-wrap gap-2">
            {recentSearches.map((item, index) => (
              <motion.button
                key={index}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.2 + index * 0.05 }}
                className="bg-white/5 backdrop-blur-sm border border-white/10 rounded-full px-4 py-2 hover:bg-white/10 hover:border-white/20 transition-all"
              >
                <div className="flex items-center gap-2">
                  <Clock className="w-3 h-3 text-white/40" />
                  <span className="text-sm font-ui">{item.query}</span>
                  <span className="text-xs text-white/40 font-ui">• {item.type}</span>
                </div>
              </motion.button>
            ))}
          </div>
        </div>
      )}

      {/* Trending Topics */}
      <div className="mb-8">
        <div className="flex items-center justify-between mb-5">
          <h2 className="text-sm text-white/80 font-ui tracking-wide">TRENDING TOPICS</h2>
          <TrendingUp className="w-4 h-4 text-[#D4A574]" />
        </div>
        
        <div className="grid grid-cols-1 gap-3">
          {trendingTopics.map((topic, index) => {
            const Icon = topic.icon;
            return (
              <motion.button
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.3 + index * 0.1 }}
                className={`relative overflow-hidden rounded-2xl bg-gradient-to-br ${topic.color} p-5 shadow-xl hover:shadow-2xl transition-all group text-left`}
              >
                <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZGVmcz48cGF0dGVybiBpZD0iZ3JpZCIgd2lkdGg9IjQwIiBoZWlnaHQ9IjQwIiBwYXR0ZXJuVW5pdHM9InVzZXJTcGFjZU9uVXNlIj48cGF0aCBkPSJNIDQwIDAgTCAwIDAgMCA0MCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSJ3aGl0ZSIgc3Ryb2tlLW9wYWNpdHk9IjAuMDMiIHN0cm9rZS13aWR0aD0iMSIvPjwvcGF0dGVybj48L2RlZnM+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0idXJsKCNncmlkKSIvPjwvc3ZnPg==')] opacity-50" />
                
                <div className="relative z-10 flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 rounded-xl bg-white/20 backdrop-blur-sm flex items-center justify-center">
                      <Icon className="w-5 h-5" />
                    </div>
                    <div>
                      <h3 className="text-lg mb-0.5 font-scripture">{topic.name}</h3>
                      <p className="text-xs text-white/70 font-ui">{topic.verses}</p>
                    </div>
                  </div>
                  <ChevronRight className="w-5 h-5 text-white/60 group-hover:translate-x-1 transition-transform" />
                </div>
              </motion.button>
            );
          })}
        </div>
      </div>

      {/* Popular Verses */}
      <div className="mb-6">
        <h2 className="text-sm text-white/80 font-ui tracking-wide mb-5">POPULAR VERSES</h2>
        <div className="space-y-3">
          {popularVerses.map((verse, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 + index * 0.1 }}
              className="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-5 hover:border-white/20 transition-all cursor-pointer group"
            >
              <p className="font-scripture text-sm mb-3 leading-relaxed text-white/90">
                "{verse.text}"
              </p>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <BookOpen className="w-3 h-3 text-[#D4A574]" />
                  <span className="text-xs text-[#D4A574] font-ui">{verse.reference}</span>
                </div>
                <div className="flex items-center gap-1 text-xs text-white/40 font-ui">
                  <Heart className="w-3 h-3" />
                  <span>{verse.reads}</span>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Quick Actions */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.8 }}
        className="grid grid-cols-2 gap-3"
      >
        <button className="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-4 hover:bg-white/10 transition-all text-left">
          <BookOpen className="w-5 h-5 text-[#D4A574] mb-3" />
          <p className="text-sm font-ui mb-1">Browse Books</p>
          <p className="text-xs text-white/60 font-ui">All 66 books</p>
        </button>
        <button className="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-4 hover:bg-white/10 transition-all text-left">
          <Sparkles className="w-5 h-5 text-[#A3B18A] mb-3" />
          <p className="text-sm font-ui mb-1">Daily Verse</p>
          <p className="text-xs text-white/60 font-ui">Get inspired</p>
        </button>
      </motion.div>
    </div>
  );
}