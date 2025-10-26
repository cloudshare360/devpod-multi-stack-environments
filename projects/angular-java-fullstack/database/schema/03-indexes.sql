-- 03-indexes.sql
-- Employee Management Database Indexes
-- Optimized indexes for all relationship types and common queries

-- ==============================================
-- DEPARTMENTS TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_departments_name ON departments(name);
CREATE INDEX IF NOT EXISTS idx_departments_head_employee_id ON departments(head_employee_id);
CREATE INDEX IF NOT EXISTS idx_departments_location ON departments(location);
CREATE INDEX IF NOT EXISTS idx_departments_budget ON departments(budget);

-- ==============================================
-- EMPLOYEES TABLE INDEXES (Core entity)
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_employees_employee_number ON employees(employee_number);
CREATE INDEX IF NOT EXISTS idx_employees_email ON employees(email);
CREATE INDEX IF NOT EXISTS idx_employees_department_id ON employees(department_id);
CREATE INDEX IF NOT EXISTS idx_employees_manager_id ON employees(manager_id);
CREATE INDEX IF NOT EXISTS idx_employees_is_active ON employees(is_active);
CREATE INDEX IF NOT EXISTS idx_employees_hire_date ON employees(hire_date);
CREATE INDEX IF NOT EXISTS idx_employees_salary ON employees(salary);
CREATE INDEX IF NOT EXISTS idx_employees_job_title ON employees(job_title);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_employees_dept_active ON employees(department_id, is_active);
CREATE INDEX IF NOT EXISTS idx_employees_manager_active ON employees(manager_id, is_active);
CREATE INDEX IF NOT EXISTS idx_employees_name ON employees(last_name, first_name);

-- Full-text search for employee names
CREATE INDEX IF NOT EXISTS idx_employees_search ON employees 
    USING GIN (to_tsvector('english', first_name || ' ' || last_name || ' ' || COALESCE(job_title, '')));

-- GIN indexes for JSONB fields
CREATE INDEX IF NOT EXISTS idx_employees_address ON employees USING GIN (address);
CREATE INDEX IF NOT EXISTS idx_employees_emergency_contact ON employees USING GIN (emergency_contact);

-- ==============================================
-- EMPLOYEE_PROFILES TABLE INDEXES (One-to-One)
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_employee_profiles_performance_rating ON employee_profiles(performance_rating);
CREATE INDEX IF NOT EXISTS idx_employee_profiles_years_experience ON employee_profiles(years_experience);
CREATE INDEX IF NOT EXISTS idx_employee_profiles_education_level ON employee_profiles(education_level);

-- GIN indexes for arrays and JSONB
CREATE INDEX IF NOT EXISTS idx_employee_profiles_skills ON employee_profiles USING GIN (skills);
CREATE INDEX IF NOT EXISTS idx_employee_profiles_certifications ON employee_profiles USING GIN (certifications);

-- ==============================================
-- PROJECTS TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_projects_name ON projects(name);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects(status);
CREATE INDEX IF NOT EXISTS idx_projects_project_manager_id ON projects(project_manager_id);
CREATE INDEX IF NOT EXISTS idx_projects_start_date ON projects(start_date);
CREATE INDEX IF NOT EXISTS idx_projects_end_date ON projects(end_date);
CREATE INDEX IF NOT EXISTS idx_projects_deadline ON projects(deadline);
CREATE INDEX IF NOT EXISTS idx_projects_priority ON projects(priority);
CREATE INDEX IF NOT EXISTS idx_projects_budget ON projects(budget);

-- Composite indexes for project queries
CREATE INDEX IF NOT EXISTS idx_projects_status_priority ON projects(status, priority);
CREATE INDEX IF NOT EXISTS idx_projects_manager_status ON projects(project_manager_id, status);

-- ==============================================
-- PROJECT_ASSIGNMENTS TABLE INDEXES (Many-to-Many)
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_project_assignments_employee_id ON project_assignments(employee_id);
CREATE INDEX IF NOT EXISTS idx_project_assignments_project_id ON project_assignments(project_id);
CREATE INDEX IF NOT EXISTS idx_project_assignments_role ON project_assignments(role);
CREATE INDEX IF NOT EXISTS idx_project_assignments_is_active ON project_assignments(is_active);
CREATE INDEX IF NOT EXISTS idx_project_assignments_assigned_date ON project_assignments(assigned_date);

-- Composite indexes for assignment queries
CREATE INDEX IF NOT EXISTS idx_project_assignments_emp_active ON project_assignments(employee_id, is_active);
CREATE INDEX IF NOT EXISTS idx_project_assignments_proj_active ON project_assignments(project_id, is_active);

