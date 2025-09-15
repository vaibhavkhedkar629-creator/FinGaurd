/*
  # AI Financial Fraud Detection System Database Schema

  1. New Tables
    - `users` - User accounts with risk profiles and notification preferences
    - `transactions` - All financial transactions with detailed metadata
    - `fraud_alerts` - Generated fraud alerts with risk scores and resolution status
    - `user_behavior_patterns` - ML-generated user behavior profiles
    - `fraud_rules` - Configurable fraud detection rules and weights

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to access their own data
    - Admin policies for fraud analysts

  3. Features
    - Real-time transaction processing
    - ML-based anomaly detection data storage
    - Rule-based fraud detection configuration
    - Comprehensive audit trails
    - Performance optimized indexes
*/

-- Users table with enhanced fraud detection fields
CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  full_name text NOT NULL,
  phone text,
  account_number text UNIQUE NOT NULL,
  bank_name text NOT NULL,
  account_type text DEFAULT 'savings',
  risk_profile text DEFAULT 'low' CHECK (risk_profile IN ('low', 'medium', 'high')),
  notification_preferences jsonb DEFAULT '{"email": true, "sms": true, "push": true}',
  is_fraud_analyst boolean DEFAULT false,
  account_status text DEFAULT 'active' CHECK (account_status IN ('active', 'suspended', 'frozen')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Transactions table with comprehensive fraud detection metadata
CREATE TABLE IF NOT EXISTS transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  transaction_id text UNIQUE NOT NULL,
  amount decimal(15,2) NOT NULL,
  currency text DEFAULT 'USD',
  transaction_type text NOT NULL CHECK (transaction_type IN ('debit', 'credit', 'transfer', 'withdrawal', 'deposit', 'payment')),
  merchant_name text,
  merchant_category text,
  location_country text,
  location_city text,
  ip_address inet,
  device_fingerprint text,
  payment_method text CHECK (payment_method IN ('card', 'online', 'mobile', 'atm', 'wire')),
  card_last_four text,
  transaction_time timestamptz NOT NULL,
  processing_time timestamptz DEFAULT now(),
  is_weekend boolean DEFAULT false,
  is_night_transaction boolean DEFAULT false,
  risk_score decimal(5,2) DEFAULT 0.00,
  is_flagged boolean DEFAULT false,
  status text DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'blocked', 'reversed')),
  created_at timestamptz DEFAULT now()
);

-- Fraud alerts table
CREATE TABLE IF NOT EXISTS fraud_alerts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
  transaction_id uuid REFERENCES transactions(id) ON DELETE CASCADE,
  alert_type text NOT NULL,
  risk_score decimal(5,2) NOT NULL CHECK (risk_score >= 0 AND risk_score <= 100),
  confidence_level text NOT NULL CHECK (confidence_level IN ('low', 'medium', 'high')),
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed_fraud', 'false_positive', 'investigating', 'resolved')),
  alert_message text NOT NULL,
  factors jsonb DEFAULT '[]',
  ml_model_version text DEFAULT 'v1.0',
  reviewed_by uuid REFERENCES users(id),
  reviewed_at timestamptz,
  resolution_notes text,
  created_at timestamptz DEFAULT now()
);

