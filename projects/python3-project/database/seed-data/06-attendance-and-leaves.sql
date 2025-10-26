-- 06-attendance-and-leaves.sql
-- Seed data for attendance and leave_requests tables (One-to-Many relationships)

-- Insert recent attendance records (last 30 days for active employees)
INSERT INTO attendance (employee_id, date, check_in_time, check_out_time, break_duration, total_hours, status, notes) VALUES
-- Sarah Johnson (CEO) - Recent attendance
('e0000001-0000-0000-0000-000000000001', '2024-10-01', '08:30:00', '18:00:00', '1 hour', 8.50, 'present', 'Board meeting day'),
('e0000001-0000-0000-0000-000000000001', '2024-10-02', '09:00:00', '17:30:00', '1 hour', 7.50, 'present', 'Client presentation'),
('e0000001-0000-0000-0000-000000000001', '2024-10-03', '08:45:00', '19:15:00', '1 hour', 9.50, 'present', 'Strategic planning session'),
('e0000001-0000-0000-0000-000000000001', '2024-10-04', NULL, NULL, NULL, NULL, 'absent', 'Personal day'),
('e0000001-0000-0000-0000-000000000001', '2024-10-07', '08:30:00', '17:00:00', '1 hour', 7.50, 'present', 'Regular day'),

