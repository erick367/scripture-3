import { motion, AnimatePresence } from "motion/react";
import { Plus, Calendar, Target, TrendingUp, BookOpen, Sparkles, ChevronRight, Users, Clock, Award, Check, Play, Zap, Filter, Search, Star, Flame, Heart, ChevronDown, Share2, Bookmark, X, CheckCircle2 } from "lucide-react";
import { useState, useEffect } from "react";
import { PlanReadingView } from "./PlanReadingView";

interface PlansPageProps {
  timeOfDay: "morning" | "day" | "evening" | "night";
  onNavigateToRead: (book: string, chapter: string, planTitle?: string) => void;
  onNavVisibilityChange?: (hide: boolean) => void;
}

export function PlansPage({ timeOfDay, onNavigateToRead, onNavVisibilityChange }: PlansPageProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [selectedCategory, setSelectedCategory] = useState<string>("All");
  const [expandedStats, setExpandedStats] = useState(false);
  const [currentRecommendedIndex, setCurrentRecommendedIndex] = useState(0);
  const [currentContinueIndex, setCurrentContinueIndex] = useState(0);
  const [swipeDirection, setSwipeDirection] = useState<"left" | "right" | null>(null);
  const [searchOpen, setSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedPlan, setSelectedPlan] = useState<typeof trendingPlans[0] | null>(null);
  const [showPlanStarted, setShowPlanStarted] = useState(false);
  const [startedPlan, setStartedPlan] = useState<typeof trendingPlans[0] | null>(null);
  const [activePlanReading, setActivePlanReading] = useState<typeof continuePlans[0] | null>(null);
  const [showAllTrending, setShowAllTrending] = useState(false);
  const [showAllNewlyReleased, setShowAllNewlyReleased] = useState(false);
  const [addedPlans, setAddedPlans] = useState<string[]>([]);
  const [showAllContinue, setShowAllContinue] = useState(false);
  const [bookmarkedPlans, setBookmarkedPlans] = useState<string[]>([]);
  const [showBookmarks, setShowBookmarks] = useState(false);

  // Categories for filtering
  const categories = ["All", "Spiritual Growth", "Gospel", "Wisdom", "Prayer", "Faith"];

  // Continue Reading Plans - Multiple for stack
  const [continuePlans, setContinuePlans] = useState([
    {
      title: "Gospel of John",
      subtitle: "Experience the life of Jesus",
      currentDay: 17,
      totalDays: 21,
      progress: 81,
      gradient: "from-blue-500 via-cyan-600 to-teal-600",
      coverImage: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&h=450&fit=crop",
      nextReading: "John 18-19",
      category: "Gospel",
      type: "plan",
      book: "John",
      chapter: 18
    },
    {
      title: "Psalms of Comfort",
      subtitle: "Find peace in God's presence",
      currentDay: 10,
      totalDays: 14,
      progress: 71,
      gradient: "from-emerald-500 via-green-600 to-teal-600",
      coverImage: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&h=450&fit=crop",
      nextReading: "Psalm 91",
      category: "Spiritual Growth",
      type: "plan",
      book: "Psalms",
      chapter: 91
    },
    {
      title: "Proverbs Journey",
      subtitle: "Daily wisdom for modern living",
      currentDay: 13,
      totalDays: 31,
      progress: 42,
      gradient: "from-amber-500 via-orange-600 to-red-600",
      coverImage: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&h=450&fit=crop",
      nextReading: "Proverbs 13",
      category: "Wisdom",
      type: "plan",
      book: "Proverbs",
      chapter: 13
    }
  ]);

  // Trending Plans - with covers like book apps
  const trendingPlans = [
    {
      title: "30 Days of Prayer",
      author: "Daily Devotional",
      rating: 4.9,
      totalDays: 30,
      participants: "12.4k",
      coverImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=450&fit=crop",
      gradient: "from-violet-500 via-purple-600 to-fuchsia-600",
      category: "Prayer",
      tags: ["Beginner", "Popular"],
      description: "Deepen your prayer life through intentional daily practice and reflection"
    },
    {
      title: "Proverbs Journey",
      author: "Wisdom Series",
      rating: 4.8,
      totalDays: 31,
      participants: "8.2k",
      coverImage: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&h=450&fit=crop",
      gradient: "from-amber-500 via-orange-600 to-red-600",
      category: "Wisdom",
      tags: ["Intermediate"],
      description: "Daily wisdom for modern living from ancient proverbs"
    },
    {
      title: "Psalms of Comfort",
      author: "Peace Collection",
      rating: 4.7,
      totalDays: 14,
      participants: "15.1k",
      coverImage: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300&h=450&fit=crop",
      gradient: "from-emerald-500 via-green-600 to-teal-600",
      category: "Spiritual Growth",
      tags: ["Beginner", "Trending"],
      description: "Find peace and comfort in God's presence during difficult times"
    }
  ];

  // Newly Released Plans
  const newPlans = [
    {
      title: "Stories of Faith",
      author: "Heroes Series",
      rating: 4.6,
      coverImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&h=280&fit=crop",
      totalDays: 21,
      gradient: "from-indigo-500 via-purple-600 to-pink-600",
      description: "Explore inspiring stories of biblical heroes who trusted God through impossible circumstances",
      tags: ["Beginner", "New"]
    },
    {
      title: "Jesus' Parables",
      author: "Teaching Collection",
      rating: 4.9,
      coverImage: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=280&fit=crop",
      totalDays: 12,
      gradient: "from-orange-500 via-red-600 to-pink-600",
      description: "Uncover the profound wisdom in Jesus' teaching stories and apply them to daily life",
      tags: ["Intermediate", "New"]
    }
  ];

  // User Stats
  const userStats = {
    plansCompleted: 7,
    currentStreak: 28,
    totalDaysRead: 156,
    bookmarksCreated: 42
  };

  // Recommended Plans for card stack
  const recommendedPlans = [
    {
      title: "Romans Deep Dive",
      author: "Theology Series",
      coverImage: "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&h=600&fit=crop",
      gradient: "from-rose-500/30 via-pink-500/20 to-transparent",
      description: "Discover the transformative power of grace and righteousness in Paul's profound letter",
      totalDays: 16,
      rating: 4.8
    },
    {
      title: "Creation & Purpose",
      author: "Life Foundations",
      coverImage: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=600&fit=crop",
      gradient: "from-slate-700/30 via-slate-600/20 to-transparent",
      description: "Understand God's intentional design for your life from the beginning of creation",
      totalDays: 14,
      rating: 4.9
    },
    {
      title: "Faith in Trials",
      author: "James Study",
      coverImage: "https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=400&h=600&fit=crop",
      gradient: "from-orange-600/30 via-amber-500/20 to-transparent",
      description: "Build unshakeable faith and perseverance through life's greatest challenges",
      totalDays: 10,
      rating: 4.7
    },
    {
      title: "Worship & Praise",
      author: "Psalms Collection",
      coverImage: "https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400&h=600&fit=crop",
      gradient: "from-blue-600/30 via-cyan-500/20 to-transparent",
      description: "Experience the joy of worship through the timeless songs and prayers of David",
      totalDays: 20,
      rating: 4.9
    }
  ];

  // Auto-advance recommended cards - wait for full animation to complete
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentRecommendedIndex((prev) => (prev + 1) % recommendedPlans.length);
    }, 12000); // 3s exit + 2.5s enter + 6.5s reading time = 12s total
    return () => clearInterval(interval);
  }, []);

  const handleNextRecommended = () => {
    setCurrentRecommendedIndex((prev) => (prev + 1) % recommendedPlans.length);
  };

  const handlePrevRecommended = () => {
    setCurrentRecommendedIndex((prev) => (prev - 1 + recommendedPlans.length) % recommendedPlans.length);
  };

  const handleAddPlanToMyPlans = (plan: typeof recommendedPlans[0]) => {
    if (!addedPlans.includes(plan.title)) {
      setAddedPlans([...addedPlans, plan.title]);
      // Optional: Show a success toast or animation
    }
  };

  const handleStartPlan = (plan: typeof trendingPlans[0]) => {
    // Check if plan is already in continue reading
    const existingPlan = continuePlans.find(p => p.title === plan.title);
    
    if (!existingPlan) {
      // Add plan to continue reading with Day 1, 0% progress
      const newPlan = {
        title: plan.title,
        subtitle: plan.description,
        currentDay: 1,
        totalDays: plan.totalDays,
        progress: 0,
        gradient: plan.gradient,
        coverImage: plan.coverImage,
        nextReading: getFirstReading(plan.title),
        category: plan.category
      };
      
      // Add to beginning of continue plans array
      setContinuePlans([newPlan, ...continuePlans]);
      
      // Show success screen
      setStartedPlan(plan);
      setShowPlanStarted(true);
      
      // Close plan details modal
      setSelectedPlan(null);
      
      // After success animation, open reading view
      setTimeout(() => {
        setShowPlanStarted(false);
        setActivePlanReading(newPlan);
      }, 2500);
    } else {
      // Already started, just open the reading view
      setSelectedPlan(null);
      setActivePlanReading(existingPlan);
    }
  };

  // Helper function to get the first reading for each plan
  const getFirstReading = (planTitle: string): string => {
    const firstReadings: Record<string, string> = {
      "30 Days of Prayer": "Matthew 6",
      "Proverbs Journey": "Proverbs 1",
      "Psalms of Comfort": "Psalm 23",
      "Stories of Faith": "Hebrews 11",
      "Jesus' Parables": "Matthew 13",
      "Romans Deep Dive": "Romans 1",
      "Creation & Purpose": "Genesis 1",
      "Faith in Trials": "James 1",
      "Worship & Praise": "Psalm 100"
    };
    return firstReadings[planTitle] || "Psalm 1";
  };

  // Show plan reading view if a plan is active
  if (activePlanReading) {
    return (
      <PlanReadingView
        plan={activePlanReading}
        timeOfDay={timeOfDay}
        onBack={() => {
          setActivePlanReading(null);
          onNavVisibilityChange?.(false);
        }}
        onDayComplete={() => {
          // Update the plan's progress in continuePlans
          setContinuePlans(prevPlans => 
            prevPlans.map(p => 
              p.title === activePlanReading.title
                ? { ...p, currentDay: p.currentDay + 1, progress: ((p.currentDay) / p.totalDays) * 100 }
                : p
            )
          );
        }}
        onNavVisibilityChange={onNavVisibilityChange}
      />
    );
  }

  return (
    <div className={`min-h-screen pb-32 transition-colors duration-700 ${
      isDark 
        ? "bg-gradient-to-br from-[#1A1410] via-[#0F0A08] to-[#0A0605]" 
        : "bg-gradient-to-br from-[#FFF8F0] via-[#FFF4E8] to-[#FFE8D6]"
    }`}>
      {/* Animated Gradient Mesh Background - Same as HomePage */}
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

      <div className="relative z-10 px-6 pt-8">
        {/* 🎨 Premium Header with Profile Stats Toggle */}
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
          className="mb-8 relative z-50"
        >
          {/* Top Bar */}
          <div className="flex items-center justify-between mb-6">
            {/* Greeting + Profile */}
            <div className="flex items-center gap-3">
              <motion.div
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className="w-12 h-12 rounded-full bg-gradient-to-br from-orange-500 via-pink-600 to-purple-600 flex items-center justify-center shadow-xl overflow-hidden cursor-pointer relative z-50"
              >
                <img 
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop"
                  alt="Profile"
                  className="w-full h-full object-cover"
                />
              </motion.div>
              <div>
                <p className={`text-xs font-bold ${isDark ? "text-white/50" : "text-gray-500"}`}>
                  Welcome back
                </p>
                <h2 className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                  Sarah
                </h2>
              </div>
            </div>

            {/* Bookmark and Search Icons */}
            <div className="flex items-center gap-2">
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className={`w-11 h-11 rounded-[16px] ${
                  isDark 
                    ? "bg-white/10 border border-white/20" 
                    : "bg-white border border-gray-200 shadow-lg"
                } backdrop-blur-xl flex items-center justify-center relative`}
                onClick={() => setShowBookmarks(!showBookmarks)}
              >
                <Bookmark className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                {bookmarkedPlans.length > 0 && (
                  <div className="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-gradient-to-br from-pink-500 to-red-600 flex items-center justify-center">
                    <span className="text-[9px] font-black text-white">{bookmarkedPlans.length}</span>
                  </div>
                )}
              </motion.button>
              
              <motion.button
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                className={`w-11 h-11 rounded-[16px] ${
                  isDark 
                    ? "bg-white/10 border border-white/20" 
                    : "bg-white border border-gray-200 shadow-lg"
                } backdrop-blur-xl flex items-center justify-center`}
                onClick={() => setSearchOpen(!searchOpen)}
              >
                <Search className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
              </motion.button>
            </div>
          </div>

          {/* User Stats Card - Collapsible */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className={`rounded-[28px] overflow-hidden ${
              isDark 
                ? "bg-white/10 border border-white/20" 
                : "bg-white/80 border border-white/60 shadow-xl"
            } backdrop-blur-xl cursor-pointer`}
            onClick={() => setExpandedStats(!expandedStats)}
          >
            <div className="p-5">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <div className="w-9 h-9 rounded-[14px] bg-gradient-to-br from-orange-500 to-pink-600 flex items-center justify-center shadow-lg">
                    <TrendingUp className="w-4.5 h-4.5 text-white" />
                  </div>
                  <h3 className={`text-sm font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                    Your Reading Stats
                  </h3>
                </div>
                <motion.div
                  animate={{ rotate: expandedStats ? 180 : 0 }}
                  transition={{ duration: 0.3 }}
                >
                  <ChevronDown className={`w-5 h-5 ${isDark ? "text-white/50" : "text-gray-500"}`} />
                </motion.div>
              </div>

              {/* Always visible stats row */}
              <div className="grid grid-cols-4 gap-3">
                <div className="text-center">
                  <motion.p
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.2, type: "spring" }}
                    className={`text-2xl font-black mb-1 ${isDark ? "text-white" : "text-gray-900"}`}
                  >
                    {userStats.plansCompleted}
                  </motion.p>
                  <p className={`text-[10px] font-bold uppercase tracking-wide ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Completed
                  </p>
                </div>
                <div className="text-center">
                  <motion.p
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.3, type: "spring" }}
                    className={`text-2xl font-black mb-1 ${isDark ? "text-white" : "text-gray-900"}`}
                  >
                    {userStats.currentStreak}
                  </motion.p>
                  <p className={`text-[10px] font-bold uppercase tracking-wide ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Day Streak
                  </p>
                </div>
                <div className="text-center">
                  <motion.p
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.4, type: "spring" }}
                    className={`text-2xl font-black mb-1 ${isDark ? "text-white" : "text-gray-900"}`}
                  >
                    {userStats.totalDaysRead}
                  </motion.p>
                  <p className={`text-[10px] font-bold uppercase tracking-wide ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Days Read
                  </p>
                </div>
                <div className="text-center">
                  <motion.p
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: 0.5, type: "spring" }}
                    className={`text-2xl font-black mb-1 ${isDark ? "text-white" : "text-gray-900"}`}
                  >
                    {userStats.bookmarksCreated}
                  </motion.p>
                  <p className={`text-[10px] font-bold uppercase tracking-wide ${
                    isDark ? "text-white/50" : "text-gray-500"
                  }`}>
                    Bookmarks
                  </p>
                </div>
              </div>
            </div>

            {/* Expanded Stats */}
            <AnimatePresence>
              {expandedStats && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: "auto", opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ type: "spring", stiffness: 300, damping: 30 }}
                  className={`border-t ${isDark ? "border-white/10" : "border-gray-200"}`}
                >
                  <div className="p-5 space-y-3">
                    {/* Achievements */}
                    <div className="flex items-center gap-3">
                      <Award className={`w-5 h-5 ${isDark ? "text-orange-400" : "text-orange-600"}`} />
                      <div className="flex-1">
                        <p className={`text-xs font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                          Recent Achievement
                        </p>
                        <p className={`text-[10px] ${isDark ? "text-white/50" : "text-gray-500"}`}>
                          28-Day Streak Master 🔥
                        </p>
                      </div>
                    </div>
                    {/* Progress to next goal */}
                    <div>
                      <div className="flex items-center justify-between mb-2">
                        <p className={`text-[10px] font-bold uppercase tracking-wide ${
                          isDark ? "text-white/50" : "text-gray-500"
                        }`}>
                          Next Goal: 10 Plans
                        </p>
                        <p className={`text-[10px] font-bold ${
                          isDark ? "text-orange-400" : "text-orange-600"
                        }`}>
                          70%
                        </p>
                      </div>
                      <div className={`h-2 rounded-full ${isDark ? "bg-white/10" : "bg-gray-200"}`}>
                        <motion.div
                          initial={{ width: 0 }}
                          animate={{ width: "70%" }}
                          transition={{ delay: 0.2, duration: 1 }}
                          className="h-full rounded-full bg-gradient-to-r from-orange-500 to-pink-600"
                        />
                      </div>
                    </div>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </motion.div>
        </motion.div>

        {/* 📖 Continue Reading Section - Stack Cards */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
              Continue Reading
            </h3>
            <motion.button
              whileHover={{ x: 4 }}
              onClick={() => setShowAllContinue(true)}
              className={`text-sm font-bold flex items-center gap-1 ${
                isDark ? "text-orange-400" : "text-orange-600"
              }`}
            >
              See all
              <ChevronRight className="w-4 h-4" />
            </motion.button>
          </div>

          {/* Stacked Cards Container */}
          <div className="relative h-[240px] flex items-center justify-center mb-4 isolate">
            {continuePlans.map((item, index) => {
              // Create infinite loop by using modulo
              const normalizedCurrentIndex = currentContinueIndex % continuePlans.length;
              const normalizedIndex = index;
              
              // Calculate offset with wrapping
              let offset = normalizedIndex - normalizedCurrentIndex;
              if (offset < 0) offset += continuePlans.length;
              
              const isVisible = offset >= 0 && offset < 3;
              
              return (
                <AnimatePresence key={`${index}-${currentContinueIndex}`} mode="popLayout">
                  {isVisible && (
                    <motion.div
                      initial={{ 
                        scale: 0.9, 
                        opacity: 0, 
                        x: swipeDirection === "right" ? 400 : 0,
                        y: 50 
                      }}
                      animate={{
                        scale: 1 - offset * 0.04,
                        y: offset * -12,
                        x: offset * 8,
                        opacity: 1,
                        zIndex: 20 - offset,
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
                      onDragEnd={(e, { offset: dragOffset }) => {
                        if (Math.abs(dragOffset.x) > 150) {
                          // Determine swipe direction
                          if (dragOffset.x > 0) {
                            setSwipeDirection("right");
                            setCurrentContinueIndex(prev => (prev - 1 + continuePlans.length) % continuePlans.length);
                          } else {
                            setSwipeDirection("left");
                            setCurrentContinueIndex(prev => (prev + 1) % continuePlans.length);
                          }
                          
                          setTimeout(() => setSwipeDirection(null), 400);
                        }
                      }}
                      whileHover={offset === 0 ? { scale: 1.02, y: offset * -12 - 8 } : {}}
                      className={`absolute w-full max-w-[380px] rounded-[24px] ${
                        isDark
                          ? "bg-[#2A2428]"
                          : "bg-white/90 shadow-xl"
                      } backdrop-blur-xl cursor-grab active:cursor-grabbing overflow-visible border-2`}
                      style={{
                        filter: `brightness(${1 - offset * 0.12})`,
                        pointerEvents: offset === 0 ? "auto" : "none",
                        borderColor: item.category === "Gospel" 
                          ? "rgba(139, 92, 246, 0.5)" // purple
                          : item.category === "Wisdom"
                          ? "rgba(251, 146, 60, 0.5)" // orange
                          : "rgba(16, 185, 129, 0.5)", // emerald
                      }}
                    >
                      <div className="flex gap-4 p-5">
                        {/* Book Cover Image with Progress Badge */}
                        <div className="relative flex-shrink-0 flex flex-col items-center gap-2">
                          <div className="w-24 h-32 rounded-[16px] overflow-hidden shadow-lg">
                            <img 
                              src={item.coverImage}
                              alt={item.title}
                              className="w-full h-full object-cover"
                            />
                          </div>
                          
                          {/* Progress Badge Below Image - Only show on front card */}
                          {offset === 0 && (
                            <motion.div 
                              initial={{ scale: 0 }}
                              animate={{ scale: 1 }}
                              transition={{ delay: 0.2, type: "spring" }}
                              className="w-14 h-7 rounded-[12px] bg-gradient-to-br from-pink-500 to-red-600 flex items-center justify-center shadow-lg"
                            >
                              <span className="text-xs font-black text-white">{Math.round(item.progress)}%</span>
                            </motion.div>
                          )}
                        </div>

                        {/* Content */}
                        <div className="flex-1 min-w-0 flex flex-col">
                          {/* Category Badge */}
                          <div className="mb-2">
                            <span className={`inline-block px-3 py-1 rounded-[10px] text-[11px] font-bold ${
                              item.category === "Gospel" 
                                ? "bg-purple-600 text-white"
                                : item.category === "Wisdom"
                                ? "bg-orange-600 text-white"
                                : "bg-emerald-600 text-white"
                            }`}>
                              {item.category}
                            </span>
                          </div>

                          {/* Title & Subtitle */}
                          <h4 className={`text-lg font-black mb-1 leading-tight ${
                            isDark ? "text-white" : "text-gray-900"
                          }`}>
                            {item.title}
                          </h4>
                          <p className={`text-xs mb-3 ${
                            isDark ? "text-white/60" : "text-gray-600"
                          }`}>
                            {item.subtitle}
                          </p>

                          {/* Progress Info */}
                          <div className="mb-2">
                            <div className="flex items-center justify-between mb-1.5">
                              <span className={`text-xs font-semibold ${
                                isDark ? "text-white/70" : "text-gray-700"
                              }`}>
                                Day {item.currentDay} of {item.totalDays}
                              </span>
                            </div>
                            
                            {/* Progress Bar */}
                            <div className={`h-1.5 rounded-full ${
                              isDark ? "bg-white/10" : "bg-gray-200"
                            }`}>
                              <motion.div
                                className="h-full rounded-full bg-gradient-to-r from-cyan-500 to-blue-600"
                                initial={{ width: 0 }}
                                animate={{ width: `${item.progress}%` }}
                                transition={{ delay: 0.4 + index * 0.1, duration: 0.8 }}
                              />
                            </div>
                          </div>

                          {/* CTA Button */}
                          <motion.button
                            whileHover={{ scale: 1.02 }}
                            whileTap={{ scale: 0.98 }}
                            onClick={() => setActivePlanReading(item)}
                            className="w-full mt-auto py-2.5 rounded-[14px] bg-gradient-to-r from-orange-500 via-pink-600 to-pink-500 text-white text-sm font-bold shadow-lg flex items-center justify-center gap-2"
                          >
                            <Play className="w-4 h-4" fill="white" />
                            Continue Reading
                          </motion.button>
                        </div>
                      </div>
                    </motion.div>
                  )}
                </AnimatePresence>
              );
            })}
          </div>

          {/* Card Indicators */}
          <div className="flex items-center justify-center gap-2 mb-3">
            {continuePlans.map((_, index) => {
              const isActive = (currentContinueIndex % continuePlans.length) === index;
              return (
                <motion.button
                  key={index}
                  onClick={() => setCurrentContinueIndex(index)}
                  animate={{
                    width: isActive ? 24 : 6,
                    opacity: isActive ? 1 : 0.3,
                  }}
                  whileHover={{ opacity: 0.6 }}
                  className={`h-1.5 rounded-full cursor-pointer transition-opacity ${
                    isDark ? "bg-white" : "bg-gray-900"
                  }`}
                />
              );
            })}
          </div>
          
          {/* Swipe Helper Text */}
          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: [0.4, 0.7, 0.4] }}
            transition={{ duration: 2, repeat: Infinity }}
            className={`text-xs text-center ${
              isDark ? "text-white/40" : "text-gray-400"
            }`}
          >
            ← Swipe to browse →
          </motion.p>
        </motion.div>

        {/* 🔥 Category Pills - Horizontal Scroll */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="mb-6 -mx-6 px-6"
        >
          <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-hide snap-x snap-mandatory">
            {categories.map((category, index) => (
              <motion.button
                key={category}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.35 + index * 0.05 }}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                onClick={() => setSelectedCategory(category)}
                className={`px-5 py-2.5 rounded-[18px] text-sm font-bold whitespace-nowrap transition-all snap-start ${
                  selectedCategory === category
                    ? "bg-gradient-to-r from-orange-500 to-pink-600 text-white shadow-lg"
                    : isDark
                    ? "bg-white/10 border border-white/20 text-white/70 hover:bg-white/15"
                    : "bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 shadow-md"
                } backdrop-blur-xl`}
              >
                {category}
              </motion.button>
            ))}
          </div>
        </motion.div>

        {/* 📚 Trending Plans - Horizontal Scroll with Book Covers */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="mb-6"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
              Trending Plans
            </h3>
            <motion.button
              whileHover={{ x: 4 }}
              onClick={() => setShowAllTrending(true)}
              className={`text-sm font-bold flex items-center gap-1 ${
                isDark ? "text-orange-400" : "text-orange-600"
              }`}
            >
              See all
              <ChevronRight className="w-4 h-4" />
            </motion.button>
          </div>

          <div className="flex gap-4 overflow-x-auto pb-4 scrollbar-hide snap-x snap-mandatory">
            {trendingPlans.map((plan, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.45 + index * 0.1 }}
                whileHover={{ scale: 1.03, y: -6 }}
                onClick={() => setSelectedPlan(plan)}
                className="flex-shrink-0 w-[160px] cursor-pointer snap-start"
              >
                {/* Book Cover */}
                <div className="relative mb-3">
                  <div className="w-[160px] h-[220px] rounded-[20px] overflow-hidden shadow-2xl">
                    <img 
                      src={plan.coverImage}
                      alt={plan.title}
                      className="w-full h-full object-cover"
                    />
                    {/* Gradient overlay matching plan */}
                    <div className={`absolute inset-0 bg-gradient-to-t ${plan.gradient} opacity-30`} />
                  </div>

                  {/* Floating Badge */}
                  {plan.tags.includes("Popular") && (
                    <div className="absolute -top-2 -right-2">
                      <motion.div
                        animate={{ scale: [1, 1.1, 1] }}
                        transition={{ duration: 2, repeat: Infinity }}
                        className="w-9 h-9 rounded-full bg-gradient-to-br from-orange-500 to-pink-600 flex items-center justify-center shadow-xl"
                      >
                        <Flame className="w-4.5 h-4.5 text-white" />
                      </motion.div>
                    </div>
                  )}

                  {/* Bookmark Button */}
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={(e) => {
                      e.stopPropagation();
                      setBookmarkedPlans(prev => 
                        prev.includes(plan.title) 
                          ? prev.filter(t => t !== plan.title)
                          : [...prev, plan.title]
                      );
                    }}
                    className={`absolute top-3 right-3 w-8 h-8 rounded-full ${
                      bookmarkedPlans.includes(plan.title)
                        ? "bg-gradient-to-br from-pink-500 to-red-600"
                        : isDark ? "bg-black/50" : "bg-white/80"
                    } backdrop-blur-xl flex items-center justify-center shadow-lg`}
                  >
                    <Bookmark className={`w-4 h-4 ${
                      bookmarkedPlans.includes(plan.title) 
                        ? "text-white fill-white" 
                        : isDark ? "text-white" : "text-gray-700"
                    }`} />
                  </motion.button>
                </div>

                {/* Plan Info */}
                <div>
                  <h4 className={`text-sm font-black mb-0.5 leading-tight line-clamp-2 ${
                    isDark ? "text-white" : "text-gray-900"
                  }`}>
                    {plan.title}
                  </h4>
                  <p className={`text-xs mb-2 ${isDark ? "text-white/50" : "text-gray-500"}`}>
                    {plan.author}
                  </p>

                  {/* Rating & Stats */}
                  <div className="flex items-center gap-2 mb-2">
                    <div className="flex items-center gap-1">
                      <Star className="w-3.5 h-3.5 text-orange-500 fill-orange-500" />
                      <span className={`text-xs font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                        {plan.rating}
                      </span>
                    </div>
                    <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>•</span>
                    <div className="flex items-center gap-1">
                      <Users className={`w-3.5 h-3.5 ${isDark ? "text-white/50" : "text-gray-500"}`} />
                      <span className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                        {plan.participants}
                      </span>
                    </div>
                  </div>

                  {/* Tags */}
                  <div className="flex gap-1.5 flex-wrap">
                    {plan.tags.map((tag) => (
                      <span
                        key={tag}
                        className={`px-2 py-0.5 rounded-[8px] text-[10px] font-bold ${
                          isDark 
                            ? "bg-white/10 text-white/70" 
                            : "bg-gray-100 text-gray-600"
                        }`}
                      >
                        {tag}
                      </span>
                    ))}
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </motion.div>

        {/* 🆕 Newly Released Plans - Compact Cards */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="mb-6"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
              Newly Released
            </h3>
            <motion.button
              whileHover={{ x: 4 }}
              onClick={() => setShowAllNewlyReleased(true)}
              className={`text-sm font-bold flex items-center gap-1 ${
                isDark ? "text-orange-400" : "text-orange-600"
              }`}
            >
              See all
              <ChevronRight className="w-4 h-4" />
            </motion.button>
          </div>

          <div className="space-y-3 max-h-[400px] overflow-y-auto scrollbar-hide">
            {newPlans.map((plan, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.55 + index * 0.1 }}
                whileHover={{ scale: 1.01, x: 4 }}
                onClick={() => setSelectedPlan(plan)}
                className={`flex items-center gap-4 p-4 rounded-[24px] ${
                  isDark 
                    ? "bg-white/10 border border-white/20" 
                    : "bg-white/80 border border-white/60 shadow-lg"
                } backdrop-blur-xl cursor-pointer`}
              >
                {/* Small Cover */}
                <div className="relative w-16 h-20 rounded-[14px] overflow-hidden shadow-lg flex-shrink-0">
                  <img 
                    src={plan.coverImage}
                    alt={plan.title}
                    className="w-full h-full object-cover"
                  />
                  
                  {/* Bookmark Badge */}
                  <motion.button
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={(e) => {
                      e.stopPropagation();
                      setBookmarkedPlans(prev => 
                        prev.includes(plan.title) 
                          ? prev.filter(t => t !== plan.title)
                          : [...prev, plan.title]
                      );
                    }}
                    className={`absolute top-1 right-1 w-6 h-6 rounded-full ${
                      bookmarkedPlans.includes(plan.title)
                        ? "bg-gradient-to-br from-pink-500 to-red-600"
                        : "bg-black/50"
                    } backdrop-blur-xl flex items-center justify-center`}
                  >
                    <Bookmark className={`w-3 h-3 ${
                      bookmarkedPlans.includes(plan.title) 
                        ? "text-white fill-white" 
                        : "text-white"
                    }`} />
                  </motion.button>
                </div>

                {/* Info */}
                <div className="flex-1 min-w-0">
                  <h4 className={`text-sm font-black mb-0.5 ${isDark ? "text-white" : "text-gray-900"}`}>
                    {plan.title}
                  </h4>
                  <p className={`text-xs mb-2 ${isDark ? "text-white/50" : "text-gray-500"}`}>
                    {plan.author}
                  </p>
                  <div className="flex items-center gap-2">
                    <div className="flex items-center gap-1">
                      <Star className="w-3 h-3 text-orange-500 fill-orange-500" />
                      <span className={`text-xs font-bold ${isDark ? "text-white/80" : "text-gray-700"}`}>
                        {plan.rating}
                      </span>
                    </div>
                    <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>•</span>
                    <span className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                      {plan.totalDays} days
                    </span>
                  </div>
                </div>

                {/* Add Button */}
                <motion.button
                  whileHover={{ scale: 1.1, rotate: 90 }}
                  whileTap={{ scale: 0.9 }}
                  className={`w-10 h-10 rounded-full flex items-center justify-center ${
                    isDark 
                      ? "bg-white/10 border border-white/20" 
                      : "bg-white border border-gray-200 shadow-md"
                  } backdrop-blur-xl flex-shrink-0`}
                >
                  <Plus className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                </motion.button>
              </motion.div>
            ))}
          </div>
        </motion.div>

        {/* 🎯 Recommended For You Section - Card Stack */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="mb-8"
        >
          <div className="flex items-center justify-between mb-4">
            <h3 className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
              Recommended
            </h3>
            <div className="flex items-center gap-2">
              {/* Pagination dots */}
              <div className="flex gap-1.5">
                {recommendedPlans.map((_, index) => (
                  <button
                    key={index}
                    onClick={() => setCurrentRecommendedIndex(index)}
                    className={`h-1.5 rounded-full transition-all ${
                      index === currentRecommendedIndex
                        ? "w-6 bg-gradient-to-r from-orange-500 to-pink-600"
                        : isDark
                        ? "w-1.5 bg-white/30"
                        : "w-1.5 bg-gray-300"
                    }`}
                  />
                ))}
              </div>
            </div>
          </div>

          {/* Stacked Cards Container */}
          <div className="relative h-[420px]" onClick={handleNextRecommended}>
            <AnimatePresence initial={false}>
              {recommendedPlans.map((plan, index) => {
                // Calculate position in stack (0 = current, 1 = next, etc.)
                const position = (index - currentRecommendedIndex + recommendedPlans.length) % recommendedPlans.length;
                
                // Only show current and next 2 cards
                if (position > 2) return null;

                const isActive = position === 0;
                
                return (
                  <motion.div
                    key={`${plan.title}-${currentRecommendedIndex}-${index}`}
                    initial={{ scale: 0.9, opacity: 0, y: 50 }}
                    animate={{
                      scale: 1 - (position * 0.05),
                      y: position * 12,
                      x: position * 4,
                      opacity: 1 - (position * 0.3),
                      zIndex: position === 0 ? 100 : recommendedPlans.length - position,
                    }}
                    exit={{ 
                      scale: 0.8, 
                      opacity: 0, 
                      x: -200,
                      y: -30,
                      rotateZ: -12,
                      zIndex: 100
                    }}
                    transition={{
                      animate: {
                        type: "tween",
                        duration: 2.5,
                        ease: [0.19, 1.0, 0.22, 1.0]
                      },
                      exit: {
                        type: "tween",
                        duration: 3.0,
                        ease: [0.43, 0.13, 0.23, 0.96]
                      }
                    }}
                    className={`absolute inset-x-0 cursor-pointer ${
                      isActive ? "" : "pointer-events-none"
                    }`}
                  >
                    <div className={`rounded-[28px] overflow-hidden ${
                      isDark
                        ? "bg-white/10 border border-white/20"
                        : "bg-white/90 border border-white/70 shadow-2xl"
                    } backdrop-blur-xl`}>
                      {/* Card Cover Image */}
                      <div className="relative h-[280px]">
                        <img
                          src={plan.coverImage}
                          alt={plan.title}
                          className="w-full h-full object-cover"
                        />
                        {/* Gradient overlay */}
                        <div className={`absolute inset-0 bg-gradient-to-t ${plan.gradient}`} />
                        
                        {/* Floating bookmark in corner */}
                        <motion.button
                          whileHover={{ scale: 1.1 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={(e) => {
                            e.stopPropagation();
                            setBookmarkedPlans(prev => 
                              prev.includes(plan.title) 
                                ? prev.filter(t => t !== plan.title)
                                : [...prev, plan.title]
                            );
                          }}
                          className={`absolute top-4 right-4 w-10 h-10 rounded-full ${
                            bookmarkedPlans.includes(plan.title)
                              ? "bg-gradient-to-br from-pink-500 to-red-600"
                              : "bg-white/20 border border-white/30"
                          } backdrop-blur-xl flex items-center justify-center shadow-lg`}
                        >
                          <Bookmark className={`w-5 h-5 ${
                            bookmarkedPlans.includes(plan.title) 
                              ? "text-white fill-white" 
                              : "text-white"
                          }`} />
                        </motion.button>
                      </div>

                      {/* Card Info */}
                      <div className="p-6">
                        <h4 className={`text-2xl font-black mb-2 leading-tight ${
                          isDark ? "text-white" : "text-gray-900"
                        }`}>
                          {plan.title}
                        </h4>
                        <p className={`text-sm mb-2 ${
                          isDark ? "text-white/60" : "text-gray-600"
                        }`}>
                          {plan.author}
                        </p>

                        {/* Description */}
                        <p className={`text-sm mb-4 leading-relaxed ${
                          isDark ? "text-white/70" : "text-gray-700"
                        }`}>
                          {plan.description}
                        </p>

                        {/* Action button */}
                        <motion.button
                          whileHover={{ scale: 1.02 }}
                          whileTap={{ scale: 0.98 }}
                          onClick={(e) => {
                            e.stopPropagation();
                            handleAddPlanToMyPlans(plan);
                          }}
                          disabled={addedPlans.includes(plan.title)}
                          className={`w-full py-3 rounded-[18px] text-white text-sm font-bold shadow-lg flex items-center justify-center gap-2 ${
                            addedPlans.includes(plan.title)
                              ? "bg-gray-400 cursor-not-allowed"
                              : "bg-gradient-to-r from-orange-500 to-pink-600"
                          }`}
                        >
                          {addedPlans.includes(plan.title) ? (
                            <>
                              <CheckCircle2 className="w-5 h-5" />
                              Added to My Plans
                            </>
                          ) : (
                            <>
                              <Plus className="w-5 h-5" />
                              Add to My Plans
                            </>
                          )}
                        </motion.button>
                      </div>
                    </div>
                  </motion.div>
                );
              })}
            </AnimatePresence>
          </div>

          {/* Swipe instruction */}
          <p className={`text-xs text-center mt-10 ${
            isDark ? "text-white/40" : "text-gray-400"
          }`}>
            Tap to see next recommendation
          </p>
        </motion.div>
      </div>

      {/* 📖 Plan Details Modal */}
      <AnimatePresence>
        {selectedPlan && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.3 }}
              className="fixed inset-0 bg-black/60 backdrop-blur-md z-[200]"
              onClick={() => setSelectedPlan(null)}
            />

            {/* Modal */}
            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 50 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 50 }}
              transition={{ type: "spring", stiffness: 300, damping: 30 }}
              className="fixed inset-x-6 top-1/2 -translate-y-1/2 z-[201] max-w-md mx-auto"
              onClick={(e) => e.stopPropagation()}
            >
              <div className={`rounded-[32px] overflow-hidden shadow-2xl ${
                isDark
                  ? "bg-[#1A1410]/95 border border-white/20"
                  : "bg-white/95 border border-gray-200"
              } backdrop-blur-2xl`}>
                {/* Cover Image Header */}
                <div className="relative h-64 overflow-hidden">
                  <img 
                    src={selectedPlan.coverImage}
                    alt={selectedPlan.title}
                    className="w-full h-full object-cover"
                  />
                  {/* Gradient Overlay */}
                  <div className={`absolute inset-0 bg-gradient-to-t ${selectedPlan.gradient} opacity-40`} />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-transparent" />
                  
                  {/* Close Button */}
                  <motion.button
                    whileHover={{ scale: 1.1, rotate: 90 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => setSelectedPlan(null)}
                    className="absolute top-4 right-4 w-10 h-10 rounded-full bg-black/50 backdrop-blur-xl flex items-center justify-center"
                  >
                    <X className="w-5 h-5 text-white" />
                  </motion.button>

                  {/* Tags Overlay */}
                  <div className="absolute top-4 left-4 flex gap-2">
                    {selectedPlan.tags.map((tag) => (
                      <span
                        key={tag}
                        className="px-3 py-1.5 rounded-[12px] bg-black/50 backdrop-blur-xl text-white text-xs font-bold"
                      >
                        {tag}
                      </span>
                    ))}
                  </div>

                  {/* Title & Author Overlay */}
                  <div className="absolute bottom-0 left-0 right-0 p-6">
                    <h2 className="text-2xl font-black text-white mb-1">
                      {selectedPlan.title}
                    </h2>
                    <p className="text-sm text-white/80 font-medium">
                      {selectedPlan.author}
                    </p>
                  </div>
                </div>

                {/* Content */}
                <div className="p-6 space-y-6">
                  {/* Stats Row */}
                  <div className="grid grid-cols-3 gap-4">
                    <div className={`text-center p-3 rounded-[16px] ${
                      isDark ? "bg-white/5" : "bg-gray-50"
                    }`}>
                      <div className="flex items-center justify-center gap-1 mb-1">
                        <Star className="w-4 h-4 text-orange-500 fill-orange-500" />
                        <p className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                          {selectedPlan.rating}
                        </p>
                      </div>
                      <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                        Rating
                      </p>
                    </div>
                    <div className={`text-center p-3 rounded-[16px] ${
                      isDark ? "bg-white/5" : "bg-gray-50"
                    }`}>
                      <p className={`text-lg font-black mb-1 ${isDark ? "text-white" : "text-gray-900"}`}>
                        {selectedPlan.totalDays}
                      </p>
                      <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                        Days
                      </p>
                    </div>
                    <div className={`text-center p-3 rounded-[16px] ${
                      isDark ? "bg-white/5" : "bg-gray-50"
                    }`}>
                      <div className="flex items-center justify-center gap-1 mb-1">
                        <Users className={`w-4 h-4 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                        <p className={`text-lg font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                          {selectedPlan.participants}
                        </p>
                      </div>
                      <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                        Joined
                      </p>
                    </div>
                  </div>

                  {/* Description */}
                  <div>
                    <h3 className={`text-sm font-bold uppercase tracking-wider mb-2 ${
                      isDark ? "text-white/50" : "text-gray-500"
                    }`}>
                      About This Plan
                    </h3>
                    <p className={`text-sm leading-relaxed ${
                      isDark ? "text-white/80" : "text-gray-700"
                    }`}>
                      {selectedPlan.description}
                    </p>
                  </div>

                  {/* What's Included */}
                  <div>
                    <h3 className={`text-sm font-bold uppercase tracking-wider mb-3 ${
                      isDark ? "text-white/50" : "text-gray-500"
                    }`}>
                      What's Included
                    </h3>
                    <div className="space-y-2">
                      {[
                        { icon: BookOpen, text: `${selectedPlan.totalDays} days of guided reading` },
                        { icon: Sparkles, text: "Daily reflections & insights" },
                        { icon: Heart, text: "Community discussion & support" }
                      ].map((item, index) => (
                        <div key={index} className="flex items-center gap-3">
                          <div className={`w-9 h-9 rounded-[12px] flex items-center justify-center ${
                            isDark 
                              ? "bg-gradient-to-br from-orange-500/20 to-pink-500/20" 
                              : "bg-gradient-to-br from-orange-50 to-pink-50"
                          }`}>
                            <item.icon className={`w-4.5 h-4.5 ${
                              isDark ? "text-orange-400" : "text-orange-600"
                            }`} />
                          </div>
                          <p className={`text-sm ${isDark ? "text-white/80" : "text-gray-700"}`}>
                            {item.text}
                          </p>
                        </div>
                      ))}
                    </div>
                  </div>

                  {/* Action Buttons */}
                  <div className="flex gap-3 pt-2">
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => setSelectedPlan(null)}
                      className={`flex-1 py-4 rounded-[18px] font-bold ${
                        isDark
                          ? "bg-white/10 text-white border border-white/20"
                          : "bg-gray-100 text-gray-900 border border-gray-200"
                      }`}
                    >
                      <Share2 className="w-4.5 h-4.5 inline-block mr-2" />
                      Share
                    </motion.button>
                    <motion.button
                      whileHover={{ scale: 1.02 }}
                      whileTap={{ scale: 0.98 }}
                      onClick={() => handleStartPlan(selectedPlan)}
                      className="flex-[2] py-4 rounded-[18px] font-bold bg-gradient-to-r from-orange-500 via-pink-600 to-pink-500 text-white shadow-lg"
                    >
                      <Play className="w-4.5 h-4.5 inline-block mr-2" fill="white" />
                      {continuePlans.some(p => p.title === selectedPlan.title) ? "Continue Plan" : "Start Plan"}
                    </motion.button>
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* 🎉 Plan Started Success Screen */}
      <AnimatePresence>
        {showPlanStarted && startedPlan && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onAnimationComplete={() => {
              // Auto-hide after showing
              setTimeout(() => setShowPlanStarted(false), 2000);
            }}
            className="fixed inset-0 z-[300] flex items-center justify-center bg-black/80 backdrop-blur-lg"
          >
            <motion.div
              initial={{ scale: 0.8, opacity: 0, y: 50 }}
              animate={{ scale: 1, opacity: 1, y: 0 }}
              exit={{ scale: 0.8, opacity: 0, y: -50 }}
              transition={{ type: "spring", stiffness: 300, damping: 25 }}
              className="max-w-sm mx-6 text-center"
            >
              {/* Success Icon */}
              <motion.div
                initial={{ scale: 0, rotate: -180 }}
                animate={{ scale: 1, rotate: 0 }}
                transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
                className="w-24 h-24 mx-auto mb-6 rounded-full bg-gradient-to-br from-green-400 to-emerald-600 flex items-center justify-center shadow-2xl"
              >
                <Check className="w-12 h-12 text-white" strokeWidth={3} />
              </motion.div>

              {/* Text */}
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3 }}
              >
                <h2 className="text-3xl font-black text-white mb-3">
                  Plan Started! 🎉
                </h2>
                <p className="text-lg text-white/80 mb-2">
                  {startedPlan.title}
                </p>
                <p className="text-sm text-white/60">
                  Day 1 of {startedPlan.totalDays} • Let's begin your journey
                </p>
              </motion.div>

              {/* Animated dots */}
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.5 }}
                className="flex items-center justify-center gap-2 mt-8"
              >
                {[0, 1, 2].map((i) => (
                  <motion.div
                    key={i}
                    animate={{
                      scale: [1, 1.5, 1],
                      opacity: [0.5, 1, 0.5]
                    }}
                    transition={{
                      duration: 1,
                      repeat: Infinity,
                      delay: i * 0.2
                    }}
                    className="w-2 h-2 rounded-full bg-white/60"
                  />
                ))}
              </motion.div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* 🔍 Search Overlay */}
      <AnimatePresence>
        {searchOpen && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.3 }}
              className="fixed inset-0 bg-black/60 backdrop-blur-md z-[200]"
              onClick={() => setSearchOpen(false)}
            />

            {/* Search Panel */}
            <motion.div
              initial={{ opacity: 0, y: -100 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -100 }}
              transition={{ type: "spring", stiffness: 300, damping: 30 }}
              className={`fixed top-0 left-0 right-0 z-[201] px-6 pt-6 pb-8 ${
                isDark
                  ? "bg-gradient-to-b from-[#1A1410]/95 via-[#0F0A08]/90 to-transparent"
                  : "bg-gradient-to-b from-white/95 via-[#FFF8F0]/90 to-transparent"
              } backdrop-blur-2xl border-b ${isDark ? "border-white/10" : "border-gray-200"}`}
            >
              {/* Search Input */}
              <div className="relative mb-6">
                <Search className={`absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 ${isDark ? "text-white/50" : "text-gray-400"}`} />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search reading plans..."
                  autoFocus
                  className={`w-full pl-14 pr-12 py-4 rounded-[20px] text-base font-medium ${
                    isDark
                      ? "bg-white/10 border border-white/20 text-white placeholder:text-white/40"
                      : "bg-white border border-gray-200 text-gray-900 placeholder:text-gray-400 shadow-lg"
                  } backdrop-blur-xl focus:outline-none focus:ring-2 focus:ring-orange-500/50`}
                />
                {searchQuery && (
                  <motion.button
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    whileTap={{ scale: 0.9 }}
                    onClick={() => setSearchQuery("")}
                    className={`absolute right-4 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full ${
                      isDark ? "bg-white/10" : "bg-gray-100"
                    } flex items-center justify-center`}
                  >
                    <Plus className={`w-4 h-4 rotate-45 ${isDark ? "text-white/70" : "text-gray-600"}`} />
                  </motion.button>
                )}
              </div>

              {/* Search Results / Suggestions */}
              <div className="space-y-6 max-h-[60vh] overflow-y-auto scrollbar-hide">
                {!searchQuery ? (
                  <>
                    {/* Recent Searches */}
                    <div>
                      <h4 className={`text-xs font-bold uppercase tracking-wide mb-3 ${
                        isDark ? "text-white/50" : "text-gray-500"
                      }`}>
                        Recent Searches
                      </h4>
                      <div className="space-y-2">
                        {["Prayer Plans", "Psalms", "Gospel of John"].map((term, index) => (
                          <motion.button
                            key={term}
                            initial={{ opacity: 0, x: -20 }}
                            animate={{ opacity: 1, x: 0 }}
                            transition={{ delay: index * 0.05 }}
                            onClick={() => setSearchQuery(term)}
                            className={`flex items-center gap-3 w-full p-3 rounded-[16px] ${
                              isDark
                                ? "bg-white/5 hover:bg-white/10 border border-white/10"
                                : "bg-white hover:bg-gray-50 border border-gray-200 shadow-sm"
                            } backdrop-blur-xl transition-colors`}
                          >
                            <Clock className={`w-4 h-4 ${isDark ? "text-white/40" : "text-gray-400"}`} />
                            <span className={`text-sm font-medium ${isDark ? "text-white/80" : "text-gray-700"}`}>
                              {term}
                            </span>
                          </motion.button>
                        ))}
                      </div>
                    </div>

                    {/* Trending Topics */}
                    <div>
                      <h4 className={`text-xs font-bold uppercase tracking-wide mb-3 ${
                        isDark ? "text-white/50" : "text-gray-500"
                      }`}>
                        Trending Now
                      </h4>
                      <div className="flex gap-2 flex-wrap">
                        {["Faith", "Wisdom", "Prayer", "Devotional", "Gospel", "Spiritual Growth"].map((tag, index) => (
                          <motion.button
                            key={tag}
                            initial={{ opacity: 0, scale: 0.9 }}
                            animate={{ opacity: 1, scale: 1 }}
                            transition={{ delay: index * 0.05 }}
                            whileHover={{ scale: 1.05 }}
                            whileTap={{ scale: 0.95 }}
                            onClick={() => setSearchQuery(tag)}
                            className={`px-4 py-2 rounded-[14px] text-sm font-bold ${
                              isDark
                                ? "bg-white/10 border border-white/20 text-white/70 hover:bg-white/15"
                                : "bg-white border border-gray-200 text-gray-700 hover:bg-gray-50 shadow-md"
                            } backdrop-blur-xl transition-all`}
                          >
                            {tag}
                          </motion.button>
                        ))}
                      </div>
                    </div>

                    {/* Quick Categories */}
                    <div>
                      <h4 className={`text-xs font-bold uppercase tracking-wide mb-3 ${
                        isDark ? "text-white/50" : "text-gray-500"
                      }`}>
                        Browse by Category
                      </h4>
                      <div className="grid grid-cols-2 gap-3">
                        {[
                          { name: "New Testament", icon: BookOpen, color: "from-blue-500 to-cyan-600" },
                          { name: "Old Testament", icon: BookOpen, color: "from-purple-500 to-pink-600" },
                          { name: "Daily Devotionals", icon: Calendar, color: "from-orange-500 to-red-600" },
                          { name: "Prayer Guides", icon: Heart, color: "from-emerald-500 to-teal-600" },
                        ].map((category, index) => {
                          const Icon = category.icon;
                          return (
                            <motion.button
                              key={category.name}
                              initial={{ opacity: 0, y: 20 }}
                              animate={{ opacity: 1, y: 0 }}
                              transition={{ delay: index * 0.05 }}
                              whileHover={{ scale: 1.02 }}
                              whileTap={{ scale: 0.98 }}
                              onClick={() => setSearchQuery(category.name)}
                              className={`p-4 rounded-[18px] ${
                                isDark
                                  ? "bg-white/10 border border-white/20"
                                  : "bg-white border border-gray-200 shadow-lg"
                              } backdrop-blur-xl text-left`}
                            >
                              <div className={`w-10 h-10 rounded-[14px] bg-gradient-to-br ${category.color} flex items-center justify-center mb-2`}>
                                <Icon className="w-5 h-5 text-white" />
                              </div>
                              <p className={`text-sm font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                                {category.name}
                              </p>
                            </motion.button>
                          );
                        })}
                      </div>
                    </div>
                  </>
                ) : (
                  /* Search Results */
                  <div>
                    <h4 className={`text-xs font-bold uppercase tracking-wide mb-3 ${
                      isDark ? "text-white/50" : "text-gray-500"
                    }`}>
                      Results for "{searchQuery}"
                    </h4>
                    <div className="space-y-3">
                      {trendingPlans
                        .filter(plan => 
                          plan.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          plan.author.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          plan.category.toLowerCase().includes(searchQuery.toLowerCase())
                        )
                        .map((plan, index) => (
                          <motion.div
                            key={index}
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: index * 0.05 }}
                            whileHover={{ scale: 1.01, x: 4 }}
                            className={`flex items-center gap-4 p-4 rounded-[20px] cursor-pointer ${
                              isDark
                                ? "bg-white/10 border border-white/20 hover:bg-white/15"
                                : "bg-white border border-gray-200 shadow-lg hover:shadow-xl"
                            } backdrop-blur-xl transition-all`}
                          >
                            {/* Small Cover */}
                            <div className="w-14 h-18 rounded-[12px] overflow-hidden shadow-md flex-shrink-0">
                              <img 
                                src={plan.coverImage}
                                alt={plan.title}
                                className="w-full h-full object-cover"
                              />
                            </div>

                            {/* Info */}
                            <div className="flex-1 min-w-0">
                              <h4 className={`text-sm font-black mb-0.5 ${isDark ? "text-white" : "text-gray-900"}`}>
                                {plan.title}
                              </h4>
                              <p className={`text-xs mb-2 ${isDark ? "text-white/50" : "text-gray-500"}`}>
                                {plan.author}
                              </p>
                              <div className="flex items-center gap-2">
                                <div className="flex items-center gap-1">
                                  <Star className="w-3 h-3 text-orange-500 fill-orange-500" />
                                  <span className={`text-xs font-bold ${isDark ? "text-white/80" : "text-gray-700"}`}>
                                    {plan.rating}
                                  </span>
                                </div>
                                <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>•</span>
                                <span className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                                  {plan.totalDays} days
                                </span>
                              </div>
                            </div>

                            {/* Arrow */}
                            <ChevronRight className={`w-5 h-5 ${isDark ? "text-white/30" : "text-gray-400"}`} />
                          </motion.div>
                        ))}
                      
                      {/* No results */}
                      {trendingPlans.filter(plan => 
                        plan.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                        plan.author.toLowerCase().includes(searchQuery.toLowerCase()) ||
                        plan.category.toLowerCase().includes(searchQuery.toLowerCase())
                      ).length === 0 && (
                        <motion.div
                          initial={{ opacity: 0 }}
                          animate={{ opacity: 1 }}
                          className="text-center py-12"
                        >
                          <div className={`w-20 h-20 rounded-full mx-auto mb-4 ${
                            isDark ? "bg-white/5" : "bg-gray-100"
                          } flex items-center justify-center`}>
                            <Search className={`w-10 h-10 ${isDark ? "text-white/20" : "text-gray-300"}`} />
                          </div>
                          <p className={`text-sm font-bold mb-1 ${isDark ? "text-white/70" : "text-gray-600"}`}>
                            No results found
                          </p>
                          <p className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>
                            Try searching for something else
                          </p>
                        </motion.div>
                      )}
                    </div>
                  </div>
                )}
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* 🔥 See All Trending Plans Modal */}
      <AnimatePresence>
        {showAllTrending && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowAllTrending(false)}
              className="fixed inset-0 bg-black/60 backdrop-blur-md z-[90]"
            />

            {/* Modal */}
            <motion.div
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 50 }}
              className="fixed inset-x-0 bottom-0 top-20 z-[91] overflow-hidden"
            >
              <div className={`h-full rounded-t-[32px] overflow-hidden ${
                isDark 
                  ? "bg-gradient-to-br from-[#1A1410] via-[#0F0A08] to-[#0A0605]" 
                  : "bg-gradient-to-br from-[#FFF8F0] via-[#FFF4E8] to-[#FFE8D6]"
              }`}>
                {/* Header */}
                <div className="sticky top-0 z-10 px-6 pt-6 pb-4 bg-gradient-to-b from-black/20 to-transparent backdrop-blur-xl border-b border-white/10">
                  <div className="flex items-center justify-between mb-2">
                    <h2 className={`text-2xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                      Trending Plans
                    </h2>
                    <motion.button
                      whileHover={{ scale: 1.05, rotate: 90 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setShowAllTrending(false)}
                      className={`w-10 h-10 rounded-full ${
                        isDark ? "bg-white/10" : "bg-white/80"
                      } backdrop-blur-xl flex items-center justify-center`}
                    >
                      <X className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                    </motion.button>
                  </div>
                  <p className={`text-sm ${isDark ? "text-white/60" : "text-gray-600"}`}>
                    Discover popular reading plans from the community
                  </p>
                </div>

                {/* Scrollable Grid */}
                <div className="h-full overflow-y-auto px-6 pb-32">
                  <div className="grid grid-cols-2 gap-4 pt-4">
                    {trendingPlans.map((plan, index) => (
                      <motion.div
                        key={index}
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.05 }}
                        whileHover={{ scale: 1.03 }}
                        onClick={() => {
                          setSelectedPlan(plan);
                          setShowAllTrending(false);
                        }}
                        className="cursor-pointer"
                      >
                        {/* Book Cover */}
                        <div className="relative mb-3">
                          <div className="w-full aspect-[2/3] rounded-[20px] overflow-hidden shadow-2xl">
                            <img 
                              src={plan.coverImage}
                              alt={plan.title}
                              className="w-full h-full object-cover"
                            />
                            {/* Gradient overlay */}
                            <div className={`absolute inset-0 bg-gradient-to-t ${plan.gradient} opacity-30`} />
                          </div>

                          {/* Floating Badge */}
                          {plan.tags.includes("Popular") && (
                            <div className="absolute -top-2 -right-2">
                              <motion.div
                                animate={{ scale: [1, 1.1, 1] }}
                                transition={{ duration: 2, repeat: Infinity }}
                                className="w-9 h-9 rounded-full bg-gradient-to-br from-orange-500 to-pink-600 flex items-center justify-center shadow-xl"
                              >
                                <Flame className="w-4.5 h-4.5 text-white" />
                              </motion.div>
                            </div>
                          )}

                          {/* Bookmark Button */}
                          <motion.button
                            whileHover={{ scale: 1.1 }}
                            whileTap={{ scale: 0.9 }}
                            onClick={(e) => {
                              e.stopPropagation();
                            }}
                            className={`absolute top-3 right-3 w-8 h-8 rounded-full ${
                              isDark ? "bg-black/50" : "bg-white/80"
                            } backdrop-blur-xl flex items-center justify-center shadow-lg`}
                          >
                            <Bookmark className={`w-4 h-4 ${isDark ? "text-white" : "text-gray-700"}`} />
                          </motion.button>
                        </div>

                        {/* Plan Info */}
                        <div>
                          <h4 className={`text-sm font-black mb-0.5 leading-tight line-clamp-2 ${
                            isDark ? "text-white" : "text-gray-900"
                          }`}>
                            {plan.title}
                          </h4>
                          <p className={`text-xs mb-2 ${isDark ? "text-white/50" : "text-gray-500"}`}>
                            {plan.author}
                          </p>

                          {/* Description */}
                          <p className={`text-xs mb-2.5 leading-relaxed line-clamp-2 ${
                            isDark ? "text-white/60" : "text-gray-600"
                          }`}>
                            {plan.description}
                          </p>

                          {/* Rating & Stats */}
                          <div className="flex items-center gap-2 mb-2">
                            <div className="flex items-center gap-1">
                              <Star className="w-3.5 h-3.5 text-orange-500 fill-orange-500" />
                              <span className={`text-xs font-bold ${isDark ? "text-white" : "text-gray-900"}`}>
                                {plan.rating}
                              </span>
                            </div>
                            <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>•</span>
                            <div className="flex items-center gap-1">
                              <Users className={`w-3.5 h-3.5 ${isDark ? "text-white/50" : "text-gray-500"}`} />
                              <span className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                                {plan.participants}
                              </span>
                            </div>
                          </div>

                          {/* Tags */}
                          <div className="flex gap-1.5 flex-wrap">
                            {plan.tags.map((tag) => (
                              <span
                                key={tag}
                                className={`px-2 py-0.5 rounded-[8px] text-[10px] font-bold ${
                                  isDark 
                                    ? "bg-white/10 text-white/70" 
                                    : "bg-gray-100 text-gray-600"
                                }`}
                              >
                                {tag}
                              </span>
                            ))}
                          </div>
                        </div>
                      </motion.div>
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* 🆕 See All Newly Released Plans Modal */}
      <AnimatePresence>
        {showAllNewlyReleased && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowAllNewlyReleased(false)}
              className="fixed inset-0 bg-black/60 backdrop-blur-md z-[90]"
            />

            {/* Modal */}
            <motion.div
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: 50 }}
              className="fixed inset-x-0 bottom-0 top-20 z-[91] overflow-hidden"
            >
              <div className={`h-full rounded-t-[32px] overflow-hidden ${
                isDark 
                  ? "bg-gradient-to-br from-[#1A1410] via-[#0F0A08] to-[#0A0605]" 
                  : "bg-gradient-to-br from-[#FFF8F0] via-[#FFF4E8] to-[#FFE8D6]"
              }`}>
                {/* Header */}
                <div className="sticky top-0 z-10 px-6 pt-6 pb-4 bg-gradient-to-b from-black/20 to-transparent backdrop-blur-xl border-b border-white/10">
                  <div className="flex items-center justify-between mb-2">
                    <h2 className={`text-2xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                      Newly Released
                    </h2>
                    <motion.button
                      whileHover={{ scale: 1.05, rotate: 90 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setShowAllNewlyReleased(false)}
                      className={`w-10 h-10 rounded-full ${
                        isDark ? "bg-white/10" : "bg-white/80"
                      } backdrop-blur-xl flex items-center justify-center`}
                    >
                      <X className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                    </motion.button>
                  </div>
                  <p className={`text-sm ${isDark ? "text-white/60" : "text-gray-600"}`}>
                    Fresh reading plans just added to the library
                  </p>
                </div>

                {/* Scrollable List */}
                <div className="h-full overflow-y-auto px-6 pb-32">
                  <div className="space-y-3 pt-4">
                    {newPlans.map((plan, index) => (
                      <motion.div
                        key={index}
                        initial={{ opacity: 0, x: -20 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: index * 0.05 }}
                        whileHover={{ scale: 1.02, x: 4 }}
                        onClick={() => {
                          setSelectedPlan(plan);
                          setShowAllNewlyReleased(false);
                        }}
                        className={`flex items-center gap-4 p-4 rounded-[24px] ${
                          isDark 
                            ? "bg-white/10 border border-white/20" 
                            : "bg-white/80 border border-white/60 shadow-lg"
                        } backdrop-blur-xl cursor-pointer`}
                      >
                        {/* Small Cover */}
                        <div className="w-16 h-20 rounded-[14px] overflow-hidden shadow-lg flex-shrink-0">
                          <img 
                            src={plan.coverImage}
                            alt={plan.title}
                            className="w-full h-full object-cover"
                          />
                        </div>

                        {/* Info */}
                        <div className="flex-1 min-w-0">
                          <h4 className={`text-sm font-black mb-0.5 ${isDark ? "text-white" : "text-gray-900"}`}>
                            {plan.title}
                          </h4>
                          <p className={`text-xs mb-1.5 ${isDark ? "text-white/50" : "text-gray-500"}`}>
                            {plan.author}
                          </p>
                          
                          {/* Description */}
                          <p className={`text-xs mb-2 leading-relaxed line-clamp-2 ${
                            isDark ? "text-white/60" : "text-gray-600"
                          }`}>
                            {plan.description}
                          </p>

                          <div className="flex items-center gap-2">
                            <div className="flex items-center gap-1">
                              <Star className="w-3 h-3 text-orange-500 fill-orange-500" />
                              <span className={`text-xs font-bold ${isDark ? "text-white/80" : "text-gray-700"}`}>
                                {plan.rating}
                              </span>
                            </div>
                            <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>•</span>
                            <span className={`text-xs ${isDark ? "text-white/60" : "text-gray-600"}`}>
                              {plan.totalDays} days
                            </span>
                          </div>
                        </div>

                        {/* Add Button */}
                        <motion.button
                          whileHover={{ scale: 1.1, rotate: 90 }}
                          whileTap={{ scale: 0.9 }}
                          onClick={(e) => {
                            e.stopPropagation();
                            setSelectedPlan(plan);
                            setShowAllNewlyReleased(false);
                          }}
                          className={`w-10 h-10 rounded-full flex items-center justify-center ${
                            isDark 
                              ? "bg-white/10 border border-white/20" 
                              : "bg-white border border-gray-200 shadow-md"
                          } backdrop-blur-xl flex-shrink-0`}
                        >
                          <Plus className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                        </motion.button>
                      </motion.div>
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* 📖 See All Continue Reading Modal */}
      <AnimatePresence>
        {showAllContinue && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowAllContinue(false)}
              className="fixed inset-0 bg-black/60 backdrop-blur-md z-[200]"
            />

            {/* Modal */}
            <motion.div
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              transition={{ type: "spring", damping: 25 }}
              className="fixed inset-x-4 top-20 bottom-20 z-[201] overflow-hidden"
            >
              <div className={`h-full rounded-[32px] overflow-hidden ${
                isDark
                  ? "bg-gray-900/95 border border-white/20"
                  : "bg-white/95 border border-gray-200 shadow-2xl"
              } backdrop-blur-2xl`}>
                {/* Header */}
                <div className={`px-6 py-5 border-b ${
                  isDark ? "border-white/10" : "border-gray-200"
                }`}>
                  <div className="flex items-center justify-between">
                    <h2 className={`text-2xl font-black ${
                      isDark ? "text-white" : "text-gray-900"
                    }`}>
                      Continue Reading
                    </h2>
                    <motion.button
                      whileHover={{ scale: 1.1, rotate: 90 }}
                      whileTap={{ scale: 0.9 }}
                      onClick={() => setShowAllContinue(false)}
                      className={`w-10 h-10 rounded-full flex items-center justify-center ${
                        isDark
                          ? "bg-white/10 border border-white/20"
                          : "bg-gray-100 border border-gray-200"
                      }`}
                    >
                      <X className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                    </motion.button>
                  </div>
                </div>

                {/* Scrollable Content */}
                <div className="overflow-y-auto h-[calc(100%-80px)] px-6 py-6">
                  <div className="space-y-4">
                    {continuePlans.map((plan, index) => (
                      <motion.div
                        key={plan.title}
                        initial={{ opacity: 0, y: 20 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: index * 0.05 }}
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                        onClick={() => {
                          if (plan.type === "plan") {
                            // Navigate to plan reading view
                            setActivePlanReading(plan);
                            setShowAllContinue(false);
                          } else {
                            // Navigate to Bible book reading
                            onNavigateToRead(plan.book || "John", plan.chapter?.toString() || "1");
                            setShowAllContinue(false);
                          }
                        }}
                        className={`rounded-[24px] overflow-hidden cursor-pointer ${
                          isDark
                            ? "bg-white/5 border border-white/10"
                            : "bg-white border border-gray-200 shadow-lg"
                        } backdrop-blur-xl`}
                      >
                        <div className="flex gap-4 p-5">
                          {/* Cover Image or Colored Square */}
                          <div className="relative w-20 h-28 rounded-[16px] overflow-hidden flex-shrink-0">
                            {plan.type === "plan" ? (
                              <>
                                <img
                                  src={plan.coverImage}
                                  alt={plan.title}
                                  className="w-full h-full object-cover"
                                />
                                <div className={`absolute inset-0 bg-gradient-to-br ${plan.gradient}`} style={{ opacity: 0.3 }} />
                              </>
                            ) : (
                              <div className={`w-full h-full bg-gradient-to-br ${plan.gradient}`} />
                            )}
                            
                            {/* Progress Badge */}
                            <div className="absolute top-2 left-2 px-2 h-5 rounded-[8px] bg-gradient-to-br from-pink-500 to-red-600 flex items-center justify-center shadow-lg">
                              <span className="text-[10px] font-black text-white">{Math.round(plan.progress)}%</span>
                            </div>
                          </div>

                          {/* Content */}
                          <div className="flex-1 min-w-0">
                            {/* Category Badge */}
                            <span className={`inline-block px-2.5 py-1 rounded-[8px] text-[10px] font-bold mb-2 ${
                              plan.category === "Gospel" 
                                ? "bg-purple-600 text-white"
                                : plan.category === "Wisdom"
                                ? "bg-orange-600 text-white"
                                : "bg-emerald-600 text-white"
                            }`}>
                              {plan.category}
                            </span>

                            {/* Title */}
                            <h4 className={`text-base font-black mb-1 leading-tight ${
                              isDark ? "text-white" : "text-gray-900"
                            }`}>
                              {plan.title}
                            </h4>

                            {/* Subtitle */}
                            <p className={`text-xs mb-2 ${
                              isDark ? "text-white/60" : "text-gray-600"
                            }`}>
                              {plan.subtitle}
                            </p>

                            {/* Progress Info */}
                            <div className="mb-2">
                              <div className="flex items-center justify-between mb-1">
                                <span className={`text-xs font-semibold ${
                                  isDark ? "text-white/70" : "text-gray-700"
                                }`}>
                                  Day {plan.currentDay} of {plan.totalDays}
                                </span>
                              </div>
                              
                              {/* Progress Bar */}
                              <div className={`h-1.5 rounded-full overflow-hidden ${
                                isDark ? "bg-white/10" : "bg-gray-200"
                              }`}>
                                <motion.div
                                  initial={{ width: 0 }}
                                  animate={{ width: `${plan.progress}%` }}
                                  transition={{ duration: 0.8, delay: index * 0.05 }}
                                  className="h-full bg-gradient-to-r from-blue-500 to-cyan-500 rounded-full"
                                />
                              </div>
                            </div>

                            {/* Action Button */}
                            <motion.button
                              whileHover={{ scale: 1.05 }}
                              whileTap={{ scale: 0.95 }}
                              onClick={(e) => {
                                e.stopPropagation();
                                if (plan.type === "plan") {
                                  setActivePlanReading(plan);
                                  setShowAllContinue(false);
                                } else {
                                  onNavigateToRead(plan.book || "John", plan.chapter?.toString() || "1");
                                  setShowAllContinue(false);
                                }
                              }}
                              className="px-4 py-2 rounded-[14px] bg-gradient-to-r from-orange-500 to-pink-600 text-white text-xs font-bold shadow-lg flex items-center gap-1.5"
                            >
                              <Play className="w-3.5 h-3.5" fill="white" />
                              Continue Reading
                            </motion.button>
                          </div>
                        </div>
                      </motion.div>
                    ))}
                  </div>
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* 🔖 Bookmarked Plans Modal */}
      <AnimatePresence>
        {showBookmarks && (
          <>
            {/* Backdrop */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.3 }}
              className="fixed inset-0 bg-black/60 backdrop-blur-sm z-[999]"
              onClick={() => setShowBookmarks(false)}
            />

            {/* Modal */}
            <motion.div
              initial={{ opacity: 0, y: 50, scale: 0.95 }}
              animate={{ opacity: 1, y: 0, scale: 1 }}
              exit={{ opacity: 0, y: 50, scale: 0.95 }}
              transition={{ type: "spring", damping: 25, stiffness: 300 }}
              className="fixed inset-x-4 top-[10%] bottom-[10%] z-[1000]"
            >
              <div className={`w-full h-full rounded-[32px] overflow-hidden ${
                isDark
                  ? "bg-gray-900/95 border border-white/10"
                  : "bg-white/95 border border-gray-200"
              } backdrop-blur-xl shadow-2xl`}>
                
                {/* Header */}
                <div className={`px-6 py-6 border-b ${
                  isDark ? "border-white/10" : "border-gray-200"
                }`}>
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-[14px] bg-gradient-to-br from-pink-500 to-red-600 flex items-center justify-center">
                        <Bookmark className="w-5 h-5 text-white fill-white" />
                      </div>
                      <div>
                        <h2 className={`text-xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                          Bookmarked Plans
                        </h2>
                        <p className={`text-xs ${isDark ? "text-white/50" : "text-gray-500"}`}>
                          {bookmarkedPlans.length} {bookmarkedPlans.length === 1 ? "plan" : "plans"} saved
                        </p>
                      </div>
                    </div>
                    <motion.button
                      whileHover={{ scale: 1.05, rotate: 90 }}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => setShowBookmarks(false)}
                      className={`w-10 h-10 rounded-full ${
                        isDark
                          ? "bg-white/10 border border-white/20"
                          : "bg-gray-100 border border-gray-200"
                      } backdrop-blur-xl flex items-center justify-center`}
                    >
                      <X className={`w-5 h-5 ${isDark ? "text-white" : "text-gray-900"}`} />
                    </motion.button>
                  </div>
                </div>

                {/* Scrollable Content */}
                <div className="overflow-y-auto h-[calc(100%-90px)] px-6 py-6">
                  {bookmarkedPlans.length === 0 ? (
                    <div className="flex flex-col items-center justify-center h-full">
                      <div className="w-20 h-20 rounded-full bg-gradient-to-br from-pink-500/20 to-red-600/20 flex items-center justify-center mb-4">
                        <Bookmark className={`w-10 h-10 ${isDark ? "text-white/30" : "text-gray-400"}`} />
                      </div>
                      <h3 className={`text-lg font-black mb-2 ${isDark ? "text-white" : "text-gray-900"}`}>
                        No Bookmarks Yet
                      </h3>
                      <p className={`text-sm text-center ${isDark ? "text-white/50" : "text-gray-500"}`}>
                        Tap the bookmark icon on any plan to save it here
                      </p>
                    </div>
                  ) : (
                    <div className="space-y-4">
                      {[...trendingPlans, ...newPlans, ...recommendedPlans]
                        .filter(plan => bookmarkedPlans.includes(plan.title))
                        .map((plan, index) => (
                          <motion.div
                            key={plan.title}
                            initial={{ opacity: 0, y: 20 }}
                            animate={{ opacity: 1, y: 0 }}
                            transition={{ delay: index * 0.05 }}
                            whileHover={{ scale: 1.02 }}
                            whileTap={{ scale: 0.98 }}
                            onClick={() => {
                              setSelectedPlan(plan);
                              setShowBookmarks(false);
                            }}
                            className={`rounded-[24px] overflow-hidden cursor-pointer ${
                              isDark
                                ? "bg-white/5 border border-white/10"
                                : "bg-white border border-gray-200 shadow-lg"
                            } backdrop-blur-xl`}
                          >
                            <div className="flex gap-4 p-5">
                              {/* Cover Image */}
                              <div className="relative w-20 h-28 rounded-[16px] overflow-hidden flex-shrink-0">
                                <img
                                  src={plan.coverImage}
                                  alt={plan.title}
                                  className="w-full h-full object-cover"
                                />
                                <div className={`absolute inset-0 bg-gradient-to-br ${plan.gradient}`} style={{ opacity: 0.3 }} />
                                
                                {/* Remove Bookmark Button */}
                                <motion.button
                                  whileHover={{ scale: 1.1 }}
                                  whileTap={{ scale: 0.9 }}
                                  onClick={(e) => {
                                    e.stopPropagation();
                                    setBookmarkedPlans(prev => prev.filter(t => t !== plan.title));
                                  }}
                                  className="absolute top-2 left-2 w-7 h-7 rounded-full bg-gradient-to-br from-pink-500 to-red-600 backdrop-blur-xl flex items-center justify-center shadow-lg"
                                >
                                  <Bookmark className="w-3.5 h-3.5 text-white fill-white" />
                                </motion.button>
                              </div>

                              {/* Content */}
                              <div className="flex-1 min-w-0">
                                {/* Category Badge */}
                                <span className={`inline-block px-2.5 py-1 rounded-[8px] text-[10px] font-bold mb-2 ${
                                  plan.category === "Gospel" 
                                    ? "bg-purple-600 text-white"
                                    : plan.category === "Wisdom"
                                    ? "bg-orange-600 text-white"
                                    : plan.category === "Prayer"
                                    ? "bg-pink-600 text-white"
                                    : plan.category === "Faith"
                                    ? "bg-blue-600 text-white"
                                    : "bg-emerald-600 text-white"
                                }`}>
                                  {plan.category}
                                </span>

                                {/* Title */}
                                <h4 className={`text-base font-black mb-1 leading-tight ${
                                  isDark ? "text-white" : "text-gray-900"
                                }`}>
                                  {plan.title}
                                </h4>

                                {/* Author */}
                                <p className={`text-xs mb-2 ${
                                  isDark ? "text-white/60" : "text-gray-600"
                                }`}>
                                  {plan.author}
                                </p>

                                {/* Stats */}
                                <div className="flex items-center gap-3">
                                  <div className="flex items-center gap-1">
                                    <Star className="w-3.5 h-3.5 text-orange-500 fill-orange-500" />
                                    <span className={`text-xs font-bold ${
                                      isDark ? "text-white/70" : "text-gray-700"
                                    }`}>
                                      {plan.rating}
                                    </span>
                                  </div>
                                  <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>•</span>
                                  <span className={`text-xs ${
                                    isDark ? "text-white/60" : "text-gray-600"
                                  }`}>
                                    {plan.totalDays} days
                                  </span>
                                </div>
                              </div>

                              {/* Arrow */}
                              <div className="flex items-center">
                                <ChevronRight className={`w-5 h-5 ${
                                  isDark ? "text-white/30" : "text-gray-400"
                                }`} />
                              </div>
                            </div>
                          </motion.div>
                        ))}
                    </div>
                  )}
                </div>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* Add custom scrollbar hiding */}
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