-- ==============================================
-- ATTENDANCE TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_attendance_employee_id ON attendance(employee_id);
CREATE INDEX IF NOT EXISTS idx_attendance_date ON attendance(date);
CREATE INDEX IF NOT EXISTS idx_attendance_status ON attendance(status);
CREATE INDEX IF NOT EXISTS idx_attendance_total_hours ON attendance(total_hours);

-- Composite indexes for attendance queries
CREATE INDEX IF NOT EXISTS idx_attendance_emp_date ON attendance(employee_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_attendance_emp_status ON attendance(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_attendance_date_status ON attendance(date, status);

-- ==============================================
-- LEAVE_REQUESTS TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_leave_requests_employee_id ON leave_requests(employee_id);
CREATE INDEX IF NOT EXISTS idx_leave_requests_leave_type ON leave_requests(leave_type);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status ON leave_requests(status);
CREATE INDEX IF NOT EXISTS idx_leave_requests_start_date ON leave_requests(start_date);
CREATE INDEX IF NOT EXISTS idx_leave_requests_end_date ON leave_requests(end_date);
CREATE INDEX IF NOT EXISTS idx_leave_requests_approved_by ON leave_requests(approved_by);

-- Composite indexes for leave queries
CREATE INDEX IF NOT EXISTS idx_leave_requests_emp_status ON leave_requests(employee_id, status);
CREATE INDEX IF NOT EXISTS idx_leave_requests_emp_type ON leave_requests(employee_id, leave_type);
CREATE INDEX IF NOT EXISTS idx_leave_requests_status_dates ON leave_requests(status, start_date, end_date);

-- ==============================================
-- PERFORMANCE_REVIEWS TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_performance_reviews_employee_id ON performance_reviews(employee_id);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_reviewer_id ON performance_reviews(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_status ON performance_reviews(status);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_overall_rating ON performance_reviews(overall_rating);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_period_start ON performance_reviews(review_period_start);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_period_end ON performance_reviews(review_period_end);

-- Composite indexes for review queries
CREATE INDEX IF NOT EXISTS idx_performance_reviews_emp_period ON performance_reviews(employee_id, review_period_start DESC);
CREATE INDEX IF NOT EXISTS idx_performance_reviews_emp_status ON performance_reviews(employee_id, status);

-- ==============================================
-- SKILLS TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_skills_name ON skills(name);
CREATE INDEX IF NOT EXISTS idx_skills_category ON skills(category);

-- ==============================================
-- EMPLOYEE_SKILLS TABLE INDEXES (Many-to-Many)
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_employee_skills_employee_id ON employee_skills(employee_id);
CREATE INDEX IF NOT EXISTS idx_employee_skills_skill_id ON employee_skills(skill_id);
CREATE INDEX IF NOT EXISTS idx_employee_skills_proficiency_level ON employee_skills(proficiency_level);
CREATE INDEX IF NOT EXISTS idx_employee_skills_years_experience ON employee_skills(years_experience);
CREATE INDEX IF NOT EXISTS idx_employee_skills_certified ON employee_skills(certified);

-- Composite indexes for skill queries
CREATE INDEX IF NOT EXISTS idx_employee_skills_emp_proficiency ON employee_skills(employee_id, proficiency_level);
CREATE INDEX IF NOT EXISTS idx_employee_skills_skill_proficiency ON employee_skills(skill_id, proficiency_level);

-- ==============================================
-- SALARY_HISTORY TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_salary_history_employee_id ON salary_history(employee_id);
CREATE INDEX IF NOT EXISTS idx_salary_history_effective_date ON salary_history(effective_date);
CREATE INDEX IF NOT EXISTS idx_salary_history_approved_by ON salary_history(approved_by);
CREATE INDEX IF NOT EXISTS idx_salary_history_change_reason ON salary_history(change_reason);

-- Composite indexes for salary queries
CREATE INDEX IF NOT EXISTS idx_salary_history_emp_date ON salary_history(employee_id, effective_date DESC);

-- ==============================================
-- AUDIT_LOGS TABLE INDEXES
-- ==============================================
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_name ON audit_logs(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_logs_record_id ON audit_logs(record_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_changed_by ON audit_logs(changed_by);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at);

-- Composite indexes for audit queries
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_record ON audit_logs(table_name, record_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table_action ON audit_logs(table_name, action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_date ON audit_logs(changed_by, created_at DESC);

-- Log index creation
DO $$
BEGIN
    RAISE NOTICE 'All indexes created successfully';
    RAISE NOTICE 'Performance indexes added for all tables';
    RAISE NOTICE 'Full-text search index created for products';
    RAISE NOTICE 'GIN indexes created for JSONB fields';
END $$;