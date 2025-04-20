-- Users table for traveler and host profiles
     CREATE TABLE users (
         user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
         cognito_id VARCHAR(128) UNIQUE NOT NULL,
         email VARCHAR(255) UNIQUE NOT NULL,
         name VARCHAR(255) NOT NULL,
         role VARCHAR(20) NOT NULL CHECK (role IN ('traveler', 'host')),
         verified BOOLEAN DEFAULT FALSE,
         loyalty_points INTEGER DEFAULT 0,
         created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
         updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
     );

     -- Meetups table for tours and events
     CREATE TABLE meetups (
         meetup_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
         host_id UUID NOT NULL REFERENCES users(user_id),
         title VARCHAR(255) NOT NULL,
         category VARCHAR(50) NOT NULL,
         location VARCHAR(255) NOT NULL,
         fee DECIMAL(15,2) NOT NULL,
         capacity INTEGER NOT NULL,
         is_recurring BOOLEAN DEFAULT FALSE,
         recurrence_rule VARCHAR(255),
         is_private BOOLEAN DEFAULT FALSE,
         created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
         updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
     );

     -- Payments table for transactions (to be used with 9Pay)
     CREATE TABLE payments (
         payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
         meetup_id UUID NOT NULL REFERENCES meetups(meetup_id),
         traveler_id UUID NOT NULL REFERENCES users(user_id),
         host_id UUID NOT NULL REFERENCES users(user_id),
         amount DECIMAL(15,2) NOT NULL,
         currency VARCHAR(3) NOT NULL DEFAULT 'VND',
         status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'verified', 'failed', 'completed')),
         proof_url VARCHAR(255),
         traveler_confirmed BOOLEAN DEFAULT FALSE,
         created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
         verified_at TIMESTAMP WITH TIME ZONE,
         completed_at TIMESTAMP WITH TIME ZONE
     );

     -- Index for faster queries
     CREATE INDEX idx_users_cognito_id ON users(cognito_id);
     CREATE INDEX idx_meetups_host_id ON meetups(host_id);
     CREATE INDEX idx_payments_meetup_id ON payments(meetup_id);