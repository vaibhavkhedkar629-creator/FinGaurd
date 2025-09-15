# FinGuard - Advanced Financial Fraud Detection System

A comprehensive, real-time AI-powered financial fraud detection system built with React, TypeScript, and Supabase. This system combines machine learning algorithms with rule-based detection to identify suspicious transactions and minimize financial fraud while reducing false positives.

## 🚀 Features

### Core Fraud Detection
- **Real-time Transaction Processing** - Analyze transactions as they occur
- **ML-based Anomaly Detection** - Advanced algorithms to identify suspicious patterns
- **Rule-based Detection Engine** - Configurable fraud detection rules with weights
- **Risk Scoring Algorithm** - Combine ML and rule-based results for accurate scoring
- **Velocity Checks** - Monitor transaction frequency and amount patterns

### Alert Management
- **Multi-level Alert System** - Low, medium, high, and critical risk categorization
- **Real-time Notifications** - Instant alerts via WebSocket connections
- **Alert Resolution Workflow** - Comprehensive investigation and resolution tools
- **False Positive Management** - Learn from analyst feedback to improve accuracy

### User Behavior Analytics
- **Behavioral Pattern Analysis** - Build comprehensive user spending profiles
- **Location-based Risk Assessment** - Flag transactions from unusual locations
- **Merchant Pattern Recognition** - Identify deviations from normal merchant usage
- **Time-based Analysis** - Detect unusual transaction timing patterns

### Advanced Dashboard
- **Real-time Transaction Monitor** - Live stream of transaction processing
- **Risk Score Visualization** - Interactive charts and trending analysis
- **Alert Management Interface** - Comprehensive alert queue with filtering
- **Performance Metrics** - System health and fraud detection effectiveness

## 🛠 Technology Stack

- **Frontend**: React 18 with TypeScript
- **Backend**: Supabase (PostgreSQL + Real-time)
- **Styling**: Tailwind CSS
- **Icons**: Lucide React
- **Authentication**: Supabase Auth
- **Database**: PostgreSQL with Row Level Security
- **Real-time**: WebSocket connections via Supabase

## 🏗 Database Schema

### Tables
- **users** - User accounts with risk profiles and preferences
- **transactions** - Comprehensive transaction data with metadata
- **fraud_alerts** - Generated alerts with risk scores and status
- **user_behavior_patterns** - ML-generated user behavior profiles
- **fraud_rules** - Configurable detection rules and weights

## 🎯 Fraud Detection Methods

### Machine Learning Features
- Amount deviation from user patterns (Z-score analysis)
- Time-based anomaly detection (unusual hours/days)
- Velocity pattern analysis (transaction frequency)
- Location-based risk assessment (new countries/cities)
- Merchant behavior analysis (new merchants, risk categories)

### Rule-based Detection
- **High Amount Threshold** - Transactions significantly above user average
- **Unusual Location** - Transactions from new geographic locations
- **Velocity Checks** - High transaction frequency within time windows
- **Time Pattern Analysis** - Night transactions, weekend patterns
- **Merchant Risk Assessment** - High-risk merchant categories
- **Cross-border Monitoring** - International transaction screening

## 🔧 Setup Instructions

### Prerequisites
- Node.js 18+
- Supabase account and project

### Installation

1. **Clone and install dependencies**
```bash
git clone <repository-url>
cd fraudguard-ai
npm install
```

2. **Set up Supabase**
   - Create a new Supabase project
   - Click "Connect to Supabase" in the top right of the interface
   - Follow the setup prompts

3. **Configure environment variables**
```bash
cp .env.example .env
# Update with your Supabase credentials
```

4. **Run the application**
```bash
npm run dev
```

## 🎮 Demo Usage

### Quick Start
1. Use the demo login credentials:
   - **Regular User**: `user@demo.com` / `demo123`
   - **Fraud Analyst**: `analyst@demo.com` / `analyst123`

2. Use the Demo Controls panel (bottom-right) to:
   - Start automatic transaction simulation
   - Generate velocity alerts (rapid transactions)
   - Trigger suspicious high-risk activities
   - Clear demo data when needed

### Understanding the Interface

#### Dashboard Overview
- **Metrics Cards** - Real-time fraud detection statistics
- **Risk Distribution Chart** - Visual breakdown of risk scores
- **Alert Categories** - Summary of different alert types
- **Transaction Monitor** - Live transaction processing stream

#### Alert Management
- **Alert Queue** - Sortable table of all fraud alerts
- **Alert Details** - Comprehensive investigation interface
- **Risk Factors** - Detailed breakdown of why alerts were triggered
- **Resolution Tools** - Mark as fraud, false positive, or investigate

## 🔒 Security Features

- **Row Level Security (RLS)** - Database-level access control
- **Encrypted Sensitive Data** - PII and financial data protection
- **API Rate Limiting** - Prevent abuse and DoS attacks
- **Audit Trails** - Comprehensive logging of all actions
- **Role-based Access Control** - Different permissions for users and analysts

## 📊 Performance Metrics

The system tracks key performance indicators:
- **Detection Accuracy** - Percentage of actual fraud detected
- **False Positive Rate** - Legitimate transactions flagged as fraud
- **Processing Speed** - Average transaction processing time
- **System Uptime** - Availability and reliability metrics
- **Alert Response Time** - Time to generate and deliver alerts

## 🧪 Testing Features

### Simulation Capabilities
- **Random Transaction Generation** - Realistic transaction patterns
- **Suspicious Activity Triggers** - Generate high-risk scenarios
- **Velocity Pattern Testing** - Rapid transaction sequences
- **Geographic Risk Testing** - Unusual location transactions
- **High-value Transaction Testing** - Large amount anomaly detection

## 🚀 Production Considerations

### Scaling
- Horizontal scaling with Supabase
- Efficient database indexing for high transaction volumes
- Real-time processing optimization
- Caching strategies for user behavior patterns

### Monitoring
- System health monitoring
- Performance metrics tracking
- Alert fatigue prevention
- Model performance monitoring

### Compliance
- GDPR/CCPA compliance features
- Data anonymization capabilities
- Audit trail requirements
- Regulatory reporting tools

## 📈 Future Enhancements

- Advanced ML models (ensemble methods, deep learning)
- Graph-based fraud detection (network analysis)
- External data integration (device fingerprinting, IP reputation)
- Mobile application support
- Advanced analytics and reporting
- Integration with external fraud databases

## 🤝 Contributing

This project demonstrates advanced fraud detection techniques and modern web development practices. It's designed to be both educational and production-ready, showcasing:

- Real-time data processing
- Machine learning integration
- Complex business logic implementation
- Advanced UI/UX design
- Database optimization
- Security best practices

## 📄 License

This project is intended for demonstration and educational purposes, showcasing advanced fraud detection capabilities in a modern web application framework.