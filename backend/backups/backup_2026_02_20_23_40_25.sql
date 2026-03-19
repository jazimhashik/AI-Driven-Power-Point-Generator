DROP TABLE IF EXISTS tbl_admin_profile;
CREATE TABLE `tbl_admin_profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login_id` int(11) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `login_id` (`login_id`),
  CONSTRAINT `tbl_admin_profile_ibfk_1` FOREIGN KEY (`login_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_admin_profile (id, login_id, full_name, phone, department, permissions, created_at, updated_at) VALUES (1, 7, 'System Administrator', '', 'Administration', '{"all": true}', '2026-02-17 12:02:30', '2026-02-17 12:02:30');

DROP TABLE IF EXISTS tbl_audit_log;
CREATE TABLE `tbl_audit_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `details` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'success',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_action` (`action`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (1, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-13 12:12:33');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (2, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-13 12:14:43');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (3, NULL, 'LOGIN_FAILED', 'Failed login attempt for email: trial@gmail.com', '127.0.0.1', 'success', '2026-02-13 12:15:22');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (4, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-13 12:19:29');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (5, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-13 12:20:38');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (6, 1, 'PPT_GENERATED', 'AI presentation generated: ragging in colleges...', '127.0.0.1', 'success', '2026-02-13 12:28:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (7, 6, 'USER_REGISTER', 'User soss registered successfully', '127.0.0.1', 'success', '2026-02-13 12:30:28');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (8, 6, 'PPT_GENERATED', 'AI presentation generated: explainabilty and trsut challenges in dl...', '127.0.0.1', 'success', '2026-02-13 12:32:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (9, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-15 00:30:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (10, 1, 'PPT_GENERATED', 'AI presentation generated: importance of AI in todays world...', '127.0.0.1', 'success', '2026-02-15 00:31:33');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (11, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-17 12:10:12');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (12, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-17 12:13:20');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (13, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-17 17:41:40');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (14, 1, 'PPT_GENERATED', 'AI presentation generated: english being a universal language...', '127.0.0.1', 'success', '2026-02-17 17:42:29');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (15, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 01:04:34');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (16, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-02-18 01:06:52');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (17, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 01:39:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (18, 8, 'USER_REGISTER', 'User shin registered successfully', '127.0.0.1', 'success', '2026-02-18 01:54:22');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (19, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 08:42:01');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (20, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 09:15:10');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (21, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 09:19:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (22, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 10:08:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (23, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-18 10:20:33');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (24, NULL, 'LOGIN_FAILED', 'Failed login attempt for email: trial@gmail.com', '127.0.0.1', 'success', '2026-02-18 10:20:52');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (25, NULL, 'LOGIN_FAILED', 'Failed login attempt for email: trail@gmail.com', '127.0.0.1', 'success', '2026-02-18 10:21:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (26, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-18 10:21:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (27, 1, 'PPT_GENERATED', 'AI presentation generated: tom and jerry cartoon...', '127.0.0.1', 'success', '2026-02-18 10:26:34');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (28, 1, 'PPT_GENERATED', 'AI presentation generated: tom and jerry cartoon...', '127.0.0.1', 'success', '2026-02-18 10:27:30');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (29, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-18 11:40:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (30, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-18 11:41:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (31, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-18 11:56:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (32, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-18 12:20:12');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (33, 1, 'PPT_GENERATED', 'AI presentation generated: Chalakudy...', '127.0.0.1', 'success', '2026-02-18 12:21:41');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (34, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-18 12:39:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (35, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-19 10:57:30');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (36, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-19 11:00:13');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (37, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-19 11:23:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (38, 1, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-02-19 11:23:46');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (39, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy and development...', '127.0.0.1', 'success', '2026-02-19 11:32:01');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (40, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy and development...', '127.0.0.1', 'success', '2026-02-19 11:32:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (41, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 12:14:54');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (42, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 12:17:28');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (43, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 20:27:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (44, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-20 20:27:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (45, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-20 20:29:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (46, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 20:33:04');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (47, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-20 20:50:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (48, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 20:50:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (49, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-20 21:05:06');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (50, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 21:05:23');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (51, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-20 21:10:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (52, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 21:10:57');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (53, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-20 21:13:55');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (54, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-20 21:14:09');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (55, 1, 'PPT_GENERATED', 'AI presentation generated: gods own country...', '127.0.0.1', 'success', '2026-02-20 21:14:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (56, 1, 'PPT_GENERATED', 'AI presentation generated: gods own country...', '127.0.0.1', 'success', '2026-02-20 21:14:46');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (57, 1, 'PPT_GENERATED', 'AI presentation generated: gods own country...', '127.0.0.1', 'success', '2026-02-20 21:15:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (58, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-20 21:15:41');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (59, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 21:15:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (60, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-20 21:52:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (61, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 21:52:20');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (62, NULL, 'LOGIN_FAILED', 'Failed login attempt for identifier: admin', '127.0.0.1', 'success', '2026-02-20 22:05:39');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (63, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 22:05:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (64, 0, 'TOGGLE_USER', 'Toggled user shin status to 0', '127.0.0.1', 'success', '2026-02-20 22:06:35');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (65, 15, 'USER_REGISTER', 'User reseena registered successfully', '127.0.0.1', 'success', '2026-02-20 23:24:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (66, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-20 23:24:35');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (67, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 23:24:42');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (68, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-20 23:37:58');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (69, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 23:38:02');

DROP TABLE IF EXISTS tbl_backup_log;
CREATE TABLE `tbl_backup_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `backup_type` varchar(20) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'success',
  `error_message` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS tbl_custdetails;
CREATE TABLE `tbl_custdetails` (
  `cust_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `registered_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`cust_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_custdetails (cust_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (1, 'shinto', 'shinto@gmail.com', '6282664307', '2026-02-13', 1, '2026-02-12 02:31:10', NULL);
INSERT INTO tbl_custdetails (cust_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (2, 'sossu', 'sosseu@gmail.com', '1234546778890', '2026-02-10', 1, '2026-02-13 12:30:28', NULL);
INSERT INTO tbl_custdetails (cust_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (3, 'shin', 'shin@gmail.com', '9896929264', '3333-03-22', 1, '2026-02-18 01:54:22', NULL);
INSERT INTO tbl_custdetails (cust_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (4, 'reseena hashik', 'reseen@gmail.com', '9898989898', '2001-02-12', 1, '2026-02-20 23:24:24', NULL);

DROP TABLE IF EXISTS tbl_generated_data;
CREATE TABLE `tbl_generated_data` (
  `content_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `raw_input` text NOT NULL,
  `summary` text DEFAULT NULL,
  `keywords` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`content_id`),
  KEY `fk_generated_user` (`user_id`),
  CONSTRAINT `fk_generated_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS tbl_input_data;
CREATE TABLE `tbl_input_data` (
  `input_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `raw_input` text NOT NULL,
  `summary` text DEFAULT NULL,
  `keywords` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`input_id`),
  KEY `fk_input_user` (`user_id`),
  CONSTRAINT `fk_input_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (1, 1, 'cake shop website', NULL, NULL, '2026-01-21 11:48:09');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (2, 1, 'cake shop website', NULL, NULL, '2026-01-21 11:55:16');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (3, 1, 'cake bakers website', NULL, NULL, '2026-01-21 12:06:07');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (4, 1, 'cake bakers website', NULL, NULL, '2026-01-21 12:10:18');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (5, 1, 'cake bakers website', NULL, NULL, '2026-01-21 12:28:53');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (6, 1, '5 page presentation on addiction of childer for mobiles', NULL, NULL, '2026-01-21 12:31:32');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (7, 1, 'elephant', NULL, NULL, '2026-01-22 11:01:07');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (8, 1, 'parrot', NULL, NULL, '2026-01-22 11:33:56');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (9, 1, 'elephant', NULL, NULL, '2026-01-25 11:59:10');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (10, 1, 'eagle', NULL, NULL, '2026-01-27 08:57:34');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (11, 1, 'eagle', NULL, NULL, '2026-01-27 09:10:14');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (12, 1, 'eagle''s nest
', NULL, NULL, '2026-01-27 09:11:57');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (13, 1, 'eagle''s nest
', NULL, NULL, '2026-01-27 09:21:24');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (14, 1, 'shinto', NULL, NULL, '2026-01-27 09:21:42');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (15, 1, 'shinto', NULL, NULL, '2026-01-27 09:24:14');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (16, 1, 'parrot', NULL, NULL, '2026-01-28 13:08:21');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (17, 1, 'parrot', NULL, NULL, '2026-01-28 13:10:45');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (18, 1, 'parrot', NULL, NULL, '2026-01-28 13:11:19');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (19, 1, 'parrot', NULL, NULL, '2026-01-28 13:13:04');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (20, 1, 'parrot', NULL, NULL, '2026-01-28 13:16:41');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (21, 1, 'parrot', NULL, NULL, '2026-01-28 13:23:58');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (22, 1, 'parrot', NULL, NULL, '2026-01-28 13:24:29');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (23, 1, 'AI in Healthcare with real-world examples
', NULL, NULL, '2026-01-28 13:32:37');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (24, 1, 'ai in healthcare
', NULL, NULL, '2026-01-28 13:37:04');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (25, 1, 'parrot', NULL, NULL, '2026-02-05 11:34:04');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (26, 1, 'parrot', NULL, NULL, '2026-02-05 11:35:58');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (27, 1, 'parrot', NULL, NULL, '2026-02-05 11:37:24');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (28, 1, 'parrot', NULL, NULL, '2026-02-05 11:38:45');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (29, 1, 'parrot', NULL, NULL, '2026-02-08 17:23:57');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (30, 1, 'parrot', NULL, NULL, '2026-02-09 11:36:49');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (31, 1, 'parrot', NULL, NULL, '2026-02-09 11:36:59');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (32, 5, 'apple', NULL, NULL, '2026-02-12 02:32:08');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (33, 5, 'apple
', NULL, NULL, '2026-02-12 02:41:35');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (34, 5, 'orange', NULL, NULL, '2026-02-12 02:44:27');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (35, 5, 'kidney', NULL, NULL, '2026-02-12 02:48:36');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (36, 5, 'liver', NULL, NULL, '2026-02-12 02:49:42');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (37, 5, 'elephant', NULL, NULL, '2026-02-12 03:02:34');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (38, 5, 'english', NULL, NULL, '2026-02-12 03:05:03');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (39, 5, 'english', NULL, NULL, '2026-02-12 03:05:17');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (40, 5, 'english', NULL, NULL, '2026-02-12 03:05:28');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (41, 5, 'football', NULL, NULL, '2026-02-12 03:09:48');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (42, 1, 'ragging in colleges', NULL, NULL, '2026-02-13 12:21:47');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (43, 1, 'ragging in colleges', NULL, NULL, '2026-02-13 12:24:24');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (44, 1, 'ragging in colleges', NULL, NULL, '2026-02-13 12:24:37');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (45, 1, 'ragging in colleges', NULL, NULL, '2026-02-13 12:26:08');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (46, 1, 'ragging in colleges', NULL, NULL, '2026-02-13 12:27:26');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (47, 1, 'ragging in colleges', NULL, NULL, '2026-02-13 12:28:42');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (48, 6, 'explainabilty and trsut challenges in dl', NULL, NULL, '2026-02-13 12:31:54');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (49, 1, 'importance of AI in todays world', NULL, NULL, '2026-02-15 00:31:21');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (50, 1, 'english being a universal language', NULL, NULL, '2026-02-17 17:42:20');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (51, 1, 'tom and jerry cartoon', NULL, NULL, '2026-02-18 10:26:27');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (52, 1, 'tom and jerry cartoon', NULL, NULL, '2026-02-18 10:27:23');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (53, 1, 'Ai in modern world', NULL, NULL, '2026-02-18 11:15:11');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (54, 1, 'india''s development with ai', NULL, NULL, '2026-02-18 11:29:17');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (55, 1, 'india''s development with ai', NULL, NULL, '2026-02-18 11:39:07');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (56, 1, 'india''s development with ai', NULL, NULL, '2026-02-18 11:40:34');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (57, 1, 'ai in india', NULL, NULL, '2026-02-18 11:41:27');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (58, 1, 'ai in india', NULL, NULL, '2026-02-18 11:56:14');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (59, 1, 'ai in india', NULL, NULL, '2026-02-18 12:20:01');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (60, 1, 'chalakudy from thrissur', NULL, NULL, '2026-02-18 12:21:31');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (61, 1, 'ai in india', NULL, NULL, '2026-02-18 12:39:06');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (62, 1, 'ai in indian economy', NULL, NULL, '2026-02-19 10:59:26');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (63, 1, 'ai in indian economy', NULL, NULL, '2026-02-19 11:23:03');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (64, 1, ' Business analytics', NULL, NULL, '2026-02-19 11:23:36');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (65, 1, 'ai in indian economy and development', NULL, NULL, '2026-02-19 11:31:52');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (66, 1, 'ai in indian economy and development', NULL, NULL, '2026-02-19 11:31:52');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (67, 1, 'gods own country', NULL, NULL, '2026-02-20 21:14:31');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (68, 1, 'gods own country', NULL, NULL, '2026-02-20 21:14:31');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (69, 1, 'gods own country', NULL, NULL, '2026-02-20 21:15:08');

DROP TABLE IF EXISTS tbl_login;
CREATE TABLE `tbl_login` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'customer',
  `email` varchar(100) DEFAULT NULL,
  `failed_attempts` tinyint(4) DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `token_expiry` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  `status` int(11) DEFAULT 1,
  `phone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`login_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (1, 'trial', 'scrypt:32768:8:1$gSlsYmWqOBwUYWND$88eb66c9cedff6a2296082257c5e1c863fe8e079592b7e9e61def6da0af9bc325838cc8630b83d2d2ad6b17bbca84ee5f119dd91fee9710134efdc72eee06671', 'customer', 'trial@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-01-21 10:30:28', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (5, 'shinto', 'scrypt:32768:8:1$fTv2tedCxcVVVTwu$4da366ab89c1aae0a267906eaa6e283a2181d1aa6506d29bc33fbc0b47ccf96bb4872b73a150950c0598f484d899bcc96135999c274e3eafb5fa8461b476800e', 'customer', 'shinto@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-12 02:31:10', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (6, 'soss', 'scrypt:32768:8:1$7q9rb1oIyPlYo3qo$4bc63819eb9edd6c51d46383f461dabab92abaa7b865f093ecd55af841e1e30f5819d7d1f98922cc45bedda7666ffa750db8c7c04ee8ca6ece3bb82c41a40b75', 'customer', 'sosseu@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-13 12:30:28', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (7, 'admin', 'scrypt:32768:8:1$KQyCxXwfZAdnfpNT$54f5b1b0221c17ec3fdde2961f9004f7fa851c6ca398f284cd041ed7d8af8df517a8a3926eb27639c68fb52c3877d57c694307bdf6f98d5d073587e040ae8611', 'admin', 'admin@cosmicai.com', 0, NULL, NULL, NULL, NULL, '2026-02-17 12:02:30', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (8, 'shin', 'scrypt:32768:8:1$8T3mGCAYTBJjenJ3$25503160778ff2b37c6b6c9fd20b5aa112d71e48ef5b91f1384b511cdb957edbb56fb994121a491c9d1b303357c93c28deaa1d07abb2b7df838c766bde2c0a22', 'customer', 'shin@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-18 01:54:22', NULL, 0, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (15, 'reseena', 'scrypt:32768:8:1$wi7fdccka6ia8MRA$fad92dc5f315a97056203d182f39cda0497875275a4cac45345f18c0a64f2aa0b445aeac003e4afe4f1c07fc779b96e983b0d3fd260390da35735c35f5c09a30', 'customer', 'reseen@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-20 23:24:24', NULL, 1, '9898989898');

DROP TABLE IF EXISTS tbl_notifications;
CREATE TABLE `tbl_notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(40) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(30) DEFAULT NULL,
  `is_read` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`notification_id`),
  KEY `fk_notify_user` (`user_id`),
  CONSTRAINT `fk_notify_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS tbl_presentations;
CREATE TABLE `tbl_presentations` (
  `ppt_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `content_id` int(11) NOT NULL,
  `template_id` int(11) NOT NULL,
  `ppt_filename` varchar(200) NOT NULL,
  `ppt_path` varchar(255) NOT NULL,
  `slide_count` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Generated',
  `created_at` datetime DEFAULT current_timestamp(),
  `input_id` int(11) DEFAULT NULL,
  `presentation_type` varchar(20) NOT NULL DEFAULT 'AI',
  `topic` varchar(255) DEFAULT NULL,
  `filename` varchar(255) NOT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`ppt_id`),
  KEY `fk_ppt_user` (`user_id`),
  KEY `fk_ppt_content` (`content_id`),
  KEY `fk_ppt_template` (`template_id`),
  CONSTRAINT `fk_ppt_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (3, 1, 0, 0, '', '', 5, 'success', '2026-02-13 12:28:47', 47, 'AI', 'ragging in colleges', 'presentation_user_1_20260213122846.pptx', '2026-02-13 12:28:47');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (4, 6, 0, 0, '', '', 5, 'success', '2026-02-13 12:32:00', 48, 'AI', 'explainabilty and trsut challenges in dl', 'presentation_user_6_20260213123200.pptx', '2026-02-13 12:32:00');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (5, 1, 0, 0, '', '', 10, 'success', '2026-02-15 00:31:33', 49, 'AI', 'importance of AI in todays world', 'presentation_user_1_20260215003129.pptx', '2026-02-15 00:31:33');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (6, 1, 0, 0, '', '', 5, 'success', '2026-02-17 17:42:29', 50, 'AI', 'english being a universal language', 'presentation_user_1_20260217174225.pptx', '2026-02-17 17:42:29');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (7, 1, 0, 0, '', '', 1, 'success', '2026-02-18 01:06:52', NULL, 'Manual', 'Manual slides (1 slides)', 'manual_presentation_user_1_20260218010648.pptx', '2026-02-18 01:06:52');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (8, 1, 0, 0, '', '', 5, 'success', '2026-02-18 10:26:34', 51, 'AI', 'tom and jerry cartoon', 'presentation_user_1_20260218102630.pptx', '2026-02-18 10:26:34');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (9, 1, 0, 0, '', '', 5, 'success', '2026-02-18 10:27:30', 52, 'AI', 'tom and jerry cartoon', 'presentation_user_1_20260218102729.pptx', '2026-02-18 10:27:30');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (10, 1, 0, 0, '', '', 5, 'success', '2026-02-18 11:40:51', 56, 'AI', 'ai in india', 'presentation_user_1_20260218114050.pptx', '2026-02-18 11:40:51');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (11, 1, 0, 0, '', '', 5, 'success', '2026-02-18 11:41:37', 57, 'AI', 'ai in india', 'presentation_user_1_20260218114136.pptx', '2026-02-18 11:41:37');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (12, 1, 0, 0, '', '', 5, 'success', '2026-02-18 11:56:37', 58, 'AI', 'ai in india', 'presentation_user_1_20260218115636.pptx', '2026-02-18 11:56:37');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (13, 1, 0, 0, '', '', 5, 'success', '2026-02-18 12:20:12', 59, 'AI', 'ai in india', 'presentation_user_1_20260218122010.pptx', '2026-02-18 12:20:12');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (14, 1, 0, 0, '', '', 2, 'success', '2026-02-18 12:21:41', 60, 'AI', 'Chalakudy', 'presentation_user_1_20260218122141.pptx', '2026-02-18 12:21:41');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (15, 1, 0, 0, '', '', 5, 'success', '2026-02-18 12:39:15', 61, 'AI', 'ai in india', 'presentation_user_1_20260218123914.pptx', '2026-02-18 12:39:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (16, 1, 0, 0, '', '', 5, 'success', '2026-02-19 11:00:13', 62, 'AI', 'ai in indian economy', 'presentation_user_1_20260219110011.pptx', '2026-02-19 11:00:13');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (17, 1, 0, 0, '', '', 5, 'success', '2026-02-19 11:23:15', 63, 'AI', 'ai in indian economy', 'presentation_user_1_20260219112315.pptx', '2026-02-19 11:23:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (18, 1, 0, 0, '', '', 5, 'success', '2026-02-19 11:23:46', 64, 'AI', ' Business analytics', 'presentation_user_1_20260219112345.pptx', '2026-02-19 11:23:46');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (19, 1, 0, 0, '', '', 5, 'success', '2026-02-19 11:32:01', 66, 'AI', 'ai in indian economy and development', 'presentation_user_1_20260219113201.pptx', '2026-02-19 11:32:01');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (20, 1, 0, 0, '', '', 5, 'success', '2026-02-19 11:32:02', 65, 'AI', 'ai in indian economy and development', 'presentation_user_1_20260219113202.pptx', '2026-02-19 11:32:02');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (21, 1, 0, 0, '', '', 5, 'success', '2026-02-20 21:14:45', 68, 'AI', 'gods own country', 'presentation_user_1_20260220211442.pptx', '2026-02-20 21:14:45');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (22, 1, 0, 0, '', '', 5, 'success', '2026-02-20 21:14:46', 67, 'AI', 'gods own country', 'presentation_user_1_20260220211442.pptx', '2026-02-20 21:14:46');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (23, 1, 0, 0, '', '', 5, 'success', '2026-02-20 21:15:18', 69, 'AI', 'gods own country', 'presentation_user_1_20260220211517.pptx', '2026-02-20 21:15:18');

DROP TABLE IF EXISTS tbl_settings;
CREATE TABLE `tbl_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) DEFAULT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS tbl_system_logs;
CREATE TABLE `tbl_system_logs` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `module` varchar(50) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `fk_logs_user` (`user_id`),
  CONSTRAINT `fk_logs_user` FOREIGN KEY (`user_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS tbl_system_settings;
CREATE TABLE `tbl_system_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `setting_type` varchar(20) DEFAULT 'string',
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (1, 'site_name', 'Cosmic AI PPT Generator', 'string', 'The name of the website', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (2, 'admin_email', 'admin@cosmicai.com', 'email', 'Admin contact email', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (3, 'max_slides_per_presentation', '20', 'integer', 'Maximum number of slides allowed per presentation', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (4, 'default_slides', '5', 'integer', 'Default number of slides for AI generation', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (5, 'session_timeout', '30', 'integer', 'Session timeout in minutes', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (6, 'max_login_attempts', '5', 'integer', 'Maximum failed login attempts before lockout', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (7, 'enable_2fa', 'false', 'boolean', 'Enable two-factor authentication', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (8, 'enable_email_notifications', 'true', 'boolean', 'Enable email notifications', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (9, 'enable_error_alerts', 'true', 'boolean', 'Enable error alerts', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (10, 'enable_weekly_reports', 'false', 'boolean', 'Enable weekly reports', '2026-02-13 12:02:01', '2026-02-13 12:02:01');
INSERT INTO tbl_system_settings (id, setting_key, setting_value, setting_type, description, created_at, updated_at) VALUES (11, 'ai_model', 'GPT-4', 'string', 'AI model to use for generation', '2026-02-13 12:02:01', '2026-02-13 12:02:01');

DROP TABLE IF EXISTS tbl_templates;
CREATE TABLE `tbl_templates` (
  `template_id` int(11) NOT NULL AUTO_INCREMENT,
  `template_name` varchar(30) NOT NULL,
  `description` text DEFAULT NULL,
  `primary_color` varchar(20) DEFAULT NULL,
  `font_style` varchar(25) DEFAULT NULL,
  `is_default` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `template_name` (`template_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

