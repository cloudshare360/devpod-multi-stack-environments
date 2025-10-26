-- 04-skills-and-employee-skills.sql
-- Seed data for skills and employee_skills tables (Many-to-Many relationship)

-- Insert skills
INSERT INTO skills (id, name, category, description) VALUES
-- Technical Skills
('s0000001-0000-0000-0000-000000000001', 'JavaScript', 'Programming Language', 'Modern web development programming language'),
('s0000002-0000-0000-0000-000000000002', 'Python', 'Programming Language', 'Versatile programming language for web, data science, and automation'),
('s0000003-0000-0000-0000-000000000003', 'Java', 'Programming Language', 'Enterprise-grade object-oriented programming language'),
('s0000004-0000-0000-0000-000000000004', 'React', 'Frontend Framework', 'Popular JavaScript library for building user interfaces'),
('s0000005-0000-0000-0000-000000000005', 'Node.js', 'Backend Technology', 'JavaScript runtime for server-side development'),
('s0000006-0000-0000-0000-000000000006', 'PostgreSQL', 'Database', 'Advanced open-source relational database'),
('s0000007-0000-0000-0000-000000000007', 'AWS', 'Cloud Platform', 'Amazon Web Services cloud computing platform'),
('s0000008-0000-0000-0000-000000000008', 'Docker', 'DevOps Tool', 'Containerization platform for application deployment'),
('s0000009-0000-0000-0000-000000000009', 'Kubernetes', 'DevOps Tool', 'Container orchestration platform'),
('s0000010-0000-0000-0000-000000000010', 'Git', 'Version Control', 'Distributed version control system'),

-- Data & Analytics
('s0000011-0000-0000-0000-000000000011', 'SQL', 'Database Query', 'Structured Query Language for database operations'),
('s0000012-0000-0000-0000-000000000012', 'Excel', 'Productivity Tool', 'Microsoft Excel for data analysis and reporting'),
('s0000013-0000-0000-0000-000000000013', 'Tableau', 'Data Visualization', 'Business intelligence and data visualization tool'),
('s0000014-0000-0000-0000-000000000014', 'Power BI', 'Data Visualization', 'Microsoft business analytics tool'),
('s0000015-0000-0000-0000-000000000015', 'Machine Learning', 'AI/ML', 'Artificial intelligence and machine learning techniques'),

-- Soft Skills
('s0000016-0000-0000-0000-000000000016', 'Leadership', 'Management', 'Ability to guide and motivate teams'),
('s0000017-0000-0000-0000-000000000017', 'Communication', 'Interpersonal', 'Effective verbal and written communication'),
('s0000018-0000-0000-0000-000000000018', 'Project Management', 'Management', 'Planning and executing projects successfully'),
('s0000019-0000-0000-0000-000000000019', 'Problem Solving', 'Analytical', 'Analytical thinking and solution development'),
('s0000020-0000-0000-0000-000000000020', 'Team Collaboration', 'Interpersonal', 'Working effectively in team environments'),

-- Business Skills
('s0000021-0000-0000-0000-000000000021', 'Financial Analysis', 'Finance', 'Analyzing financial data and making recommendations'),
('s0000022-0000-0000-0000-000000000022', 'Digital Marketing', 'Marketing', 'Online marketing strategies and execution'),
('s0000023-0000-0000-0000-000000000023', 'Sales Strategy', 'Sales', 'Developing and implementing sales approaches'),
('s0000024-0000-0000-0000-000000000024', 'HR Management', 'Human Resources', 'Managing human resources and talent'),
('s0000025-0000-0000-0000-000000000025', 'Strategic Planning', 'Strategy', 'Long-term planning and strategic thinking');

-- Insert employee skills (Many-to-Many relationships)
INSERT INTO employee_skills (employee_id, skill_id, proficiency_level, years_experience, certified, last_used_date) VALUES
-- Sarah Johnson (CEO) - Leadership and Strategic skills
('e0000001-0000-0000-0000-000000000001', 's0000016-0000-0000-0000-000000000016', 'expert', 20, true, '2024-10-20'),
('e0000001-0000-0000-0000-000000000001', 's0000025-0000-0000-0000-000000000025', 'expert', 18, true, '2024-10-20'),
('e0000001-0000-0000-0000-000000000001', 's0000017-0000-0000-0000-000000000017', 'expert', 20, false, '2024-10-20'),
('e0000001-0000-0000-0000-000000000001', 's0000018-0000-0000-0000-000000000018', 'advanced', 15, true, '2024-10-15'),

-- Michael Chen (CTO) - Technical leadership
('e0000002-0000-0000-0000-000000000002', 's0000002-0000-0000-0000-000000000002', 'expert', 15, true, '2024-10-20'),
('e0000002-0000-0000-0000-000000000002', 's0000003-0000-0000-0000-000000000003', 'expert', 12, true, '2024-10-18'),
('e0000002-0000-0000-0000-000000000002', 's0000007-0000-0000-0000-000000000007', 'expert', 8, true, '2024-10-20'),
('e0000002-0000-0000-0000-000000000002', 's0000009-0000-0000-0000-000000000009', 'expert', 6, true, '2024-10-19'),
('e0000002-0000-0000-0000-000000000002', 's0000015-0000-0000-0000-000000000015', 'advanced', 5, true, '2024-10-17'),
('e0000002-0000-0000-0000-000000000002', 's0000016-0000-0000-0000-000000000016', 'expert', 10, false, '2024-10-20'),

