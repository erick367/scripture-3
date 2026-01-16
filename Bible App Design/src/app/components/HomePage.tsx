import { Sparkles, Play, BookOpen, Award, User as UserIcon, Search as SearchIcon, TrendingUp, Flame, Target, Heart, ChevronRight, Zap, BookMarked, Compass, Bell, ArrowRight, Calendar, Clock, Star } from "lucide-react";
import { motion, useMotionValue, useTransform, AnimatePresence } from "motion/react";
import { useState, useRef } from "react";
import { SpiritualCarousel } from "@/app/components/SpiritualCarousel";

interface HomePageProps {
  onProfileClick: () => void;
  onSearchClick: () => void;
  timeOfDay: "morning" | "day" | "evening" | "night";
}

export function HomePage({ onProfileClick, onSearchClick, timeOfDay }: HomePageProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [currentCardIndex, setCurrentCardIndex] = useState(0);
  const [hoveredCard, setHoveredCard] = useState<string | null>(null);
  const [draggedCard, setDraggedCard] = useState<number | null>(null);
  const [swipeDirection, setSwipeDirection] = useState<"left" | "right" | null>(null);
  const [carouselIndex, setCarouselIndex] = useState(0); // 0 = Verse, 1 = Prayer
  const dragX = useMotionValue(0);
  const dragY = useMotionValue(0);
  
  // 3D Tilt effect for hero card
  const cardRef = useRef<HTMLDivElement>(null);
  const mouseX = useMotionValue(0);
  const mouseY = useMotionValue(0);
  
  const rotateX = useTransform(mouseY, [-300, 300], [15, -15]);
  const rotateY = useTransform(mouseX, [-300, 300], [-15, 15]);

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    if (!cardRef.current) return;
    const rect = cardRef.current.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    mouseX.set(x);
    mouseY.set(y);
  };

  const handleMouseLeave = () => {
    mouseX.set(0);
    mouseY.set(0);
  };

  const greeting = {
    morning: "Good Morning",
    day: "Good Afternoon", 
    evening: "Good Evening",
    night: "Good Night"
  }[timeOfDay];

  const verseOfTheDay = {
    verse: "I am the vine; you are the branches. If you remain in me and I in you, you will bear much fruit; apart from me you can do nothing.",
    reference: "John 15:5",
    category: "Abiding in Christ",
    book: "John",
    chapter: "15",
    verseNum: "5"
  };

  const prayerOfTheDay = {
    title: "A Prayer for Strength",
    prayer: "Lord, help me to remain in You today. When I feel weak, remind me that Your strength is made perfect in my weakness.",
    theme: "Daily Strength"
  };

  const streakData = {
    current: 47,
    goal: 100,
    percentage: 47
  };

  const todayStats = {
    versesRead: 12,
    minutesSpent: 23,
    chaptersCompleted: 2
  };

  const continueReading = [
    {
      book: "Psalms",
      chapter: "23",
      progress: 67,
      gradient: "from-amber-500 via-orange-500 to-red-600",
      nextVerse: "Verse 4",
      totalVerses: 6
    },
    {
      book: "Proverbs",
      chapter: "31",
      progress: 42,
      gradient: "from-violet-500 via-purple-500 to-fuchsia-600",
      nextVerse: "Verse 13",
      totalVerses: 31
    },
    {
      book: "John",
      chapter: "15",
      progress: 81,
      gradient: "from-blue-500 via-cyan-500 to-teal-600",
      nextVerse: "Verse 22",
      totalVerses: 27
    }
  ];

  const achievements = [
    { icon: "🔥", label: "7 Day Streak", unlocked: true },
    { icon: "📖", label: "100 Chapters", unlocked: true },
    { icon: "⭐", label: "30 Day Goal", unlocked: false }
  ];

  return (
    <div className={`min-h-screen pb-32 ${
      isDark 
        ? "bg-[#0A0A0A]" 
        : "bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50"
    } transition-colors duration-700`}>
      
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

      <div className="relative z-10 px-6 pt-6">
        {/* 🎨 DYNAMIC ISLAND HEADER - Premium Floating Pill */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
          className="mb-10"
        >
          <motion.div
            className={`rounded-full ${
              isDark
                ? "bg-white/10 border border-white/20"
                : "bg-white border border-gray-200 shadow-xl"
            } backdrop-blur-2xl px-6 py-4 flex items-center justify-between`}
          >
            {/* Left: Logo + Greeting */}
            <div className="flex items-center gap-3">
              {/* Compact Logo */}
              <motion.div
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className={`w-11 h-11 rounded-[16px] bg-gradient-to-br ${
                  isDark
                    ? "from-orange-500 via-pink-600 to-purple-600"
                    : "from-orange-400 via-pink-500 to-purple-500"
                } flex items-center justify-center shadow-lg relative overflow-hidden shrink-0`}
              >
                <motion.div
                  animate={{ x: ["-100%", "200%"] }}
                  transition={{ 
                    duration: 3,
                    repeat: Infinity,
                    ease: "linear",
                    repeatDelay: 2
                  }}
                  className="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent"
                />
                <BookOpen className="w-5 h-5 text-white relative z-10" />
              </motion.div>

              {/* Personalized Greeting */}
              <div className="min-w-0">
                <motion.p
                  initial={{ opacity: 0, x: -10 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.1 }}
                  className={`text-xs font-medium ${
                    isDark ? "text-white/60" : "text-gray-500"
                  }`}
                >
                  {greeting}
                </motion.p>
                <motion.h1
                  initial={{ opacity: 0, x: -10 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.15 }}
                  className={`text-lg font-bold truncate ${
                    isDark ? "text-white" : "text-gray-900"
                  }`}
                >
                  Erick
                </motion.h1>
              </div>
            </div>

            {/* Right: Actions */}
            <div className="flex items-center gap-2 shrink-0">
              {/* Notifications with badge */}
              <motion.button
                initial={{ opacity: 0, scale: 0.8 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.2 }}
                whileHover={{ scale: 1.08 }}
                whileTap={{ scale: 0.95 }}
                className={`relative w-10 h-10 rounded-full ${
                  isDark
                    ? "bg-white/10 hover:bg-white/15"
                    : "bg-gray-100 hover:bg-gray-200"
                } flex items-center justify-center transition-all duration-200`}
              >
                <Bell className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                <motion.div
                  animate={{ scale: [1, 1.2, 1] }}
                  transition={{ duration: 2, repeat: Infinity }}
                  className="absolute -top-1 -right-1 w-5 h-5 bg-gradient-to-br from-red-500 to-pink-600 rounded-full border-2 border-white flex items-center justify-center"
                >
                  <span className="text-[10px] font-bold text-white">3</span>
                </motion.div>
              </motion.button>

              {/* Search */}
              <motion.button
                initial={{ opacity: 0, scale: 0.8 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.25 }}
                whileHover={{ scale: 1.08 }}
                whileTap={{ scale: 0.95 }}
                onClick={onSearchClick}
                className={`w-10 h-10 rounded-full ${
                  isDark
                    ? "bg-white/10 hover:bg-white/15"
                    : "bg-gray-100 hover:bg-gray-200"
                } flex items-center justify-center transition-all duration-200`}
              >
                <SearchIcon className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
              </motion.button>

              {/* Profile */}
              <motion.button
                initial={{ opacity: 0, scale: 0.8 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.3 }}
                whileHover={{ scale: 1.08 }}
                whileTap={{ scale: 0.95 }}
                onClick={onProfileClick}
                className={`relative w-10 h-10 rounded-full ${
                  isDark
                    ? "bg-gradient-to-br from-[#C17D4A] to-[#8B7355]"
                    : "bg-gradient-to-br from-[#D4A574] to-[#A67C52]"
                } flex items-center justify-center shadow-md hover:shadow-lg transition-all duration-200`}
              >
                <UserIcon className="w-5 h-5 text-white" />
                <motion.div
                  animate={{ scale: [1, 1.2, 1] }}
                  transition={{ duration: 2, repeat: Infinity }}
                  className="absolute -top-0.5 -right-0.5 w-3 h-3 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full border-2 border-white/30"
                />
              </motion.button>
            </div>
          </motion.div>
        </motion.div>

        {/* 🎡 SPIRITUAL CAROUSEL - Verse & Prayer */}
        <SpiritualCarousel 
          isDark={isDark}
          verseOfTheDay={verseOfTheDay}
          prayerOfTheDay={prayerOfTheDay}
        />

        {/* 🔥 Streak Card - Clean & Inspiring */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="mb-6"
        >
          <motion.button
            whileHover={{ scale: 1.02, y: -4 }}
            whileTap={{ scale: 0.98 }}
            className={`w-full rounded-[40px] ${
              isDark
                ? "bg-gradient-to-br from-[#5C2E1F] via-[#4A2418] to-[#3D1F14] border border-orange-900/40"
                : "bg-gradient-to-br from-[#8B5A3C] via-[#7A4E33] to-[#6B432A] border border-orange-800/20"
            } backdrop-blur-xl p-8 shadow-2xl overflow-hidden relative group cursor-pointer`}
          >
            {/* Subtle gradient orb */}
            <motion.div
              animate={{
                scale: [1, 1.3, 1],
                opacity: [0.2, 0.4, 0.2],
              }}
              transition={{
                duration: 15,
                repeat: Infinity,
              }}
              className="absolute top-0 right-0 w-96 h-96 rounded-full bg-gradient-to-br from-orange-600/30 via-red-600/20 to-pink-600/30 blur-3xl"
            />

            <div className="relative z-10">
              {/* Header */}
              <div className="mb-6">
                <span className="text-sm font-bold uppercase tracking-widest block mb-1 text-orange-200/80">
                  Day Streak
                </span>
                <span className="text-xs text-white/50">
                  Keep the momentum going!
                </span>
              </div>

              {/* Big Number */}
              <div className="mb-6">
                <div className="flex items-baseline gap-3">
                  <h3 className="text-[120px] font-black leading-none bg-gradient-to-br from-orange-200 via-red-300 to-pink-400 bg-clip-text text-transparent">
                    {streakData.current}
                  </h3>
                  <span className="text-3xl font-semibold text-white/40 mb-4">
                    days
                  </span>
                </div>
              </div>

              {/* Inspirational Message */}
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6 }}
                className="mb-6"
              >
                <p className="font-scripture text-xl text-white/80 italic leading-relaxed" style={{ fontFamily: "'Crimson Text', serif" }}>
                  "Every day you spend in His Word builds a foundation that cannot be shaken."
                </p>
              </motion.div>

              {/* Days Remaining */}
              <div className="mb-4 text-sm font-medium text-white/60">
                {streakData.goal - streakData.current} more days to reach your 100-day goal 🎯
              </div>

              {/* Single Progress bar */}
              <div className="h-3 rounded-full bg-black/30 overflow-hidden">
                <motion.div
                  className="h-full bg-gradient-to-r from-orange-500 via-red-500 to-pink-600 rounded-full relative overflow-hidden"
                  initial={{ width: 0 }}
                  animate={{ width: `${streakData.percentage}%` }}
                  transition={{ delay: 0.5, duration: 1.2, ease: "easeOut" }}
                >
                  <motion.div
                    className="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent"
                    animate={{ x: ["-100%", "200%"] }}
                    transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
                  />
                </motion.div>
              </div>
            </div>
          </motion.button>
        </motion.div>

        {/* 📊 TODAY'S ACTIVITY - REDESIGNED: Premium Glassmorphic Stats with Circular Progress */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.25 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className={`text-xl font-bold ${
              isDark ? "text-white" : "text-gray-900"
            }`}>
              Today's Activity
            </h3>
            <button className={`text-sm font-semibold ${
              isDark ? "text-white/60 hover:text-white" : "text-gray-500 hover:text-gray-900"
            } transition-colors flex items-center gap-1`}>
              View Details
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>

          <motion.div
            whileHover={{ y: -4 }}
            className={`rounded-[36px] ${
              isDark
                ? "bg-gradient-to-br from-white/10 via-white/5 to-white/10 border border-white/20"
                : "bg-gradient-to-br from-white via-blue-50/30 to-purple-50/30 border border-black/10 shadow-xl"
            } backdrop-blur-2xl p-8 overflow-hidden relative`}
          >
            {/* Animated gradient orbs */}
            <motion.div
              animate={{
                scale: [1, 1.4, 1],
                x: [0, 50, 0],
                opacity: [0.2, 0.4, 0.2],
              }}
              transition={{
                duration: 15,
                repeat: Infinity,
              }}
              className={`absolute top-0 right-0 w-80 h-80 rounded-full blur-3xl ${
                isDark 
                  ? "bg-gradient-to-br from-blue-500/20 via-purple-500/20 to-pink-500/20"
                  : "bg-gradient-to-br from-blue-400/30 via-purple-400/30 to-pink-400/30"
              }`}
            />
            
            <motion.div
              animate={{
                scale: [1, 1.3, 1],
                x: [0, -40, 0],
                opacity: [0.15, 0.3, 0.15],
              }}
              transition={{
                duration: 18,
                repeat: Infinity,
                delay: 2,
              }}
              className={`absolute bottom-0 left-0 w-72 h-72 rounded-full blur-3xl ${
                isDark
                  ? "bg-gradient-to-br from-orange-500/20 via-red-500/20 to-pink-500/20"
                  : "bg-gradient-to-br from-orange-400/30 via-red-400/30 to-pink-400/30"
              }`}
            />

            <div className="relative z-10 grid grid-cols-3 gap-6">
              {/* Chapters - Circular Progress */}
              <div className="flex flex-col items-center">
                <motion.div 
                  className="relative w-24 h-24 mb-3"
                  whileHover={{ scale: 1.05 }}
                >
                  {/* Background circle */}
                  <svg className="w-full h-full transform -rotate-90">
                    <circle
                      cx="48"
                      cy="48"
                      r="42"
                      stroke={isDark ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.1)"}
                      strokeWidth="6"
                      fill="none"
                    />
                    {/* Progress circle */}
                    <motion.circle
                      cx="48"
                      cy="48"
                      r="42"
                      stroke="url(#gradient-blue)"
                      strokeWidth="6"
                      fill="none"
                      strokeLinecap="round"
                      initial={{ strokeDasharray: "0 264" }}
                      animate={{ strokeDasharray: `${(todayStats.chaptersCompleted / 5) * 264} 264` }}
                      transition={{ duration: 1.5, delay: 0.3, ease: "easeOut" }}
                    />
                    <defs>
                      <linearGradient id="gradient-blue" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stopColor="#3B82F6" />
                        <stop offset="100%" stopColor="#06B6D4" />
                      </linearGradient>
                    </defs>
                  </svg>
                  
                  {/* Center content */}
                  <div className="absolute inset-0 flex flex-col items-center justify-center">
                    <BookOpen className={`w-5 h-5 mb-0.5 ${
                      isDark ? "text-blue-400" : "text-blue-600"
                    }`} />
                    <motion.span 
                      className={`text-3xl font-black leading-none ${
                        isDark ? "text-white" : "text-gray-900"
                      }`}
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      transition={{ delay: 0.5, type: "spring", stiffness: 300 }}
                    >
                      {todayStats.chaptersCompleted}
                    </motion.span>
                  </div>

                  {/* Floating sparkles */}
                  {[...Array(3)].map((_, i) => (
                    <motion.div
                      key={i}
                      className={`absolute w-1 h-1 rounded-full ${
                        isDark ? "bg-blue-400" : "bg-blue-500"
                      }`}
                      animate={{
                        y: [-15, -30, -15],
                        opacity: [0, 1, 0],
                        scale: [0, 1, 0],
                      }}
                      transition={{
                        duration: 2,
                        repeat: Infinity,
                        delay: i * 0.4,
                      }}
                      style={{
                        top: "15%",
                        left: `${30 + i * 20}%`,
                      }}
                    />
                  ))}
                </motion.div>
                
                <p className={`text-sm font-bold mb-0.5 ${
                  isDark ? "text-white" : "text-gray-900"
                }`}>
                  Chapters
                </p>
                <p className={`text-xs ${
                  isDark ? "text-white/50" : "text-gray-500"
                }`}>
                  {5 - todayStats.chaptersCompleted} to goal
                </p>
              </div>

              {/* Minutes - Circular Progress */}
              <div className="flex flex-col items-center">
                <motion.div 
                  className="relative w-24 h-24 mb-3"
                  whileHover={{ scale: 1.05 }}
                >
                  {/* Background circle */}
                  <svg className="w-full h-full transform -rotate-90">
                    <circle
                      cx="48"
                      cy="48"
                      r="42"
                      stroke={isDark ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.1)"}
                      strokeWidth="6"
                      fill="none"
                    />
                    {/* Progress circle */}
                    <motion.circle
                      cx="48"
                      cy="48"
                      r="42"
                      stroke="url(#gradient-purple)"
                      strokeWidth="6"
                      fill="none"
                      strokeLinecap="round"
                      initial={{ strokeDasharray: "0 264" }}
                      animate={{ strokeDasharray: `${(todayStats.minutesSpent / 30) * 264} 264` }}
                      transition={{ duration: 1.5, delay: 0.4, ease: "easeOut" }}
                    />
                    <defs>
                      <linearGradient id="gradient-purple" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stopColor="#A855F7" />
                        <stop offset="100%" stopColor="#EC4899" />
                      </linearGradient>
                    </defs>
                  </svg>
                  
                  {/* Center content */}
                  <div className="absolute inset-0 flex flex-col items-center justify-center">
                    <Clock className={`w-5 h-5 mb-0.5 ${
                      isDark ? "text-purple-400" : "text-purple-600"
                    }`} />
                    <motion.span 
                      className={`text-3xl font-black leading-none ${
                        isDark ? "text-white" : "text-gray-900"
                      }`}
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      transition={{ delay: 0.6, type: "spring", stiffness: 300 }}
                    >
                      {todayStats.minutesSpent}
                    </motion.span>
                  </div>

                  {/* Floating sparkles */}
                  {[...Array(3)].map((_, i) => (
                    <motion.div
                      key={i}
                      className={`absolute w-1 h-1 rounded-full ${
                        isDark ? "bg-purple-400" : "bg-purple-500"
                      }`}
                      animate={{
                        y: [-15, -30, -15],
                        opacity: [0, 1, 0],
                        scale: [0, 1, 0],
                      }}
                      transition={{
                        duration: 2,
                        repeat: Infinity,
                        delay: i * 0.4 + 0.2,
                      }}
                      style={{
                        top: "15%",
                        left: `${30 + i * 20}%`,
                      }}
                    />
                  ))}
                </motion.div>
                
                <p className={`text-sm font-bold mb-0.5 ${
                  isDark ? "text-white" : "text-gray-900"
                }`}>
                  Minutes
                </p>
                <p className={`text-xs ${
                  isDark ? "text-white/50" : "text-gray-500"
                }`}>
                  {30 - todayStats.minutesSpent} to goal
                </p>
              </div>

              {/* Goals - Circular Progress */}
              <div className="flex flex-col items-center">
                <motion.div 
                  className="relative w-24 h-24 mb-3"
                  whileHover={{ scale: 1.05 }}
                >
                  {/* Background circle */}
                  <svg className="w-full h-full transform -rotate-90">
                    <circle
                      cx="48"
                      cy="48"
                      r="42"
                      stroke={isDark ? "rgba(255,255,255,0.1)" : "rgba(0,0,0,0.1)"}
                      strokeWidth="6"
                      fill="none"
                    />
                    {/* Progress circle */}
                    <motion.circle
                      cx="48"
                      cy="48"
                      r="42"
                      stroke="url(#gradient-green)"
                      strokeWidth="6"
                      fill="none"
                      strokeLinecap="round"
                      initial={{ strokeDasharray: "0 264" }}
                      animate={{ strokeDasharray: `${(12 / 15) * 264} 264` }}
                      transition={{ duration: 1.5, delay: 0.5, ease: "easeOut" }}
                    />
                    <defs>
                      <linearGradient id="gradient-green" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" stopColor="#10B981" />
                        <stop offset="100%" stopColor="#059669" />
                      </linearGradient>
                    </defs>
                  </svg>
                  
                  {/* Center content */}
                  <div className="absolute inset-0 flex flex-col items-center justify-center">
                    <Target className={`w-5 h-5 mb-0.5 ${
                      isDark ? "text-green-400" : "text-green-600"
                    }`} />
                    <motion.span 
                      className={`text-3xl font-black leading-none ${
                        isDark ? "text-white" : "text-gray-900"
                      }`}
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      transition={{ delay: 0.7, type: "spring", stiffness: 300 }}
                    >
                      12
                    </motion.span>
                  </div>

                  {/* Floating sparkles */}
                  {[...Array(3)].map((_, i) => (
                    <motion.div
                      key={i}
                      className={`absolute w-1 h-1 rounded-full ${
                        isDark ? "bg-green-400" : "bg-green-500"
                      }`}
                      animate={{
                        y: [-15, -30, -15],
                        opacity: [0, 1, 0],
                        scale: [0, 1, 0],
                      }}
                      transition={{
                        duration: 2,
                        repeat: Infinity,
                        delay: i * 0.4 + 0.4,
                      }}
                      style={{
                        top: "15%",
                        left: `${30 + i * 20}%`,
                      }}
                    />
                  ))}
                </motion.div>
                
                <p className={`text-sm font-bold mb-0.5 ${
                  isDark ? "text-white" : "text-gray-900"
                }`}>
                  Goals Hit
                </p>
                <p className={`text-xs ${
                  isDark ? "text-white/50" : "text-gray-500"
                }`}>
                  3 to milestone
                </p>
              </div>
            </div>
          </motion.div>
        </motion.div>

        {/* 🎯 DAILY CHALLENGE - Compact Preview */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="mb-8"
        >
          <motion.button
            whileHover={{ y: -4, scale: 1.01 }}
            whileTap={{ scale: 0.98 }}
            className={`w-full rounded-[32px] p-6 ${
              isDark
                ? "bg-gradient-to-br from-orange-900/40 via-red-900/30 to-pink-900/40 border-2 border-orange-500/40"
                : "bg-gradient-to-br from-orange-50 via-red-50 to-pink-50 border-2 border-orange-300/60"
            } backdrop-blur-2xl shadow-xl overflow-hidden relative cursor-pointer group`}
          >
            {/* Animated glow */}
            <motion.div
              className="absolute inset-0 rounded-[32px] opacity-40"
              animate={{
                boxShadow: [
                  "0 0 20px rgba(249, 115, 22, 0.3)",
                  "0 0 40px rgba(249, 115, 22, 0.5)",
                  "0 0 20px rgba(249, 115, 22, 0.3)",
                ],
              }}
              transition={{
                duration: 2,
                repeat: Infinity,
              }}
            />

            {/* Small celebration particles */}
            <div className="absolute inset-0 overflow-hidden rounded-[32px] pointer-events-none">
              {[...Array(6)].map((_, i) => (
                <motion.div
                  key={i}
                  className="absolute w-1.5 h-1.5 rounded-full"
                  style={{
                    background: ["#F59E0B", "#EF4444", "#EC4899"][i % 3],
                    left: `${20 + Math.random() * 60}%`,
                    top: `${20 + Math.random() * 60}%`,
                  }}
                  animate={{
                    y: [0, -20, 0],
                    opacity: [0, 0.8, 0],
                    scale: [0, 1.2, 0],
                  }}
                  transition={{
                    duration: 2 + Math.random(),
                    repeat: Infinity,
                    delay: Math.random() * 2,
                  }}
                />
              ))}
            </div>

            <div className="relative z-10">
              {/* Header Row */}
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <motion.div
                    animate={{ rotate: [0, -10, 10, -10, 0] }}
                    transition={{ duration: 0.5, repeat: Infinity, repeatDelay: 3 }}
                    className={`w-12 h-12 rounded-2xl ${
                      isDark
                        ? "bg-gradient-to-br from-yellow-500 to-orange-600"
                        : "bg-gradient-to-br from-yellow-400 to-orange-500"
                    } flex items-center justify-center shadow-lg`}
                  >
                    <Zap className="w-6 h-6 text-white" fill="white" />
                  </motion.div>
                  <div className="text-left">
                    <h3 className={`text-base font-black ${
                      isDark ? "text-white" : "text-gray-900"
                    }`}>
                      Daily Challenge
                    </h3>
                    <p className={`text-xs font-medium ${
                      isDark ? "text-white/50" : "text-gray-600"
                    }`}>
                      Memory Verse Master
                    </p>
                  </div>
                </div>
                <motion.div
                  animate={{ scale: [1, 1.1, 1] }}
                  transition={{ duration: 2, repeat: Infinity }}
                  className={`px-3 py-1.5 rounded-full text-xs font-bold ${
                    isDark
                      ? "bg-orange-500/20 text-orange-300 border border-orange-500/30"
                      : "bg-orange-100 text-orange-600 border border-orange-300"
                  }`}
                >
                  8h left
                </motion.div>
              </div>

              {/* Progress Row */}
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className={`text-sm font-bold ${
                    isDark ? "text-white/70" : "text-gray-700"
                  }`}>
                    2/3 Complete
                  </div>
                  <div className="flex items-center gap-1">
                    {[true, true, false].map((completed, i) => (
                      <motion.div
                        key={i}
                        className={`w-2 h-2 rounded-full ${
                          completed
                            ? isDark
                              ? "bg-green-400"
                              : "bg-green-500"
                            : isDark
                            ? "bg-white/20"
                            : "bg-gray-300"
                        }`}
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        transition={{ delay: i * 0.1 }}
                      />
                    ))}
                  </div>
                </div>
                <motion.div
                  className="flex items-center gap-2"
                  whileHover={{ x: 5 }}
                >
                  <span className={`text-sm font-bold ${
                    isDark ? "text-orange-300" : "text-orange-600"
                  }`}>
                    +50 XP
                  </span>
                  <ArrowRight className={`w-4 h-4 ${
                    isDark ? "text-orange-300" : "text-orange-600"
                  }`} />
                </motion.div>
              </div>
            </div>
          </motion.button>
        </motion.div>

        {/* 🎴 Continue Reading - Stackable Tinder Cards */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className={`text-xl font-bold ${
              isDark ? "text-white" : "text-gray-900"
            }`}>
              Continue Reading
            </h3>
            <button className={`text-sm font-semibold ${
              isDark ? "text-white/60 hover:text-white" : "text-gray-500 hover:text-gray-900"
            } transition-colors flex items-center gap-1`}>
              View All
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>

          {/* Stacked Cards Container */}
          <div className="relative h-[320px] flex items-center justify-center">
            {continueReading.map((item, index) => {
              // Create infinite loop by using modulo
              const normalizedCurrentIndex = currentCardIndex % continueReading.length;
              const normalizedIndex = index;
              
              // Calculate offset with wrapping
              let offset = normalizedIndex - normalizedCurrentIndex;
              if (offset < 0) offset += continueReading.length;
              
              const isVisible = offset >= 0 && offset < 3;
              
              return (
                <AnimatePresence key={`${index}-${currentCardIndex}`} mode="popLayout">
                  {isVisible && (
                    <motion.div
                      initial={{ 
                        scale: 0.9, 
                        opacity: 0, 
                        x: swipeDirection === "right" ? 400 : 0,
                        y: 50 
                      }}
                      animate={{
                        scale: 1 - offset * 0.05,
                        y: offset * -12,
                        x: offset * 8,
                        opacity: 1,
                        zIndex: 100 - offset,
                        rotateZ: offset * 2,
                      }}
                      exit={{ 
                        scale: 0.8, 
                        opacity: 0, 
                        x: swipeDirection === "right" ? 400 : -400,
                        transition: { duration: 0.3 }
                      }}
                      transition={{ type: "spring", stiffness: 260, damping: 20 }}
                      drag={offset === 0 ? "x" : false}
                      dragConstraints={{ left: 0, right: 0 }}
                      onDragEnd={(e, { offset: dragOffset, velocity }) => {
                        if (Math.abs(dragOffset.x) > 150) {
                          // Determine swipe direction
                          if (dragOffset.x > 0) {
                            // Swiped right - go to previous card (loop backwards)
                            setSwipeDirection("right");
                            setCurrentCardIndex(prev => (prev - 1 + continueReading.length) % continueReading.length);
                          } else {
                            // Swiped left - go to next card (loop forward)
                            setSwipeDirection("left");
                            setCurrentCardIndex(prev => (prev + 1) % continueReading.length);
                          }
                          
                          // Reset swipe direction after animation
                          setTimeout(() => setSwipeDirection(null), 400);
                        }
                      }}
                      whileHover={offset === 0 ? { scale: 1.02, y: -8 } : {}}
                      className={`absolute w-[340px] rounded-[36px] bg-gradient-to-br ${item.gradient} p-8 shadow-2xl cursor-grab active:cursor-grabbing overflow-hidden`}
                      style={{
                        filter: `brightness(${1 - offset * 0.15})`,
                        pointerEvents: offset === 0 ? "auto" : "none",
                      }}
                    >
                      {/* Glass overlay */}
                      <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-white/10 to-transparent" />
                      
                      <div className="relative z-10">
                        <div className="flex items-center justify-between mb-6">
                          <div>
                            <h4 className="font-scripture text-4xl font-black text-white mb-2">
                              {item.book}
                            </h4>
                            <p className="text-white/90 text-base font-semibold">
                              Chapter {item.chapter}
                            </p>
                          </div>
                          
                          <motion.button
                            whileHover={{ scale: 1.15, rotate: 90 }}
                            whileTap={{ scale: 0.9 }}
                            className="w-16 h-16 rounded-3xl bg-white/25 backdrop-blur-md flex items-center justify-center shadow-xl border border-white/20"
                          >
                            <Play className="w-7 h-7 text-white ml-1" fill="white" />
                          </motion.button>
                        </div>

                        <div className="mb-6">
                          <div className="px-5 py-3 rounded-2xl bg-white/20 backdrop-blur-md inline-block border border-white/20">
                            <span className="text-white text-base font-bold">
                              Next: {item.nextVerse}
                            </span>
                          </div>
                        </div>

                        <div className="space-y-3">
                          <div className="flex items-center justify-between text-white text-base">
                            <span className="font-semibold">Progress</span>
                            <span className="font-black text-lg">{item.progress}%</span>
                          </div>
                          <div className="h-3 bg-black/20 rounded-full overflow-hidden backdrop-blur-sm">
                            <motion.div
                              className="h-full bg-white rounded-full shadow-lg"
                              initial={{ width: 0 }}
                              animate={{ width: `${item.progress}%` }}
                              transition={{ delay: 0.6 + index * 0.1, duration: 0.8 }}
                            />
                          </div>
                        </div>

                        {/* Swipe Hint */}
                        {offset === 0 && currentCardIndex < 2 && (
                          <motion.div
                            initial={{ opacity: 0 }}
                            animate={{ opacity: [0, 0.7, 0] }}
                            transition={{ duration: 2, repeat: 2, delay: 1 }}
                            className="absolute bottom-6 left-1/2 -translate-x-1/2 text-white/60 text-sm font-semibold"
                          >
                            ← Swipe to browse →
                          </motion.div>
                        )}
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              );
            })}
          </div>

          {/* Card Indicators */}
          <div className="flex items-center justify-center gap-2 mt-6">
            {continueReading.map((_, index) => {
              const isActive = (currentCardIndex % continueReading.length) === index;
              return (
                <motion.button
                  key={index}
                  onClick={() => setCurrentCardIndex(index)}
                  animate={{
                    width: isActive ? 32 : 8,
                    opacity: isActive ? 1 : 0.3,
                  }}
                  whileHover={{ opacity: 0.6 }}
                  className={`h-2 rounded-full cursor-pointer transition-opacity ${
                    isDark ? "bg-white" : "bg-gray-900"
                  }`}
                />
              );
            })}
          </div>
        </motion.div>
      </div>

      <style>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </div>
  );
}