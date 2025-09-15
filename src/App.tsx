import React from 'react';
import { useAuth } from './hooks/useAuth';
import { Auth } from './components/Auth';
import { Dashboard } from './components/Dashboard';
import { DemoControls } from './components/DemoControls';

function App() {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"></div>
          <p className="text-gray-600">Loading FraudGuard AI...</p>
        </div>
      </div>
    );
  }

  if (!user) {
    return <Auth />;
  }

  return (
    <>
      <Dashboard />
      <DemoControls />
    </>
  );
}

export default App;
