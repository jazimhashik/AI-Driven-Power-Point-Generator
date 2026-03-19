-- Admin Database Tables Setup Script
-- Run this script in XAMPP phpMyAdmin (localhost/phpmyadmin)
-- Database: ai_ppt_generator

-- Select database first
USE ai_ppt_generator;

-- ============================================
-- AUDIT LOG TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    status VARCHAR(20) DEFAULT 'success',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- PRESENTATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_presentations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    input_id INT,
    presentation_type VARCHAR(20) NOT NULL,
    topic VARCHAR(255),
    slide_count INT DEFAULT 0,
    filename VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'success',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_type (presentation_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- ADMIN PROFILE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_admin_profile (
    id INT AUTO_INCREMENT PRIMARY KEY,
    login_id INT NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    department VARCHAR(50),
    permissions JSON,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (login_id) REFERENCES tbl_login(login_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- SYSTEM SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(20) DEFAULT 'string',
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- BACKUP LOG TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_backup_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    backup_type VARCHAR(20) NOT NULL,
    filename VARCHAR(255) NOT NULL,
    file_size BIGINT,
    status VARCHAR(20) DEFAULT 'success',
    error_message TEXT,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- INSERT DEFAULT SETTINGS
-- ============================================
INSERT IGNORE INTO tbl_system_settings (setting_key, setting_value, setting_type, description) VALUES
('site_name', 'Cosmic AI PPT Generator', 'string', 'The name of the website'),
('admin_email', 'admin@cosmicai.com', 'email', 'Admin contact email'),
('max_slides_per_presentation', '20', 'integer', 'Maximum number of slides allowed per presentation'),
('default_slides', '5', 'integer', 'Default number of slides for AI generation'),
('session_timeout', '30', 'integer', 'Session timeout in minutes'),
('max_login_attempts', '5', 'integer', 'Maximum failed login attempts before lockout'),
('enable_2fa', 'false', 'boolean', 'Enable two-factor authentication'),
('enable_email_notifications', 'true', 'boolean', 'Enable email notifications'),
('enable_error_alerts', 'true', 'boolean', 'Enable error alerts'),
('enable_weekly_reports', 'false', 'boolean', 'Enable weekly reports'),
('ai_model', 'GPT-4', 'string', 'AI model to use for generation'),
('daily_ppt_limit', '10', 'integer', 'Maximum number of PPTs a user can generate per day');

-- ============================================
-- TEMPLATES TABLE (Presentation Templates)
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_templates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    template_type VARCHAR(20) NOT NULL COMMENT 'ai or manual',
    available_for VARCHAR(20) DEFAULT 'both' COMMENT 'ai, manual, or both',
    description VARCHAR(255),
    thumbnail VARCHAR(255),
    pptx_filename VARCHAR(255),
    color_scheme_id INT,
    font_id INT,
    background_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    is_default BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_type (template_type),
    INDEX idx_active (is_active),
    INDEX idx_available (available_for),
    FOREIGN KEY (color_scheme_id) REFERENCES tbl_color_schemes(id) ON DELETE SET NULL,
    FOREIGN KEY (font_id) REFERENCES tbl_fonts(id) ON DELETE SET NULL,
    FOREIGN KEY (background_id) REFERENCES tbl_backgrounds(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- FONTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_fonts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    display_name VARCHAR(100) NOT NULL,
    font_family VARCHAR(255) NOT NULL,
    font_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    is_default BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- COLOR SCHEMES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_color_schemes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    primary_color VARCHAR(20) NOT NULL,
    secondary_color VARCHAR(20),
    accent_color VARCHAR(20),
    background_color VARCHAR(20),
    text_color VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    is_default BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- BACKGROUNDS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS tbl_backgrounds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    background_type VARCHAR(20) NOT NULL COMMENT 'image, gradient, solid',
    image_url VARCHAR(255),
    gradient_colors JSON,
    solid_color VARCHAR(20),
    thumbnail VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    is_default BOOLEAN DEFAULT FALSE,
    created_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_type (background_type),
    INDEX idx_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- INSERT DEFAULT DATA
-- ============================================

-- Default Templates
INSERT IGNORE INTO tbl_templates (id, name, template_type, description, is_active, is_default) VALUES
(1, 'Professional Blue', 'ai', 'Clean blue professional template', 1, 1),
(2, 'Modern Dark', 'ai', 'Modern dark theme', 1, 0),
(3, 'Creative Orange', 'ai', 'Creative orange accent', 1, 0),
(4, 'Classic White', 'manual', 'Classic white background', 1, 1),
(5, 'Elegant Gray', 'manual', 'Elegant gray theme', 1, 0);

-- Default Fonts
INSERT IGNORE INTO tbl_fonts (id, name, display_name, font_family, is_active, is_default) VALUES
(1, 'Arial', 'Arial', 'Arial, sans-serif', 1, 1),
(2, 'Roboto', 'Roboto', 'Roboto, sans-serif', 1, 0),
(3, 'Open Sans', 'Open Sans', 'Open Sans, sans-serif', 1, 0),
(4, 'Montserrat', 'Montserrat', 'Montserrat, sans-serif', 1, 0),
(5, 'Playfair Display', 'Playfair Display', 'Playfair Display, serif', 1, 0);

-- Default Color Schemes
INSERT IGNORE INTO tbl_color_schemes (id, name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default) VALUES
(1, 'Ocean Blue', '#007bff', '#0056b3', '#00d4ff', '#ffffff', '#333333', 1, 1),
(2, 'Forest Green', '#28a745', '#1e7e34', '#20c997', '#ffffff', '#333333', 1, 0),
(3, 'Sunset Orange', '#fd7e14', '#dc6502', '#ffbe0b', '#ffffff', '#333333', 1, 0),
(4, 'Royal Purple', '#6f42c1', '#4a2c81', '#e0aaff', '#ffffff', '#333333', 1, 0),
(5, 'Dark Mode', '#1a1a2e', '#16213e', '#0f3460', '#0f0f0f', '#ffffff', 1, 0);

-- Default Backgrounds
INSERT IGNORE INTO tbl_backgrounds (id, name, background_type, solid_color, gradient_colors, is_active, is_default) VALUES
(1, 'White', 'solid', '#ffffff', NULL, 1, 1),
(2, 'Light Gray', 'solid', '#f8f9fa', NULL, 1, 0),
(3, 'Dark Navy', 'solid', '#1a1a2e', NULL, 1, 0),
(4, 'Soft Blue', 'gradient', NULL, '#e0f7fa,#80deea', 1, 0),
(5, 'Warm Sunset', 'gradient', NULL, '#ffecd2,#fcb69f', 1, 0);

-- ============================================
-- Migration: Add new columns to existing tables
-- ============================================

-- Add columns to tbl_templates if they don't exist
ALTER TABLE tbl_templates ADD COLUMN IF NOT EXISTS available_for VARCHAR(20) DEFAULT 'both' COMMENT 'ai, manual, or both';
ALTER TABLE tbl_templates ADD COLUMN IF NOT EXISTS color_scheme_id INT;
ALTER TABLE tbl_templates ADD COLUMN IF NOT EXISTS font_id INT;
ALTER TABLE tbl_templates ADD COLUMN IF NOT EXISTS background_id INT;

-- Add foreign keys if they don't exist
-- Note: These may fail if foreign key checks are disabled, which is fine
-- ALTER TABLE tbl_templates ADD CONSTRAINT IF NOT EXISTS fk_template_color FOREIGN KEY (color_scheme_id) REFERENCES tbl_color_schemes(id) ON DELETE SET NULL;
-- ALTER TABLE tbl_templates ADD CONSTRAINT IF NOT EXISTS fk_template_font FOREIGN KEY (font_id) REFERENCES tbl_fonts(id) ON DELETE SET NULL;
-- ALTER TABLE tbl_templates ADD CONSTRAINT IF NOT EXISTS fk_template_bg FOREIGN KEY (background_id) REFERENCES tbl_backgrounds(id) ON DELETE SET NULL;

-- Update default templates to use default color scheme
UPDATE IGNORE tbl_templates SET color_scheme_id = 1 WHERE color_scheme_id IS NULL AND template_type = 'ai';
UPDATE IGNORE tbl_templates SET color_scheme_id = 5 WHERE color_scheme_id IS NULL AND template_type = 'manual';
UPDATE IGNORE tbl_templates SET available_for = 'both' WHERE available_for IS NULL;

-- ============================================
-- UPDATE EXISTING ADMIN USER OR CREATE NEW
-- ============================================

-- Option 1: If admin user already exists (update role to admin)
UPDATE tbl_login SET role = 'admin' WHERE username = 'admin';

-- Option 2: If no admin user exists, create one
-- Note: Replace 'admin123' with your desired password hash
-- To generate hash, run in Python: from werkzeug.security import generate_password_hash; print(generate_password_hash('admin123'))

-- INSERT INTO tbl_login (username, email, password_hash, role, status) 
-- VALUES ('admin', 'admin@cosmicai.com', 'YOUR_PASSWORD_HASH_HERE', 'admin', 1);

-- ============================================
-- CREATE ADMIN PROFILE
-- ============================================

-- Insert admin profile (update login_id to match your admin user)
-- First find the admin login_id:
-- SELECT login_id FROM tbl_login WHERE username = 'admin';

-- INSERT INTO tbl_admin_profile (login_id, full_name, phone, department, permissions)
-- VALUES (1, 'System Administrator', '', 'Administration', '{"all": true}');
