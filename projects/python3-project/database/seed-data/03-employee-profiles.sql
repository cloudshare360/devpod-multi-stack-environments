-- 03-employee-profiles.sql
-- Seed data for employee profiles (One-to-One relationship)

INSERT INTO employee_profiles (employee_id, bio, avatar_url, linkedin_url, skills, certifications, performance_rating, years_experience, education_level, preferred_language) VALUES
-- C-Level Executives
('e0000001-0000-0000-0000-000000000001', 'Visionary leader with 20+ years in technology and business management. Passionate about innovation and team development.', 'https://example.com/avatars/sarah-johnson.jpg', 'https://linkedin.com/in/sarah-johnson-ceo', ARRAY['Leadership', 'Strategic Planning', 'Business Development', 'Public Speaking'], '{"certifications": [{"name": "Executive Leadership Certificate", "issuer": "Harvard Business School", "year": 2018}, {"name": "Certified Director", "issuer": "Institute of Directors", "year": 2019}]}', 4.9, 20, 'Masters', 'en'),

('e0000002-0000-0000-0000-000000000002', 'Technology visionary with expertise in cloud architecture, AI/ML, and digital transformation. Leading cutting-edge development teams.', 'https://example.com/avatars/michael-chen.jpg', 'https://linkedin.com/in/michael-chen-cto', ARRAY['Cloud Architecture', 'AI/ML', 'DevOps', 'Team Leadership', 'Python', 'Java', 'Kubernetes'], '{"certifications": [{"name": "AWS Solutions Architect Professional", "issuer": "Amazon", "year": 2020}, {"name": "Google Cloud Professional", "issuer": "Google", "year": 2021}, {"name": "Certified Kubernetes Administrator", "issuer": "CNCF", "year": 2021}]}', 4.8, 18, 'PhD', 'en'),

('e0000003-0000-0000-0000-000000000003', 'Financial strategist specializing in corporate finance, risk management, and investor relations. CPA with international experience.', 'https://example.com/avatars/emily-davis.jpg', 'https://linkedin.com/in/emily-davis-cfo', ARRAY['Financial Analysis', 'Risk Management', 'Corporate Finance', 'Investor Relations', 'Excel', 'SQL'], '{"certifications": [{"name": "Certified Public Accountant", "issuer": "AICPA", "year": 2015}, {"name": "Financial Risk Manager", "issuer": "GARP", "year": 2017}, {"name": "Chartered Financial Analyst", "issuer": "CFA Institute", "year": 2016}]}', 4.7, 15, 'Masters', 'en'),

-- Department Directors
('e0000004-0000-0000-0000-000000000004', 'People-focused HR leader committed to building inclusive workplace cultures and driving organizational excellence through human capital.', 'https://example.com/avatars/james-wilson.jpg', 'https://linkedin.com/in/james-wilson-hr', ARRAY['Talent Management', 'Organizational Development', 'Employment Law', 'Performance Management', 'Training & Development'], '{"certifications": [{"name": "Senior Professional in Human Resources", "issuer": "HRCI", "year": 2019}, {"name": "Certified Compensation Professional", "issuer": "WorldatWork", "year": 2020}]}', 4.6, 12, 'Masters', 'en'),

('e0000005-0000-0000-0000-000000000005', 'Creative marketing strategist with expertise in digital marketing, brand management, and customer experience optimization.', 'https://example.com/avatars/maria-garcia.jpg', 'https://linkedin.com/in/maria-garcia-marketing', ARRAY['Digital Marketing', 'Brand Management', 'Content Strategy', 'SEO/SEM', 'Social Media', 'Analytics'], '{"certifications": [{"name": "Google Marketing Platform", "issuer": "Google", "year": 2021}, {"name": "Facebook Blueprint Certified", "issuer": "Meta", "year": 2021}, {"name": "HubSpot Content Marketing", "issuer": "HubSpot", "year": 2020}]}', 4.5, 14, 'Masters', 'es'),

('e0000006-0000-0000-0000-000000000006', 'Results-driven sales leader with proven track record in B2B sales, relationship building, and revenue growth strategies.', 'https://example.com/avatars/david-brown.jpg', 'https://linkedin.com/in/david-brown-sales', ARRAY['B2B Sales', 'Account Management', 'Negotiation', 'CRM', 'Sales Strategy', 'Team Management'], '{"certifications": [{"name": "Certified Sales Professional", "issuer": "Sales Management Association", "year": 2018}, {"name": "Salesforce Administrator", "issuer": "Salesforce", "year": 2019}]}', 4.4, 16, 'Bachelors', 'en'),

