interface DynamicIslandNavProps {
  currentPage: "sanctuary" | "lens" | "plans" | "mentor";
  onPageChange: (page: "sanctuary" | "lens" | "plans" | "mentor") => void;
  isDark: boolean;
}

export function DynamicIslandNav({ currentPage, onPageChange, isDark }: DynamicIslandNavProps) {
  return (
    <div className="fixed bottom-8 left-1/2 transform -translate-x-1/2 bg-gray-800 text-white rounded-full px-6 py-3 flex gap-4">
      <button onClick={() => onPageChange("sanctuary")} className={currentPage === "sanctuary" ? "font-bold" : ""}>
        Home
      </button>
      <button onClick={() => onPageChange("lens")} className={currentPage === "lens" ? "font-bold" : ""}>
        Read
      </button>
      <button onClick={() => onPageChange("plans")} className={currentPage === "plans" ? "font-bold" : ""}>
        Plans
      </button>
      <button onClick={() => onPageChange("mentor")} className={currentPage === "mentor" ? "font-bold" : ""}>
        Journal
      </button>
    </div>
  );
}
