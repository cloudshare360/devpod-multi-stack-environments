-- 02-tables.sql
-- Employee Management Database Schema
-- Demonstrates all RDBMS relationship types with comprehensive CRUD operations

-- ==============================================
-- DEPARTMENTS TABLE (Master table for 1:M relationships)
-- ==============================================
CREATE TABLE IF NOT EXISTS departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    budget DECIMAL(15,2) CHECK (budget >= 0),
    location VARCHAR(100),
    head_employee_id UUID, -- Will be set after employees table creation
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- EMPLOYEES TABLE (Core entity with multiple relationships)
-- ==============================================
CREATE TABLE IF NOT EXISTS employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    salary DECIMAL(12,2) CHECK (salary >= 0),
    job_title VARCHAR(100),
    department_id UUID REFERENCES departments(id), -- Many-to-One relationship
    manager_id UUID REFERENCES employees(id), -- Self-referencing (Manager hierarchy)
    is_active BOOLEAN DEFAULT true,
    address JSONB, -- JSON field for complex address data
    emergency_contact JSONB, -- JSON field for emergency contact info
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key constraint for department head (One-to-One relationship)
ALTER TABLE departments ADD CONSTRAINT fk_departments_head_employee 
    FOREIGN KEY (head_employee_id) REFERENCES employees(id);

-- ==============================================
-- EMPLOYEE PROFILES TABLE (One-to-One relationship)
-- ==============================================
CREATE TABLE IF NOT EXISTS employee_profiles (
    employee_id UUID PRIMARY KEY REFERENCES employees(id) ON DELETE CASCADE,
    bio TEXT,
    avatar_url VARCHAR(255),
    linkedin_url VARCHAR(255),
    skills TEXT[], -- Array of skills
    certifications JSONB, -- JSON array of certifications
    performance_rating DECIMAL(3,2) CHECK (performance_rating >= 0 AND performance_rating <= 5),
    years_experience INTEGER DEFAULT 0,
    education_level VARCHAR(50),
    preferred_language VARCHAR(20) DEFAULT 'en',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- PROJECTS TABLE (For Many-to-Many relationships)
-- ==============================================
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    start_date DATE,
    end_date DATE,
    deadline DATE,
    status VARCHAR(20) DEFAULT 'planning' CHECK (status IN ('planning', 'active', 'on_hold', 'completed', 'cancelled')),
    budget DECIMAL(15,2) CHECK (budget >= 0),
    project_manager_id UUID REFERENCES employees(id), -- One-to-Many relationship
    client_name VARCHAR(100),
    priority VARCHAR(10) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- PROJECT_ASSIGNMENTS TABLE (Many-to-Many relationship)
-- ==============================================
CREATE TABLE IF NOT EXISTS project_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    role VARCHAR(100), -- Developer, Designer, Tester, etc.
    assigned_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    hours_allocated INTEGER DEFAULT 0,
    hourly_rate DECIMAL(8,2),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, project_id) -- One assignment per employee per project
);

-- ==============================================
-- ATTENDANCE TABLE (One-to-Many from employees)
-- ==============================================
CREATE TABLE IF NOT EXISTS attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    break_duration INTERVAL DEFAULT '0 hours',
    total_hours DECIMAL(4,2),
    status VARCHAR(20) DEFAULT 'present' CHECK (status IN ('present', 'absent', 'late', 'half_day', 'holiday', 'sick_leave')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, date) -- One attendance record per employee per day
);

-- ==============================================
-- LEAVE_REQUESTS TABLE (One-to-Many from employees)
-- ==============================================
CREATE TABLE IF NOT EXISTS leave_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    leave_type VARCHAR(30) NOT NULL CHECK (leave_type IN ('vacation', 'sick', 'personal', 'maternity', 'paternity', 'bereavement', 'other')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_requested INTEGER NOT NULL CHECK (days_requested > 0),
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
    approved_by UUID REFERENCES employees(id),
    approved_at TIMESTAMP WITH TIME ZONE,
    comments TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- PERFORMANCE_REVIEWS TABLE (One-to-Many from employees)
-- ==============================================
CREATE TABLE IF NOT EXISTS performance_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    reviewer_id UUID NOT NULL REFERENCES employees(id),
    review_period_start DATE NOT NULL,
    review_period_end DATE NOT NULL,
    overall_rating DECIMAL(3,2) CHECK (overall_rating >= 0 AND overall_rating <= 5),
    goals_achievement DECIMAL(3,2) CHECK (goals_achievement >= 0 AND goals_achievement <= 5),
    technical_skills DECIMAL(3,2) CHECK (technical_skills >= 0 AND technical_skills <= 5),
    communication_skills DECIMAL(3,2) CHECK (communication_skills >= 0 AND communication_skills <= 5),
    teamwork DECIMAL(3,2) CHECK (teamwork >= 0 AND teamwork <= 5),
    strengths TEXT,
    areas_for_improvement TEXT,
    goals_next_period TEXT,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'final')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- EMPLOYEE_SKILLS TABLE (Many-to-Many skills management)
-- ==============================================
CREATE TABLE IF NOT EXISTS skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50), -- Technical, Soft Skills, Languages, etc.
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employee_skills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    proficiency_level VARCHAR(20) DEFAULT 'beginner' CHECK (proficiency_level IN ('beginner', 'intermediate', 'advanced', 'expert')),
    years_experience INTEGER DEFAULT 0,
    certified BOOLEAN DEFAULT false,
    last_used_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(employee_id, skill_id)
);

-- ==============================================
-- SALARY_HISTORY TABLE (One-to-Many for tracking salary changes)
-- ==============================================
CREATE TABLE IF NOT EXISTS salary_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE CASCADE,
    old_salary DECIMAL(12,2),
    new_salary DECIMAL(12,2) NOT NULL,
    change_reason VARCHAR(100),
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    approved_by UUID REFERENCES employees(id),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- AUDIT_LOGS TABLE (For tracking all changes)
-- ==============================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_name VARCHAR(50) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(10) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_values JSONB,
    new_values JSONB,
    changed_by UUID REFERENCES employees(id),
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================
-- TRIGGERS FOR AUTOMATIC UPDATED_AT
-- ==============================================
CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employee_profiles_updated_at BEFORE UPDATE ON employee_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_leave_requests_updated_at BEFORE UPDATE ON leave_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_performance_reviews_updated_at BEFORE UPDATE ON performance_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_employee_skills_updated_at BEFORE UPDATE ON employee_skills
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Log table creation
DO $$
BEGIN
    RAISE NOTICE 'All tables created successfully';
    RAISE NOTICE 'Tables: users, categories, products, orders, order_items, reviews, user_sessions, audit_logs';
    RAISE NOTICE 'Triggers added for automatic updated_at timestamps';
END $$;