-- Michael Chen (CTO) - Technical meetings and code reviews
('e0000002-0000-0000-0000-000000000002', '2024-10-01', '09:15:00', '18:30:00', '45 minutes', 8.50, 'late', 'Traffic delay'),
('e0000002-0000-0000-0000-000000000002', '2024-10-02', '08:45:00', '19:00:00', '1 hour', 9.25, 'present', 'Architecture review'),
('e0000002-0000-0000-0000-000000000002', '2024-10-03', '09:00:00', '17:45:00', '45 minutes', 8.00, 'present', 'Team standup'),
('e0000002-0000-0000-0000-000000000002', '2024-10-04', '08:30:00', '18:15:00', '1 hour', 8.75, 'present', 'Code review day'),
('e0000002-0000-0000-0000-000000000002', '2024-10-07', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Sprint planning'),

-- Lisa Anderson (Senior Software Engineer)
('e0000007-0000-0000-0000-000000000007', '2024-10-01', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Development work'),
('e0000007-0000-0000-0000-000000000007', '2024-10-02', '09:15:00', '18:00:00', '45 minutes', 8.00, 'present', 'Bug fixes'),
('e0000007-0000-0000-0000-000000000007', '2024-10-03', '08:45:00', '17:15:00', '30 minutes', 8.00, 'present', 'Feature development'),
('e0000007-0000-0000-0000-000000000007', '2024-10-04', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Testing'),
('e0000007-0000-0000-0000-000000000007', '2024-10-07', '09:00:00', '13:00:00', '0 minutes', 4.00, 'half_day', 'Doctor appointment'),

-- Jessica White (Software Developer)
('e0000011-0000-0000-0000-000000000011', '2024-10-01', '09:30:00', '18:00:00', '30 minutes', 8.00, 'present', 'Frontend work'),
('e0000011-0000-0000-0000-000000000011', '2024-10-02', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'React components'),
('e0000011-0000-0000-0000-000000000011', '2024-10-03', '09:15:00', '17:45:00', '30 minutes', 8.00, 'present', 'UI improvements'),
('e0000011-0000-0000-0000-000000000011', '2024-10-04', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Code review'),
('e0000011-0000-0000-0000-000000000011', '2024-10-07', NULL, NULL, NULL, NULL, 'sick_leave', 'Flu symptoms'),

-- Ryan Clark (Junior Developer)
('e0000016-0000-0000-0000-000000000016', '2024-10-01', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Learning React'),
('e0000016-0000-0000-0000-000000000016', '2024-10-02', '09:30:00', '18:00:00', '30 minutes', 8.00, 'present', 'Code review'),
('e0000016-0000-0000-0000-000000000016', '2024-10-03', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Bug fixing'),
('e0000016-0000-0000-0000-000000000016', '2024-10-04', '09:15:00', '17:45:00', '30 minutes', 8.00, 'present', 'Training session'),
('e0000016-0000-0000-0000-000000000016', '2024-10-07', '09:00:00', '17:30:00', '30 minutes', 8.00, 'present', 'Pair programming'),

-- Robert Taylor (Senior Financial Analyst)
('e0000008-0000-0000-0000-000000000008', '2024-10-01', '08:30:00', '17:00:00', '30 minutes', 8.00, 'present', 'Monthly reports'),
('e0000008-0000-0000-0000-000000000008', '2024-10-02', '08:45:00', '17:15:00', '30 minutes', 8.00, 'present', 'Budget analysis'),
('e0000008-0000-0000-0000-000000000008', '2024-10-03', '08:30:00', '17:00:00', '30 minutes', 8.00, 'present', 'Financial modeling'),
('e0000008-0000-0000-0000-000000000008', '2024-10-04', '08:30:00', '17:00:00', '30 minutes', 8.00, 'present', 'Audit prep'),
('e0000008-0000-0000-0000-000000000008', '2024-10-07', '08:30:00', '17:00:00', '30 minutes', 8.00, 'present', 'Compliance review');

-- Insert leave requests
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, days_requested, reason, status, approved_by, approved_at, comments) VALUES
-- Approved leave requests
('e0000001-0000-0000-0000-000000000001', 'vacation', '2024-11-15', '2024-11-22', 6, 'Family vacation to Europe', 'approved', 'e0000001-0000-0000-0000-000000000001', '2024-10-15 10:30:00', 'Enjoy your vacation'),

('e0000007-0000-0000-0000-000000000007', 'vacation', '2024-12-23', '2024-12-31', 7, 'Christmas and New Year holidays', 'approved', 'e0000002-0000-0000-0000-000000000002', '2024-10-10 14:15:00', 'Approved for holiday period'),

('e0000011-0000-0000-0000-000000000011', 'sick', '2024-10-07', '2024-10-09', 3, 'Flu symptoms and recovery', 'approved', 'e0000007-0000-0000-0000-000000000007', '2024-10-07 08:30:00', 'Get well soon, take care'),

('e0000016-0000-0000-0000-000000000016', 'personal', '2024-11-01', '2024-11-01', 1, 'Moving to new apartment', 'approved', 'e0000011-0000-0000-0000-000000000011', '2024-10-20 11:45:00', 'Good luck with the move'),

('e0000013-0000-0000-0000-000000000013', 'maternity', '2024-12-01', '2025-03-01', 90, 'Maternity leave for new baby', 'approved', 'e0000009-0000-0000-0000-000000000009', '2024-09-15 16:20:00', 'Congratulations! Take all the time you need'),

-- Pending leave requests
('e0000012-0000-0000-0000-000000000012', 'vacation', '2024-11-25', '2024-11-29', 5, 'Thanksgiving week with family', 'pending', NULL, NULL, NULL),

('e0000014-0000-0000-0000-000000000014', 'personal', '2024-10-30', '2024-10-30', 1, 'Personal medical appointment', 'pending', NULL, NULL, NULL),

('e0000019-0000-0000-0000-000000000019', 'vacation', '2024-12-15', '2024-12-20', 4, 'Year-end break before holidays', 'pending', NULL, NULL, NULL),

-- Rejected leave requests
('e0000015-0000-0000-0000-000000000015', 'vacation', '2024-10-28', '2024-11-05', 7, 'Extended vacation during busy period', 'rejected', 'e0000006-0000-0000-0000-000000000006', '2024-10-18 09:15:00', 'Sorry, this is our busiest sales period. Please consider rescheduling'),

('e0000020-0000-0000-0000-000000000020', 'personal', '2024-10-25', '2024-10-26', 2, 'Concert tickets', 'rejected', 'e0000015-0000-0000-0000-000000000015', '2024-10-22 13:30:00', 'Need more advance notice for personal leave'),

-- Historical approved leaves
('e0000008-0000-0000-0000-000000000008', 'vacation', '2024-08-15', '2024-08-25', 8, 'Summer vacation with family', 'approved', 'e0000003-0000-0000-0000-000000000003', '2024-07-10 10:00:00', 'Enjoy your summer break'),

('e0000009-0000-0000-0000-000000000009', 'sick', '2024-09-10', '2024-09-12', 3, 'Food poisoning recovery', 'approved', 'e0000004-0000-0000-0000-000000000004', '2024-09-10 07:45:00', 'Feel better soon'),

('e0000010-0000-0000-0000-000000000010', 'vacation', '2024-07-01', '2024-07-10', 8, 'Summer vacation in Spain', 'approved', 'e0000005-0000-0000-0000-000000000005', '2024-05-15 14:20:00', 'Have a great trip!');

-- Log attendance and leave data insertion
DO $$
BEGIN
    RAISE NOTICE 'Inserted % attendance records', (SELECT COUNT(*) FROM attendance);
    RAISE NOTICE 'Inserted % leave requests', (SELECT COUNT(*) FROM leave_requests);
    RAISE NOTICE 'Approved leaves: %', (SELECT COUNT(*) FROM leave_requests WHERE status = 'approved');
    RAISE NOTICE 'Pending leaves: %', (SELECT COUNT(*) FROM leave_requests WHERE status = 'pending');
    RAISE NOTICE 'Recent attendance entries for % employees', (SELECT COUNT(DISTINCT employee_id) FROM attendance WHERE date >= '2024-10-01');
END $$;