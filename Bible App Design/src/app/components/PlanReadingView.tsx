import { motion, AnimatePresence } from "motion/react";
import { ChevronLeft, ChevronRight, BookOpen, Heart, MessageCircle, Sparkles, Check, X, Share2, Bookmark, Calendar } from "lucide-react";
import { useState, useEffect, useRef } from "react";

interface PlanReadingViewProps {
  plan: {
    title: string;
    subtitle: string;
    currentDay: number;
    totalDays: number;
    gradient: string;
    coverImage: string;
    category: string;
  };
  timeOfDay: "morning" | "day" | "evening" | "night";
  onBack: () => void;
  onDayComplete: () => void;
  onNavVisibilityChange?: (hide: boolean) => void;
}

export function PlanReadingView({ plan, timeOfDay, onBack, onDayComplete, onNavVisibilityChange }: PlanReadingViewProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  const [currentDay, setCurrentDay] = useState(plan.currentDay);
  const [completedToday, setCompletedToday] = useState(false);
  const [bookmarked, setBookmarked] = useState(false);
  const [isBottomBarVisible, setIsBottomBarVisible] = useState(true);
  const lastScrollY = useRef(0);
  const scrollTimeout = useRef<NodeJS.Timeout | null>(null);

  // Auto-hide bottom bar on scroll
  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      const windowHeight = window.innerHeight;
      const documentHeight = document.documentElement.scrollHeight;
      const scrolledToBottom = windowHeight + currentScrollY >= documentHeight - 50;
      
      // Clear existing timeout
      if (scrollTimeout.current) {
        clearTimeout(scrollTimeout.current);
      }
      
      // Show nav if scrolled to bottom
      if (scrolledToBottom) {
        setIsBottomBarVisible(true);
        onNavVisibilityChange?.(false);
        lastScrollY.current = currentScrollY;
        return;
      }
      
      // Determine scroll direction
      if (currentScrollY < lastScrollY.current) {
        // Scrolling up - show bar
        setIsBottomBarVisible(true);
        onNavVisibilityChange?.(false);
      } else if (currentScrollY > lastScrollY.current && currentScrollY > 100) {
        // Scrolling down - hide bar
        setIsBottomBarVisible(false);
        onNavVisibilityChange?.(true);
      }
      
      lastScrollY.current = currentScrollY;
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    
    return () => {
      window.removeEventListener('scroll', handleScroll);
      if (scrollTimeout.current) {
        clearTimeout(scrollTimeout.current);
      }
    };
  }, [onNavVisibilityChange]);

  // Mock daily content - in real app this would come from API
  const dailyContent = {
    title: currentDay === 1 
      ? "Beginning Your Journey" 
      : `Day ${currentDay}: Growing Deeper`,
    verse: {
      reference: currentDay === 1 ? "Matthew 6:5-8" : "Matthew 6:9-13",
      text: currentDay === 1 
        ? `"And when you pray, do not be like the hypocrites, for they love to pray standing in the synagogues and on the street corners to be seen by others. Truly I tell you, they have received their reward in full. But when you pray, go into your room, close the door and pray to your Father, who is unseen. Then your Father, who sees what is done in secret, will reward you. And when you pray, do not keep on babbling like pagans, for they think they will be heard because of their many words. Do not be like them, for your Father knows what you need before you ask him."`
        : `"This, then, is how you should pray: 'Our Father in heaven, hallowed be your name, your kingdom come, your will be done, on earth as it is in heaven. Give us today our daily bread. And forgive us our debts, as we also have forgiven our debtors. And lead us not into temptation, but deliver us from the evil one.'"`
    },
    reflection: currentDay === 1
      ? "Prayer is not about impressing others or using fancy words. It's an intimate conversation with your Heavenly Father who already knows your heart. Today, we begin our journey by learning the foundation of authentic prayer - simplicity and sincerity."
      : "Jesus teaches us the model for prayer. Notice how it begins with worship, acknowledges God's sovereignty, and then brings our needs before Him. This pattern helps us align our hearts with God's will.",
    question: currentDay === 1
      ? "When you pray, are you more focused on who might be listening, or on genuinely connecting with God?"
      : "Which part of the Lord's Prayer resonates most with you today, and why?",
    action: currentDay === 1
      ? "Find a quiet place today - your room, a park, or even your car. Spend 5 minutes in honest conversation with God about what's really on your heart."
      : "Pray through the Lord's Prayer slowly, pausing after each line to reflect on what it means for your life today.",
    prayerPrompt: currentDay === 1
      ? "Father, teach me to pray with authenticity. Help me to come to you honestly, without pretense, knowing that you already see my heart..."
      : "Our Father in heaven, I honor your holy name. May your kingdom come and your will be done in my life today..."
  };

  const handleComplete = () => {
    setCompletedToday(true);
    setTimeout(() => {
      if (currentDay < plan.totalDays) {
        setCurrentDay(currentDay + 1);
        setCompletedToday(false);
        onDayComplete();
      }
    }, 1500);
  };

  const handlePrevDay = () => {
    if (currentDay > 1) {
      setCurrentDay(currentDay - 1);
      setCompletedToday(false);
    }
  };

  const handleNextDay = () => {
    if (currentDay < plan.totalDays) {
      setCurrentDay(currentDay + 1);
      setCompletedToday(false);
    }
  };

  const progress = ((currentDay - 1) / plan.totalDays) * 100;

  return (
    <div className={`min-h-screen pb-32 transition-colors duration-700 ${
      isDark 
        ? "bg-gradient-to-br from-[#1A1410] via-[#0F0A08] to-[#0A0605]" 
        : "bg-gradient-to-br from-[#FFF8F0] via-[#FFF4E8] to-[#FFE8D6]"
    }`}>
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

      <div className="relative z-10">
        {/* Header */}
        <div className="px-6 pt-8 pb-6">
          <div className="flex items-center justify-between mb-6">
            <motion.button
              whileHover={{ scale: 1.05, x: -4 }}
              whileTap={{ scale: 0.95 }}
              onClick={onBack}
              className={`flex items-center gap-2 px-4 py-2.5 rounded-[14px] ${
                isDark
                  ? "bg-white/10 border border-white/20 text-white"
                  : "bg-white border border-gray-200 text-gray-900 shadow-lg"
              } backdrop-blur-xl font-bold`}
            >
              <ChevronLeft className="w-5 h-5" />
              Plans
            </motion.button>

            <div className="flex items-center gap-2">
              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                onClick={() => setBookmarked(!bookmarked)}
                className={`w-10 h-10 rounded-[14px] ${
                  isDark
                    ? "bg-white/10 border border-white/20"
                    : "bg-white border border-gray-200 shadow-lg"
                } backdrop-blur-xl flex items-center justify-center`}
              >
                <Bookmark className={`w-5 h-5 ${
                  bookmarked 
                    ? "fill-orange-500 text-orange-500" 
                    : isDark ? "text-white/70" : "text-gray-600"
                }`} />
              </motion.button>
              <motion.button
                whileHover={{ scale: 1.1 }}
                whileTap={{ scale: 0.9 }}
                className={`w-10 h-10 rounded-[14px] ${
                  isDark
                    ? "bg-white/10 border border-white/20"
                    : "bg-white border border-gray-200 shadow-lg"
                } backdrop-blur-xl flex items-center justify-center`}
              >
                <Share2 className={`w-5 h-5 ${isDark ? "text-white/70" : "text-gray-600"}`} />
              </motion.button>
            </div>
          </div>

          {/* Plan Title & Progress */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="mb-6"
          >
            <p className={`text-sm font-bold mb-2 ${isDark ? "text-orange-400" : "text-orange-600"}`}>
              {plan.title}
            </p>
            <h1 className={`text-3xl font-black mb-4 ${isDark ? "text-white" : "text-gray-900"}`}>
              Day {currentDay} of {plan.totalDays}
            </h1>
            
            {/* Progress Bar */}
            <div className={`h-2 rounded-full overflow-hidden ${
              isDark ? "bg-white/10" : "bg-gray-200"
            }`}>
              <motion.div
                initial={{ width: 0 }}
                animate={{ width: `${progress}%` }}
                transition={{ duration: 0.5, ease: "easeOut" }}
                className={`h-full bg-gradient-to-r ${plan.gradient}`}
              />
            </div>
            <p className={`text-xs mt-2 ${isDark ? "text-white/50" : "text-gray-500"}`}>
              {Math.round(progress)}% complete
            </p>
          </motion.div>
        </div>

        {/* Content Scroll Area */}
        <div className="px-6 space-y-6 pb-8">
          {/* Daily Title Card */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className={`p-6 rounded-[28px] ${
              isDark
                ? "bg-white/10 border border-white/20"
                : "bg-white/80 border border-white/60 shadow-xl"
            } backdrop-blur-xl`}
          >
            <div className="flex items-start gap-3 mb-4">
              <div className={`w-12 h-12 rounded-[16px] flex items-center justify-center bg-gradient-to-br ${plan.gradient}`}>
                <Sparkles className="w-6 h-6 text-white" />
              </div>
              <div className="flex-1">
                <h2 className={`text-xl font-black ${isDark ? "text-white" : "text-gray-900"}`}>
                  {dailyContent.title}
                </h2>
              </div>
            </div>
          </motion.div>

          {/* Scripture Card */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
            className={`p-6 rounded-[28px] ${
              isDark
                ? "bg-white/10 border border-white/20"
                : "bg-white/80 border border-white/60 shadow-xl"
            } backdrop-blur-xl`}
          >
            <div className="flex items-center gap-2 mb-4">
              <BookOpen className={`w-5 h-5 ${isDark ? "text-orange-400" : "text-orange-600"}`} />
              <h3 className={`text-sm font-bold uppercase tracking-wider ${
                isDark ? "text-orange-400" : "text-orange-600"
              }`}>
                Today's Scripture
              </h3>
            </div>
            <p className={`text-sm font-bold mb-3 ${isDark ? "text-white/80" : "text-gray-700"}`}>
              {dailyContent.verse.reference}
            </p>
            <p className={`text-base leading-relaxed font-serif ${
              isDark ? "text-white/90" : "text-gray-800"
            }`} style={{ fontFamily: "'Crimson Text', serif" }}>
              {dailyContent.verse.text}
            </p>
          </motion.div>

          {/* Reflection Card */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
            className={`p-6 rounded-[28px] ${
              isDark
                ? "bg-white/10 border border-white/20"
                : "bg-white/80 border border-white/60 shadow-xl"
            } backdrop-blur-xl`}
          >
            <div className="flex items-center gap-2 mb-4">
              <Heart className={`w-5 h-5 ${isDark ? "text-pink-400" : "text-pink-600"}`} />
              <h3 className={`text-sm font-bold uppercase tracking-wider ${
                isDark ? "text-pink-400" : "text-pink-600"
              }`}>
                Reflection
              </h3>
            </div>
            <p className={`text-base leading-relaxed ${isDark ? "text-white/80" : "text-gray-700"}`}>
              {dailyContent.reflection}
            </p>
          </motion.div>

          {/* Question Card */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className={`p-6 rounded-[28px] ${
              isDark
                ? "bg-white/10 border border-white/20"
                : "bg-white/80 border border-white/60 shadow-xl"
            } backdrop-blur-xl`}
          >
            <div className="flex items-center gap-2 mb-4">
              <MessageCircle className={`w-5 h-5 ${isDark ? "text-purple-400" : "text-purple-600"}`} />
              <h3 className={`text-sm font-bold uppercase tracking-wider ${
                isDark ? "text-purple-400" : "text-purple-600"
              }`}>
                Reflect & Journal
              </h3>
            </div>
            <p className={`text-base leading-relaxed font-medium italic ${
              isDark ? "text-white/90" : "text-gray-800"
            }`}>
              {dailyContent.question}
            </p>
            
            {/* Journal Space */}
            <div className="mt-4">
              <textarea
                placeholder="Write your thoughts here..."
                className={`w-full h-32 p-4 rounded-[18px] text-sm resize-none ${
                  isDark
                    ? "bg-white/5 border border-white/10 text-white placeholder:text-white/30"
                    : "bg-white/50 border border-gray-200 text-gray-900 placeholder:text-gray-400"
                } backdrop-blur-sm focus:outline-none focus:ring-2 focus:ring-purple-500/50`}
              />
            </div>
          </motion.div>

          {/* Action Step Card */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.5 }}
            className={`p-6 rounded-[28px] bg-gradient-to-br ${plan.gradient} shadow-xl`}
          >
            <h3 className="text-sm font-bold uppercase tracking-wider text-white/90 mb-3">
              ⚡ Today's Action
            </h3>
            <p className="text-base leading-relaxed text-white font-medium">
              {dailyContent.action}
            </p>
          </motion.div>

          {/* Prayer Prompt Card */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6 }}
            className={`p-6 rounded-[28px] ${
              isDark
                ? "bg-white/10 border border-white/20"
                : "bg-white/80 border border-white/60 shadow-xl"
            } backdrop-blur-xl`}
          >
            <h3 className={`text-sm font-bold uppercase tracking-wider mb-3 ${
              isDark ? "text-teal-400" : "text-teal-600"
            }`}>
              🙏 Prayer Starter
            </h3>
            <p className={`text-base leading-relaxed italic ${
              isDark ? "text-white/80" : "text-gray-700"
            }`}>
              {dailyContent.prayerPrompt}
            </p>
          </motion.div>

          {/* Complete Day Button - After Content */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7 }}
            className="pt-4"
          >
            {/* Progress Dots */}
            <div className="flex items-center justify-center gap-1.5 mb-4">
              {[...Array(Math.min(plan.totalDays, 10))].map((_, i) => {
                const dayNumber = i + 1;
                const isCompleted = dayNumber < currentDay;
                const isCurrent = dayNumber === currentDay;
                
                return (
                  <motion.div
                    key={i}
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    transition={{ delay: i * 0.05 }}
                    className={`h-1.5 rounded-full transition-all duration-300 ${
                      isCurrent 
                        ? "w-8 bg-gradient-to-r from-orange-500 to-pink-500" 
                        : isCompleted
                          ? "w-1.5 bg-green-500"
                          : isDark ? "w-1.5 bg-white/20" : "w-1.5 bg-gray-300"
                    }`}
                  />
                );
              })}
              {plan.totalDays > 10 && (
                <span className={`text-xs ${isDark ? "text-white/40" : "text-gray-400"}`}>
                  +{plan.totalDays - 10}
                </span>
              )}
            </div>

            {/* Main Complete Button */}
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleComplete}
              disabled={completedToday}
              className={`w-full py-4 rounded-[20px] font-bold shadow-2xl relative overflow-hidden ${
                completedToday
                  ? "bg-gradient-to-r from-green-500 to-emerald-600"
                  : `bg-gradient-to-r ${plan.gradient}`
              } text-white disabled:cursor-not-allowed`}
            >
              <motion.div
                className="absolute inset-0 bg-white/20"
                initial={{ x: "-100%" }}
                animate={{ x: completedToday ? "100%" : "-100%" }}
                transition={{ duration: 0.6 }}
              />
              <span className="relative flex items-center justify-center gap-2.5">
                {completedToday ? (
                  <>
                    <Check className="w-5 h-5" strokeWidth={3} />
                    Day {currentDay} Complete! 🎉
                  </>
                ) : (
                  <>
                    <div className={`w-6 h-6 rounded-full border-2 border-white/60 flex items-center justify-center ${
                      completedToday ? "bg-white" : ""
                    }`}>
                      {completedToday && <Check className="w-4 h-4 text-green-600" strokeWidth={3} />}
                    </div>
                    Complete Day {currentDay}
                  </>
                )}
              </span>
            </motion.button>
          </motion.div>
        </div>

        {/* Fixed Edge Navigation Buttons */}
        <AnimatePresence>
          {isBottomBarVisible && (
            <motion.div 
              initial={{ y: 100, opacity: 0 }}
              animate={{ y: 0, opacity: 1 }}
              exit={{ y: 100, opacity: 0 }}
              transition={{ duration: 0.3, ease: "easeOut" }}
              className="fixed bottom-0 left-0 right-0 z-40 px-4 pb-6 flex items-center justify-between pointer-events-none"
            >
              {/* Previous Day Button - Left Edge */}
              <motion.button
                whileHover={{ scale: 1.1, x: -4 }}
                whileTap={{ scale: 0.9 }}
                onClick={handlePrevDay}
                disabled={currentDay === 1}
                className={`w-14 h-14 rounded-[18px] flex items-center justify-center shadow-xl pointer-events-auto ${
                  currentDay === 1
                    ? isDark 
                      ? "bg-white/5 text-white/20" 
                      : "bg-gray-200/50 text-gray-300"
                    : isDark
                      ? "bg-white/15 border border-white/30 text-white"
                      : "bg-white/90 border border-white/60 text-gray-900 shadow-2xl"
                } backdrop-blur-2xl disabled:cursor-not-allowed transition-all`}
              >
                <ChevronLeft className="w-6 h-6" strokeWidth={2.5} />
              </motion.button>

              {/* Next Day Button - Right Edge */}
              <motion.button
                whileHover={{ scale: 1.1, x: 4 }}
                whileTap={{ scale: 0.9 }}
                onClick={handleNextDay}
                disabled={currentDay === plan.totalDays}
                className={`w-14 h-14 rounded-[18px] flex items-center justify-center shadow-xl pointer-events-auto ${
                  currentDay === plan.totalDays
                    ? isDark 
                      ? "bg-white/5 text-white/20" 
                      : "bg-gray-200/50 text-gray-300"
                    : isDark
                      ? "bg-white/15 border border-white/30 text-white"
                      : "bg-white/90 border border-white/60 text-gray-900 shadow-2xl"
                } backdrop-blur-2xl disabled:cursor-not-allowed transition-all`}
              >
                <ChevronRight className="w-6 h-6" strokeWidth={2.5} />
              </motion.button>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      {/* Success Confetti Animation */}
      <AnimatePresence>
        {completedToday && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 pointer-events-none z-50 flex items-center justify-center"
          >
            {[...Array(20)].map((_, i) => (
              <motion.div
                key={i}
                initial={{ 
                  y: "50%", 
                  x: "50%",
                  scale: 0,
                  rotate: 0
                }}
                animate={{ 
                  y: `${Math.random() * 100 - 50}%`,
                  x: `${Math.random() * 100 - 50}%`,
                  scale: [0, 1.5, 0],
                  rotate: Math.random() * 360
                }}
                transition={{ 
                  duration: 1.5,
                  ease: "easeOut"
                }}
                className={`absolute w-3 h-3 rounded-full ${
                  i % 3 === 0 
                    ? "bg-orange-500" 
                    : i % 3 === 1 
                      ? "bg-pink-500" 
                      : "bg-purple-500"
                }`}
              />
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}