-- Senior Technical Staff
('e0000007-0000-0000-0000-000000000007', 'Senior software engineer passionate about clean code, system architecture, and mentoring junior developers. Full-stack expertise.', 'https://example.com/avatars/lisa-anderson.jpg', 'https://linkedin.com/in/lisa-anderson-dev', ARRAY['JavaScript', 'React', 'Node.js', 'Python', 'PostgreSQL', 'AWS', 'Docker', 'Git'], '{"certifications": [{"name": "AWS Developer Associate", "issuer": "Amazon", "year": 2021}, {"name": "React Developer Certification", "issuer": "React Training", "year": 2020}]}', 4.6, 8, 'Bachelors', 'en'),

('e0000008-0000-0000-0000-000000000008', 'Detail-oriented financial analyst with expertise in financial modeling, forecasting, and business intelligence analytics.', 'https://example.com/avatars/robert-taylor.jpg', 'https://linkedin.com/in/robert-taylor-finance', ARRAY['Financial Modeling', 'Excel', 'SQL', 'Tableau', 'Python', 'Statistical Analysis', 'Forecasting'], '{"certifications": [{"name": "Financial Modeling & Valuation Analyst", "issuer": "CFI", "year": 2020}, {"name": "Tableau Desktop Specialist", "issuer": "Tableau", "year": 2021}]}', 4.3, 7, 'Masters', 'en'),

-- Mid-level Staff
('e0000011-0000-0000-0000-000000000011', 'Dedicated software developer with strong problem-solving skills and passion for modern web technologies and user experience.', 'https://example.com/avatars/jessica-white.jpg', 'https://linkedin.com/in/jessica-white-dev', ARRAY['JavaScript', 'Vue.js', 'HTML/CSS', 'Git', 'REST APIs', 'Agile'], '{"certifications": [{"name": "Vue.js Developer", "issuer": "Vue Mastery", "year": 2022}]}', 4.2, 4, 'Bachelors', 'en'),

('e0000012-0000-0000-0000-000000000012', 'Analytical financial professional focused on data-driven insights and process improvement in financial operations.', 'https://example.com/avatars/daniel-jones.jpg', 'https://linkedin.com/in/daniel-jones-finance', ARRAY['Excel', 'Financial Analysis', 'SQL', 'Power BI', 'Process Improvement'], '{"certifications": [{"name": "Microsoft Excel Expert", "issuer": "Microsoft", "year": 2021}]}', 4.0, 5, 'Bachelors', 'en'),

-- Junior Staff
('e0000016-0000-0000-0000-000000000016', 'Enthusiastic junior developer eager to learn and contribute to innovative software solutions. Strong foundation in computer science.', 'https://example.com/avatars/ryan-clark.jpg', 'https://linkedin.com/in/ryan-clark-dev', ARRAY['Python', 'JavaScript', 'HTML/CSS', 'Git', 'SQL'], '{"certifications": [{"name": "Python Institute PCAP", "issuer": "Python Institute", "year": 2022}]}', 3.8, 2, 'Bachelors', 'en'),

('e0000017-0000-0000-0000-000000000017', 'Detail-oriented junior analyst with strong analytical skills and passion for data-driven decision making.', 'https://example.com/avatars/nicole-rodriguez.jpg', 'https://linkedin.com/in/nicole-rodriguez-analyst', ARRAY['Excel', 'Data Analysis', 'Statistics', 'SQL'], '{"certifications": [{"name": "Google Data Analytics", "issuer": "Google", "year": 2022}]}', 3.9, 2, 'Bachelors', 'en'),

('e0000018-0000-0000-0000-000000000018', 'Organized HR assistant committed to supporting employee experience and learning HR best practices.', 'https://example.com/avatars/brandon-lewis.jpg', 'https://linkedin.com/in/brandon-lewis-hr', ARRAY['Communication', 'Organization', 'MS Office', 'HRIS'], '{"certifications": [{"name": "PHR Associate", "issuer": "HRCI", "year": 2023}]}', 3.7, 1, 'Bachelors', 'en'),

('e0000019-0000-0000-0000-000000000019', 'Creative marketing coordinator with eye for design and strong project management skills in digital campaigns.', 'https://example.com/avatars/stephanie-walker.jpg', 'https://linkedin.com/in/stephanie-walker-marketing', ARRAY['Adobe Creative Suite', 'Social Media', 'Project Management', 'Content Creation'], '{"certifications": [{"name": "Adobe Certified Expert", "issuer": "Adobe", "year": 2022}]}', 4.1, 3, 'Bachelors', 'en'),

('e0000020-0000-0000-0000-000000000020', 'Motivated sales intern learning the fundamentals of B2B sales and customer relationship management.', 'https://example.com/avatars/jonathan-hill.jpg', 'https://linkedin.com/in/jonathan-hill-sales', ARRAY['Communication', 'Customer Service', 'CRM Basics', 'Presentation Skills'], '{"certifications": []}', 3.5, 0, 'Bachelors', 'en');

-- Log profile insertion
DO $$
BEGIN
    RAISE NOTICE 'Inserted % employee profiles (One-to-One relationship)', (SELECT COUNT(*) FROM employee_profiles);
END $$;