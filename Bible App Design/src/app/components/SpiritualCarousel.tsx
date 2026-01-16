import { Sparkles, ArrowRight, Heart } from "lucide-react";
import { motion, AnimatePresence } from "motion/react";
import { useState } from "react";

interface SpiritualCarouselProps {
  isDark: boolean;
  verseOfTheDay: {
    verse: string;
    reference: string;
    category: string;
  };
  prayerOfTheDay: {
    title: string;
    prayer: string;
    theme: string;
  };
}

export function SpiritualCarousel({ isDark, verseOfTheDay, prayerOfTheDay }: SpiritualCarouselProps) {
  const [carouselIndex, setCarouselIndex] = useState(0);

  const switchCard = () => {
    setCarouselIndex((prev) => (prev === 0 ? 1 : 0));
  };

  const handleCardClick = (e: React.MouseEvent) => {
    // Don't flip if clicking on a button or interactive element
    const target = e.target as HTMLElement;
    if (target.closest('button') || target.closest('[role="button"]')) {
      return;
    }
    switchCard();
  };

  return (
    <div className="mb-6">
      {/* Stacked Cards Container - increased height to show stacked card */}
      <div className="relative h-[520px] pt-0 pb-8">
        {/* Back Card (Prayer) - Always visible, stacked behind and peeking from top */}
        <motion.div
          animate={{
            scale: carouselIndex === 1 ? 1 : 0.96,
            y: carouselIndex === 1 ? 0 : 0,
            x: carouselIndex === 1 ? 0 : 0,
            opacity: carouselIndex === 1 ? 1 : 1,
            zIndex: carouselIndex === 1 ? 20 : 10,
          }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
          className={`absolute top-12 left-0 right-0 h-[480px] rounded-[40px] p-10 ${
            isDark
              ? "bg-gradient-to-br from-purple-900/60 via-indigo-900/50 to-blue-900/60 border border-purple-500/30"
              : "bg-gradient-to-br from-purple-50 via-indigo-50 to-blue-50 border border-purple-200"
          } backdrop-blur-xl shadow-2xl overflow-hidden`}
          style={{ 
            pointerEvents: carouselIndex === 1 ? 'auto' : 'none',
            cursor: carouselIndex === 1 ? 'pointer' : 'default',
          }}
          onClick={(e) => carouselIndex === 1 && handleCardClick(e)}
        >
          {/* Glass overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/10 via-transparent to-white/5" />

          {/* Animated gradient orb */}
          <motion.div
            animate={{
              scale: [1, 1.4, 1],
              opacity: [0.2, 0.4, 0.2],
            }}
            transition={{
              duration: 12,
              repeat: Infinity,
            }}
            className={`absolute -top-20 -right-20 w-96 h-96 rounded-full blur-3xl ${
              isDark
                ? "bg-gradient-to-br from-purple-500/30 via-indigo-500/20 to-blue-500/30"
                : "bg-gradient-to-br from-purple-400/40 via-indigo-400/30 to-blue-400/40"
            }`}
          />

          <div className="relative z-10 h-full flex flex-col">
            {/* Header */}
            <div className="flex items-center gap-3 mb-6">
              <motion.div
                animate={{ rotate: [0, 10, -10, 0] }}
                transition={{ duration: 4, repeat: Infinity }}
                className={`w-14 h-14 rounded-[18px] ${
                  isDark
                    ? "bg-gradient-to-br from-purple-500 via-indigo-600 to-blue-600"
                    : "bg-gradient-to-br from-purple-400 via-indigo-500 to-blue-500"
                } flex items-center justify-center shadow-lg relative overflow-hidden`}
              >
                <motion.div
                  animate={{ x: ["-100%", "200%"] }}
                  transition={{
                    duration: 3,
                    repeat: Infinity,
                    ease: "linear",
                    repeatDelay: 2,
                  }}
                  className="absolute inset-0 bg-gradient-to-r from-transparent via-white/40 to-transparent"
                />
                <Heart className="w-7 h-7 text-white relative z-10" />
              </motion.div>
              <div>
                <h3
                  className={`text-base font-bold uppercase tracking-wider ${
                    isDark ? "text-purple-200" : "text-purple-700"
                  }`}
                >
                  Prayer of the Day
                </h3>
                <p
                  className={`text-sm ${
                    isDark ? "text-white/60" : "text-gray-600"
                  }`}
                >
                  {prayerOfTheDay.theme}
                </p>
              </div>
            </div>

            {/* Prayer Title */}
            <h4
              className={`text-2xl font-bold mb-4 ${
                isDark ? "text-white" : "text-gray-900"
              }`}
            >
              {prayerOfTheDay.title}
            </h4>

            {/* Prayer Text */}
            <p
              className={`font-scripture text-2xl leading-relaxed italic mb-6 ${
                isDark ? "text-white/90" : "text-gray-800"
              }`}
              style={{ fontFamily: "'Crimson Text', serif" }}
            >
              "{prayerOfTheDay.prayer}"
            </p>

            {/* Spacer */}
            <div className="flex-1" />
          </div>
        </motion.div>

        {/* Front Card (Verse) - Always visible, stacked in front */}
        <motion.div
          animate={{
            scale: carouselIndex === 0 ? 1 : 0.95,
            y: carouselIndex === 0 ? 0 : 12,
            opacity: carouselIndex === 0 ? 1 : 0.6,
            zIndex: carouselIndex === 0 ? 20 : 10,
          }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
          className={`absolute top-0 left-0 right-0 h-[480px] rounded-[40px] ${
            isDark
              ? "bg-gradient-to-br from-white/10 to-white/5 border border-white/20"
              : "bg-gradient-to-br from-white via-white to-blue-50/50 border border-black/10"
          } backdrop-blur-2xl shadow-2xl p-10 overflow-hidden`}
          style={{ 
            pointerEvents: carouselIndex === 0 ? 'auto' : 'none',
            cursor: carouselIndex === 0 ? 'pointer' : 'default',
          }}
          onClick={(e) => carouselIndex === 0 && handleCardClick(e)}
        >
          {/* Floating particles */}
          <div className="absolute inset-0 overflow-hidden rounded-[40px] pointer-events-none">
            {[...Array(8)].map((_, i) => (
              <motion.div
                key={i}
                animate={{
                  y: [0, -30, 0],
                  x: [0, Math.random() * 20 - 10, 0],
                  opacity: [0.3, 0.6, 0.3],
                }}
                transition={{
                  duration: 3 + Math.random() * 2,
                  repeat: Infinity,
                  delay: Math.random() * 2,
                }}
                className={`absolute w-2 h-2 rounded-full ${
                  isDark ? "bg-white/30" : "bg-blue-400/40"
                }`}
                style={{
                  left: `${Math.random() * 100}%`,
                  top: `${Math.random() * 100}%`,
                }}
              />
            ))}
          </div>

          {/* Content */}
          <div className="relative">
            <motion.div className="flex items-center gap-3 mb-6">
              <motion.div
                whileHover={{ rotate: 360 }}
                transition={{ duration: 0.6 }}
                className={`w-14 h-14 rounded-2xl ${
                  isDark
                    ? "bg-gradient-to-br from-orange-500 to-pink-600"
                    : "bg-gradient-to-br from-orange-400 to-pink-500"
                } flex items-center justify-center shadow-xl`}
              >
                <Sparkles className="w-7 h-7 text-white" />
              </motion.div>
              <div>
                <h2 className={`text-lg font-bold ${
                  isDark ? "text-white" : "text-gray-900"
                }`}>
                  Verse of the Day
                </h2>
                <p className={`text-sm ${
                  isDark ? "text-white/50" : "text-gray-500"
                }`}>
                  {verseOfTheDay.category}
                </p>
              </div>
            </motion.div>

            <blockquote
              className={`font-scripture text-[26px] leading-[1.6] mb-6 ${
                isDark ? "text-white" : "text-gray-900"
              }`}
              style={{ fontFamily: "'Crimson Text', serif" }}
            >
              "{verseOfTheDay.verse}"
            </blockquote>

            <div className="flex items-center justify-between mt-auto pt-4">
              <div className="flex items-center gap-3">
                <div
                  className={`px-4 py-2 rounded-2xl ${
                    isDark
                      ? "bg-white/10 border border-white/20"
                      : "bg-gradient-to-br from-orange-50 to-pink-50 border border-orange-200"
                  }`}
                >
                  <span
                    className={`font-bold ${
                      isDark ? "text-orange-300" : "text-orange-600"
                    }`}
                  >
                    {verseOfTheDay.reference}
                  </span>
                </div>
              </div>

              <motion.button
                animate={{ x: [0, 5, 0] }}
                transition={{ duration: 2, repeat: Infinity }}
                onClick={(e) => {
                  e.stopPropagation(); // Prevent card flip
                  console.log("Read More clicked!");
                }}
                className={`px-6 py-3 rounded-2xl ${
                  isDark
                    ? "bg-white/10 border border-white/20 hover:bg-white/20"
                    : "bg-white border border-black/10 shadow-lg hover:shadow-xl"
                } font-semibold flex items-center gap-2 ${
                  isDark ? "text-white" : "text-gray-900"
                } transition-all cursor-pointer`}
                style={{ pointerEvents: 'auto' }}
              >
                Read More
                <ArrowRight className="w-5 h-5" />
              </motion.button>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Card Indicators - More prominent */}
      <div className="flex items-center justify-center gap-2 mt-5">
        {[0, 1].map((index) => {
          const isActive = carouselIndex === index;
          return (
            <motion.button
              key={index}
              onClick={() => {
                setCarouselIndex(index);
              }}
              animate={{
                width: isActive ? 32 : 8,
                opacity: isActive ? 1 : 0.3,
              }}
              whileHover={{ opacity: 0.6, scale: 1.1 }}
              className={`h-2 rounded-full cursor-pointer transition-all ${
                isDark ? "bg-white" : "bg-gray-900"
              }`}
            />
          );
        })}
      </div>

      {/* Helper text below dots - Made more prominent and visible */}
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6 }}
        className="flex items-center justify-center mt-4"
      >
        <motion.button
          animate={{ 
            y: [0, -3, 0],
            scale: [1, 1.05, 1]
          }}
          transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
          onClick={() => switchCard()}
          className={`px-5 py-2.5 rounded-full ${
            isDark 
              ? "bg-gradient-to-r from-purple-500/20 to-pink-500/20 border border-purple-400/40 hover:from-purple-500/30 hover:to-pink-500/30" 
              : "bg-gradient-to-r from-purple-100 to-pink-100 border border-purple-300/60 hover:from-purple-200 hover:to-pink-200"
          } backdrop-blur-sm shadow-lg cursor-pointer transition-all`}
        >
          <span className={`text-sm font-bold tracking-wide ${
            isDark ? "text-white" : "text-gray-900"
          }`}>
            {carouselIndex === 0 ? "Tap for prayer" : "Tap for verse"}
          </span>
        </motion.button>
      </motion.div>
    </div>
  );
}