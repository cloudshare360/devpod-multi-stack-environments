-- 01-departments.sql
-- Seed data for departments table

INSERT INTO departments (id, name, description, budget, location) VALUES
('11111111-1111-1111-1111-111111111111', 'Information Technology', 'Responsible for all technology infrastructure, software development, and digital transformation initiatives', 2500000.00, 'Building A, Floor 3'),
('22222222-2222-2222-2222-222222222222', 'Human Resources', 'Manages employee relations, recruitment, training, and organizational development', 800000.00, 'Building A, Floor 1'),
('33333333-3333-3333-3333-333333333333', 'Finance', 'Handles financial planning, accounting, budgeting, and financial reporting', 1200000.00, 'Building B, Floor 2'),
('44444444-4444-4444-4444-444444444444', 'Marketing', 'Develops marketing strategies, brand management, and customer acquisition campaigns', 1800000.00, 'Building A, Floor 2'),
('55555555-5555-5555-5555-555555555555', 'Sales', 'Drives revenue growth through customer acquisition and relationship management', 3000000.00, 'Building B, Floor 1'),
('66666666-6666-6666-6666-666666666666', 'Operations', 'Oversees daily business operations, process optimization, and supply chain management', 1500000.00, 'Building C, Floor 1'),
('77777777-7777-7777-7777-777777777777', 'Research and Development', 'Focuses on innovation, product development, and emerging technology research', 2200000.00, 'Building C, Floor 3'),
('88888888-8888-8888-8888-888888888888', 'Quality Assurance', 'Ensures product quality, testing, and compliance with industry standards', 900000.00, 'Building A, Floor 4'),
('99999999-9999-9999-9999-999999999999', 'Legal', 'Provides legal counsel, contract management, and regulatory compliance', 700000.00, 'Building B, Floor 3'),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Customer Support', 'Delivers customer service, technical support, and client relationship management', 600000.00, 'Building C, Floor 2');

-- Log department insertion
DO $$
BEGIN
    RAISE NOTICE 'Inserted % departments', (SELECT COUNT(*) FROM departments);
END $$;