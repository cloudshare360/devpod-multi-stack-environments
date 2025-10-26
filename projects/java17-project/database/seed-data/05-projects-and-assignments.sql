-- 05-projects-and-assignments.sql
-- Seed data for projects and project_assignments tables (Many-to-Many relationship)

-- Insert projects
INSERT INTO projects (id, name, description, start_date, end_date, deadline, status, budget, project_manager_id, client_name, priority) VALUES
('p0000001-0000-0000-0000-000000000001', 'Customer Portal Redesign', 'Complete redesign of customer-facing web portal with modern UI/UX and improved performance', '2024-01-15', NULL, '2024-06-30', 'active', 850000.00, 'e0000007-0000-0000-0000-000000000007', 'Internal Project', 'high'),

('p0000002-0000-0000-0000-000000000002', 'Mobile App Development', 'Native mobile application for iOS and Android with real-time features and offline capabilities', '2024-02-01', NULL, '2024-08-15', 'active', 1200000.00, 'e0000002-0000-0000-0000-000000000002', 'TechCorp Solutions', 'critical'),

('p0000003-0000-0000-0000-000000000003', 'Data Analytics Platform', 'Enterprise-grade analytics platform with machine learning capabilities and real-time dashboards', '2024-03-01', NULL, '2024-12-31', 'active', 2000000.00, 'e0000007-0000-0000-0000-000000000007', 'DataInsights Inc', 'high'),

('p0000004-0000-0000-0000-000000000004', 'HR Management System', 'Comprehensive HRMS with employee self-service, performance management, and recruiting modules', '2023-09-01', '2024-02-28', '2024-02-28', 'completed', 650000.00, 'e0000009-0000-0000-0000-000000000009', 'Global HR Solutions', 'medium'),

('p0000005-0000-0000-0000-000000000005', 'Cloud Migration Initiative', 'Migration of legacy systems to AWS cloud infrastructure with improved scalability and security', '2024-01-01', NULL, '2024-09-30', 'active', 1500000.00, 'e0000002-0000-0000-0000-000000000002', 'Internal Project', 'high'),

('p0000006-0000-0000-0000-000000000006', 'E-commerce Integration', 'Integration with major e-commerce platforms and payment gateways for seamless transactions', '2024-04-01', NULL, '2024-07-31', 'planning', 750000.00, 'e0000011-0000-0000-0000-000000000011', 'RetailMax Corp', 'medium'),

('p0000007-0000-0000-0000-000000000007', 'Security Audit & Compliance', 'Comprehensive security audit and implementation of SOX compliance measures', '2024-02-15', NULL, '2024-05-31', 'active', 400000.00, 'e0000008-0000-0000-0000-000000000008', 'Internal Project', 'critical'),

('p0000008-0000-0000-0000-000000000008', 'Marketing Automation Platform', 'Advanced marketing automation with AI-powered personalization and campaign management', '2024-03-15', NULL, '2024-10-31', 'active', 900000.00, 'e0000010-0000-0000-0000-000000000010', 'MarketGenius Ltd', 'medium'),

('p0000009-0000-0000-0000-000000000009', 'Supply Chain Optimization', 'AI-driven supply chain optimization system with predictive analytics and inventory management', '2023-11-01', '2024-04-30', '2024-04-30', 'completed', 1100000.00, 'e0000007-0000-0000-0000-000000000007', 'LogiFlow Systems', 'high'),

('p0000010-0000-0000-0000-000000000010', 'Training Portal Development', 'Learning management system with video streaming, progress tracking, and certification management', '2024-05-01', NULL, '2024-11-30', 'planning', 550000.00, 'e0000009-0000-0000-0000-000000000009', 'EduTech Partners', 'low');

-- Insert project assignments (Many-to-Many relationships)
INSERT INTO project_assignments (employee_id, project_id, role, assigned_date, end_date, hours_allocated, hourly_rate, is_active) VALUES
-- Customer Portal Redesign team
('e0000007-0000-0000-0000-000000000007', 'p0000001-0000-0000-0000-000000000001', 'Project Manager & Lead Developer', '2024-01-15', NULL, 1200, 95.00, true),
('e0000011-0000-0000-0000-000000000011', 'p0000001-0000-0000-0000-000000000001', 'Frontend Developer', '2024-01-20', NULL, 1000, 75.00, true),
('e0000016-0000-0000-0000-000000000016', 'p0000001-0000-0000-0000-000000000001', 'Junior Developer', '2024-02-01', NULL, 800, 45.00, true),
('e0000014-0000-0000-0000-000000000014', 'p0000001-0000-0000-0000-000000000001', 'UI/UX Designer', '2024-01-15', NULL, 600, 65.00, true),

-- Mobile App Development team
('e0000002-0000-0000-0000-000000000002', 'p0000002-0000-0000-0000-000000000002', 'Technical Lead', '2024-02-01', NULL, 800, 120.00, true),
('e0000007-0000-0000-0000-000000000007', 'p0000002-0000-0000-0000-000000000002', 'Senior Developer', '2024-02-05', NULL, 1000, 95.00, true),
('e0000011-0000-0000-0000-000000000011', 'p0000002-0000-0000-0000-000000000002', 'Mobile Developer', '2024-02-10', NULL, 1200, 75.00, true),
('e0000016-0000-0000-0000-000000000016', 'p0000002-0000-0000-0000-000000000002', 'QA Tester', '2024-02-15', NULL, 600, 45.00, true),

