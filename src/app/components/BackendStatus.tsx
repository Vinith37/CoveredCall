import { useState, useEffect } from "react";
import { checkBackendHealth } from "../api/payoffApi";

interface BackendStatusProps {
  className?: string;
}

export function BackendStatus({ className = "" }: BackendStatusProps) {
  const [isHealthy, setIsHealthy] = useState<boolean | null>(null);
  const [isChecking, setIsChecking] = useState(true);

  useEffect(() => {
    const checkHealth = async () => {
      setIsChecking(true);
      const healthy = await checkBackendHealth();
      setIsHealthy(healthy);
      setIsChecking(false);
    };

    // Check immediately
    checkHealth();

    // Check every 30 seconds
    const interval = setInterval(checkHealth, 30000);

    return () => clearInterval(interval);
  }, []);

  if (isChecking) {
    return (
      <div className={`flex items-center gap-2 text-sm ${className}`}>
        <div className="w-2 h-2 rounded-full bg-gray-400 animate-pulse" />
        <span className="text-gray-500">Checking backend...</span>
      </div>
    );
  }

  if (isHealthy) {
    return (
      <div className={`flex items-center gap-2 text-sm ${className}`}>
        <div className="w-2 h-2 rounded-full bg-green-500 animate-pulse" />
        <span className="text-green-700 font-medium">Backend connected</span>
      </div>
    );
  }

  return (
    <div className={`flex items-center gap-2 text-sm ${className}`}>
      <div className="w-2 h-2 rounded-full bg-amber-500" />
      <span className="text-amber-700 font-medium">
        Backend offline (using local calculations)
      </span>
    </div>
  );
}
