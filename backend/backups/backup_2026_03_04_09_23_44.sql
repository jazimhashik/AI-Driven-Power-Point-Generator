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
) ENGINE=InnoDB AUTO_INCREMENT=336 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (70, 0, 'CREATE_BACKUP', 'Created backup: backups\backup_2026_02_20_23_40_25.sql', '127.0.0.1', 'success', '2026-02-20 23:40:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (71, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-20 23:46:01');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (72, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-21 00:03:49');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (73, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-21 00:16:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (74, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-21 00:16:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (75, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-21 00:21:12');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (76, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-21 00:21:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (77, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: 42750d38c2b340e4b3cb74db9d017082_ppt bg img.jpg', '127.0.0.1', 'success', '2026-02-21 00:32:49');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (78, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: 4bf1af4ece784139b515835e4968344d_ppt bg img.jpg', '127.0.0.1', 'success', '2026-02-21 00:38:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (79, 0, 'ADD_TEMPLATE', 'Added template: test', '127.0.0.1', 'success', '2026-02-21 00:38:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (80, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-21 00:38:32');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (81, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-21 00:38:38');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (82, 1, 'PPT_GENERATED', 'AI presentation generated: richest man in india...', '127.0.0.1', 'success', '2026-02-21 00:40:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (83, 1, 'PPT_GENERATED', 'AI presentation generated: richest man in india...', '127.0.0.1', 'success', '2026-02-21 00:40:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (84, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-21 00:52:58');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (85, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-21 00:53:12');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (86, 1, 'PPT_GENERATED', 'AI presentation generated: teaching as a profession...', '127.0.0.1', 'success', '2026-02-21 00:54:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (87, 1, 'PPT_GENERATED', 'AI presentation generated: teaching as a profession...', '127.0.0.1', 'success', '2026-02-21 00:54:22');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (88, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-21 17:58:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (89, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-21 23:52:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (90, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-22 20:47:39');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (91, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: 576c7625412047bcb4a5e0c24ded50f4_blue bg.jpg', '127.0.0.1', 'success', '2026-02-22 21:08:32');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (92, 0, 'ADD_TEMPLATE', 'Added template: Test blue', '127.0.0.1', 'success', '2026-02-22 21:09:09');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (93, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-22 21:09:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (94, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-22 21:09:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (95, 1, 'PPT_GENERATED', 'AI presentation generated: motorcycles...', '127.0.0.1', 'success', '2026-02-22 21:10:07');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (96, 1, 'PPT_GENERATED', 'AI presentation generated: motorcycles...', '127.0.0.1', 'success', '2026-02-22 21:10:07');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (97, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-22 21:16:50');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (98, NULL, 'LOGIN_FAILED', 'Failed login attempt for identifier: admin', '127.0.0.1', 'success', '2026-02-22 21:16:55');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (99, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-22 21:17:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (100, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-25 08:57:52');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (101, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 08:59:10');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (102, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 08:59:11');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (103, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 09:00:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (104, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 09:00:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (105, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime in india...', '127.0.0.1', 'success', '2026-02-25 09:13:57');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (106, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime in india...', '127.0.0.1', 'success', '2026-02-25 09:14:01');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (107, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 09:15:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (108, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 09:15:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (109, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-25 09:25:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (110, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-25 09:25:22');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (111, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-25 09:27:21');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (112, NULL, 'LOGIN_FAILED', 'Failed login attempt for identifier: trial', '127.0.0.1', 'success', '2026-02-25 09:27:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (113, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-25 09:27:36');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (114, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 09:39:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (115, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 09:39:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (116, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-25 09:42:22');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (117, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-25 09:42:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (118, 15, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-25 09:49:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (119, 15, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-25 09:49:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (120, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 09:51:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (121, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 09:51:21');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (122, 15, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 10:39:43');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (123, 15, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-25 10:39:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (124, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-25 10:57:58');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (125, NULL, 'LOGIN_FAILED', 'Failed login attempt for identifier: reseena', '127.0.0.1', 'success', '2026-02-25 10:58:19');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (126, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-25 10:58:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (127, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:13:29');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (128, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:13:29');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (129, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:15:13');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (130, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:15:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (131, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:15:52');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (132, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:15:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (133, 15, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-02-25 11:43:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (134, 15, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-02-25 11:43:26');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (135, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-25 11:48:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (136, 16, 'USER_REGISTER', 'User jaz registered successfully', '127.0.0.1', 'success', '2026-02-25 11:49:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (137, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:49:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (138, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:49:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (139, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:50:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (140, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 11:50:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (141, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india and how it is transforming india...', '127.0.0.1', 'success', '2026-02-25 11:52:36');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (142, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india and how it is transforming india...', '127.0.0.1', 'success', '2026-02-25 11:52:36');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (143, 16, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-25 11:53:08');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (144, 16, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-25 11:53:09');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (145, 16, 'PPT_GENERATED', 'AI presentation generated: types of cybercrimes...', '127.0.0.1', 'success', '2026-02-25 12:08:42');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (146, 16, 'PPT_GENERATED', 'AI presentation generated: types of cybercrimes...', '127.0.0.1', 'success', '2026-02-25 12:08:42');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (147, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 12:20:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (148, 16, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 12:20:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (149, 16, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-25 12:20:19');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (150, 17, 'USER_REGISTER', 'User aggie registered successfully', '127.0.0.1', 'success', '2026-02-25 12:21:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (151, 17, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 12:37:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (152, 17, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-25 12:37:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (153, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 20:45:59');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (154, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: 0a14f5fc70b84d83bf519f1ba5964148_Stylish Romantic.ttf', '127.0.0.1', 'success', '2026-02-27 20:50:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (155, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 20:55:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (156, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: 63619f4c3d7d48628ef9ef9dffad49d4_Stylish Romantic.ttf', '127.0.0.1', 'success', '2026-02-27 20:56:08');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (157, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-27 21:15:40');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (158, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:15:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (159, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: b7fcfd2946ef47c3aaafffc129cfcae2_Stylish Romantic.ttf (58156 bytes)', '127.0.0.1', 'success', '2026-02-27 21:19:57');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (160, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:25:50');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (161, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: 6e70f07161474c43b1a6493cfe7c6bdf_Stylish Romantic.ttf (58156 bytes)', '127.0.0.1', 'success', '2026-02-27 21:26:01');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (162, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-27 21:28:23');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (163, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:28:26');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (164, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: f9fcf52679b54be99f4c2bd9051b3630_Stylish Romantic.ttf (58156 bytes)', '127.0.0.1', 'success', '2026-02-27 21:28:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (165, 0, 'ADD_FONT', 'Added font: Stylish romanctic', '127.0.0.1', 'success', '2026-02-27 21:28:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (166, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: ae99e957d4f6434e985a4fb4a32242ca_pngtree-watercolor-leafy-green-serenity-ppt-background-image_17425782.jpg (14922 bytes)', '127.0.0.1', 'success', '2026-02-27 21:31:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (167, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-27 21:34:48');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (168, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:34:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (169, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: 46bbec51190e4e83b6c890994966595c_pngtree-watercolor-leafy-green-serenity-ppt-background-image_17425782.jpg (14922 bytes)', '127.0.0.1', 'success', '2026-02-27 21:35:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (170, 0, 'ADD_TEMPLATE', 'Added template: testing 11 (ai, available_for: both)', '127.0.0.1', 'success', '2026-02-27 21:35:39');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (171, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-02-27 21:35:44');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (172, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:35:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (173, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-27 21:36:50');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (174, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-27 21:36:50');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (175, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-27 21:54:28');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (176, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:54:32');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (177, 0, 'UPDATE_TEMPLATE', 'Updated template ID: 7', '127.0.0.1', 'success', '2026-02-27 21:55:09');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (178, 0, 'UPDATE_TEMPLATE', 'Updated template ID: 7', '127.0.0.1', 'success', '2026-02-27 21:55:12');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (179, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:55:39');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (180, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-27 21:59:31');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (181, 15, 'PPT_GENERATED', 'AI presentation generated: Micro greens...', '127.0.0.1', 'success', '2026-02-27 22:01:20');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (182, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-27 22:03:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (183, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 22:03:35');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (184, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-02-27 23:24:10');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (185, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: 369436ee83074839b0eb6fd7477f8851_download (4).jpg (1609 bytes)', '127.0.0.1', 'success', '2026-02-27 23:26:11');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (186, 0, 'ADD_TEMPLATE', 'Added template: test (ai, available_for: both)', '127.0.0.1', 'success', '2026-02-27 23:26:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (187, 0, 'UPDATE_TEMPLATE', 'Updated template ID: 14', '127.0.0.1', 'success', '2026-02-27 23:26:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (188, 0, 'UPDATE_TEMPLATE', 'Updated template ID: 14', '127.0.0.1', 'success', '2026-02-27 23:26:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (189, 0, 'UPDATE_TEMPLATE', 'Updated template ID: 10', '127.0.0.1', 'success', '2026-02-27 23:26:29');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (190, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-27 23:26:46');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (191, 1, 'PPT_GENERATED', 'AI presentation generated: cooking as a passion...', '127.0.0.1', 'success', '2026-02-27 23:27:56');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (192, 1, 'PPT_GENERATED', 'AI presentation generated: cooking as a passion...', '127.0.0.1', 'success', '2026-02-27 23:35:20');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (193, 1, 'PPT_GENERATED', 'AI presentation generated: cooking as a passion...', '127.0.0.1', 'success', '2026-02-27 23:45:32');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (194, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-27 23:45:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (195, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-27 23:47:10');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (196, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-28 00:22:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (197, 1, 'PPT_GENERATED', 'AI presentation generated: business tips...', '127.0.0.1', 'success', '2026-02-28 00:24:04');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (198, 1, 'PPT_GENERATED', 'AI presentation generated: business tips...', '127.0.0.1', 'success', '2026-02-28 00:25:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (199, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-28 00:32:40');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (200, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-28 00:32:49');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (201, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-28 00:33:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (202, 1, 'PPT_GENERATED', 'AI presentation generated:  Business analytics along with AI...', '127.0.0.1', 'success', '2026-02-28 00:34:56');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (203, 1, 'PPT_GENERATED', 'AI presentation generated: business analytics with AI...', '127.0.0.1', 'success', '2026-02-28 00:35:41');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (204, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-28 00:40:31');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (205, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-28 00:40:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (206, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-02-28 00:41:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (207, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-28 20:01:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (208, 15, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-28 20:02:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (209, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-02-28 20:26:05');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (210, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-02-28 20:26:12');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (211, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-02-28 20:26:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (212, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-02-28 20:27:33');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (213, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 14:36:30');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (214, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-03-01 14:37:06');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (215, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-03-01 14:38:02');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (216, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 14:47:10');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (217, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-03-01 14:47:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (218, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 14:47:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (219, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-01 14:47:59');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (220, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-01 14:49:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (221, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-03-01 14:50:23');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (222, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 15:33:56');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (223, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 15:34:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (224, 1, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-03-01 15:34:39');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (225, 1, 'PPT_GENERATED', 'AI presentation generated: cooking as a passion...', '127.0.0.1', 'success', '2026-03-01 15:35:32');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (226, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 15:57:05');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (227, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 15:57:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (228, 15, 'PPT_GENERATED', 'AI presentation generated: cooking as a passion...', '127.0.0.1', 'success', '2026-03-01 15:57:57');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (229, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 16:27:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (230, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 16:27:31');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (231, 15, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-03-01 16:29:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (232, 15, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-01 16:30:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (233, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 17:04:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (234, 15, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-01 17:05:04');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (235, 15, 'PPT_GENERATED', 'AI presentation generated: AI...', '127.0.0.1', 'success', '2026-03-01 17:06:23');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (236, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 17:21:48');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (237, 15, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-03-01 17:22:25');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (238, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 18:03:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (239, 15, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-03-01 18:04:32');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (240, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 18:30:30');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (241, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 18:30:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (242, 1, 'PPT_GENERATED', 'AI presentation generated:  Business analytics...', '127.0.0.1', 'success', '2026-03-01 18:31:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (243, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 19:46:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (244, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 19:46:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (245, 1, 'PPT_GENERATED', 'AI presentation generated: AI in India...', '127.0.0.1', 'success', '2026-03-01 19:47:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (246, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-03-01 19:48:04');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (247, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:14:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (248, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:14:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (249, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:16:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (250, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:16:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (251, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 20:44:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (252, 15, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:45:43');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (253, 15, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:45:43');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (254, 15, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 20:46:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (255, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 20:46:21');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (256, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 20:46:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (257, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 20:59:22');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (258, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 20:59:31');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (259, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 21:00:56');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (260, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 21:00:56');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (261, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 23:17:16');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (262, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 23:19:07');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (263, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 23:19:07');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (264, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 23:25:35');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (265, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 23:25:44');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (266, 15, 'PPT_UPLOADED', 'Manual presentation uploaded: 1 slides', '127.0.0.1', 'success', '2026-03-01 23:28:14');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (267, 15, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 23:40:48');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (268, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 23:40:54');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (269, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 2 slides', '127.0.0.1', 'success', '2026-03-01 23:41:50');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (270, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 23:51:37');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (271, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-01 23:51:44');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (272, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 2 slides', '127.0.0.1', 'success', '2026-03-01 23:52:49');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (273, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-01 23:59:19');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (274, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-01 23:59:28');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (275, 0, 'UPDATE_TEMPLATE', 'Updated template ID: 10', '127.0.0.1', 'success', '2026-03-01 23:59:38');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (276, 0, 'ADD_COLOR_SCHEME', 'Added color scheme: Testing', '127.0.0.1', 'success', '2026-03-02 00:00:30');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (277, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: 3247a26b047a4180a4f315ae1a0a1b85_pngtree-watercolor-leafy-green-serenity-ppt-background-image_17425782.jpg (14922 bytes)', '127.0.0.1', 'success', '2026-03-02 00:02:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (278, 0, 'ADD_TEMPLATE', 'Added template: test forest (manual, available_for: both)', '127.0.0.1', 'success', '2026-03-02 00:04:13');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (279, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-03-02 00:04:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (280, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 00:04:24');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (281, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-02 00:14:44');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (282, NULL, 'LOGIN_FAILED', 'Failed login attempt for identifier: trial', '127.0.0.1', 'success', '2026-03-02 00:14:49');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (283, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 00:14:55');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (284, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-03-02 00:15:41');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (285, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-02 00:30:18');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (286, 15, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 00:30:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (287, 15, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-03-02 00:32:04');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (288, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 09:06:33');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (289, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-02 14:44:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (290, 0, 'UPLOAD_THEME_FILE', 'Uploaded background: 492de8fb4ec24577912c5bae30962c9f_pngtree-watercolor-leafy-green-serenity-ppt-background-image_17425782.jpg (14922 bytes)', '127.0.0.1', 'success', '2026-03-02 14:47:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (291, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-03-02 14:47:38');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (292, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 14:47:43');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (293, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-02 14:48:38');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (294, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 15:06:41');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (295, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 22:45:27');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (296, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-02 22:46:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (297, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-02 22:48:33');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (298, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-02 23:36:05');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (299, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 23:36:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (300, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 23:38:52');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (301, 1, 'PPT_GENERATED', 'AI presentation generated: ai in india...', '127.0.0.1', 'success', '2026-03-02 23:39:36');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (302, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-02 23:40:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (303, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-02 23:40:09');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (304, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: 8dc272108e074f21a286f1fdbcd60403_Guazhiru-3gPz.ttf (92208 bytes)', '127.0.0.1', 'success', '2026-03-02 23:45:07');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (305, 0, 'UPLOAD_THEME_FILE', 'Uploaded font: 8e1146e2047841228b7fc58f3780f413_Guazhiru-3gPz.ttf (92208 bytes)', '127.0.0.1', 'success', '2026-03-02 23:45:29');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (306, 0, 'ADD_FONT', 'Added font: Guazhiru', '127.0.0.1', 'success', '2026-03-02 23:45:47');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (307, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-03-02 23:45:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (308, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-02 23:46:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (309, 1, 'PPT_GENERATED', 'AI presentation generated: ai in indian economy...', '127.0.0.1', 'success', '2026-03-02 23:47:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (310, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-02 23:50:51');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (311, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-02 23:51:06');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (312, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-03-03 00:34:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (313, 18, 'USER_REGISTER', 'User George registered successfully', '127.0.0.1', 'success', '2026-03-03 12:54:31');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (314, 18, 'PPT_GENERATED', 'AI presentation generated: Machine Learning...', '127.0.0.1', 'success', '2026-03-03 12:56:15');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (315, 18, 'PPT_GENERATED', 'AI presentation generated: Supervised Learning...', '127.0.0.1', 'success', '2026-03-03 12:58:21');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (316, 18, 'PPT_UPLOADED', 'Manual presentation uploaded: 2 slides', '127.0.0.1', 'success', '2026-03-03 13:02:30');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (317, 18, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-03 13:03:04');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (318, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-03 13:03:09');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (319, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-04 08:40:03');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (320, 0, 'UPLOAD_THEME_FILE', 'Uploaded template: d31f3f855fc845e99dcbf47718edcc4a_shapelined-_JBKdviweXI-unsplash.jpg (332586 bytes)', '127.0.0.1', 'success', '2026-03-04 08:45:06');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (321, 0, 'UPLOAD_THEME_FILE', 'Uploaded background: 2cc3618a15d348e68b019dabc3872395_shapelined-_JBKdviweXI-unsplash.jpg (332586 bytes)', '127.0.0.1', 'success', '2026-03-04 08:45:20');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (322, 0, 'ADD_TEMPLATE', 'Added template: Trial (ai, available_for: both)', '127.0.0.1', 'success', '2026-03-04 08:45:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (323, 0, 'ADMIN_LOGOUT', 'Admin logged out', '127.0.0.1', 'success', '2026-03-04 08:45:49');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (324, NULL, 'LOGIN_FAILED', 'Failed login attempt for identifier: trial', '127.0.0.1', 'success', '2026-03-04 08:45:55');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (325, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-04 08:46:00');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (326, 1, 'PPT_GENERATED', 'AI presentation generated: Healthcare in India...', '127.0.0.1', 'success', '2026-03-04 08:46:48');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (327, 1, 'PPT_GENERATED', 'AI presentation generated: Healthcare in India...', '127.0.0.1', 'success', '2026-03-04 08:47:17');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (328, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-04 08:54:45');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (329, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-04 09:01:26');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (330, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-04 09:01:34');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (331, 1, 'USER_LOGIN', 'User logged in successfully', '127.0.0.1', 'success', '2026-03-04 09:14:28');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (332, 1, 'PPT_GENERATED', 'AI presentation generated: cybercrime...', '127.0.0.1', 'success', '2026-03-04 09:15:55');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (333, 1, 'PPT_UPLOADED', 'Manual presentation uploaded: 2 slides', '127.0.0.1', 'success', '2026-03-04 09:18:10');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (334, 1, 'USER_LOGOUT', 'User logged out', '127.0.0.1', 'success', '2026-03-04 09:19:53');
INSERT INTO tbl_audit_log (id, user_id, action, details, ip_address, status, created_at) VALUES (335, 0, 'ADMIN_LOGIN', 'Admin logged in successfully', '127.0.0.1', 'success', '2026-03-04 09:20:02');

DROP TABLE IF EXISTS tbl_backgrounds;
CREATE TABLE `tbl_backgrounds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `background_type` varchar(20) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `gradient_colors` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`gradient_colors`)),
  `solid_color` varchar(20) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_default` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (1, 'Cosmic Dark', 'solid', NULL, NULL, '#080c1c', NULL, 1, 1, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (2, 'Ocean Blue', 'solid', NULL, NULL, '#0a2350', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (3, 'Neon Purple', 'solid', NULL, NULL, '#0f0523', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (4, 'Minimal Light', 'solid', NULL, NULL, '#fcfcff', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (5, 'Corporate Pro', 'solid', NULL, NULL, '#0f1e37', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (6, 'Elegant Dark', 'solid', NULL, NULL, '#0c0c12', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (7, 'Tech Modern', 'solid', NULL, NULL, '#0a081e', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (8, 'Nature Fresh', 'solid', NULL, NULL, '#0c321e', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (9, 'Creative Colorful', 'solid', NULL, NULL, '#19192d', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (10, 'Sunset Glow', 'solid', NULL, NULL, '#23121c', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (11, 'Arctic Ice', 'solid', NULL, NULL, '#0f283c', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (12, 'Midnight Express', 'solid', NULL, NULL, '#080810', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (13, 'Royal Purple', 'solid', NULL, NULL, '#190a28', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_backgrounds (id, name, background_type, image_url, gradient_colors, solid_color, thumbnail, is_active, is_default, created_by, created_at, updated_at) VALUES (14, 'Trial Background', 'image', '/theme_uploads/2cc3618a15d348e68b019dabc3872395_shapelined-_JBKdviweXI-unsplash.jpg', NULL, NULL, NULL, 1, 0, 0, '2026-03-04 08:45:45', '2026-03-04 08:45:45');

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

DROP TABLE IF EXISTS tbl_color_schemes;
CREATE TABLE `tbl_color_schemes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `primary_color` varchar(20) NOT NULL,
  `secondary_color` varchar(20) DEFAULT NULL,
  `accent_color` varchar(20) DEFAULT NULL,
  `background_color` varchar(20) DEFAULT NULL,
  `text_color` varchar(20) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_default` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (1, 'Cosmic Dark', '#78b4ff', '#48d1cc', '#9370db', '#080c1c', '#dceaff', 1, 1, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (2, 'Ocean Blue', '#ffffff', '#50c8ff', '#00b4dc', '#0a2350', '#c8e6ff', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (3, 'Neon Purple', '#dc64ff', '#ff32b4', '#b450ff', '#0f0523', '#e6b4ff', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (4, 'Minimal Light', '#19284b', '#64b4ff', '#0078d7', '#fcfcff', '#374664', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (5, 'Corporate Pro', '#ffffff', '#ffaa32', '#3ca55f', '#0f1e37', '#d2e1f5', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (6, 'Elegant Dark', '#dab44b', '#dab44b', '#b9963c', '#0c0c12', '#e1e1e1', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (7, 'Tech Modern', '#00ffb4', '#00dcdc', '#50c8ff', '#0a081e', '#aad2ff', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (8, 'Nature Fresh', '#a0f5a0', '#b4e6b4', '#5abe64', '#0c321e', '#d2ffc8', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (9, 'Creative Colorful', '#ff8282', '#8250c8', '#ffc832', '#19192d', '#ffe6aa', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (10, 'Sunset Glow', '#ffc8aa', '#ffd26e', '#ff8282', '#23121c', '#ffe6d7', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (11, 'Arctic Ice', '#b9f0e1', '#3c6e9b', '#96e1c3', '#0f283c', '#d7faf0', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (12, 'Midnight Express', '#d7e6ff', '#1e2d4b', '#7896c8', '#080810', '#b4c8e6', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (13, 'Royal Purple', '#ffc3e6', '#5f376a', '#ff4682', '#190a28', '#ebc3f5', 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default, created_by, created_at, updated_at) VALUES (14, 'Testing', '#2d69a9', '#364759', '#5cb5c7', '#ffffff', '#000000', 1, 0, 0, '2026-03-02 00:00:30', '2026-03-02 00:00:30');

DROP TABLE IF EXISTS tbl_custdetails;
CREATE TABLE `tbl_custdetails` (
  `cust_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_id` int(11) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `registered_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`cust_id`),
  UNIQUE KEY `email` (`email`),
  KEY `login_id` (`login_id`),
  CONSTRAINT `tbl_custdetails_ibfk_1` FOREIGN KEY (`login_id`) REFERENCES `tbl_login` (`login_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (1, NULL, 'shinto', 'shinto@gmail.com', '6282664307', '2026-02-13', 1, '2026-02-12 02:31:10', NULL);
INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (2, NULL, 'sossu', 'sosseu@gmail.com', '1234546778890', '2026-02-10', 1, '2026-02-13 12:30:28', NULL);
INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (3, NULL, 'shin', 'shin@gmail.com', '9896929264', '3333-03-22', 1, '2026-02-18 01:54:22', NULL);
INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (4, NULL, 'reseena hashik', 'reseen@gmail.com', '9898989898', '2001-02-12', 1, '2026-02-20 23:24:24', NULL);
INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (5, 16, 'Jaz', 'jaz@gmail.com', '9898434316', '2004-10-04', 1, '2026-02-25 11:49:27', NULL);
INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (6, 17, 'Aggie', 'aggie@yahoo.com', '7736965699', '2005-10-10', 1, '2026-02-25 12:21:18', NULL);
INSERT INTO tbl_custdetails (cust_id, login_id, name, email, phone, dob, status, registered_at, updated_at) VALUES (7, 18, 'Juby', 'juby@gmail.com', '9876543210', '2005-05-25', 1, '2026-03-03 12:54:31', NULL);

DROP TABLE IF EXISTS tbl_fonts;
CREATE TABLE `tbl_fonts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `font_family` varchar(255) NOT NULL,
  `font_url` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_default` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (1, 'Arial', 'Arial', 'Arial, sans-serif', NULL, 1, 1, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (2, 'Roboto', 'Roboto', 'Roboto, sans-serif', NULL, 0, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (3, 'Open Sans', 'Open Sans', 'Open Sans, sans-serif', NULL, 0, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (4, 'Montserrat', 'Montserrat', 'Montserrat, sans-serif', NULL, 0, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (5, 'Playfair Display', 'Playfair Display', 'Playfair Display, serif', NULL, 0, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (6, 'DM Sans', 'DM Sans', 'DM Sans, sans-serif', NULL, 0, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (7, 'Inter', 'Inter', 'Inter, sans-serif', NULL, 0, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (8, 'Poppins', 'Poppins', 'Poppins, sans-serif', NULL, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (9, 'Lato', 'Lato', 'Lato', NULL, 1, 0, NULL, '2026-03-01 17:33:41', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (10, 'Barlow', 'Barlow', 'Barlow', NULL, 1, 0, NULL, '2026-03-01 17:33:41', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (11, 'PT Sans', 'PT Sans', 'PT Sans', NULL, 1, 0, NULL, '2026-03-01 17:33:41', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (12, 'PT Serif', 'PT Serif', 'PT Serif', NULL, 1, 0, NULL, '2026-03-01 17:33:41', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (13, 'Fira Sans', 'Fira Sans', 'Fira Sans', NULL, 1, 0, NULL, '2026-03-01 17:33:41', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (14, 'Ubuntu', 'Ubuntu', 'Ubuntu', NULL, 1, 0, NULL, '2026-03-01 17:33:41', '2026-03-01 17:33:41');
INSERT INTO tbl_fonts (id, name, display_name, font_family, font_url, is_active, is_default, created_by, created_at, updated_at) VALUES (15, 'Guazhiru', 'Guazhiru', 'Guazhiru', '/theme_uploads/8e1146e2047841228b7fc58f3780f413_Guazhiru-3gPz.ttf', 1, 0, 0, '2026-03-02 23:45:47', '2026-03-02 23:45:47');

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
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (70, 1, 'richest man in india', NULL, NULL, '2026-02-21 00:39:41');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (71, 1, 'richest man in india', NULL, NULL, '2026-02-21 00:39:41');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (72, 1, 'teaching as a profession', NULL, NULL, '2026-02-21 00:53:55');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (73, 1, 'teaching as a profession', NULL, NULL, '2026-02-21 00:53:55');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (74, 1, 'motorcycles', NULL, NULL, '2026-02-22 21:09:54');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (75, 1, 'motorcycles', NULL, NULL, '2026-02-22 21:09:54');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (76, 1, 'cybercrime', NULL, NULL, '2026-02-25 08:58:45');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (77, 1, 'cybercrime', NULL, NULL, '2026-02-25 08:58:45');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (78, 1, 'cybercrime', NULL, NULL, '2026-02-25 08:59:55');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (79, 1, 'cybercrime', NULL, NULL, '2026-02-25 08:59:56');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (80, 1, 'cybercrime in india', NULL, NULL, '2026-02-25 09:13:43');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (81, 1, 'cybercrime in india', NULL, NULL, '2026-02-25 09:13:43');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (82, 1, 'ai in india', NULL, NULL, '2026-02-25 09:15:01');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (83, 1, 'ai in india', NULL, NULL, '2026-02-25 09:15:01');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (84, 1, 'cybercrime', NULL, NULL, '2026-02-25 09:38:55');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (85, 1, 'cybercrime', NULL, NULL, '2026-02-25 09:38:55');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (86, 15, 'ai in indian economy', NULL, NULL, '2026-02-25 09:49:17');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (87, 15, 'ai in indian economy', NULL, NULL, '2026-02-25 09:49:17');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (88, 15, 'ai in india', NULL, NULL, '2026-02-25 09:51:06');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (89, 15, 'ai in india', NULL, NULL, '2026-02-25 09:51:06');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (90, 15, 'cybercrime', NULL, NULL, '2026-02-25 10:39:28');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (91, 15, 'cybercrime', NULL, NULL, '2026-02-25 10:39:28');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (92, 15, 'ai in india', NULL, NULL, '2026-02-25 11:13:15');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (93, 15, 'ai in india', NULL, NULL, '2026-02-25 11:13:15');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (94, 15, 'ai in india', NULL, NULL, '2026-02-25 11:15:02');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (95, 15, 'ai in india', NULL, NULL, '2026-02-25 11:15:02');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (96, 15, 'ai in india', NULL, NULL, '2026-02-25 11:15:46');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (97, 15, 'ai in india', NULL, NULL, '2026-02-25 11:15:46');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (98, 15, ' Business analytics', NULL, NULL, '2026-02-25 11:43:20');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (99, 15, ' Business analytics', NULL, NULL, '2026-02-25 11:43:20');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (100, 16, 'ai in india', NULL, NULL, '2026-02-25 11:49:43');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (101, 16, 'ai in india', NULL, NULL, '2026-02-25 11:49:43');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (102, 16, 'ai in india and how it is transforming india', NULL, NULL, '2026-02-25 11:50:15');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (103, 16, 'ai in india and how it is transforming india', NULL, NULL, '2026-02-25 11:50:15');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (104, 16, 'ai in india and how it is transforming india', NULL, NULL, '2026-02-25 11:52:34');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (105, 16, 'ai in india and how it is transforming india', NULL, NULL, '2026-02-25 11:52:34');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (106, 16, 'ai in indian economy', NULL, NULL, '2026-02-25 11:53:08');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (107, 16, 'ai in indian economy', NULL, NULL, '2026-02-25 11:53:08');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (108, 16, 'types of cybercrimes', NULL, NULL, '2026-02-25 12:08:38');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (109, 16, 'types of cybercrimes', NULL, NULL, '2026-02-25 12:08:38');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (110, 16, 'ai in india', NULL, NULL, '2026-02-25 12:18:48');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (111, 16, 'ai in india', NULL, NULL, '2026-02-25 12:18:48');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (112, 17, 'ai in india', NULL, NULL, '2026-02-25 12:35:51');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (113, 17, 'ai in india', NULL, NULL, '2026-02-25 12:35:51');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (114, 1, 'cybercrime around the world and mainly in india', NULL, NULL, '2026-02-27 21:36:38');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (115, 1, 'cybercrime around the world and mainly in india', NULL, NULL, '2026-02-27 21:36:39');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (116, 15, 'About how micro grrens are prepared and it s marketing trends', NULL, NULL, '2026-02-27 22:01:03');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (117, 1, 'cooking as a passion', NULL, NULL, '2026-02-27 23:27:41');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (118, 1, 'cooking as a passion', NULL, NULL, '2026-02-27 23:35:12');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (119, 1, 'cooking as a passion', NULL, NULL, '2026-02-27 23:45:24');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (120, 1, 'ai in indian economy', NULL, NULL, '2026-02-27 23:45:46');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (121, 1, 'cybercrime', NULL, NULL, '2026-02-27 23:46:51');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (122, 1, 'business tips', NULL, NULL, '2026-02-28 00:23:41');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (123, 1, 'business tips', NULL, NULL, '2026-02-28 00:24:52');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (124, 1, 'cybercrime', NULL, NULL, '2026-02-28 00:33:13');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (125, 1, ' Business analytics along with AI', NULL, NULL, '2026-02-28 00:34:46');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (126, 1, 'business analytics with AI', NULL, NULL, '2026-02-28 00:35:18');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (127, 1, 'ai in indian economy', NULL, NULL, '2026-02-28 00:41:13');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (128, 15, 'cybercrime', NULL, NULL, '2026-02-28 20:01:58');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (129, 1, 'ai in india', NULL, NULL, '2026-02-28 20:26:37');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (130, 1, 'cybercrime', NULL, NULL, '2026-02-28 20:27:22');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (131, 1, 'ai in india', NULL, NULL, '2026-03-01 14:36:52');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (132, 1, 'ai in indian economy', NULL, NULL, '2026-03-01 14:37:51');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (133, 1, 'ai in indian economy', NULL, NULL, '2026-03-01 14:47:07');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (134, 1, 'cybercrime', NULL, NULL, '2026-03-01 14:47:50');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (135, 1, 'cybercrime', NULL, NULL, '2026-03-01 14:49:03');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (136, 1, 'ai in india', NULL, NULL, '2026-03-01 14:50:12');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (137, 1, ' Business analytics', NULL, NULL, '2026-03-01 15:34:28');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (138, 1, 'cooking as a passion', NULL, NULL, '2026-03-01 15:35:24');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (139, 15, 'cooking as a passion', NULL, NULL, '2026-03-01 15:57:48');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (140, 15, ' Business analytics', NULL, NULL, '2026-03-01 16:29:09');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (141, 15, 'cybercrime', NULL, NULL, '2026-03-01 16:30:43');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (142, 15, 'cybercrime', NULL, NULL, '2026-03-01 17:04:52');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (143, 15, 'AI', NULL, NULL, '2026-03-01 17:06:11');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (144, 15, 'ai in indian economy', NULL, NULL, '2026-03-01 17:22:12');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (145, 15, ' Business analytics', NULL, NULL, '2026-03-01 18:04:22');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (146, 1, ' Business analytics', NULL, NULL, '2026-03-01 18:30:53');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (147, 1, '', NULL, NULL, '2026-03-01 19:47:17');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (148, 1, '', NULL, NULL, '2026-03-01 19:47:57');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (149, 1, 'ai in india', NULL, NULL, '2026-03-02 00:15:32');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (150, 15, 'ai in india', NULL, NULL, '2026-03-02 00:31:48');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (151, 1, 'cybercrime', NULL, NULL, '2026-03-02 22:46:02');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (152, 1, 'cybercrime', NULL, NULL, '2026-03-02 22:48:22');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (153, 1, 'ai in india', NULL, NULL, '2026-03-02 23:39:27');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (154, 1, 'ai in indian economy', NULL, NULL, '2026-03-02 23:46:51');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (155, 18, 'Machine Learning', NULL, NULL, '2026-03-03 12:55:55');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (156, 18, 'explain about dataset in Supervised Learning for bca students', NULL, NULL, '2026-03-03 12:58:08');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (157, 1, 'Healthcare in India', NULL, NULL, '2026-03-04 08:46:36');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (158, 1, 'Healthcare in India', NULL, NULL, '2026-03-04 08:47:07');
INSERT INTO tbl_input_data (input_id, user_id, raw_input, summary, keywords, created_at) VALUES (159, 1, 'cybercrime', NULL, NULL, '2026-03-04 09:15:43');

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (1, 'trial', 'scrypt:32768:8:1$gSlsYmWqOBwUYWND$88eb66c9cedff6a2296082257c5e1c863fe8e079592b7e9e61def6da0af9bc325838cc8630b83d2d2ad6b17bbca84ee5f119dd91fee9710134efdc72eee06671', 'customer', 'trial@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-01-21 10:30:28', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (5, 'shinto', 'scrypt:32768:8:1$fTv2tedCxcVVVTwu$4da366ab89c1aae0a267906eaa6e283a2181d1aa6506d29bc33fbc0b47ccf96bb4872b73a150950c0598f484d899bcc96135999c274e3eafb5fa8461b476800e', 'customer', 'shinto@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-12 02:31:10', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (6, 'soss', 'scrypt:32768:8:1$7q9rb1oIyPlYo3qo$4bc63819eb9edd6c51d46383f461dabab92abaa7b865f093ecd55af841e1e30f5819d7d1f98922cc45bedda7666ffa750db8c7c04ee8ca6ece3bb82c41a40b75', 'customer', 'sosseu@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-13 12:30:28', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (7, 'admin', 'scrypt:32768:8:1$KQyCxXwfZAdnfpNT$54f5b1b0221c17ec3fdde2961f9004f7fa851c6ca398f284cd041ed7d8af8df517a8a3926eb27639c68fb52c3877d57c694307bdf6f98d5d073587e040ae8611', 'admin', 'admin@cosmicai.com', 0, NULL, NULL, NULL, NULL, '2026-02-17 12:02:30', NULL, 1, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (8, 'shin', 'scrypt:32768:8:1$8T3mGCAYTBJjenJ3$25503160778ff2b37c6b6c9fd20b5aa112d71e48ef5b91f1384b511cdb957edbb56fb994121a491c9d1b303357c93c28deaa1d07abb2b7df838c766bde2c0a22', 'customer', 'shin@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-18 01:54:22', NULL, 0, NULL);
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (15, 'reseena', 'scrypt:32768:8:1$wi7fdccka6ia8MRA$fad92dc5f315a97056203d182f39cda0497875275a4cac45345f18c0a64f2aa0b445aeac003e4afe4f1c07fc779b96e983b0d3fd260390da35735c35f5c09a30', 'customer', 'reseen@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-20 23:24:24', NULL, 1, '9898989898');
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (16, 'jaz', 'scrypt:32768:8:1$yAxXYqywblCHW8Dc$c51f84ef3ada6f684f03c1f1e0471a20310e3b3173ec9a4c8b51b80a42a54dc0934dcf48335117a874e41cc5cf115a938b799c5bdbd9085842b52a10fb7d51e0', 'customer', 'jaz@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-02-25 11:49:27', NULL, 1, '9898434316');
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (17, 'aggie', 'scrypt:32768:8:1$6AQJOPcLDYhWjhjn$8bc2e8f9685863cfc70c98a7a625f8250b8dd054488b00b632f460a0f01b879eecc1542db2a8427fd5311e33c7598631d46ed33bb3d47da80fe7f6ecf4376ee3', 'customer', 'aggie@yahoo.com', 0, NULL, NULL, NULL, NULL, '2026-02-25 12:21:18', NULL, 1, '7736965699');
INSERT INTO tbl_login (login_id, username, password_hash, role, email, failed_attempts, locked_until, last_login, password_reset_token, token_expiry, created_at, updated_at, status, phone) VALUES (18, 'George', 'scrypt:32768:8:1$fURNRf4IRDfEHUTT$56711952d7945dce36a4e83b42e1e84242a579cf9813bff6629c85b5b6279d8f4a92e0ee11e2c7cbbb43659d62f5bdeaf9636defa72ac93be2ee718b58b4d671', 'customer', 'juby@gmail.com', 0, NULL, NULL, NULL, NULL, '2026-03-03 12:54:31', NULL, 1, '9876543210');

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
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (24, 1, 0, 0, '', '', 5, 'success', '2026-02-21 00:40:02', 70, 'AI', 'richest man in india', 'presentation_user_1_20260221003958.pptx', '2026-02-21 00:40:02');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (25, 1, 0, 0, '', '', 5, 'success', '2026-02-21 00:40:02', 71, 'AI', 'richest man in india', 'presentation_user_1_20260221004000.pptx', '2026-02-21 00:40:02');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (26, 1, 0, 0, '', '', 5, 'success', '2026-02-21 00:54:14', 73, 'AI', 'teaching as a profession', 'presentation_user_1_20260221005412.pptx', '2026-02-21 00:54:14');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (27, 1, 0, 0, '', '', 5, 'success', '2026-02-21 00:54:22', 72, 'AI', 'teaching as a profession', 'presentation_user_1_20260221005422.pptx', '2026-02-21 00:54:22');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (28, 1, 0, 0, '', '', 5, 'success', '2026-02-22 21:10:07', 75, 'AI', 'motorcycles', 'presentation_user_1_20260222211003.pptx', '2026-02-22 21:10:07');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (29, 1, 0, 0, '', '', 5, 'success', '2026-02-22 21:10:07', 74, 'AI', 'motorcycles', 'presentation_user_1_20260222211005.pptx', '2026-02-22 21:10:07');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (30, 1, 0, 0, '', '', 5, 'success', '2026-02-25 08:59:10', 76, 'AI', 'cybercrime', 'presentation_user_1_20260225085906.pptx', '2026-02-25 08:59:10');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (31, 1, 0, 0, '', '', 5, 'success', '2026-02-25 08:59:11', 77, 'AI', 'cybercrime', 'presentation_user_1_20260225085911.pptx', '2026-02-25 08:59:11');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (32, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:00:15', 79, 'AI', 'cybercrime', 'presentation_user_1_20260225090014.pptx', '2026-02-25 09:00:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (33, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:00:16', 78, 'AI', 'cybercrime', 'presentation_user_1_20260225090016.pptx', '2026-02-25 09:00:16');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (34, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:13:57', 81, 'AI', 'cybercrime in india', 'presentation_user_1_20260225091355.pptx', '2026-02-25 09:13:57');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (35, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:14:01', 80, 'AI', 'cybercrime in india', 'presentation_user_1_20260225091400.pptx', '2026-02-25 09:14:01');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (36, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:15:17', 83, 'AI', 'ai in india', 'presentation_user_1_20260225091516.pptx', '2026-02-25 09:15:17');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (37, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:15:17', 82, 'AI', 'ai in india', 'presentation_user_1_20260225091516.pptx', '2026-02-25 09:15:17');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (38, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:39:14', 85, 'AI', 'cybercrime', 'presentation_user_1_20260225093912.pptx', '2026-02-25 09:39:14');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (39, 1, 0, 0, '', '', 5, 'success', '2026-02-25 09:39:17', 84, 'AI', 'cybercrime', 'presentation_user_1_20260225093917.pptx', '2026-02-25 09:39:17');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (40, 15, 0, 0, '', '', 5, 'success', '2026-02-25 09:49:25', 86, 'AI', 'ai in indian economy', 'presentation_user_15_20260225094924.pptx', '2026-02-25 09:49:25');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (41, 15, 0, 0, '', '', 5, 'success', '2026-02-25 09:49:25', 87, 'AI', 'ai in indian economy', 'presentation_user_15_20260225094925.pptx', '2026-02-25 09:49:25');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (42, 15, 0, 0, '', '', 5, 'success', '2026-02-25 09:51:17', 88, 'AI', 'ai in india', 'presentation_user_15_20260225095116.pptx', '2026-02-25 09:51:17');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (43, 15, 0, 0, '', '', 5, 'success', '2026-02-25 09:51:21', 89, 'AI', 'ai in india', 'presentation_user_15_20260225095120.pptx', '2026-02-25 09:51:21');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (44, 15, 0, 0, '', '', 5, 'success', '2026-02-25 10:39:43', 90, 'AI', 'cybercrime', 'presentation_user_15_20260225103942.pptx', '2026-02-25 10:39:43');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (45, 15, 0, 0, '', '', 5, 'success', '2026-02-25 10:39:47', 91, 'AI', 'cybercrime', 'presentation_user_15_20260225103947.pptx', '2026-02-25 10:39:47');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (46, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:13:29', 93, 'AI', 'ai in india', 'presentation_user_15_20260225111327.pptx', '2026-02-25 11:13:29');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (47, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:13:29', 92, 'AI', 'ai in india', 'presentation_user_15_20260225111329.pptx', '2026-02-25 11:13:29');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (48, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:15:13', 95, 'AI', 'ai in india', 'presentation_user_15_20260225111513.pptx', '2026-02-25 11:15:13');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (49, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:15:18', 94, 'AI', 'ai in india', 'presentation_user_15_20260225111518.pptx', '2026-02-25 11:15:18');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (50, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:15:52', 97, 'AI', 'ai in india', 'presentation_user_15_20260225111551.pptx', '2026-02-25 11:15:52');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (51, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:15:53', 96, 'AI', 'ai in india', 'presentation_user_15_20260225111552.pptx', '2026-02-25 11:15:53');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (52, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:43:24', 98, 'AI', ' Business analytics', 'presentation_user_15_20260225114321.pptx', '2026-02-25 11:43:24');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (53, 15, 0, 0, '', '', 5, 'success', '2026-02-25 11:43:26', 99, 'AI', ' Business analytics', 'presentation_user_15_20260225114326.pptx', '2026-02-25 11:43:26');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (54, 16, 0, 0, '', '', 5, 'success', '2026-02-25 11:49:45', 100, 'AI', 'ai in india', 'presentation_user_16_20260225114944.pptx', '2026-02-25 11:49:45');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (55, 16, 0, 0, '', '', 5, 'success', '2026-02-25 11:49:45', 101, 'AI', 'ai in india', 'presentation_user_16_20260225114944.pptx', '2026-02-25 11:49:45');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (56, 16, 0, 0, '', '', 5, 'success', '2026-02-25 11:50:16', 103, 'AI', 'ai in india', 'presentation_user_16_20260225115016.pptx', '2026-02-25 11:50:16');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (57, 16, 0, 0, '', '', 5, 'success', '2026-02-25 11:50:16', 102, 'AI', 'ai in india', 'presentation_user_16_20260225115016.pptx', '2026-02-25 11:50:16');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (58, 16, 0, 0, '', '', 5, 'success', '2026-02-25 11:52:36', 105, 'AI', 'ai in india and how it is transforming india', 'presentation_user_16_20260225115235.pptx', '2026-02-25 11:52:36');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (59, 16, 0, 0, '', '', 5, 'success', '2026-02-25 11:52:36', 104, 'AI', 'ai in india and how it is transforming india', 'presentation_user_16_20260225115235.pptx', '2026-02-25 11:52:36');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (60, 16, 0, 0, '', '', 7, 'success', '2026-02-25 11:53:08', 106, 'AI', 'ai in indian economy', 'presentation_user_16_20260225115308.pptx', '2026-02-25 11:53:08');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (61, 16, 0, 0, '', '', 7, 'success', '2026-02-25 11:53:09', 107, 'AI', 'ai in indian economy', 'presentation_user_16_20260225115308.pptx', '2026-02-25 11:53:09');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (62, 16, 0, 0, '', '', 5, 'success', '2026-02-25 12:08:42', 109, 'AI', 'types of cybercrimes', 'presentation_user_16_20260225120840.pptx', '2026-02-25 12:08:42');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (63, 16, 0, 0, '', '', 5, 'success', '2026-02-25 12:08:42', 108, 'AI', 'types of cybercrimes', 'presentation_user_16_20260225120840.pptx', '2026-02-25 12:08:42');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (64, 16, 0, 0, '', '', 5, 'success', '2026-02-25 12:20:15', 111, 'AI', 'ai in india', 'presentation_user_16_20260225122013.pptx', '2026-02-25 12:20:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (65, 16, 0, 0, '', '', 5, 'success', '2026-02-25 12:20:15', 110, 'AI', 'ai in india', 'presentation_user_16_20260225122013.pptx', '2026-02-25 12:20:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (66, 17, 0, 0, '', '', 5, 'success', '2026-02-25 12:37:16', 113, 'AI', 'ai in india', 'presentation_user_17_20260225123716.pptx', '2026-02-25 12:37:16');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (67, 17, 0, 0, '', '', 5, 'success', '2026-02-25 12:37:16', 112, 'AI', 'ai in india', 'presentation_user_17_20260225123716.pptx', '2026-02-25 12:37:16');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (68, 1, 0, 0, '', '', 5, 'success', '2026-02-27 21:36:50', 114, 'AI', 'cybercrime', 'presentation_user_1_20260227213649.pptx', '2026-02-27 21:36:50');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (69, 1, 0, 0, '', '', 5, 'success', '2026-02-27 21:36:50', 115, 'AI', 'cybercrime', 'presentation_user_1_20260227213647.pptx', '2026-02-27 21:36:50');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (70, 15, 0, 0, '', '', 10, 'success', '2026-02-27 22:01:20', 116, 'AI', 'Micro greens', 'presentation_user_15_20260227220119.pptx', '2026-02-27 22:01:20');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (71, 1, 0, 0, '', '', 5, 'success', '2026-02-27 23:27:56', 117, 'AI', 'cooking as a passion', 'presentation_user_1_20260227232754.pptx', '2026-02-27 23:27:56');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (72, 1, 0, 0, '', '', 5, 'success', '2026-02-27 23:35:20', 118, 'AI', 'cooking as a passion', 'presentation_user_1_20260227233520.pptx', '2026-02-27 23:35:20');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (73, 1, 0, 0, '', '', 5, 'success', '2026-02-27 23:45:32', 119, 'AI', 'cooking as a passion', 'presentation_user_1_20260227234531.pptx', '2026-02-27 23:45:32');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (74, 1, 0, 0, '', '', 5, 'success', '2026-02-27 23:45:53', 120, 'AI', 'ai in indian economy', 'presentation_user_1_20260227234552.pptx', '2026-02-27 23:45:53');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (75, 1, 0, 0, '', '', 5, 'success', '2026-02-27 23:47:10', 121, 'AI', 'cybercrime', 'presentation_user_1_20260227234709.pptx', '2026-02-27 23:47:10');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (76, 1, 0, 0, '', '', 5, 'success', '2026-02-28 00:24:04', 122, 'AI', 'business tips', 'presentation_user_1_20260228002402.pptx', '2026-02-28 00:24:04');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (77, 1, 0, 0, '', '', 5, 'success', '2026-02-28 00:25:02', 123, 'AI', 'business tips', 'presentation_user_1_20260228002501.pptx', '2026-02-28 00:25:02');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (78, 1, 0, 0, '', '', 5, 'success', '2026-02-28 00:33:24', 124, 'AI', 'cybercrime', 'presentation_user_1_20260228003323.pptx', '2026-02-28 00:33:24');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (79, 1, 0, 0, '', '', 5, 'success', '2026-02-28 00:34:56', 125, 'AI', ' Business analytics along with AI', 'presentation_user_1_20260228003456.pptx', '2026-02-28 00:34:56');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (80, 1, 0, 0, '', '', 5, 'success', '2026-02-28 00:35:41', 126, 'AI', 'business analytics with AI', 'presentation_user_1_20260228003541.pptx', '2026-02-28 00:35:41');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (81, 1, 0, 0, '', '', 5, 'success', '2026-02-28 00:41:37', 127, 'AI', 'ai in indian economy', 'presentation_user_1_20260228004135.pptx', '2026-02-28 00:41:37');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (82, 15, 0, 0, '', '', 5, 'success', '2026-02-28 20:02:16', 128, 'AI', 'cybercrime', 'presentation_user_15_20260228200213.pptx', '2026-02-28 20:02:16');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (83, 1, 0, 0, '', '', 5, 'success', '2026-02-28 20:26:47', 129, 'AI', 'ai in india', 'presentation_user_1_20260228202645.pptx', '2026-02-28 20:26:47');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (84, 1, 0, 0, '', '', 5, 'success', '2026-02-28 20:27:33', 130, 'AI', 'cybercrime', 'presentation_user_1_20260228202732.pptx', '2026-02-28 20:27:33');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (85, 1, 0, 0, '', '', 5, 'success', '2026-03-01 14:37:06', 131, 'AI', 'ai in india', 'presentation_user_1_20260301143703.pptx', '2026-03-01 14:37:06');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (86, 1, 0, 0, '', '', 5, 'success', '2026-03-01 14:38:02', 132, 'AI', 'ai in indian economy', 'presentation_user_1_20260301143801.pptx', '2026-03-01 14:38:02');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (87, 1, 0, 0, '', '', 5, 'success', '2026-03-01 14:47:18', 133, 'AI', 'ai in indian economy', 'presentation_user_1_20260301144717.pptx', '2026-03-01 14:47:18');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (88, 1, 0, 0, '', '', 5, 'success', '2026-03-01 14:47:59', 134, 'AI', 'cybercrime', 'presentation_user_1_20260301144759.pptx', '2026-03-01 14:47:59');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (89, 1, 0, 0, '', '', 5, 'success', '2026-03-01 14:49:14', 135, 'AI', 'cybercrime', 'presentation_user_1_20260301144913.pptx', '2026-03-01 14:49:14');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (90, 1, 0, 0, '', '', 5, 'success', '2026-03-01 14:50:23', 136, 'AI', 'ai in india', 'presentation_user_1_20260301145022.pptx', '2026-03-01 14:50:23');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (91, 1, 0, 0, '', '', 5, 'success', '2026-03-01 15:34:39', 137, 'AI', ' Business analytics', 'presentation_user_1_20260301153437.pptx', '2026-03-01 15:34:39');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (92, 1, 0, 0, '', '', 5, 'success', '2026-03-01 15:35:32', 138, 'AI', 'cooking as a passion', 'presentation_user_1_20260301153532.pptx', '2026-03-01 15:35:32');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (93, 15, 0, 0, '', '', 5, 'success', '2026-03-01 15:57:57', 139, 'AI', 'cooking as a passion', 'presentation_user_15_20260301155756.pptx', '2026-03-01 15:57:57');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (94, 15, 0, 0, '', '', 5, 'success', '2026-03-01 16:29:18', 140, 'AI', ' Business analytics', 'presentation_user_15_20260301162917.pptx', '2026-03-01 16:29:18');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (95, 15, 0, 0, '', '', 5, 'success', '2026-03-01 16:30:53', 141, 'AI', 'cybercrime', 'presentation_user_15_20260301163053.pptx', '2026-03-01 16:30:53');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (96, 15, 0, 0, '', '', 5, 'success', '2026-03-01 17:05:04', 142, 'AI', 'cybercrime', 'presentation_user_15_20260301170502.pptx', '2026-03-01 17:05:04');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (97, 15, 0, 0, '', '', 5, 'success', '2026-03-01 17:06:23', 143, 'AI', 'AI', 'presentation_user_15_20260301170622.pptx', '2026-03-01 17:06:23');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (98, 15, 0, 0, '', '', 5, 'success', '2026-03-01 17:22:25', 144, 'AI', 'ai in indian economy', 'presentation_user_15_20260301172223.pptx', '2026-03-01 17:22:25');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (99, 15, 0, 0, '', '', 5, 'success', '2026-03-01 18:04:32', 145, 'AI', ' Business analytics', 'presentation_user_15_20260301180430.pptx', '2026-03-01 18:04:32');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (100, 1, 0, 0, '', '', 5, 'success', '2026-03-01 18:31:03', 146, 'AI', ' Business analytics', 'presentation_user_1_20260301183103.pptx', '2026-03-01 18:31:03');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (101, 1, 0, 0, '', '', 5, 'success', '2026-03-01 19:47:27', 147, 'AI', 'AI in India', 'presentation_user_1_20260301194725.pptx', '2026-03-01 19:47:27');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (102, 1, 0, 0, '', '', 5, 'success', '2026-03-01 19:48:04', 148, 'AI', 'ai in india', 'presentation_user_1_20260301194804.pptx', '2026-03-01 19:48:04');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (103, 1, 0, 0, '', '', 2, 'success', '2026-03-01 20:14:27', NULL, 'Manual', 'cybercrime', 'manual_presentation_user_1_20260301201426.pptx', '2026-03-01 20:14:27');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (104, 1, 0, 0, '', '', 2, 'success', '2026-03-01 20:14:27', NULL, 'Manual', 'cybercrime', 'manual_presentation_user_1_20260301201426.pptx', '2026-03-01 20:14:27');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (105, 1, 0, 0, '', '', 2, 'success', '2026-03-01 20:16:14', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_1_20260301201614.pptx', '2026-03-01 20:16:14');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (106, 1, 0, 0, '', '', 2, 'success', '2026-03-01 20:16:14', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_1_20260301201614.pptx', '2026-03-01 20:16:14');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (107, 15, 0, 0, '', '', 2, 'success', '2026-03-01 20:45:43', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_15_20260301204542.pptx', '2026-03-01 20:45:43');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (108, 15, 0, 0, '', '', 2, 'success', '2026-03-01 20:45:43', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_15_20260301204542.pptx', '2026-03-01 20:45:43');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (109, 15, 0, 0, '', '', 2, 'success', '2026-03-01 20:46:18', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_15_20260301204618.pptx', '2026-03-01 20:46:18');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (110, 1, 0, 0, '', '', 3, 'success', '2026-03-01 21:00:56', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_1_20260301210055.pptx', '2026-03-01 21:00:56');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (111, 1, 0, 0, '', '', 3, 'success', '2026-03-01 21:00:56', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_1_20260301210055.pptx', '2026-03-01 21:00:56');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (112, 1, 0, 0, '', '', 3, 'success', '2026-03-01 23:19:07', NULL, 'Manual', ' Business analytics', 'manual_presentation_user_1_20260301231906.pptx', '2026-03-01 23:19:07');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (113, 1, 0, 0, '', '', 3, 'success', '2026-03-01 23:19:07', NULL, 'Manual', ' Business analytics', 'manual_presentation_user_1_20260301231906.pptx', '2026-03-01 23:19:07');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (114, 15, 0, 0, '', '', 3, 'success', '2026-03-01 23:28:14', NULL, 'Manual', 'ai in india title', 'manual_presentation_user_15_20260301232813.pptx', '2026-03-01 23:28:14');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (115, 1, 0, 0, '', '', 4, 'success', '2026-03-01 23:41:50', NULL, 'Manual', 'cybercrime', 'manual_presentation_user_1_20260301234148.pptx', '2026-03-01 23:41:50');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (116, 1, 0, 0, '', '', 4, 'success', '2026-03-01 23:52:49', NULL, 'Manual', 'cybercrime', 'manual_presentation_user_1_20260301235248.pptx', '2026-03-01 23:52:49');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (117, 1, 0, 0, '', '', 7, 'success', '2026-03-02 00:15:41', 149, 'AI', 'ai in india', 'presentation_user_1_20260302001540.pptx', '2026-03-02 00:15:41');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (118, 15, 0, 0, '', '', 7, 'success', '2026-03-02 00:32:04', 150, 'AI', 'ai in india', 'presentation_user_15_20260302003203.pptx', '2026-03-02 00:32:04');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (119, 1, 0, 0, '', '', 6, 'success', '2026-03-02 22:46:15', 151, 'AI', 'cybercrime', 'presentation_user_1_20260302224610.pptx', '2026-03-02 22:46:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (120, 1, 0, 0, '', '', 7, 'success', '2026-03-02 22:48:33', 152, 'AI', 'cybercrime', 'presentation_user_1_20260302224832.pptx', '2026-03-02 22:48:33');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (121, 1, 0, 0, '', '', 7, 'success', '2026-03-02 23:39:36', 153, 'AI', 'ai in india', 'presentation_user_1_20260302233934.pptx', '2026-03-02 23:39:36');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (122, 1, 0, 0, '', '', 7, 'success', '2026-03-02 23:47:03', 154, 'AI', 'ai in indian economy', 'presentation_user_1_20260302234702.pptx', '2026-03-02 23:47:03');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (123, 18, 0, 0, '', '', 7, 'success', '2026-03-03 12:56:15', 155, 'AI', 'Machine Learning', 'presentation_user_18_20260303125611.pptx', '2026-03-03 12:56:15');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (124, 18, 0, 0, '', '', 7, 'success', '2026-03-03 12:58:21', 156, 'AI', 'Supervised Learning', 'presentation_user_18_20260303125820.pptx', '2026-03-03 12:58:21');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (125, 18, 0, 0, '', '', 3, 'success', '2026-03-03 13:02:30', NULL, 'Manual', 'ai in india', 'manual_presentation_user_18_20260303130229.pptx', '2026-03-03 13:02:30');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (126, 1, 0, 0, '', '', 7, 'success', '2026-03-04 08:46:48', 157, 'AI', 'Healthcare in India', 'presentation_user_1_20260304084645.pptx', '2026-03-04 08:46:48');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (127, 1, 0, 0, '', '', 7, 'success', '2026-03-04 08:47:17', 158, 'AI', 'Healthcare in India', 'presentation_user_1_20260304084715.pptx', '2026-03-04 08:47:17');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (128, 1, 0, 0, '', '', 7, 'success', '2026-03-04 09:15:55', 159, 'AI', 'cybercrime', 'presentation_user_1_20260304091553.pptx', '2026-03-04 09:15:55');
INSERT INTO tbl_presentations (ppt_id, user_id, content_id, template_id, ppt_filename, ppt_path, slide_count, status, created_at, input_id, presentation_type, topic, filename, updated_at) VALUES (129, 1, 0, 0, '', '', 3, 'success', '2026-03-04 09:18:10', NULL, 'Manual', 'cybercrime', 'manual_presentation_user_1_20260304091809.pptx', '2026-03-04 09:18:10');

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
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `template_type` varchar(20) NOT NULL,
  `available_for` varchar(20) DEFAULT 'both',
  `description` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `pptx_filename` varchar(255) DEFAULT NULL,
  `color_scheme_id` int(11) DEFAULT NULL,
  `font_id` int(11) DEFAULT NULL,
  `background_id` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_default` tinyint(1) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (1, 'Cosmic Dark', 'ai', 'both', 'Space themed with premium glow effects', NULL, NULL, 1, 1, 1, 1, 1, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (2, 'Ocean Blue', 'ai', 'both', 'Clean corporate gradient style', NULL, NULL, 2, 1, 2, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (3, 'Neon Purple', 'ai', 'both', 'Futuristic neon highlights', NULL, NULL, 3, 1, 3, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (4, 'Minimal Light', 'ai', 'both', 'Simple bright business layout', NULL, NULL, 4, 1, 4, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (5, 'Corporate Pro', 'ai', 'both', 'Professional blue-toned corporate', NULL, NULL, 5, 1, 5, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (6, 'Elegant Dark', 'ai', 'both', 'Sophisticated dark with gold accents', NULL, NULL, 6, 1, 6, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (7, 'Tech Modern', 'ai', 'both', 'Sleek tech-focused design', NULL, NULL, 7, 1, 7, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (8, 'Nature Fresh', 'ai', 'both', 'Clean green-themed design', NULL, NULL, 8, 1, 8, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (9, 'Creative Colorful', 'ai', 'both', 'Vibrant multi-colored style', NULL, NULL, 9, 1, 9, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (10, 'Sunset Glow', 'ai', 'both', 'Warm sunset colors', NULL, NULL, 10, 1, 10, 1, 0, NULL, '2026-02-27 23:24:19', '2026-03-01 23:59:38');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (11, 'Arctic Ice', 'ai', 'both', 'Cool refreshing tones', NULL, NULL, 11, 1, 11, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (12, 'Midnight Express', 'ai', 'both', 'Dark night sleek theme', NULL, NULL, 12, 1, 12, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (13, 'Royal Purple', 'ai', 'both', 'Luxurious purple tones', NULL, NULL, 13, 1, 13, 1, 0, NULL, '2026-02-27 23:24:19', '2026-02-27 23:24:19');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (14, 'test', 'ai', 'both', 'test', '/theme_uploads/369436ee83074839b0eb6fd7477f8851_download (4).jpg', NULL, 13, 8, 4, 1, 0, 0, '2026-02-27 23:26:14', '2026-02-27 23:26:25');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (15, 'test forest', 'manual', 'both', 'forst and greenish', '/theme_uploads/3247a26b047a4180a4f315ae1a0a1b85_pngtree-watercolor-leafy-green-serenity-ppt-background-image_17425782.jpg', NULL, 8, 3, 4, 1, 0, 0, '2026-03-02 00:04:13', '2026-03-02 00:04:13');
INSERT INTO tbl_templates (id, name, template_type, available_for, description, thumbnail, pptx_filename, color_scheme_id, font_id, background_id, is_active, is_default, created_by, created_at, updated_at) VALUES (16, 'Trial', 'ai', 'both', 'testing template', '/theme_uploads/d31f3f855fc845e99dcbf47718edcc4a_shapelined-_JBKdviweXI-unsplash.jpg', NULL, 2, 8, 14, 1, 0, 0, '2026-03-04 08:45:45', '2026-03-04 08:45:45');