-- Data Analytics Platform team
('e0000007-0000-0000-0000-000000000007', 'p0000003-0000-0000-0000-000000000003', 'Project Manager', '2024-03-01', NULL, 1000, 95.00, true),
('e0000002-0000-0000-0000-000000000002', 'p0000003-0000-0000-0000-000000000003', 'AI/ML Architect', '2024-03-05', NULL, 800, 120.00, true),
('e0000008-0000-0000-0000-000000000008', 'p0000003-0000-0000-0000-000000000003', 'Data Analyst', '2024-03-01', NULL, 1200, 85.00, true),
('e0000012-0000-0000-0000-000000000012', 'p0000003-0000-0000-0000-000000000003', 'Business Analyst', '2024-03-10', NULL, 800, 70.00, true),

-- HR Management System team (Completed project)
('e0000009-0000-0000-0000-000000000009', 'p0000004-0000-0000-0000-000000000004', 'Project Manager', '2023-09-01', '2024-02-28', 1000, 90.00, false),
('e0000013-0000-0000-0000-000000000013', 'p0000004-0000-0000-0000-000000000004', 'HR Specialist', '2023-09-15', '2024-02-28', 800, 55.00, false),
('e0000011-0000-0000-0000-000000000011', 'p0000004-0000-0000-0000-000000000004', 'Backend Developer', '2023-10-01', '2024-02-28', 1200, 75.00, false),
('e0000018-0000-0000-0000-000000000018', 'p0000004-0000-0000-0000-000000000004', 'Documentation Specialist', '2023-11-01', '2024-02-28', 400, 35.00, false),

-- Cloud Migration Initiative team
('e0000002-0000-0000-0000-000000000002', 'p0000005-0000-0000-0000-000000000005', 'Migration Lead', '2024-01-01', NULL, 1000, 120.00, true),
('e0000007-0000-0000-0000-000000000007', 'p0000005-0000-0000-0000-000000000005', 'DevOps Engineer', '2024-01-15', NULL, 1200, 95.00, true),
('e0000011-0000-0000-0000-000000000011', 'p0000005-0000-0000-0000-000000000005', 'Cloud Developer', '2024-01-20', NULL, 1000, 75.00, true),

-- E-commerce Integration team (Planning phase)
('e0000011-0000-0000-0000-000000000011', 'p0000006-0000-0000-0000-000000000006', 'Project Manager', '2024-04-01', NULL, 800, 75.00, true),
('e0000016-0000-0000-0000-000000000016', 'p0000006-0000-0000-0000-000000000006', 'Integration Developer', '2024-04-01', NULL, 1000, 45.00, true),
('e0000015-0000-0000-0000-000000000015', 'p0000006-0000-0000-0000-000000000006', 'Sales Liaison', '2024-04-01', NULL, 400, 65.00, true),

-- Security Audit team
('e0000008-0000-0000-0000-000000000008', 'p0000007-0000-0000-0000-000000000007', 'Audit Lead', '2024-02-15', NULL, 800, 85.00, true),
('e0000002-0000-0000-0000-000000000002', 'p0000007-0000-0000-0000-000000000007', 'Security Architect', '2024-02-20', NULL, 600, 120.00, true),
('e0000012-0000-0000-0000-000000000012', 'p0000007-0000-0000-0000-000000000007', 'Compliance Analyst', '2024-02-25', NULL, 700, 70.00, true),

-- Marketing Automation Platform team
('e0000010-0000-0000-0000-000000000010', 'p0000008-0000-0000-0000-000000000008', 'Project Manager', '2024-03-15', NULL, 800, 85.00, true),
('e0000014-0000-0000-0000-000000000014', 'p0000008-0000-0000-0000-000000000008', 'Marketing Specialist', '2024-03-15', NULL, 1000, 65.00, true),
('e0000019-0000-0000-0000-000000000019', 'p0000008-0000-0000-0000-000000000008', 'Content Coordinator', '2024-03-20', NULL, 800, 55.00, true),
('e0000011-0000-0000-0000-000000000011', 'p0000008-0000-0000-0000-000000000008', 'Platform Developer', '2024-03-25', NULL, 1000, 75.00, true),

-- Supply Chain Optimization team (Completed)
('e0000007-0000-0000-0000-000000000007', 'p0000009-0000-0000-0000-000000000009', 'Project Manager', '2023-11-01', '2024-04-30', 1200, 95.00, false),
('e0000002-0000-0000-0000-000000000002', 'p0000009-0000-0000-0000-000000000009', 'AI Specialist', '2023-11-15', '2024-04-30', 800, 120.00, false),
('e0000008-0000-0000-0000-000000000008', 'p0000009-0000-0000-0000-000000000009', 'Business Analyst', '2023-11-01', '2024-04-30', 1000, 85.00, false);

-- Log projects and assignments insertion
DO $$
BEGIN
    RAISE NOTICE 'Inserted % projects', (SELECT COUNT(*) FROM projects);
    RAISE NOTICE 'Inserted % project assignments (Many-to-Many relationships)', (SELECT COUNT(*) FROM project_assignments);
    RAISE NOTICE 'Active projects: %', (SELECT COUNT(*) FROM projects WHERE status = 'active');
    RAISE NOTICE 'Completed projects: %', (SELECT COUNT(*) FROM projects WHERE status = 'completed');
END $$;