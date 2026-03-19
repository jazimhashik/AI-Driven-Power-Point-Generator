"""
Admin Database Setup Script for XAMPP
Run this script to initialize the admin-related database tables.
"""

import mysql.connector
import os

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",  # XAMPP default has no password
        database="ai_ppt_generator"
    )

def create_admin_tables():
    """Create all admin-related tables"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Add status column to tbl_login if it doesn't exist
    try:
        cursor.execute("ALTER TABLE tbl_login ADD COLUMN status INT DEFAULT 1")
        print("Added status column to tbl_login")
    except Exception as e:
        print(f"Status column check/creation: {e}")
    
    # Create audit log table
    cursor.execute("""
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    """)
    print("tbl_audit_log table created")
    
    # Drop invalid foreign key constraints if they exist
    foreign_keys_to_drop = ["fk_ppt_content", "fk_ppt_template"]
    for fk_name in foreign_keys_to_drop:
        try:
            cursor.execute(f"ALTER TABLE tbl_presentations DROP FOREIGN KEY {fk_name}")
            print(f"Dropped invalid foreign key constraint {fk_name}")
        except Exception as e:
            print(f"Foreign key {fk_name} check: {e}")
    
    # Drop invalid indexes if they exist
    indexes_to_drop = ["idx_content_id", "idx_template_id"]
    for idx_name in indexes_to_drop:
        try:
            cursor.execute(f"ALTER TABLE tbl_presentations DROP INDEX {idx_name}")
            print(f"Dropped invalid index {idx_name}")
        except Exception as e:
            print(f"Index {idx_name} check: {e}")
    
    # Add all missing columns to tbl_presentations
    columns_to_add = [
        ("input_id", "INT"),
        ("presentation_type", "VARCHAR(20) NOT NULL DEFAULT 'AI'"),
        ("topic", "VARCHAR(255)"),
        ("slide_count", "INT DEFAULT 0"),
        ("filename", "VARCHAR(255) NOT NULL"),
        ("status", "VARCHAR(20) DEFAULT 'success'"),
        ("created_at", "DATETIME DEFAULT CURRENT_TIMESTAMP"),
        ("updated_at", "DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"),
    ]
    
    for col_name, col_type in columns_to_add:
        try:
            cursor.execute(f"ALTER TABLE tbl_presentations ADD COLUMN {col_name} {col_type}")
            print(f"Added {col_name} column to tbl_presentations")
        except Exception as e:
            print(f"{col_name} column check/creation: {e}")
    
    # Create presentations table (for new installs)
    cursor.execute("""
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    """)
    print("tbl_presentations table created or verified")
    
    # Create admin profile table
    cursor.execute("""
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    """)
    print("tbl_admin_profile table created")
    
    # Create settings table for configuration
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS tbl_system_settings (
            id INT AUTO_INCREMENT PRIMARY KEY,
            setting_key VARCHAR(100) UNIQUE NOT NULL,
            setting_value TEXT,
            setting_type VARCHAR(20) DEFAULT 'string',
            description VARCHAR(255),
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    """)
    print("tbl_system_settings table created")
    
    # Create backup logs table
    cursor.execute("""
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
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    """)
    print("tbl_backup_log table created")
    
    conn.commit()
    cursor.close()
    conn.close()
    print("\nAll admin tables created successfully!")

def create_admin_user():
    """Create the admin user in tbl_login"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Check if admin already exists
    cursor.execute("SELECT * FROM tbl_login WHERE username = %s", ("admin",))
    admin = cursor.fetchone()
    
    if admin:
        # Update existing user to admin role
        cursor.execute("UPDATE tbl_login SET role = 'admin' WHERE username = 'admin'")
        conn.commit()
        print(f"Admin user updated! (ID: {admin['login_id']})")
        admin_id = admin['login_id']
    else:
        from werkzeug.security import generate_password_hash
        
        # Create admin user
        password_hash = generate_password_hash("admin123")
        cursor.execute(
            """
            INSERT INTO tbl_login (username, email, password_hash, role, status)
            VALUES (%s, %s, %s, %s, %s)
            """,
            ("admin", "admin@cosmicai.com", password_hash, "admin", 1)
        )
        admin_id = cursor.lastrowid
        print(f"Admin user created! (ID: {admin_id})")
    
    # Check if admin profile exists
    cursor.execute("SELECT * FROM tbl_admin_profile WHERE login_id = %s", (admin_id,))
    profile = cursor.fetchone()
    
    if not profile:
        cursor.execute(
            """
            INSERT INTO tbl_admin_profile (login_id, full_name, phone, department, permissions)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (admin_id, "System Administrator", "", "Administration", '{"all": true}')
        )
        conn.commit()
        print("Admin profile created!")
    
    cursor.close()
    conn.close()

def insert_default_settings():
    """Insert default system settings"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    default_settings = [
        ("site_name", "Cosmic AI PPT Generator", "string", "The name of the website"),
        ("admin_email", "admin@cosmicai.com", "email", "Admin contact email"),
        ("max_slides_per_presentation", "20", "integer", "Maximum number of slides allowed per presentation"),
        ("default_slides", "5", "integer", "Default number of slides for AI generation"),
        ("session_timeout", "30", "integer", "Session timeout in minutes"),
        ("max_login_attempts", "5", "integer", "Maximum failed login attempts before lockout"),
        ("enable_2fa", "false", "boolean", "Enable two-factor authentication"),
        ("enable_email_notifications", "true", "boolean", "Enable email notifications"),
        ("enable_error_alerts", "true", "boolean", "Enable error alerts"),
        ("enable_weekly_reports", "false", "boolean", "Enable weekly reports"),
        ("ai_model", "GPT-4", "string", "AI model to use for generation"),
    ]
    
    for setting in default_settings:
        cursor.execute(
            """
            INSERT IGNORE INTO tbl_system_settings (setting_key, setting_value, setting_type, description)
            VALUES (%s, %s, %s, %s)
            """,
            setting
        )
    
    conn.commit()
    cursor.close()
    conn.close()
    print("Default settings inserted")

def run_setup():
    """Run all setup functions"""
    print("=" * 50)
    print("Admin Database Setup (XAMPP)")
    print("=" * 50)
    print()
    
    try:
        create_admin_tables()
        create_admin_user()
        insert_default_settings()
        
        print()
        print("=" * 50)
        print("Setup Complete!")
        print("=" * 50)
        print()
        print("Admin Login Credentials:")
        print("  URL: http://localhost:5000/admin/login")
        print("  Username: admin")
        print("  Password: admin123")
        print()
        
    except mysql.connector.Error as e:
        print(f"Database error: {e}")
        print("\nMake sure XAMPP MySQL is running and the database 'ai_ppt_generator' exists.")
        print("\nTo create the database in XAMPP phpMyAdmin:")
        print("1. Open http://localhost/phpmyadmin")
        print("2. Click 'New' to create database")
        print("3. Enter 'ai_ppt_generator' as name")
        print("4. Click 'Create'")
        print("5. Then run this script again")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    run_setup()