-- Emily Davis (CFO) - Financial skills
('e0000003-0000-0000-0000-000000000003', 's0000021-0000-0000-0000-000000000021', 'expert', 15, true, '2024-10-20'),
('e0000003-0000-0000-0000-000000000003', 's0000012-0000-0000-0000-000000000012', 'expert', 15, true, '2024-10-20'),
('e0000003-0000-0000-0000-000000000003', 's0000011-0000-0000-0000-000000000011', 'advanced', 10, false, '2024-10-18'),
('e0000003-0000-0000-0000-000000000003', 's0000016-0000-0000-0000-000000000016', 'advanced', 8, false, '2024-10-20'),
('e0000003-0000-0000-0000-000000000003', 's0000025-0000-0000-0000-000000000025', 'advanced', 10, false, '2024-10-15'),

-- James Wilson (HR Director)
('e0000004-0000-0000-0000-000000000004', 's0000024-0000-0000-0000-000000000024', 'expert', 12, true, '2024-10-20'),
('e0000004-0000-0000-0000-000000000004', 's0000016-0000-0000-0000-000000000016', 'expert', 10, true, '2024-10-20'),
('e0000004-0000-0000-0000-000000000004', 's0000017-0000-0000-0000-000000000017', 'expert', 12, false, '2024-10-20'),
('e0000004-0000-0000-0000-000000000004', 's0000018-0000-0000-0000-000000000018', 'advanced', 8, false, '2024-10-18'),

-- Maria Garcia (Marketing Director)
('e0000005-0000-0000-0000-000000000005', 's0000022-0000-0000-0000-000000000022', 'expert', 14, true, '2024-10-20'),
('e0000005-0000-0000-0000-000000000005', 's0000016-0000-0000-0000-000000000016', 'advanced', 8, false, '2024-10-20'),
('e0000005-0000-0000-0000-000000000005', 's0000017-0000-0000-0000-000000000017', 'expert', 14, false, '2024-10-20'),
('e0000005-0000-0000-0000-000000000005', 's0000018-0000-0000-0000-000000000018', 'advanced', 10, false, '2024-10-19'),

-- Lisa Anderson (Senior Software Engineer)
('e0000007-0000-0000-0000-000000000007', 's0000001-0000-0000-0000-000000000001', 'expert', 8, false, '2024-10-20'),
('e0000007-0000-0000-0000-000000000007', 's0000004-0000-0000-0000-000000000004', 'expert', 5, true, '2024-10-20'),
('e0000007-0000-0000-0000-000000000007', 's0000005-0000-0000-0000-000000000005', 'expert', 6, false, '2024-10-19'),
('e0000007-0000-0000-0000-000000000007', 's0000002-0000-0000-0000-000000000002', 'advanced', 4, false, '2024-10-18'),
('e0000007-0000-0000-0000-000000000007', 's0000006-0000-0000-0000-000000000006', 'advanced', 5, false, '2024-10-17'),
('e0000007-0000-0000-0000-000000000007', 's0000007-0000-0000-0000-000000000007', 'advanced', 3, true, '2024-10-16'),
('e0000007-0000-0000-0000-000000000007', 's0000010-0000-0000-0000-000000000010', 'expert', 8, false, '2024-10-20'),

-- Jessica White (Software Developer)
('e0000011-0000-0000-0000-000000000011', 's0000001-0000-0000-0000-000000000001', 'advanced', 4, false, '2024-10-20'),
('e0000011-0000-0000-0000-000000000011', 's0000004-0000-0000-0000-000000000004', 'intermediate', 2, false, '2024-10-19'),
('e0000011-0000-0000-0000-000000000011', 's0000010-0000-0000-0000-000000000010', 'advanced', 4, false, '2024-10-20'),
('e0000011-0000-0000-0000-000000000011', 's0000011-0000-0000-0000-000000000011', 'intermediate', 3, false, '2024-10-18'),
('e0000011-0000-0000-0000-000000000011', 's0000020-0000-0000-0000-000000000020', 'advanced', 4, false, '2024-10-20'),

-- Ryan Clark (Junior Developer)
('e0000016-0000-0000-0000-000000000016', 's0000002-0000-0000-0000-000000000002', 'intermediate', 2, true, '2024-10-20'),
('e0000016-0000-0000-0000-000000000016', 's0000001-0000-0000-0000-000000000001', 'beginner', 1, false, '2024-10-19'),
('e0000016-0000-0000-0000-000000000016', 's0000010-0000-0000-0000-000000000010', 'intermediate', 2, false, '2024-10-20'),
('e0000016-0000-0000-0000-000000000016', 's0000011-0000-0000-0000-000000000011', 'beginner', 1, false, '2024-10-17'),

-- Robert Taylor (Senior Financial Analyst)
('e0000008-0000-0000-0000-000000000008', 's0000021-0000-0000-0000-000000000021', 'expert', 7, true, '2024-10-20'),
('e0000008-0000-0000-0000-000000000008', 's0000012-0000-0000-0000-000000000012', 'expert', 7, true, '2024-10-20'),
('e0000008-0000-0000-0000-000000000008', 's0000011-0000-0000-0000-000000000011', 'advanced', 5, false, '2024-10-19'),
('e0000008-0000-0000-0000-000000000008', 's0000013-0000-0000-0000-000000000013', 'advanced', 3, true, '2024-10-18'),
('e0000008-0000-0000-0000-000000000008', 's0000002-0000-0000-0000-000000000002', 'intermediate', 2, false, '2024-10-15');

-- Log skills insertion
DO $$
BEGIN
    RAISE NOTICE 'Inserted % skills', (SELECT COUNT(*) FROM skills);
    RAISE NOTICE 'Inserted % employee-skill relationships (Many-to-Many)', (SELECT COUNT(*) FROM employee_skills);
END $$;