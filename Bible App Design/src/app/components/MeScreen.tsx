import { Settings, Award, BookOpen, Sparkles, Heart, Calendar, ChevronRight, X, TrendingUp, Target, Zap } from "lucide-react";
import { motion } from "motion/react";

interface MeScreenProps {
  onClose: () => void;
  timeOfDay: "morning" | "day" | "evening" | "night";
}

export function MeScreen({ onClose, timeOfDay }: MeScreenProps) {
  const isDark = timeOfDay === "night" || timeOfDay === "evening";
  
  const stats = [
    { icon: Award, label: "Day Streak", value: "127", color: "from-orange-500 to-red-600", glow: "orange" },
    { icon: BookOpen, label: "Verses Read", value: "1.2k", color: "from-blue-500 to-cyan-600", glow: "blue" },
    { icon: Sparkles, label: "Notes", value: "24", color: "from-purple-500 to-pink-600", glow: "purple" },
    { icon: Heart, label: "Prayers", value: "156", color: "from-rose-500 to-pink-600", glow: "pink" }
  ];

  const achievements = [
    { title: "30 Day Streak", description: "Read scripture for 30 consecutive days", unlocked: true, gradient: "from-amber-500 to-orange-600" },
    { title: "Scripture Scholar", description: "Read 1000 verses", unlocked: true, gradient: "from-blue-500 to-cyan-600" },
    { title: "Prayer Warrior", description: "Complete 100 prayer entries", unlocked: false, gradient: "from-gray-400 to-gray-500" }
  ];

  return (
    <div className={`min-h-screen pb-32 px-6 pt-6 ${isDark ? "text-white" : "text-gray-900"}`}>
      {/* Header with Close and Settings */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        className="mb-8 flex items-center justify-between"
      >
        <button
          onClick={onClose}
          className="w-10 h-10 rounded-full bg-white/5 backdrop-blur-sm flex items-center justify-center hover:bg-white/10 transition-colors"
        >
          <X className="w-5 h-5" />
        </button>
        <button className="w-10 h-10 rounded-full bg-white/5 backdrop-blur-sm flex items-center justify-center hover:bg-white/10 transition-colors">
          <Settings className="w-5 h-5" />
        </button>
      </motion.div>

      {/* 3D Soul Sphere Placeholder / Profile Avatar */}
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ delay: 0.1 }}
        className="mb-8 flex flex-col items-center"
      >
        <div className="relative w-32 h-32 mb-6">
          {/* Outer glow ring */}
          <div className="absolute inset-0 rounded-full bg-gradient-to-br from-[#C17D4A] to-[#8B7355] blur-2xl opacity-40 animate-pulse" />
          
          {/* Main sphere */}
          <div className="relative w-32 h-32 rounded-full bg-gradient-to-br from-[#C17D4A] via-[#D4A574] to-[#8B7355] border-4 border-white/20 shadow-2xl overflow-hidden">
            {/* Glass effect overlay */}
            <div className="absolute inset-0 bg-gradient-to-br from-white/30 via-transparent to-black/20" />
            
            {/* Highlight shine */}
            <div className="absolute top-6 left-6 w-12 h-12 bg-white/40 rounded-full blur-xl" />
          </div>
        </div>

        <h1 className="text-3xl mb-2 font-scripture">Your Soul Sphere</h1>
        <p className="text-white/60 text-sm font-ui">Reflecting your spiritual journey</p>
      </motion.div>

      {/* Quick Stats Grid */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        className="grid grid-cols-2 gap-3 mb-8"
      >
        {stats.map((stat, index) => {
          const Icon = stat.icon;
          return (
            <motion.div
              key={index}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.3 + index * 0.05 }}
              className={`relative overflow-hidden rounded-3xl bg-gradient-to-br ${stat.color} p-5 shadow-xl`}
            >
              <div className="absolute top-0 right-0 w-20 h-20 bg-white/10 rounded-full blur-2xl" />
              <div className="relative z-10">
                <Icon className="w-6 h-6 mb-3 text-white/90" />
                <p className="text-3xl mb-1 font-ui">{stat.value}</p>
                <p className="text-xs text-white/70 font-ui">{stat.label}</p>
              </div>
            </motion.div>
          );
        })}
      </motion.div>

      {/* Progress Section */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
        className="mb-8"
      >
        <h2 className="text-sm text-white/80 font-ui tracking-wide mb-4">THIS WEEK'S PROGRESS</h2>
        <div className="bg-white/5 backdrop-blur-sm border border-white/10 rounded-3xl p-6">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <TrendingUp className="w-4 h-4 text-[#D4A574]" />
              <span className="text-sm font-ui">Reading Goal</span>
            </div>
            <span className="text-sm text-[#D4A574] font-ui">67%</span>
          </div>
          <div className="h-2 bg-white/10 rounded-full overflow-hidden mb-3">
            <div className="h-full bg-gradient-to-r from-[#C17D4A] to-[#D4A574] rounded-full w-2/3" />
          </div>
          <p className="text-xs text-white/60 font-ui">20 of 30 days completed</p>
        </div>
      </motion.div>

      {/* Achievements */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6 }}
        className="mb-8"
      >
        <h2 className="text-sm text-white/80 font-ui tracking-wide mb-4">ACHIEVEMENTS</h2>
        <div className="space-y-3">
          {achievements.map((achievement, index) => (
            <div
              key={index}
              className={`bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-4 ${
                achievement.unlocked ? "" : "opacity-50"
              }`}
            >
              <div className="flex items-center gap-4">
                <div
                  className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                    achievement.unlocked
                      ? "bg-gradient-to-br from-[#C17D4A] to-[#8B7355]"
                      : "bg-white/10"
                  }`}
                >
                  <Award className="w-6 h-6" />
                </div>
                <div className="flex-1">
                  <h3 className="text-sm mb-1 font-ui">{achievement.title}</h3>
                  <p className="text-xs text-white/60 font-ui">{achievement.description}</p>
                </div>
                {achievement.unlocked && <ChevronRight className="w-5 h-5 text-white/40" />}
              </div>
            </div>
          ))}
        </div>
      </motion.div>

      {/* Activity Calendar Preview */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.7 }}
        className="mb-6"
      >
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-sm text-white/80 font-ui tracking-wide">ACTIVITY</h2>
          <button className="text-xs text-[#D4A574] hover:text-[#C17D4A] transition-colors font-ui flex items-center gap-1">
            View All <ChevronRight className="w-3 h-3" />
          </button>
        </div>
        <div className="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-5">
          <div className="grid grid-cols-7 gap-2">
            {Array.from({ length: 28 }).map((_, i) => {
              const isActive = Math.random() > 0.3;
              return (
                <div
                  key={i}
                  className={`aspect-square rounded-lg ${
                    isActive
                      ? "bg-gradient-to-br from-[#C17D4A] to-[#8B7355]"
                      : "bg-white/10"
                  }`}
                />
              );
            })}
          </div>
          <div className="flex items-center justify-between mt-4 pt-4 border-t border-white/10">
            <div className="flex items-center gap-2">
              <Calendar className="w-3 h-3 text-white/40" />
              <span className="text-xs text-white/60 font-ui">Last 4 weeks</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-sm bg-white/10" />
              <span className="text-xs text-white/40 font-ui">Less</span>
              <div className="w-2 h-2 rounded-sm bg-[#C17D4A]/40" />
              <div className="w-2 h-2 rounded-sm bg-[#C17D4A]/70" />
              <div className="w-2 h-2 rounded-sm bg-[#C17D4A]" />
              <span className="text-xs text-white/40 font-ui">More</span>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  );
}