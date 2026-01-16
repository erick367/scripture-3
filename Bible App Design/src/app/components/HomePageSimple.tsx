interface HomePageProps {
  onProfileClick: () => void;
  onSearchClick: () => void;
  timeOfDay: "morning" | "day" | "evening" | "night";
}

export function HomePage({ onProfileClick, onSearchClick, timeOfDay }: HomePageProps) {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl mb-4">HomePage - {timeOfDay}</h1>
        <button onClick={onProfileClick} className="mr-4 px-4 py-2 bg-blue-500 text-white rounded">Profile</button>
        <button onClick={onSearchClick} className="px-4 py-2 bg-green-500 text-white rounded">Search</button>
      </div>
    </div>
  );
}