-- User behavior patterns table for ML profiling
CREATE TABLE IF NOT EXISTS user_behavior_patterns (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  avg_transaction_amount decimal(15,2) DEFAULT 0,
  std_transaction_amount decimal(15,2) DEFAULT 0,
  max_transaction_amount decimal(15,2) DEFAULT 0,
  typical_transaction_times jsonb DEFAULT '[]',
  frequent_merchants jsonb DEFAULT '[]',
  usual_locations jsonb DEFAULT '[]',
  usual_countries jsonb DEFAULT '[]',
  usual_cities jsonb DEFAULT '[]',
  monthly_spending_avg decimal(15,2) DEFAULT 0,
  transaction_frequency_daily decimal(5,2) DEFAULT 0,
  preferred_payment_methods jsonb DEFAULT '[]',
  spending_by_category jsonb DEFAULT '{}',
  weekend_spending_ratio decimal(5,2) DEFAULT 0.3,
  night_transaction_ratio decimal(5,2) DEFAULT 0.1,
  last_updated timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

-- Fraud detection rules table
CREATE TABLE IF NOT EXISTS fraud_rules (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rule_name text NOT NULL UNIQUE,
  rule_type text NOT NULL CHECK (rule_type IN ('amount_threshold', 'location_check', 'velocity_check', 'time_pattern', 'merchant_risk', 'device_check')),
  conditions jsonb NOT NULL,
  risk_weight decimal(5,2) NOT NULL CHECK (risk_weight >= 0 AND risk_weight <= 100),
  is_active boolean DEFAULT true,
  description text,
  created_by text DEFAULT 'system',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes for performance optimization
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_time ON transactions(transaction_time);
CREATE INDEX IF NOT EXISTS idx_transactions_risk_score ON transactions(risk_score DESC);
CREATE INDEX IF NOT EXISTS idx_fraud_alerts_user_id ON fraud_alerts(user_id);
CREATE INDEX IF NOT EXISTS idx_fraud_alerts_status ON fraud_alerts(status);
CREATE INDEX IF NOT EXISTS idx_fraud_alerts_risk_score ON fraud_alerts(risk_score DESC);
CREATE INDEX IF NOT EXISTS idx_fraud_alerts_created_at ON fraud_alerts(created_at DESC);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE fraud_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_behavior_patterns ENABLE ROW LEVEL SECURITY;
ALTER TABLE fraud_rules ENABLE ROW LEVEL SECURITY;

-- RLS Policies for users
CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Fraud analysts can view all users"
  ON users FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users WHERE id = auth.uid() AND is_fraud_analyst = true
    )
  );

-- RLS Policies for transactions
CREATE POLICY "Users can view own transactions"
  ON transactions FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_fraud_analyst = true)
  );

CREATE POLICY "System can insert transactions"
  ON transactions FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- RLS Policies for fraud alerts
CREATE POLICY "Users can view own alerts"
  ON fraud_alerts FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_fraud_analyst = true)
  );

CREATE POLICY "Fraud analysts can manage alerts"
  ON fraud_alerts FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_fraud_analyst = true)
  );

-- RLS Policies for user behavior patterns
CREATE POLICY "Users can view own patterns"
  ON user_behavior_patterns FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_fraud_analyst = true)
  );

CREATE POLICY "System can manage behavior patterns"
  ON user_behavior_patterns FOR ALL
  TO authenticated
  WITH CHECK (true);

-- RLS Policies for fraud rules
CREATE POLICY "Everyone can view active fraud rules"
  ON fraud_rules FOR SELECT
  TO authenticated
  USING (is_active = true);

CREATE POLICY "Fraud analysts can manage rules"
  ON fraud_rules FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND is_fraud_analyst = true)
  );

-- Insert default fraud detection rules
INSERT INTO fraud_rules (rule_name, rule_type, conditions, risk_weight, description) VALUES
('High Amount Transaction', 'amount_threshold', '{"multiplier": 5, "base": "user_average"}', 30.0, 'Transaction amount 5x higher than user average'),
('Unusual Location', 'location_check', '{"check_country": true, "check_city": false}', 25.0, 'Transaction from unusual country'),
('High Frequency', 'velocity_check', '{"max_transactions": 5, "time_window": "1 hour"}', 40.0, 'More than 5 transactions in 1 hour'),
('Night Transaction', 'time_pattern', '{"start_hour": 23, "end_hour": 5}', 15.0, 'Transaction during night hours (11PM - 5AM)'),
('Weekend Large Amount', 'time_pattern', '{"is_weekend": true, "amount_multiplier": 3}', 20.0, 'Large transaction during weekend'),
('New Merchant High Amount', 'merchant_risk', '{"new_merchant": true, "amount_multiplier": 2}', 25.0, 'High amount transaction with new merchant'),
('Rapid Successive Transactions', 'velocity_check', '{"max_transactions": 3, "time_window": "5 minutes"}', 35.0, 'More than 3 transactions in 5 minutes'),
('Cross-border Transaction', 'location_check', '{"different_country": true, "min_amount": 1000}', 30.0, 'International transaction over $1000')
ON CONFLICT (rule_name) DO NOTHING;

-- Function to update user behavior patterns
CREATE OR REPLACE FUNCTION update_user_behavior_patterns()
RETURNS trigger AS $$
BEGIN
  INSERT INTO user_behavior_patterns (user_id, last_updated)
  VALUES (NEW.user_id, now())
  ON CONFLICT (user_id) DO UPDATE SET last_updated = now();
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update behavior patterns when new transactions are added
CREATE TRIGGER update_behavior_patterns_trigger
  AFTER INSERT ON transactions
  FOR EACH ROW
  EXECUTE FUNCTION update_user_behavior_patterns();
