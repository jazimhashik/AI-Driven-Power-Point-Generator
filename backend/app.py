print(">>> COSMIC AI is now running. <<<")

import os
import json
import datetime
import mysql.connector
from flask import (
    Flask,
    request,
    send_from_directory,
    redirect,
    url_for,
    session,
    render_template,
    jsonify
)
from werkzeug.security import generate_password_hash, check_password_hash

# AI + PPT
from ai_engine import generate_ppt_content
from ppt_generator import create_ppt

# Spire Presentation
from spire.presentation import Presentation
import psutil


# -------------------------------------------------
# APP SETUP
# -------------------------------------------------

app = Flask(__name__)
app.secret_key = "secret-key-for-session"

# -------------------------------------------------
# DATABASE CONNECTION
# -------------------------------------------------

def get_db_connection():
    """Get database connection"""
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="ai_ppt_generator",
        connection_timeout=10
    )

# -------------------------------------------------
# DATABASE MIGRATION - Add missing columns if needed
# -------------------------------------------------

def run_migrations():
    """Run database migrations to ensure tables have required columns"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if tbl_custdetails has login_id column
        cursor.execute("SHOW COLUMNS FROM tbl_custdetails LIKE 'login_id'")
        result = cursor.fetchone()
        
        if not result:
            print("Adding login_id column to tbl_custdetails...")
            # Try to add the column after cust_id (the primary key)
            try:
                cursor.execute("ALTER TABLE tbl_custdetails ADD COLUMN login_id INT AFTER cust_id")
                cursor.execute("ALTER TABLE tbl_custdetails ADD FOREIGN KEY (login_id) REFERENCES tbl_login(login_id) ON DELETE CASCADE")
                conn.commit()
                print("Successfully added login_id column to tbl_custdetails")
            except Exception as e:
                print(f"Could not add login_id column: {e}")
                # Check if column already exists (may have been added in previous attempt)
                cursor.execute("SHOW COLUMNS FROM tbl_custdetails LIKE 'login_id'")
                if cursor.fetchone():
                    print("login_id column already exists, trying to update records...")
                    try:
                        cursor.execute("""
                            UPDATE tbl_custdetails c
                            INNER JOIN tbl_login l ON c.email = l.email
                            SET c.login_id = l.login_id
                            WHERE c.login_id IS NULL OR c.login_id = 0
                        """)
                        conn.commit()
                        print("Updated existing records with login_id based on email")
                    except Exception as e2:
                        print(f"Could not update existing records: {e2}")
                else:
                    # Try to update existing records by matching email anyway
                    try:
                        cursor.execute("""
                            UPDATE tbl_custdetails c
                            INNER JOIN tbl_login l ON c.email = l.email
                            SET c.login_id = l.login_id
                            WHERE c.login_id IS NULL OR c.login_id = 0
                        """)
                        conn.commit()
                        print("Updated existing records with login_id based on email")
                    except Exception as e2:
                        print(f"Could not update existing records: {e2}")
        
        # Ensure tbl_templates has available_for column
        try:
            cursor.execute("SHOW TABLES LIKE 'tbl_templates'")
            if cursor.fetchone():
                cursor.execute("SHOW COLUMNS FROM tbl_templates LIKE 'available_for'")
                if not cursor.fetchone():
                    print("Adding available_for column to tbl_templates...")
                    cursor.execute("ALTER TABLE tbl_templates ADD COLUMN available_for VARCHAR(20) DEFAULT 'both'")
                    conn.commit()
                    print("Successfully added available_for column")
        except Exception as e:
            print(f"Could not add available_for column: {e}")
        
        # Ensure tbl_presentations has is_flagged and flag_reason columns for content moderation
        try:
            cursor.execute("SHOW TABLES LIKE 'tbl_presentations'")
            if cursor.fetchone():
                cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_flagged'")
                if not cursor.fetchone():
                    print("Adding content moderation columns to tbl_presentations...")
                    cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN is_flagged BOOLEAN DEFAULT FALSE")
                    cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN flag_reason TEXT DEFAULT NULL")
                    conn.commit()
                    print("Successfully added content moderation columns")
                
                # Add review columns if not present
                cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_reviewed'")
                if not cursor.fetchone():
                    print("Adding review tracking columns to tbl_presentations...")
                    cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN is_reviewed BOOLEAN DEFAULT FALSE")
                    cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN reviewed_by VARCHAR(100) DEFAULT NULL")
                    cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN reviewed_at DATETIME DEFAULT NULL")
                    conn.commit()
                    print("Successfully added review tracking columns")
        except Exception as e:
            print(f"Could not add content moderation columns: {e}")
        
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Migration error: {e}")

# Run migrations on startup
try:
    run_migrations()
except Exception as e:
    print(f"Failed to run migrations: {e}")

FRONTEND_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "frontend")
)

# -------------------------------------------------
# PREVIEW IMAGE FOLDER
# -------------------------------------------------

PREVIEW_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "generated_previews")
)
os.makedirs(PREVIEW_DIR, exist_ok=True)

GENERATED_PPTS_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "generated_ppts")
)
os.makedirs(GENERATED_PPTS_DIR, exist_ok=True)

# -------------------------------------------------
# FAVICON ROUTE (to avoid 404 errors)
# -------------------------------------------------

@app.route('/favicon.ico')
def favicon():
    return '', 204  # Return empty response with no content

# -------------------------------------------------
# HELPER FUNCTIONS
# -------------------------------------------------

def log_audit_action(user_id, action, details, status="success"):
    """Log an action to the audit trail"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO tbl_audit_log (user_id, action, details, ip_address, status, created_at)
            VALUES (%s, %s, %s, %s, %s, NOW())
            """,
            (user_id, action, details, request.remote_addr if request else None, status)
        )
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Audit log error: {e}")

def is_admin():
    """Check if current user is admin"""
    return session.get("role") == "admin"

def admin_required():
    """Decorator to require admin access"""
    if "user_id" not in session:
        return redirect(url_for("admin_login"))
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    return None

# -------------------------------------------------
# CONTENT MODERATION
# -------------------------------------------------

# Keywords and patterns for detecting harmful/illegal/threatening content
FLAGGED_CATEGORIES = {
    "violence": [
        "how to kill", "how to murder", "assassination", "mass shooting", "bomb making",
        "make a bomb", "build a bomb", "create a weapon", "how to attack", "school shooting",
        "how to poison", "planning attack", "violent attack", "commit murder", "hire hitman",
        "terrorist attack", "suicide bombing", "how to stab", "how to shoot", "gun violence",
        "mass murder", "genocide", "ethnic cleansing"
    ],
    "terrorism": [
        "terrorist", "terrorism", "isis", "al qaeda", "jihad", "radicalization",
        "extremism", "extremist propaganda", "recruitment for terror", "terror cell",
        "bioterrorism", "cyberterrorism", "bomb threat", "hostage taking"
    ],
    "illegal_activities": [
        "how to hack", "hacking tutorial", "steal identity", "identity theft",
        "drug manufacturing", "how to make drugs", "cook meth", "drug trafficking",
        "money laundering", "counterfeit money", "forge documents", "human trafficking",
        "child exploitation", "child abuse", "blackmail", "extortion", "fraud scheme",
        "ponzi scheme", "tax evasion guide", "smuggling", "how to steal",
        "illegal weapons", "arms dealing"
    ],
    "hate_speech": [
        "white supremacy", "racial superiority", "hate speech", "anti-semitic",
        "neo nazi", "white power", "racial genocide", "ethnic hatred",
        "islamophobia propaganda", "homophobia propaganda", "sexist propaganda",
        "promoting hatred", "incite violence"
    ],
    "self_harm": [
        "how to commit suicide", "suicide methods", "self harm", "kill myself",
        "end my life", "methods of suicide", "painless death"
    ],
    "threats": [
        "death threat", "i will kill", "going to kill", "threatening to harm",
        "destroy you", "burn it down", "blow up", "shoot up"
    ]
}

def check_content_safety(text):
    """
    Check if the provided text contains harmful, illegal, or threatening content.
    Returns a tuple: (is_flagged: bool, reasons: list of str)
    """
    if not text:
        return False, []
    
    text_lower = text.lower()
    flagged_reasons = []
    
    for category, keywords in FLAGGED_CATEGORIES.items():
        for keyword in keywords:
            if keyword in text_lower:
                reason = f"{category.replace('_', ' ').title()}: matched '{keyword}'"
                if reason not in flagged_reasons:
                    flagged_reasons.append(reason)
    
    is_flagged = len(flagged_reasons) > 0
    return is_flagged, flagged_reasons

# -------------------------------------------------
# SLIDE PREVIEW GENERATOR
# -------------------------------------------------

def generate_slide_previews(ppt_path, ppt_filename):
    try:
        ppt_folder = os.path.splitext(ppt_filename)[0]
        output_folder = os.path.join(PREVIEW_DIR, ppt_folder)
        os.makedirs(output_folder, exist_ok=True)

        presentation = Presentation()
        presentation.LoadFromFile(ppt_path)

        preview_urls = []

        for i, slide in enumerate(presentation.Slides):
            img = slide.SaveAsImage()
            img_path = os.path.join(output_folder, f"slide_{i + 1}.png")

            img.Save(img_path)
            img.Dispose()

            preview_urls.append(
                f"/generated_previews/{ppt_folder}/slide_{i + 1}.png"
            )

        presentation.Dispose()
        return preview_urls

    except Exception as e:
        print("❌ Preview generation error:", e)
        return []

# -------------------------------------------------
# HOME / WELCOME
# -------------------------------------------------

@app.route("/")
@app.route("/welcome")
def welcome():
    return send_from_directory(FRONTEND_DIR, "welcome.html")

@app.route("/user-choice")
def user_choice():
    return send_from_directory(FRONTEND_DIR, "user_choice.html")

# -------------------------------------------------
# ADMIN LOGIN
# -------------------------------------------------

@app.route("/admin/login", methods=["GET", "POST"])
def admin_login():
    # Redirect to unified login page
    return redirect(url_for("login"))

@app.route("/admin")
def admin():
    """Redirect to admin dashboard"""
    return redirect(url_for("admin_dashboard"))

# -------------------------------------------------
# ADMIN DASHBOARD
# -------------------------------------------------

@app.route("/admin/api/system-health")
def admin_api_system_health():
    """Get real-time system health metrics"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    cpu_percent = psutil.cpu_percent(interval=0.3)
    mem = psutil.virtual_memory()
    disk = psutil.disk_usage('/')
    
    # Network I/O
    net = psutil.net_io_counters()
    
    # Process count
    process_count = len(psutil.pids())
    
    # Boot time / uptime
    boot_time = datetime.datetime.fromtimestamp(psutil.boot_time())
    uptime_seconds = (datetime.datetime.now() - boot_time).total_seconds()
    days = int(uptime_seconds // 86400)
    hours = int((uptime_seconds % 86400) // 3600)
    minutes = int((uptime_seconds % 3600) // 60)
    uptime_str = f"{days}d {hours}h {minutes}m"
    
    return jsonify({
        "cpu_percent": cpu_percent,
        "cpu_count": psutil.cpu_count(),
        "cpu_freq": round(psutil.cpu_freq().current, 0) if psutil.cpu_freq() else 0,
        "memory_percent": mem.percent,
        "memory_used_gb": round(mem.used / (1024**3), 2),
        "memory_total_gb": round(mem.total / (1024**3), 2),
        "disk_percent": disk.percent,
        "disk_used_gb": round(disk.used / (1024**3), 2),
        "disk_total_gb": round(disk.total / (1024**3), 2),
        "net_sent_mb": round(net.bytes_sent / (1024**2), 2),
        "net_recv_mb": round(net.bytes_recv / (1024**2), 2),
        "process_count": process_count,
        "uptime": uptime_str
    })

@app.route("/admin/dashboard")
def admin_dashboard():
    """Admin dashboard main page"""
    auth_check = admin_required()
    if auth_check:
        return auth_check
    
    return send_from_directory(FRONTEND_DIR, "admin_dashboard.html")

# -------------------------------------------------
# ADMIN API ENDPOINTS
# -------------------------------------------------

@app.route("/admin/api/stats")
def admin_api_stats():
    """Get dashboard statistics"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Total users
    cursor.execute("SELECT COUNT(*) as count FROM tbl_login WHERE role = 'customer'")
    total_users = cursor.fetchone()["count"]
    
    # Total presentations
    cursor.execute("SELECT COUNT(*) as count FROM tbl_presentations")
    total_presentations = cursor.fetchone()["count"]
    
    # Storage used (approximate)
    ppt_dir = GENERATED_PPTS_DIR
    total_size = 0
    if os.path.exists(ppt_dir):
        for f in os.listdir(ppt_dir):
            fp = os.path.join(ppt_dir, f)
            total_size += os.path.getsize(fp)
    storage_mb = round(total_size / (1024 * 1024), 2)
    
    # Recent errors (last 24h)
    cursor.execute("SELECT COUNT(*) as count FROM tbl_audit_log WHERE status = 'error' AND created_at > DATE_SUB(NOW(), INTERVAL 24 HOUR)")
    error_count = cursor.fetchone()["count"]
    
    # Flagged content count (unreviewed)
    flagged_count = 0
    try:
        cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_flagged'")
        if cursor.fetchone():
            cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_reviewed'")
            has_review = cursor.fetchone() is not None
            if has_review:
                cursor.execute("SELECT COUNT(*) as count FROM tbl_presentations WHERE is_flagged = TRUE AND (is_reviewed = FALSE OR is_reviewed IS NULL)")
            else:
                cursor.execute("SELECT COUNT(*) as count FROM tbl_presentations WHERE is_flagged = TRUE")
            flagged_count = cursor.fetchone()["count"]
    except:
        pass
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "total_users": total_users,
        "total_presentations": total_presentations,
        "storage_used": f"{storage_mb} MB",
        "error_count": error_count,
        "flagged_count": flagged_count
    })

@app.route("/admin/api/recent-activities")
def admin_api_activities():
    """Get recent activities"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT a.action, a.details, a.created_at, COALESCE(l.username, 'System') as username 
        FROM tbl_audit_log a
        LEFT JOIN tbl_login l ON a.user_id = l.login_id
        ORDER BY a.created_at DESC 
        LIMIT 10
    """)
    
    activities = []
    for row in cursor.fetchall():
        # Calculate time ago
        time_diff = datetime.datetime.now() - row["created_at"]
        minutes = int(time_diff.total_seconds() / 60)
        if minutes < 60:
            time_ago = f"{minutes} min ago"
        elif minutes < 1440:
            time_ago = f"{int(minutes / 60)} hours ago"
        else:
            time_ago = f"{int(minutes / 1440)} days ago"
        
        activities.append({
            "user": row["username"] or "System",
            "action": row["action"],
            "time": time_ago
        })
    
    cursor.close()
    conn.close()
    
    return jsonify(activities)

@app.route("/admin/api/generation-logs")
def admin_api_logs():
    """Get generation logs with optional filtering"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    # Get filter parameters
    filter_type = request.args.get("type", "")
    filter_status = request.args.get("status", "")
    filter_flagged = request.args.get("flagged", "")
    date_from = request.args.get("date_from", "")
    date_to = request.args.get("date_to", "")
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # Check if is_flagged column exists
        has_flag_col = False
        has_review_col = False
        try:
            cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_flagged'")
            has_flag_col = cursor.fetchone() is not None
            cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_reviewed'")
            has_review_col = cursor.fetchone() is not None
        except:
            pass
        
        # Use ppt_id as that's what the database has
        flag_cols = ", p.is_flagged, p.flag_reason" if has_flag_col else ""
        review_cols = ", p.is_reviewed, p.reviewed_by, p.reviewed_at" if has_review_col else ""
        query = f"""
            SELECT p.ppt_id, p.created_at, p.updated_at, p.presentation_type, p.topic, p.slide_count, p.status, p.filename, l.username{flag_cols}{review_cols}
            FROM tbl_presentations p
            LEFT JOIN tbl_login l ON p.user_id = l.login_id
            WHERE 1=1
        """
        params = []
        
        if filter_type:
            query += " AND p.presentation_type = %s"
            params.append(filter_type)
        
        if filter_status:
            query += " AND p.status = %s"
            params.append(filter_status)
        
        if date_from:
            query += " AND DATE(p.created_at) >= %s"
            params.append(date_from)
        
        if date_to:
            query += " AND DATE(p.created_at) <= %s"
            params.append(date_to)
        
        query += " ORDER BY p.created_at DESC LIMIT 100"
        
        cursor.execute(query, params)
        
        logs = []
        for row in cursor.fetchall():
            # Format timestamp safely
            timestamp = "N/A"
            if row.get("created_at"):
                try:
                    timestamp = row["created_at"].strftime("%Y-%m-%d %H:%M:%S")
                except:
                    timestamp = str(row["created_at"])
            
            # Calculate generation duration if available
            duration = "N/A"
            if row.get("updated_at") and row.get("created_at"):
                try:
                    diff = (row["updated_at"] - row["created_at"]).total_seconds()
                    duration = f"{diff:.1f}s"
                except:
                    pass
            
            # Check if the file actually exists on disk
            fname = row.get("filename") or ""
            file_exists = False
            if fname:
                file_exists = os.path.exists(os.path.join(GENERATED_PPTS_DIR, fname))
            
            logs.append({
                "ppt_id": row.get("ppt_id"),
                "timestamp": timestamp,
                "user": row.get("username") or "Unknown",
                "type": row.get("presentation_type") or "N/A",
                "topic": row.get("topic") or "Untitled",
                "slides": row.get("slide_count") or 0,
                "status": row.get("status") or "unknown",
                "duration": duration,
                "filename": fname,
                "file_exists": file_exists,
                "is_flagged": bool(row.get("is_flagged")) if has_flag_col else False,
                "flag_reason": row.get("flag_reason") or "" if has_flag_col else "",
                "is_reviewed": bool(row.get("is_reviewed")) if has_review_col else False,
                "reviewed_by": row.get("reviewed_by") or "" if has_review_col else "",
                "reviewed_at": row["reviewed_at"].strftime("%Y-%m-%d %H:%M:%S") if has_review_col and row.get("reviewed_at") else ""
            })
        
        return jsonify(logs)
        
    except Exception as e:
        print(f"Error in generation-logs: {e}")
        return jsonify({"error": str(e), "logs": []})
    finally:
        cursor.close()
        conn.close()

@app.route("/admin/api/generation-logs/download")
def admin_api_logs_download():
    """Download generation logs as CSV with current filters"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    # Get filter parameters from URL
    filter_type = request.args.get("type", "")
    filter_status = request.args.get("status", "")
    date_from = request.args.get("date_from", "")
    date_to = request.args.get("date_to", "")
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # Build query with filters
        query = """
            SELECT p.ppt_id, p.created_at, p.presentation_type, p.topic, p.slide_count, p.status, l.username
            FROM tbl_presentations p
            LEFT JOIN tbl_login l ON p.user_id = l.login_id
            WHERE 1=1
        """
        params = []
        
        if filter_type:
            query += " AND p.presentation_type = %s"
            params.append(filter_type)
        
        if filter_status:
            query += " AND p.status = %s"
            params.append(filter_status)
        
        if date_from:
            query += " AND DATE(p.created_at) >= %s"
            params.append(date_from)
        
        if date_to:
            query += " AND DATE(p.created_at) <= %s"
            params.append(date_to)
        
        query += " ORDER BY p.created_at DESC LIMIT 500"
        
        cursor.execute(query, params)
        logs = cursor.fetchall()
        
        # Create CSV content
        import csv
        import io
        
        output = io.StringIO()
        writer = csv.writer(output)
        writer.writerow(['ID', 'Timestamp', 'User', 'Type', 'Topic', 'Slides', 'Status'])
        
        for log in logs:
            # Format timestamp safely - handle various date formats
            timestamp = ''
            created_at = log.get("created_at")
            if created_at:
                try:
                    # Try different strftime formats
                    if hasattr(created_at, 'strftime'):
                        timestamp = created_at.strftime("%Y-%m-%d %H:%M:%S")
                    else:
                        timestamp = str(created_at)
                except:
                    timestamp = str(created_at)
            
            writer.writerow([
                log.get('ppt_id', log.get('id', '')),
                timestamp,
                log.get('username') or 'Unknown',
                log.get('presentation_type') or '',
                log.get('topic') or 'Untitled',
                log.get('slide_count') or 0,
                log.get('status') or ''
            ])
        
        output.seek(0)
        
        from flask import Response
        return Response(
            output.getvalue(),
            mimetype="text/csv",
            headers={"Content-disposition": "attachment; filename=generation_logs.csv"}
        )
    except Exception as e:
        print(f"Error in download: {e}")
        return jsonify({"error": str(e)})
    finally:
        cursor.close()
        conn.close()

@app.route("/admin/api/filter-options")
def admin_api_filter_options():
    """Get available filter options for generation logs"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Get unique presentation types
    cursor.execute("SELECT DISTINCT presentation_type FROM tbl_presentations WHERE presentation_type IS NOT NULL")
    types = [row['presentation_type'] for row in cursor.fetchall()]
    
    # Get unique statuses
    cursor.execute("SELECT DISTINCT status FROM tbl_presentations WHERE status IS NOT NULL")
    statuses = [row['status'] for row in cursor.fetchall()]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "types": types,
        "statuses": statuses
    })

@app.route("/admin/api/reports-stats")
def admin_api_reports_stats():
    """Get reports and analytics data"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # Get weekly new users
        cursor.execute("SELECT COUNT(*) as count FROM tbl_login WHERE role = 'customer' AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)")
        weekly_users = cursor.fetchone()["count"] or 0
        
        # Get weekly presentations
        cursor.execute("SELECT COUNT(*) as count FROM tbl_presentations WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)")
        weekly_presentations = cursor.fetchone()["count"] or 0
        
        # Get AI vs Manual counts
        cursor.execute("SELECT presentation_type, COUNT(*) as count FROM tbl_presentations GROUP BY presentation_type")
        type_counts = {}
        for row in cursor.fetchall():
            if row.get('presentation_type'):
                type_counts[row['presentation_type']] = row['count']
        
        # Get total users
        cursor.execute("SELECT COUNT(*) as count FROM tbl_login WHERE role = 'customer'")
        total_users = cursor.fetchone()["count"] or 0
        
        # Get total presentations
        cursor.execute("SELECT COUNT(*) as count FROM tbl_presentations")
        total_presentations = cursor.fetchone()["count"] or 0
        
        return jsonify({
            "weekly_users": weekly_users,
            "weekly_presentations": weekly_presentations,
            "total_users": total_users,
            "total_presentations": total_presentations,
            "ai_count": type_counts.get('AI', 0),
            "manual_count": type_counts.get('Manual', 0),
            "avg_session": 5,
            "bounce_rate": 25
        })
        
    except Exception as e:
        print(f"Error in reports-stats: {e}")
        return jsonify({"error": str(e)})
    finally:
        cursor.close()
        conn.close()

@app.route("/admin/api/users")
def admin_api_users():
    """Get all users"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    search = request.args.get("search", "")
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if search:
        cursor.execute("""
            SELECT l.login_id as id, l.username, l.email, l.status, l.created_at,
                   (SELECT COUNT(*) FROM tbl_presentations WHERE user_id = l.login_id) as presentation_count
            FROM tbl_login l
            WHERE l.role = 'customer' AND (l.username LIKE %s OR l.email LIKE %s)
            ORDER BY l.created_at DESC
        """, (f"%{search}%", f"%{search}%"))
    else:
        cursor.execute("""
            SELECT l.login_id as id, l.username, l.email, l.status, l.created_at,
                   (SELECT COUNT(*) FROM tbl_presentations WHERE user_id = l.login_id) as presentation_count
            FROM tbl_login l
            WHERE l.role = 'customer'
            ORDER BY l.created_at DESC
        """)
    
    users = []
    for row in cursor.fetchall():
        users.append({
            "id": row["id"],
            "username": row["username"],
            "email": row["email"],
            "presentation_count": row["presentation_count"],
            "joined": row["created_at"].strftime("%Y-%m-%d"),
            "status": "active" if row["status"] == 1 else "inactive"
        })
    
    cursor.close()
    conn.close()
    
    return jsonify(users)


@app.route("/admin/api/settings/auto-backup", methods=["GET", "POST"])
def admin_api_auto_backup():
    """Get or set auto-backup schedule"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Ensure settings table exists
    cursor.execute("SHOW TABLES LIKE 'tbl_settings'")
    if not cursor.fetchone():
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS tbl_settings (
                id INT PRIMARY KEY AUTO_INCREMENT,
                setting_key VARCHAR(100) UNIQUE,
                setting_value TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        conn.commit()
    
    if request.method == "POST":
        data = request.get_json()
        auto_backup_enabled = "true" if data.get("enabled", False) else "false"
        auto_backup_frequency = data.get("frequency", "daily")
        
        cursor.execute(
            "INSERT INTO tbl_settings (setting_key, setting_value) VALUES ('auto_backup_enabled', %s) "
            "ON DUPLICATE KEY UPDATE setting_value = %s",
            (auto_backup_enabled, auto_backup_enabled)
        )
        cursor.execute(
            "INSERT INTO tbl_settings (setting_key, setting_value) VALUES ('auto_backup_frequency', %s) "
            "ON DUPLICATE KEY UPDATE setting_value = %s",
            (auto_backup_frequency, auto_backup_frequency)
        )
        conn.commit()
        log_audit_action(session.get("user_id"), "UPDATE_AUTO_BACKUP", f"Auto-backup: {auto_backup_enabled}, frequency: {auto_backup_frequency}")
        cursor.close()
        conn.close()
        return jsonify({"success": True})
    
    # GET
    cursor.execute("SELECT setting_key, setting_value FROM tbl_settings WHERE setting_key IN ('auto_backup_enabled', 'auto_backup_frequency')")
    settings = {}
    for row in cursor.fetchall():
        settings[row["setting_key"]] = row["setting_value"]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "enabled": settings.get("auto_backup_enabled", "false") == "true",
        "frequency": settings.get("auto_backup_frequency", "daily")
    })

@app.route("/admin/api/user/<int:user_id>/toggle", methods=["POST"])
def admin_toggle_user(user_id):
    """Toggle user status"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute("SELECT status, username FROM tbl_login WHERE login_id = %s", (user_id,))
        user = cursor.fetchone()
        
        if not user:
            cursor.close()
            conn.close()
            return jsonify({"error": "User not found"}), 404
        
        current_status = user[0]
        # Handle both numeric (0/1) and string (active/inactive) status
        if isinstance(current_status, int):
            new_status = 0 if current_status == 1 else 1
        else:
            new_status = 0 if current_status == 1 else 1
        
        cursor.execute("UPDATE tbl_login SET status = %s WHERE login_id = %s", (new_status, user_id))
        conn.commit()
        
        log_audit_action(session.get("user_id"), "TOGGLE_USER", f"Toggled user {user[1]} status to {new_status}")
        
        cursor.close()
        conn.close()
        return jsonify({"success": True, "new_status": "active" if new_status == 1 else "inactive"})
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/user/<int:user_id>")
def admin_get_user(user_id):
    """Get user details"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # First check what columns exist in tbl_login
        cursor.execute("DESCRIBE tbl_login")
        columns_info = {row['Field'] for row in cursor.fetchall()}
        
        # Build query based on available columns
        cols = ["l.login_id", "l.username", "l.email"]
        phone_from_login = None
        if 'phone' in columns_info:
            cols.append("l.phone")
            phone_from_login = "l.phone"
        if 'dob' in columns_info:
            cols.append("l.dob")
        cols.extend(["l.status", "l.created_at"])
        
        # Get presentation id column name
        cursor.execute("DESCRIBE tbl_presentations")
        ppt_columns = {row['Field'] for row in cursor.fetchall()}
        ppt_id_col = 'ppt_id' if 'ppt_id' in ppt_columns else 'id'
        
        query = f"""
            SELECT {', '.join(cols)},
                   (SELECT COUNT(*) FROM tbl_presentations WHERE user_id = l.login_id) as presentation_count
            FROM tbl_login l
            WHERE l.login_id = %s
        """
        
        cursor.execute(query, (user_id,))
        user = cursor.fetchone()
        
        if not user:
            cursor.close()
            conn.close()
            return jsonify({"error": "User not found"}), 404
        
        # If phone not in tbl_login, try to get from tbl_custdetails
        if phone_from_login is None:
            cursor.execute("SELECT phone FROM tbl_custdetails WHERE login_id = %s", (user_id,))
            cust_details = cursor.fetchone()
            user['phone'] = cust_details['phone'] if cust_details and cust_details.get('phone') else None
        
        # Get recent presentations
        cursor.execute(f"""
            SELECT {ppt_id_col} as id, topic, presentation_type, slide_count, status, created_at
            FROM tbl_presentations
            WHERE user_id = %s
            ORDER BY created_at DESC
            LIMIT 5
        """, (user_id,))
        
        presentations = []
        for row in cursor.fetchall():
            date_str = "N/A"
            if row.get("created_at"):
                try:
                    date_str = row["created_at"].strftime("%Y-%m-%d %H:%M")
                except:
                    date_str = str(row["created_at"])
            
            presentations.append({
                "id": row.get("id"),
                "topic": row.get("topic") or "Untitled",
                "type": row.get("presentation_type") or "N/A",
                "slides": row.get("slide_count") or 0,
                "status": row.get("status") or "unknown",
                "date": date_str
            })
        
        # Format dates
        joined_date = "N/A"
        if user.get("created_at"):
            try:
                joined_date = user["created_at"].strftime("%Y-%m-%d")
            except:
                joined_date = str(user["created_at"])
        
        # Format status
        user_status = "inactive"
        if user.get("status") == 1 or user.get("status") == "active":
            user_status = "active"
        
        user["presentations"] = presentations
        user["joined"] = joined_date
        user["status"] = user_status
        
        cursor.close()
        conn.close()
        
        return jsonify(user)
    except Exception as e:
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/user/<int:user_id>/delete", methods=["POST"])
def admin_delete_user(user_id):
    """Delete user"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute("SELECT username FROM tbl_login WHERE login_id = %s", (user_id,))
        user = cursor.fetchone()
        
        if user:
            # Delete user's presentations first
            cursor.execute("DELETE FROM tbl_presentations WHERE user_id = %s", (user_id,))
            # Delete user
            cursor.execute("DELETE FROM tbl_login WHERE login_id = %s", (user_id,))
            conn.commit()
            
            log_audit_action(session.get("user_id"), "DELETE_USER", f"Deleted user: {user[0]}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True})
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500
    
    return jsonify({"error": "User not found"}), 404

@app.route("/admin/api/backups")
def admin_api_backups():
    """Get backup history"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    backups = []
    backup_dir = "backups"
    
    if os.path.exists(backup_dir):
        for f in sorted(os.listdir(backup_dir), reverse=True):
            fp = os.path.join(backup_dir, f)
            if os.path.isfile(fp):
                size = os.path.getsize(fp)
                size_mb = round(size / (1024 * 1024), 2)
                backups.append({
                    "name": f,
                    "size": f"{size_mb} MB",
                    "date": datetime.datetime.fromtimestamp(os.path.getmtime(fp)).strftime("%Y-%m-%d %H:%M")
                })
    
    return jsonify(backups)

@app.route("/admin/api/create-backup", methods=["POST"])
def admin_create_backup():
    """Create a database backup"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    backup_dir = "backups"
    os.makedirs(backup_dir, exist_ok=True)
    
    timestamp = datetime.datetime.now().strftime("%Y_%m_%d_%H_%M_%S")
    backup_file = os.path.join(backup_dir, f"backup_{timestamp}.sql")
    
    try:
        # Get database credentials from existing connection
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Get all tables
        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        
        with open(backup_file, "w", encoding="utf-8") as f:
            for table in tables:
                table_name = table[0]
                
                # Get create table statement
                cursor.execute(f"SHOW CREATE TABLE {table_name}")
                create_stmt = cursor.fetchone()[1]
                f.write(f"DROP TABLE IF EXISTS {table_name};\n")
                f.write(create_stmt + ";\n\n")
                
                # Get table data
                cursor.execute(f"SELECT * FROM {table_name}")
                rows = cursor.fetchall()
                
                if rows:
                    # Get column names
                    cursor.execute(f"SHOW COLUMNS FROM {table_name}")
                    columns = [col[0] for col in cursor.fetchall()]
                    
                    for row in rows:
                        values = []
                        for val in row:
                            if val is None:
                                values.append("NULL")
                            elif isinstance(val, (int, float)):
                                values.append(str(val))
                            else:
                                values.append("'" + str(val).replace("'", "''") + "'")
                        f.write(f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({', '.join(values)});\n")
                    f.write("\n")
        
        cursor.close()
        conn.close()
        
        log_audit_action(session.get("user_id"), "CREATE_BACKUP", f"Created backup: {backup_file}")
        
        return jsonify({
            "success": True,
            "backup_file": f"backup_{timestamp}.sql"
        })
        
    except Exception as e:
        log_audit_action(session.get("user_id"), "CREATE_BACKUP_FAILED", str(e), "error")
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/backup/download/<filename>")
def admin_download_backup(filename):
    """Download a backup file"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    backup_dir = "backups"
    return send_from_directory(backup_dir, filename, as_attachment=True)


@app.route("/admin/api/backup/<filename>", methods=["DELETE"])
def admin_delete_backup(filename):
    """Delete a backup file"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    backup_dir = "backups"
    file_path = os.path.join(backup_dir, filename)
    
    try:
        if os.path.exists(file_path):
            os.remove(file_path)
            log_audit_action(session.get("user_id"), "DELETE_BACKUP", f"Deleted backup: {filename}")
            return jsonify({"success": True})
        return jsonify({"error": "File not found"}), 404
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/admin/api/audit-logs")
def admin_api_audit_logs():
    """Get audit trail logs"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT a.*, l.username
        FROM tbl_audit_log a
        LEFT JOIN tbl_login l ON a.user_id = l.login_id
        ORDER BY a.created_at DESC
        LIMIT 100
    """)
    
    logs = []
    for row in cursor.fetchall():
        logs.append({
            "timestamp": row["created_at"].strftime("%Y-%m-%d %H:%M:%S"),
            "user": row["username"] or "System",
            "action": row["action"],
            "details": row["details"],
            "ip": row["ip_address"] or "N/A",
            "status": row["status"]
        })
    
    cursor.close()
    conn.close()
    
    return jsonify(logs)

@app.route("/admin/api/ai-performance")
def admin_api_ai_performance():
    """Get AI performance metrics"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # First check what types exist in the database
        cursor.execute("SELECT DISTINCT presentation_type FROM tbl_presentations")
        types = [row['presentation_type'] for row in cursor.fetchall()]
        
        # Get all presentations count
        cursor.execute("SELECT COUNT(*) as total FROM tbl_presentations")
        all_total = cursor.fetchone()["total"] or 0
        
        # If no AI presentations, show all presentations as fallback
        if all_total > 0:
            # Get today's presentations
            cursor.execute("""
                SELECT 
                    COUNT(*) as total,
                    AVG(TIMESTAMPDIFF(SECOND, created_at, updated_at)) as avg_duration,
                    SUM(CASE WHEN LOWER(status) = 'success' THEN 1 ELSE 0 END) as success_count
                FROM tbl_presentations
                WHERE DATE(created_at) = DATE(NOW())
            """)
            today = cursor.fetchone()
            
            # Get all-time statistics
            cursor.execute("""
                SELECT 
                    COUNT(*) as total,
                    SUM(CASE WHEN LOWER(status) = 'success' THEN 1 ELSE 0 END) as success_count,
                    AVG(TIMESTAMPDIFF(SECOND, created_at, updated_at)) as overall_avg_duration
                FROM tbl_presentations
            """)
            overall = cursor.fetchone()
            
            # Get weekly data
            cursor.execute("SELECT COUNT(*) as total FROM tbl_presentations WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)")
            weekly_count = cursor.fetchone()["total"] or 0
            
            # Get monthly data
            cursor.execute("""
                SELECT 
                    COUNT(*) as total,
                    SUM(CASE WHEN LOWER(status) = 'success' THEN 1 ELSE 0 END) as success_count
                FROM tbl_presentations
                WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
            """)
            monthly = cursor.fetchone()
            
            # Calculate metrics
            avg_duration = round(today.get("avg_duration") or 0, 1)
            today_total = today.get("total") or 0
            today_success = today.get("success_count") or 0
            today_success_rate = round((today_success / today_total * 100), 1) if today_total > 0 else 0
            
            overall_total = overall.get("total") or 0
            overall_success = overall.get("success_count") or 0
            ai_accuracy = round((overall_success / overall_total * 100), 1) if overall_total > 0 else 0
            
            monthly_total = monthly.get("total") or 0
            monthly_success = monthly.get("success_count") or 0
            monthly_success_rate = round((monthly_success / monthly_total * 100), 1) if monthly_total > 0 else 0
        else:
            # No data
            avg_duration = 0
            today_total = 0
            today_success_rate = 0
            overall_total = 0
            ai_accuracy = 0
            weekly_count = 0
            monthly_success_rate = 0
        
        return jsonify({
            "avg_generation_time": avg_duration,
            "success_rate": today_success_rate,
            "ai_accuracy": ai_accuracy,
            "requests_today": today_total,
            "weekly_requests": weekly_count,
            "monthly_success_rate": monthly_success_rate,
            "total_ai_presentations": overall_total,
            "overall_avg_time": round(overall.get("overall_avg_duration") or 0, 1) if overall_total > 0 else 0,
            "all_presentations": all_total,
            "db_types": types
        })
        
    except Exception as e:
        print(f"Error in ai-performance: {e}")
        return jsonify({"error": str(e)})
    finally:
        cursor.close()
        conn.close()

# -------------------------------------------------
# REGISTER
# -------------------------------------------------

import re
from datetime import date

@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        name = request.form.get("name")
        username = request.form.get("username")
        email = request.form.get("email")
        phone = request.form.get("phone")
        dob = request.form.get("dob")
        password = request.form.get("password")

        # Validation: Check for required fields
        if not username or not email or not password:
            return render_template(
                "register.html",
                error="Please fill all required fields",
                error_class="error"
            )

        # Validation: Username length and characters
        if len(username) < 3:
            return render_template(
                "register.html",
                error="Username must be at least 3 characters long",
                error_class="error"
            )
        if len(username) > 30:
            return render_template(
                "register.html",
                error="Username must not exceed 30 characters",
                error_class="error"
            )
        if not username.isalnum():
            return render_template(
                "register.html",
                error="Username can only contain letters and numbers",
                error_class="error"
            )

        # Validation: Password strength
        if len(password) < 6:
            return render_template(
                "register.html",
                error="Password must be at least 6 characters long",
                error_class="error"
            )
        if len(password) > 50:
            return render_template(
                "register.html",
                error="Password must not exceed 50 characters",
                error_class="error"
            )

        # Validation: Email format
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        if not re.match(email_pattern, email):
            return render_template(
                "register.html",
                error="Please enter a valid email address",
                error_class="error"
            )

        # Validation: Phone number format
        if phone:
            phone_pattern = r'^[0-9+\- ]{10,20}$'
            if not re.match(phone_pattern, phone):
                return render_template(
                    "register.html",
                    error="Please enter a valid phone number (10-20 digits)",
                    error_class="error"
                )

        # Validation: Age check (must be 15 or older)
        if dob:
            try:
                birth_date = date.fromisoformat(dob)
                today = date.today()
                age = today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))
                if age < 15:
                    return render_template(
                        "register.html",
                        error="You must be at least 15 years old to register",
                        error_class="error"
                    )
                if age > 120:
                    return render_template(
                        "register.html",
                        error="Please enter a valid date of birth",
                        error_class="error"
                    )
            except:
                return render_template(
                    "register.html",
                    error="Please enter a valid date of birth",
                    error_class="error"
                )

        password_hash = generate_password_hash(password)

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Validation: Check for duplicate email
        cursor.execute(
            "SELECT login_id FROM tbl_login WHERE email = %s",
            (email,)
        )
        if cursor.fetchone():
            cursor.close()
            conn.close()
            return render_template(
                "register.html",
                error="Email already registered. Please login.",
                error_class="error"
            )

        # Validation: Check for duplicate username
        cursor.execute(
            "SELECT login_id FROM tbl_login WHERE username = %s",
            (username,)
        )
        if cursor.fetchone():
            cursor.close()
            conn.close()
            return render_template(
                "register.html",
                error="Username already taken. Please choose another.",
                error_class="error"
            )

        # Validation: Check for duplicate phone (if provided and column exists)
        if phone:
            cursor.execute("DESCRIBE tbl_login")
            login_columns = {row['Field'] for row in cursor.fetchall()}
            if 'phone' in login_columns:
                cursor.execute(
                    "SELECT login_id FROM tbl_login WHERE phone = %s",
                    (phone,)
                )
                if cursor.fetchone():
                    cursor.close()
                    conn.close()
                    return render_template(
                        "register.html",
                        error="Phone number already registered. Please use a different number.",
                        error_class="error"
                    )

        # Check if phone column exists in tbl_login and get the ID column name
        cursor.execute("DESCRIBE tbl_login")
        login_columns = {row['Field']: row for row in cursor.fetchall()}
        
        # Determine the ID column (could be 'id' or 'login_id')
        id_col = 'login_id' if 'login_id' in login_columns else 'id'
        
        # Add phone column if it doesn't exist
        if 'phone' not in login_columns:
            try:
                cursor.execute("ALTER TABLE tbl_login ADD COLUMN phone VARCHAR(50)")
            except:
                pass  # Column might already exist
        
        # Get columns again after potential ALTER
        cursor.execute("DESCRIBE tbl_login")
        login_columns = {row['Field'] for row in cursor.fetchall()}
        
        # Insert into tbl_login (with or without phone based on column existence)
        if 'phone' in login_columns:
            cursor.execute(
                """
                INSERT INTO tbl_login (username, email, password_hash, role, status, phone)
                VALUES (%s, %s, %s, %s, 1, %s)
                """,
                (username, email, password_hash, "customer", phone)
            )
        else:
            cursor.execute(
                """
                INSERT INTO tbl_login (username, email, password_hash, role, status)
                VALUES (%s, %s, %s, %s, 1)
                """,
                (username, email, password_hash, "customer")
            )
        
        # Get the last inserted ID
        login_id = cursor.lastrowid
        if not login_id:
            # Fallback: get the ID we just inserted
            cursor.execute(f"SELECT {id_col} as id FROM tbl_login WHERE username = %s", (username,))
            result = cursor.fetchone()
            login_id = result['id'] if result else None

        # Check if tbl_custdetails exists
        cursor.execute("SHOW TABLES LIKE 'tbl_custdetails'")
        if not cursor.fetchone():
            # Create table if it doesn't exist
            cursor.execute("""
                CREATE TABLE tbl_custdetails (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    login_id INT NOT NULL,
                    name VARCHAR(100),
                    email VARCHAR(100),
                    phone VARCHAR(50),
                    dob DATE,
                    status INT DEFAULT 1,
                    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
                )
            """)
        else:
            # Table exists - check if login_id column exists, if not add it
            cursor.execute("DESCRIBE tbl_custdetails")
            cust_columns = {row['Field'] for row in cursor.fetchall()}
            if 'login_id' not in cust_columns:
                # Try to add login_id column
                try:
                    # Try to find user_id column
                    if 'user_id' in cust_columns:
                        cursor.execute("ALTER TABLE tbl_custdetails CHANGE COLUMN user_id login_id INT NOT NULL")
                    else:
                        # Add new column
                        cursor.execute("ALTER TABLE tbl_custdetails ADD COLUMN login_id INT NOT NULL AFTER id")
                except:
                    pass
        
        # Now get the actual columns
        cursor.execute("DESCRIBE tbl_custdetails")
        cust_columns = {row['Field'] for row in cursor.fetchall()}
        
        # Build insert query based on available columns
        insert_parts = []
        insert_vals = []
        
        if 'login_id' in cust_columns:
            insert_parts.append("login_id = %s")
            insert_vals.append(login_id)
        elif 'user_id' in cust_columns:
            insert_parts.append("user_id = %s")
            insert_vals.append(login_id)
        
        if 'email' in cust_columns:
            insert_parts.append("email = %s")
            insert_vals.append(email)
        if 'name' in cust_columns:
            insert_parts.append("name = %s")
            insert_vals.append(name if name else username)
        if 'phone' in cust_columns:
            insert_parts.append("phone = %s")
            insert_vals.append(phone)
        if 'dob' in cust_columns:
            insert_parts.append("dob = %s")
            insert_vals.append(dob)
        if 'status' in cust_columns:
            insert_parts.append("status = %s")
            insert_vals.append(1)
        if 'registered_at' in cust_columns:
            insert_parts.append("registered_at = NOW()")
        
        if insert_parts:
            cursor.execute(
                f"INSERT INTO tbl_custdetails SET {', '.join(insert_parts)}",
                insert_vals
            )

        conn.commit()
        cursor.close()
        conn.close()

        session["user_id"] = login_id
        session["email"] = email
        session["role"] = "customer"
        
        log_audit_action(login_id, "USER_REGISTER", f"User {username} registered successfully")

        return redirect(url_for("dashboard"))

    return render_template("register.html", error_class="")

# -------------------------------------------------
# LOGIN
# -------------------------------------------------

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        identifier = request.form.get("identifier")  # Can be username or email
        password = request.form.get("password")

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # First, check if it's an admin login (by username)
        ADMIN_USERNAME = "admin"
        ADMIN_PASSWORD = "admin123"

        if identifier == ADMIN_USERNAME and password == ADMIN_PASSWORD:
            cursor.close()
            conn.close()
            # Admin login - set session and redirect to admin dashboard
            session["user_id"] = 0  # Admin ID is 0
            session["username"] = ADMIN_USERNAME
            session["email"] = "admin@cosmicai.com"
            session["role"] = "admin"
            
            log_audit_action(0, "ADMIN_LOGIN", "Admin logged in successfully", "success")
            return redirect(url_for("admin_dashboard"))

        # Check if it's a customer login (by email or username)
        cursor.execute(
            "SELECT * FROM tbl_login WHERE email = %s OR username = %s",
            (identifier, identifier)
        )
        user = cursor.fetchone()

        cursor.close()
        conn.close()

        if not user or not check_password_hash(
            user["password_hash"], password
        ):
            log_audit_action(None, "LOGIN_FAILED", f"Failed login attempt for identifier: {identifier}")
            return render_template(
                "login.html",
                error="Invalid username/email or password",
                error_class="error"
            )

        # Use .get() with default value to handle missing status gracefully
        if user.get("status", 1) == 0:
            return render_template(
                "login.html",
                error="Your account has been deactivated. Please contact support.",
                error_class="error"
            )

        session["user_id"] = user["login_id"]
        session["email"] = user["email"]
        session["username"] = user["username"]
        session["role"] = user["role"]
        
        log_audit_action(user["login_id"], "USER_LOGIN", "User logged in successfully")

        # Redirect based on role - but both admin and customer go to their respective dashboards
        if user["role"] == "admin":
            return redirect(url_for("admin_dashboard"))
        else:
            return redirect(url_for("dashboard"))

    return render_template("login.html", error_class="")

# -------------------------------------------------
# DASHBOARD
# -------------------------------------------------

@app.route("/dashboard")
def dashboard():
    if "user_id" not in session:
        return redirect(url_for("login"))
    
    # Touch session to ensure it's persisted - helps with session initialization
    session.modified = True
    
    return send_from_directory(FRONTEND_DIR, "dashboard.html")

# -------------------------------------------------
# CUSTOMER API ENDPOINTS
# -------------------------------------------------

@app.route("/api/user/session", methods=["GET"])
def api_check_session():
    """Check if session is valid - helps with session initialization on first load"""
    if "user_id" not in session:
        return jsonify({"valid": False, "message": "No session"}), 401
    
    user_id = session.get("user_id")
    username = session.get("username", "")
    role = session.get("role", "")
    
    if not user_id:
        return jsonify({"valid": False, "message": "Invalid session"}), 401
    
    return jsonify({
        "valid": True,
        "user_id": user_id,
        "username": username,
        "role": role
    })

@app.route("/api/user/presentations", methods=["GET"])
def api_get_presentations():
    """Get user's presentations"""
    # Check session first - ensure it's properly initialized
    if "user_id" not in session:
        print("API call without session - returning 401")
        return jsonify({"error": "Unauthorized", "message": "User not logged in. Please login again."}), 401
    
    user_id = session.get("user_id")
    if not user_id:
        print("API call with empty user_id - returning 401")
        return jsonify({"error": "Unauthorized", "message": "Invalid session. Please login again."}), 401
    
    limit = request.args.get("limit", 10, type=int)
    
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        # Verify connection is alive
        if not conn.is_connected():
            conn.reconnect()
        
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute(
            """
            SELECT ppt_id, topic, presentation_type, slide_count, filename, created_at
            FROM tbl_presentations
            WHERE user_id = %s
            ORDER BY created_at DESC
            LIMIT %s
            """,
            (user_id, limit)
        )
        
        presentations = cursor.fetchall()
        
        # Format datetime objects
        for p in presentations:
            if p.get('created_at'):
                p['created_at'] = p['created_at'].strftime('%Y-%m-%d %H:%M:%S')
        
        return jsonify(presentations)
        
    except mysql.connector.Error as e:
        print(f"Database error fetching presentations: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({"error": "Database error", "message": "Failed to fetch presentations. Please try again."}), 500
    except Exception as e:
        print(f"Error fetching presentations: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({"error": "Failed to fetch presentations", "message": str(e)}), 500
    finally:
        if cursor:
            try:
                cursor.close()
            except:
                pass
        if conn:
            try:
                conn.close()
            except:
                pass

@app.route("/api/user/usage", methods=["GET"])
def api_get_usage():
    """Get user's usage statistics"""
    # Check session first - ensure it's properly initialized
    if "user_id" not in session:
        print("Usage API call without session - returning 401")
        return jsonify({"error": "Unauthorized", "message": "User not logged in. Please login again."}), 401
    
    user_id = session.get("user_id")
    if not user_id:
        print("Usage API call with empty user_id - returning 401")
        return jsonify({"error": "Unauthorized", "message": "Invalid session. Please login again."}), 401
    
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        # Verify connection is alive
        if not conn.is_connected():
            conn.reconnect()
        
        cursor = conn.cursor(dictionary=True)
        
        # Get total presentations
        cursor.execute(
            "SELECT COUNT(*) as count FROM tbl_presentations WHERE user_id = %s",
            (user_id,)
        )
        total_presentations = cursor.fetchone()['count']
        
        # Get presentations created today
        cursor.execute(
            """
            SELECT COUNT(*) as count FROM tbl_presentations
            WHERE user_id = %s AND DATE(created_at) = CURDATE()
            """,
            (user_id,)
        )
        today_presentations = cursor.fetchone()['count']
        
        # Daily limit (configurable via system settings, default to 10)
        daily_limit = 10
        try:
            cursor.execute(
                "SELECT setting_value FROM tbl_system_settings WHERE setting_key = %s",
                ("daily_ppt_limit",)
            )
            setting = cursor.fetchone()
            if setting:
                daily_limit = int(setting['setting_value'])
        except:
            # Table might not exist, use default
            daily_limit = 10
        
        ppts_left_today = max(0, daily_limit - today_presentations)
        
        return jsonify({
            "total_presentations": total_presentations,
            "presentations_today": today_presentations,
            "daily_limit": daily_limit,
            "ppts_left_today": ppts_left_today
        })
    except mysql.connector.Error as e:
        print(f"Database error fetching usage: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({"error": "Database error", "message": "Failed to fetch usage. Please try again."}), 500
    except Exception as e:
        print(f"Error fetching usage: {e}")
        return jsonify({"error": "Failed to fetch usage", "message": str(e)}), 500
    finally:
        if cursor:
            try:
                cursor.close()
            except:
                pass
        if conn:
            try:
                conn.close()
            except:
                pass

@app.route("/api/user/profile", methods=["GET"])
def api_get_profile():
    """Get user's profile info"""
    # Check session first - ensure it's properly initialized
    if "user_id" not in session:
        print("Profile API call without session - returning 401")
        return jsonify({"error": "Unauthorized", "message": "User not logged in. Please login again."}), 401
    
    user_id = session.get("user_id")
    if not user_id:
        print("Profile API call with empty user_id - returning 401")
        return jsonify({"error": "Unauthorized", "message": "Invalid session. Please login again."}), 401
    
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        # Verify connection is alive
        if not conn.is_connected():
            conn.reconnect()
        
        cursor = conn.cursor(dictionary=True)
        
        # First get basic info from tbl_login
        cursor.execute(
            "SELECT login_id, username, email FROM tbl_login WHERE login_id = %s",
            (user_id,)
        )
        user_data = cursor.fetchone()
        
        if not user_data:
            return jsonify({"error": "User not found"}), 404
        
        # Try to get additional details from tbl_custdetails
        # Use a safe query that won't fail if columns don't exist
        try:
            cursor.execute(
                "SELECT name, phone, dob FROM tbl_custdetails WHERE login_id = %s",
                (user_id,)
            )
            cust_data = cursor.fetchone()
        except mysql.connector.Error as e:
            # Table or column might not exist, use defaults
            print(f"Could not fetch customer details: {e}")
            cust_data = None
        
        # Build response
        profile = {
            "username": user_data.get("username", ""),
            "email": user_data.get("email", ""),
            "name": cust_data.get("name") if cust_data else None,
            "phone": cust_data.get("phone") if cust_data else None,
            "dob": cust_data.get("dob") if cust_data else None
        }
        
        return jsonify(profile)
        
    except mysql.connector.Error as e:
        print(f"Database error fetching profile: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({"error": "Database error", "message": "Failed to fetch profile. Please try again."}), 500
    except Exception as e:
        print(f"Error fetching profile: {e}")
        import traceback
        traceback.print_exc()
        return jsonify({"error": "Failed to fetch profile", "message": str(e)}), 500
    finally:
        if cursor:
            try:
                cursor.close()
            except:
                pass
        if conn:
            try:
                conn.close()
            except:
                pass

# -------------------------------------------------
# LOGOUT
# -------------------------------------------------

@app.route("/logout")
def logout():
    user_id = session.get("user_id")
    role = session.get("role")
    
    session.clear()
    
    if role == "admin":
        log_audit_action(user_id, "ADMIN_LOGOUT", "Admin logged out")
        return redirect(url_for("admin_login"))
    
    log_audit_action(user_id, "USER_LOGOUT", "User logged out")
    return redirect(url_for("login"))

# -------------------------------------------------
# CREATE FLOW
# -------------------------------------------------

@app.route("/create")
def create_mode():
    if "user_id" not in session:
        return redirect(url_for("login"))
    
    # Touch session to ensure it's persisted - helps with session initialization
    session.modified = True
    
    return send_from_directory(FRONTEND_DIR, "create_mode.html")

@app.route("/presentations")
def presentations_page():
    """My Presentations page - shows all user presentations"""
    if "user_id" not in session:
        return redirect(url_for("login"))
    
    # Touch session to ensure it's persisted - helps with session initialization
    session.modified = True
    
    return send_from_directory(FRONTEND_DIR, "presentations.html")

@app.route("/usage")
def usage_page():
    """Usage analytics page"""
    if "user_id" not in session:
        return redirect(url_for("login"))
    
    # Touch session to ensure it's persisted - helps with session initialization
    session.modified = True
    
    return send_from_directory(FRONTEND_DIR, "usage.html")

@app.route("/create/ai")
def create_ai():
    if "user_id" not in session:
        return redirect(url_for("login"))
    
    # Touch session to ensure it's persisted
    session.modified = True
    
    return send_from_directory(FRONTEND_DIR, "create.html")

@app.route("/create/manual")
def create_manual():
    if "user_id" not in session:
        return redirect(url_for("login"))
    
    # Touch session to ensure it's persisted
    session.modified = True
    
    return send_from_directory(FRONTEND_DIR, "create_manual.html")

# -------------------------------------------------
# AI PPT GENERATION
# -------------------------------------------------

@app.route("/submit", methods=["POST"])
def submit():
    if "user_id" not in session:
        return redirect(url_for("login"))

    user_input = request.form.get("user_input")
    user_id = session["user_id"]
    
    # Content settings
    slide_count = int(request.form.get("slides", 5))
    content_depth = request.form.get("depth", "balanced")
    
    # Design settings
    theme = request.form.get("theme", "cosmic_dark")
    layout = request.form.get("layout", "title_bullets")
    heading_font = request.form.get("heading_font", "calibri")
    body_font = request.form.get("body_font", "calibri")
    font_size = request.form.get("font_size", "standard")
    
    # New settings - presentation title and custom title color
    presentation_title = request.form.get("presentation_title", "")
    title_color = request.form.get("title_color", "default_title")
    subtitle = request.form.get("subtitle", "")
    
    # Thank you / conclusion slide option
    add_thank_you = request.form.get("add_thank_you", "off") == "on"
    
    # Use presentation title if provided, otherwise use first part of user input
    ppt_title = presentation_title if presentation_title.strip() else user_input[:50]

    # Content moderation check
    combined_text = f"{user_input} {ppt_title} {subtitle}"
    is_flagged, flag_reasons = check_content_safety(combined_text)
    if is_flagged:
        log_audit_action(user_id, "CONTENT_FLAGGED", f"Flagged AI presentation: {ppt_title} | Reasons: {'; '.join(flag_reasons)}", status="warning")

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO tbl_input_data (user_id, raw_input) VALUES (%s, %s)",
        (user_id, user_input)
    )
    input_id = cursor.lastrowid
    conn.commit()
    cursor.close()
    conn.close()

    ai_text = generate_ppt_content(
        user_input,
        slide_count,
        content_depth
    )

    output_dir = GENERATED_PPTS_DIR
    os.makedirs(output_dir, exist_ok=True)

    ppt_filename = f"presentation_user_{user_id}_{datetime.datetime.now().strftime('%Y%m%d%H%M%S')}.pptx"
    ppt_path = os.path.join(output_dir, ppt_filename)

    create_ppt(
        ai_text, 
        ppt_path, 
        theme=theme,
        layout=layout,
        heading_font=heading_font,
        body_font=body_font,
        font_size=font_size,
        custom_title_color=title_color,
        presentation_title=ppt_title,
        content_depth=content_depth,
        subtitle=subtitle,
        add_thank_you=add_thank_you
    )

    preview_images = generate_slide_previews(
        ppt_path,
        ppt_filename
    )

    # Log presentation creation
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        """
        INSERT INTO tbl_presentations (user_id, input_id, presentation_type, topic, slide_count, filename, status, is_flagged, flag_reason)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """,
        (user_id, input_id, "AI", ppt_title, 1 + slide_count + (1 if add_thank_you else 0), ppt_filename, "success", is_flagged, "; ".join(flag_reasons) if flag_reasons else None)
    )
    conn.commit()
    cursor.close()
    conn.close()
    
    log_audit_action(user_id, "PPT_GENERATED", f"AI presentation generated: {ppt_title}...")

    return render_template(
        "success.html",
        ppt_filename=ppt_filename,
        preview_images=preview_images
    )

# -------------------------------------------------
# MANUAL PPT GENERATION
# -------------------------------------------------

@app.route("/submit_manual", methods=["POST"])
def submit_manual():
    if "user_id" not in session:
        return redirect(url_for("login"))

    content = request.form.get("user_content")
    user_id = session["user_id"]
    
    # Get theme from form
    theme = request.form.get("theme", "cosmic_dark")
    
    # Get font options
    heading_font = request.form.get("heading_font", "calibri")
    body_font = request.form.get("body_font", "calibri")
    font_size = request.form.get("font_size", "standard")
    layout = request.form.get("layout", "title_bullets")
    
    # Get presentation title
    presentation_title = request.form.get("presentation_title", "My Presentation")
    
    # Get optional subtitle
    subtitle = request.form.get("subtitle", "")
    
    # Get custom color overrides (hex values like #ff0000, or empty for theme default)
    custom_title_color_hex = request.form.get("custom_title_color_hex", "")
    custom_heading_color_hex = request.form.get("custom_heading_color_hex", "")
    custom_body_color_hex = request.form.get("custom_body_color_hex", "")

    # Split slides by unique separator (sent from slide editor)
    if "===SLIDE_BREAK===" in content:
        slides = [p.strip() for p in content.split("===SLIDE_BREAK===") if p.strip()]
    else:
        # Fallback for older format
        slides = [p.strip() for p in content.split("\n\n") if p.strip()]
    
    # Content moderation check
    combined_text = f"{presentation_title} {subtitle} {content}"
    is_flagged, flag_reasons = check_content_safety(combined_text)
    if is_flagged:
        log_audit_action(user_id, "CONTENT_FLAGGED", f"Flagged manual presentation: {presentation_title} | Reasons: {'; '.join(flag_reasons)}", status="warning")
    
    # Get optional thank you slide setting
    add_thank_you = request.form.get("add_thank_you", "off") == "on"

    output_dir = GENERATED_PPTS_DIR
    os.makedirs(output_dir, exist_ok=True)

    ppt_filename = f"manual_presentation_user_{user_id}_{datetime.datetime.now().strftime('%Y%m%d%H%M%S')}.pptx"
    ppt_path = os.path.join(output_dir, ppt_filename)
    
    # Pass slides as content and presentation_title separately
    # Title slide is created automatically inside create_ppt using presentation_title
    create_ppt(slides, ppt_path, theme=theme, layout=layout, 
               heading_font=heading_font, body_font=body_font, font_size=font_size,
               content_depth="balanced", subtitle=subtitle,
               presentation_title=presentation_title, add_thank_you=add_thank_you,
               custom_title_color_hex=custom_title_color_hex,
               custom_heading_color_hex=custom_heading_color_hex,
               custom_body_color_hex=custom_body_color_hex)

    preview_images = generate_slide_previews(
        ppt_path,
        ppt_filename
    )

    # Log presentation creation (slide_count = title + content + optional thank you)
    total_slides = 1 + len(slides) + (1 if add_thank_you else 0)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        """
        INSERT INTO tbl_presentations (user_id, presentation_type, topic, slide_count, filename, status, is_flagged, flag_reason)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """,
        (user_id, "Manual", presentation_title, total_slides, ppt_filename, "success", is_flagged, "; ".join(flag_reasons) if flag_reasons else None)
    )
    conn.commit()
    cursor.close()
    conn.close()
    
    log_audit_action(user_id, "PPT_UPLOADED", f"Manual presentation uploaded: {len(slides)} slides")

    return render_template(
        "success.html",
        ppt_filename=ppt_filename,
        preview_images=preview_images
    )

# -------------------------------------------------
# DOWNLOAD PPT
# -------------------------------------------------

@app.route("/generated_ppts/<filename>")
def download_ppt(filename):
    if "user_id" not in session:
        return redirect(url_for("login"))

    return send_from_directory(
        GENERATED_PPTS_DIR,
        filename,
        as_attachment=True
    )

@app.route("/admin/api/download-presentation/<filename>")
def admin_download_presentation(filename):
    """Allow admin to download any user's presentation"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    # Sanitize filename to prevent path traversal
    safe_filename = os.path.basename(filename)
    file_path = os.path.join(GENERATED_PPTS_DIR, safe_filename)
    
    if not os.path.exists(file_path):
        return jsonify({"error": "File not found"}), 404
    
    log_audit_action(session.get("user_id"), "ADMIN_DOWNLOAD_PPT", f"Admin downloaded presentation: {safe_filename}")
    
    return send_from_directory(
        GENERATED_PPTS_DIR,
        safe_filename,
        as_attachment=True
    )

@app.route("/admin/api/review-flagged", methods=["POST"])
def admin_review_flagged():
    """Mark a flagged presentation as reviewed by admin"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    data = request.get_json()
    ppt_id = data.get("ppt_id")
    
    if not ppt_id:
        return jsonify({"error": "Missing ppt_id"}), 400
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        # Ensure review columns exist
        cursor.execute("SHOW COLUMNS FROM tbl_presentations LIKE 'is_reviewed'")
        if not cursor.fetchone():
            cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN is_reviewed BOOLEAN DEFAULT FALSE")
            cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN reviewed_by VARCHAR(100) DEFAULT NULL")
            cursor.execute("ALTER TABLE tbl_presentations ADD COLUMN reviewed_at DATETIME DEFAULT NULL")
            conn.commit()
        
        admin_username = session.get("username", "Admin")
        cursor.execute(
            "UPDATE tbl_presentations SET is_reviewed = TRUE, reviewed_by = %s, reviewed_at = NOW() WHERE ppt_id = %s AND is_flagged = TRUE",
            (admin_username, ppt_id)
        )
        conn.commit()
        
        if cursor.rowcount == 0:
            return jsonify({"error": "Presentation not found or not flagged"}), 404
        
        log_audit_action(session.get("user_id"), "FLAGGED_CONTENT_REVIEWED", f"Admin reviewed flagged presentation ID: {ppt_id}")
        
        return jsonify({"success": True, "message": "Flagged content marked as reviewed"})
    except Exception as e:
        print(f"Error reviewing flagged content: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# -------------------------------------------------
# ADMIN SETTINGS API
# -------------------------------------------------

@app.route("/admin/api/settings/general", methods=["GET", "POST"])
def admin_api_settings_general():
    """Get or save general settings"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == "POST":
        data = request.get_json()
        site_name = data.get("site_name", "Cosmic AI PPT Generator")
        admin_email = data.get("admin_email", "admin@cosmicai.com")
        default_language = data.get("default_language", "English")
        
        # Check if settings table exists
        cursor.execute("SHOW TABLES LIKE 'tbl_settings'")
        if not cursor.fetchone():
            # Create settings table
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS tbl_settings (
                    id INT PRIMARY KEY AUTO_INCREMENT,
                    setting_key VARCHAR(100) UNIQUE,
                    setting_value TEXT,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                )
            """)
        
        # Update or insert settings
        settings_to_update = [
            ("site_name", site_name),
            ("admin_email", admin_email),
            ("default_language", default_language)
        ]
        
        for key, value in settings_to_update:
            cursor.execute(
                "INSERT INTO tbl_settings (setting_key, setting_value) VALUES (%s, %s) "
                "ON DUPLICATE KEY UPDATE setting_value = %s",
                (key, value, value)
            )
        
        conn.commit()
        log_audit_action(session.get("user_id"), "UPDATE_SETTINGS", "Updated general settings")
        cursor.close()
        conn.close()
        return jsonify({"success": True})
    
    # GET - Load settings
    cursor.execute("SHOW TABLES LIKE 'tbl_settings'")
    if not cursor.fetchone():
        cursor.close()
        conn.close()
        return jsonify({
            "site_name": "Cosmic AI PPT Generator",
            "admin_email": "admin@cosmicai.com",
            "default_language": "English"
        })
    
    cursor.execute("SELECT setting_key, setting_value FROM tbl_settings")
    settings = {}
    for row in cursor.fetchall():
        settings[row["setting_key"]] = row["setting_value"]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "site_name": settings.get("site_name", "Cosmic AI PPT Generator"),
        "admin_email": settings.get("admin_email", "admin@cosmicai.com"),
        "default_language": settings.get("default_language", "English")
    })


@app.route("/admin/api/settings/ai", methods=["GET", "POST"])
def admin_api_settings_ai():
    """Get or save AI configuration"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Ensure settings table exists
    cursor.execute("SHOW TABLES LIKE 'tbl_settings'")
    if not cursor.fetchone():
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS tbl_settings (
                id INT PRIMARY KEY AUTO_INCREMENT,
                setting_key VARCHAR(100) UNIQUE,
                setting_value TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        conn.commit()
    
    if request.method == "POST":
        data = request.get_json()
        max_slides = data.get("max_slides", 20)
        default_slides = data.get("default_slides", 5)
        ai_model = data.get("ai_model", "GPT-4")
        # Normalize content_depth to lowercase for consistency
        content_depth = data.get("content_depth", "balanced").lower()
        
        settings_to_update = [
            ("max_slides", str(max_slides)),
            ("default_slides", str(default_slides)),
            ("ai_model", ai_model),
            ("content_depth", content_depth)
        ]
        
        for key, value in settings_to_update:
            cursor.execute(
                "INSERT INTO tbl_settings (setting_key, setting_value) VALUES (%s, %s) "
                "ON DUPLICATE KEY UPDATE setting_value = %s",
                (key, value, value)
            )
        
        conn.commit()
        log_audit_action(session.get("user_id"), "UPDATE_AI_SETTINGS", "Updated AI configuration")
        cursor.close()
        conn.close()
        return jsonify({"success": True})
    
    # GET - Load settings
    cursor.execute("SELECT setting_key, setting_value FROM tbl_settings")
    settings = {}
    for row in cursor.fetchall():
        settings[row["setting_key"]] = row["setting_value"]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "max_slides": int(settings.get("max_slides", 20)),
        "default_slides": int(settings.get("default_slides", 5)),
        "ai_model": settings.get("ai_model", "GPT-4"),
        "content_depth": settings.get("content_depth", "balanced")
    })


@app.route("/admin/api/settings/security", methods=["GET", "POST"])
def admin_api_settings_security():
    """Get or save simplified security settings (2FA removed)"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Ensure settings table exists
    cursor.execute("SHOW TABLES LIKE 'tbl_settings'")
    if not cursor.fetchone():
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS tbl_settings (
                id INT PRIMARY KEY AUTO_INCREMENT,
                setting_key VARCHAR(100) UNIQUE,
                setting_value TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        conn.commit()
    
    if request.method == "POST":
        data = request.get_json()
        session_timeout = data.get("session_timeout", 30)
        max_login_attempts = data.get("max_login_attempts", 5)
        
        settings_to_update = [
            ("session_timeout", str(session_timeout)),
            ("max_login_attempts", str(max_login_attempts))
        ]
        
        for key, value in settings_to_update:
            cursor.execute(
                "INSERT INTO tbl_settings (setting_key, setting_value) VALUES (%s, %s) "
                "ON DUPLICATE KEY UPDATE setting_value = %s",
                (key, value, value)
            )
        
        conn.commit()
        log_audit_action(session.get("user_id"), "UPDATE_SECURITY_SETTINGS", "Updated security settings")
        cursor.close()
        conn.close()
        return jsonify({"success": True})
    
    # GET - Load settings
    cursor.execute("SELECT setting_key, setting_value FROM tbl_settings")
    settings = {}
    for row in cursor.fetchall():
        settings[row["setting_key"]] = row["setting_value"]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "session_timeout": int(settings.get("session_timeout", 30)),
        "max_login_attempts": int(settings.get("max_login_attempts", 5))
    })


@app.route("/admin/api/settings/notifications", methods=["GET", "POST"])
def admin_api_settings_notifications():
    """Get or save notification settings"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Ensure settings table exists
    cursor.execute("SHOW TABLES LIKE 'tbl_settings'")
    if not cursor.fetchone():
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS tbl_settings (
                id INT PRIMARY KEY AUTO_INCREMENT,
                setting_key VARCHAR(100) UNIQUE,
                setting_value TEXT,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        conn.commit()
    
    if request.method == "POST":
        data = request.get_json()
        email_notifications = "true" if data.get("email_notifications", True) else "false"
        error_alerts = "true" if data.get("error_alerts", True) else "false"
        weekly_reports = "true" if data.get("weekly_reports", False) else "false"
        
        settings_to_update = [
            ("email_notifications", email_notifications),
            ("error_alerts", error_alerts),
            ("weekly_reports", weekly_reports)
        ]
        
        for key, value in settings_to_update:
            cursor.execute(
                "INSERT INTO tbl_settings (setting_key, setting_value) VALUES (%s, %s) "
                "ON DUPLICATE KEY UPDATE setting_value = %s",
                (key, value, value)
            )
        
        conn.commit()
        log_audit_action(session.get("user_id"), "UPDATE_NOTIFICATION_SETTINGS", "Updated notification settings")
        cursor.close()
        conn.close()
        return jsonify({"success": True})
    
    # GET - Load settings
    cursor.execute("SELECT setting_key, setting_value FROM tbl_settings")
    settings = {}
    for row in cursor.fetchall():
        settings[row["setting_key"]] = row["setting_value"]
    
    cursor.close()
    conn.close()
    
    return jsonify({
        "email_notifications": settings.get("email_notifications", "true") == "true",
        "error_alerts": settings.get("error_alerts", "true") == "true",
        "weekly_reports": settings.get("weekly_reports", "false") == "true"
    })


# =================================================
# THEME & DESIGN ASSETS MANAGEMENT
# =================================================

@app.route("/admin/api/themes/ensure-tables", methods=["GET"])
def admin_ensure_theme_tables():
    """Ensure theme/design assets tables exist with default data"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        # Drop existing tables if they exist (to fix any column issues)
        cursor.execute("DROP TABLE IF EXISTS tbl_templates")
        cursor.execute("DROP TABLE IF EXISTS tbl_fonts")
        cursor.execute("DROP TABLE IF EXISTS tbl_color_schemes")
        cursor.execute("DROP TABLE IF EXISTS tbl_backgrounds")
        conn.commit()
        
        # Create templates table
        cursor.execute("""
            CREATE TABLE tbl_templates (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                template_type VARCHAR(20) NOT NULL,
                available_for VARCHAR(20) DEFAULT 'both',
                description VARCHAR(255),
                thumbnail VARCHAR(255),
                pptx_filename VARCHAR(255),
                color_scheme_id INT DEFAULT NULL,
                font_id INT DEFAULT NULL,
                background_id INT DEFAULT NULL,
                is_active BOOLEAN DEFAULT TRUE,
                is_default BOOLEAN DEFAULT FALSE,
                created_by INT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        
        # Add new columns to existing tables if they don't exist
        try:
            cursor.execute("ALTER TABLE tbl_templates ADD COLUMN color_scheme_id INT DEFAULT NULL")
        except:
            pass
        try:
            cursor.execute("ALTER TABLE tbl_templates ADD COLUMN font_id INT DEFAULT NULL")
        except:
            pass
        try:
            cursor.execute("ALTER TABLE tbl_templates ADD COLUMN background_id INT DEFAULT NULL")
        except:
            pass
        try:
            cursor.execute("ALTER TABLE tbl_templates ADD COLUMN available_for VARCHAR(20) DEFAULT 'both'")
        except:
            pass
        
        # Create fonts table
        cursor.execute("""
            CREATE TABLE tbl_fonts (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                display_name VARCHAR(100) NOT NULL,
                font_family VARCHAR(255) NOT NULL,
                font_url VARCHAR(500),
                is_active BOOLEAN DEFAULT TRUE,
                is_default BOOLEAN DEFAULT FALSE,
                created_by INT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        
        # Create color schemes table
        cursor.execute("""
            CREATE TABLE tbl_color_schemes (
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
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        
        # Create backgrounds table
        cursor.execute("""
            CREATE TABLE tbl_backgrounds (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                background_type VARCHAR(20) NOT NULL,
                image_url VARCHAR(255),
                gradient_colors JSON,
                solid_color VARCHAR(20),
                thumbnail VARCHAR(255),
                is_active BOOLEAN DEFAULT TRUE,
                is_default BOOLEAN DEFAULT FALSE,
                created_by INT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        """)
        
        conn.commit()
        
        # Insert default data if tables are empty
        cursor.execute("SELECT COUNT(*) FROM tbl_color_schemes")
        if cursor.fetchone()[0] == 0:
            color_defaults = [
                ("Cosmic Dark", "#78b4ff", "#48d1cc", "#9370db", "#080c1c", "#dceaff", 1, 1),
                ("Ocean Blue", "#ffffff", "#50c8ff", "#00b4dc", "#0a2350", "#c8e6ff", 1, 0),
                ("Neon Purple", "#dc64ff", "#ff32b4", "#b450ff", "#0f0523", "#e6b4ff", 1, 0),
                ("Minimal Light", "#19284b", "#64b4ff", "#0078d7", "#fcfcff", "#374664", 1, 0),
                ("Corporate Pro", "#ffffff", "#ffaa32", "#3ca55f", "#0f1e37", "#d2e1f5", 1, 0),
                ("Elegant Dark", "#dab44b", "#dab44b", "#b9963c", "#0c0c12", "#e1e1e1", 1, 0),
                ("Tech Modern", "#00ffb4", "#00dcdc", "#50c8ff", "#0a081e", "#aad2ff", 1, 0),
                ("Nature Fresh", "#a0f5a0", "#b4e6b4", "#5abe64", "#0c321e", "#d2ffc8", 1, 0),
                ("Creative Colorful", "#ff8282", "#8250c8", "#ffc832", "#19192d", "#ffe6aa", 1, 0),
                ("Sunset Glow", "#ffc8aa", "#ffd26e", "#ff8282", "#23121c", "#ffe6d7", 1, 0),
                ("Arctic Ice", "#b9f0e1", "#3c6e9b", "#96e1c3", "#0f283c", "#d7faf0", 1, 0),
                ("Midnight Express", "#d7e6ff", "#1e2d4b", "#7896c8", "#080810", "#b4c8e6", 1, 0),
                ("Royal Purple", "#ffc3e6", "#5f376a", "#ff4682", "#190a28", "#ebc3f5", 1, 0)
            ]
            cursor.executemany("INSERT INTO tbl_color_schemes (name, primary_color, secondary_color, accent_color, background_color, text_color, is_active, is_default) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", color_defaults)
            conn.commit()
        
        cursor.execute("SELECT COUNT(*) FROM tbl_fonts")
        if cursor.fetchone()[0] == 0:
            font_defaults = [
                ("Arial", "Arial", "Arial", 1, 1),
                ("Poppins", "Poppins", "Poppins", 1, 0),
                ("Lato", "Lato", "Lato", 1, 0),
                ("Barlow", "Barlow", "Barlow", 1, 0),
                ("PT Sans", "PT Sans", "PT Sans", 1, 0),
                ("PT Serif", "PT Serif", "PT Serif", 1, 0),
                ("Fira Sans", "Fira Sans", "Fira Sans", 1, 0),
                ("Ubuntu", "Ubuntu", "Ubuntu", 1, 0)
            ]
            cursor.executemany("INSERT INTO tbl_fonts (name, display_name, font_family, is_active, is_default) VALUES (%s, %s, %s, %s, %s)", font_defaults)
            conn.commit()
        
        # Deactivate variable/problematic Google fonts in existing databases
        variable_fonts = ['Roboto', 'Open Sans', 'Montserrat', 'Playfair Display', 'DM Sans', 'Inter',
                          'Raleway', 'Nunito', 'Oswald', 'Merriweather', 'Libre Baskerville',
                          'Noto Sans', 'Work Sans', 'Quicksand', 'Rubik', 'Karla', 'Josefin Sans',
                          'Cabin', 'Manrope', 'Outfit', 'Space Grotesk', 'Sora',
                          'Plus Jakarta Sans', 'Source Sans 3']
        placeholders = ','.join(['%s'] * len(variable_fonts))
        cursor.execute(f"UPDATE tbl_fonts SET is_active = FALSE WHERE name IN ({placeholders})", variable_fonts)
        
        # Ensure static Google fonts exist in DB
        static_google_fonts = [
            ("Poppins", "Poppins", "Poppins", 1, 0),
            ("Lato", "Lato", "Lato", 1, 0),
            ("Barlow", "Barlow", "Barlow", 1, 0),
            ("PT Sans", "PT Sans", "PT Sans", 1, 0),
            ("PT Serif", "PT Serif", "PT Serif", 1, 0),
            ("Fira Sans", "Fira Sans", "Fira Sans", 1, 0),
            ("Ubuntu", "Ubuntu", "Ubuntu", 1, 0),
        ]
        for font_row in static_google_fonts:
            cursor.execute("SELECT COUNT(*) FROM tbl_fonts WHERE name = %s", (font_row[0],))
            if cursor.fetchone()[0] == 0:
                cursor.execute("INSERT INTO tbl_fonts (name, display_name, font_family, is_active, is_default) VALUES (%s, %s, %s, %s, %s)", font_row)
        conn.commit()
        
        cursor.execute("SELECT COUNT(*) FROM tbl_backgrounds")
        if cursor.fetchone()[0] == 0:
            bg_defaults = [
                ("Cosmic Dark", "solid", "#080c1c", None, 1, 1),
                ("Ocean Blue", "solid", "#0a2350", None, 1, 0),
                ("Neon Purple", "solid", "#0f0523", None, 1, 0),
                ("Minimal Light", "solid", "#fcfcff", None, 1, 0),
                ("Corporate Pro", "solid", "#0f1e37", None, 1, 0),
                ("Elegant Dark", "solid", "#0c0c12", None, 1, 0),
                ("Tech Modern", "solid", "#0a081e", None, 1, 0),
                ("Nature Fresh", "solid", "#0c321e", None, 1, 0),
                ("Creative Colorful", "solid", "#19192d", None, 1, 0),
                ("Sunset Glow", "solid", "#23121c", None, 1, 0),
                ("Arctic Ice", "solid", "#0f283c", None, 1, 0),
                ("Midnight Express", "solid", "#080810", None, 1, 0),
                ("Royal Purple", "solid", "#190a28", None, 1, 0)
            ]
            cursor.executemany("INSERT INTO tbl_backgrounds (name, background_type, solid_color, gradient_colors, is_active, is_default) VALUES (%s, %s, %s, %s, %s, %s)", bg_defaults)
            conn.commit()
        
        # Insert default templates linked to color schemes and backgrounds
        cursor.execute("SELECT COUNT(*) FROM tbl_templates")
        if cursor.fetchone()[0] == 0:
            # Get the inserted color scheme and background IDs
            cursor.execute("SELECT id, name FROM tbl_color_schemes WHERE is_active = TRUE ORDER BY id")
            color_schemes = {row[1]: row[0] for row in cursor.fetchall()}
            
            cursor.execute("SELECT id, name FROM tbl_backgrounds WHERE is_active = TRUE ORDER BY id")
            backgrounds = {row[1]: row[0] for row in cursor.fetchall()}
            
            cursor.execute("SELECT id FROM tbl_fonts WHERE is_default = TRUE LIMIT 1")
            default_font_row = cursor.fetchone()
            default_font_id = default_font_row[0] if default_font_row else None
            
            template_defaults = [
                ("Cosmic Dark", "ai", "both", "Space themed with premium glow effects", color_schemes.get("Cosmic Dark"), default_font_id, backgrounds.get("Cosmic Dark"), 1, 1),
                ("Ocean Blue", "ai", "both", "Clean corporate gradient style", color_schemes.get("Ocean Blue"), default_font_id, backgrounds.get("Ocean Blue"), 1, 0),
                ("Neon Purple", "ai", "both", "Futuristic neon highlights", color_schemes.get("Neon Purple"), default_font_id, backgrounds.get("Neon Purple"), 1, 0),
                ("Minimal Light", "ai", "both", "Simple bright business layout", color_schemes.get("Minimal Light"), default_font_id, backgrounds.get("Minimal Light"), 1, 0),
                ("Corporate Pro", "ai", "both", "Professional blue-toned corporate", color_schemes.get("Corporate Pro"), default_font_id, backgrounds.get("Corporate Pro"), 1, 0),
                ("Elegant Dark", "ai", "both", "Sophisticated dark with gold accents", color_schemes.get("Elegant Dark"), default_font_id, backgrounds.get("Elegant Dark"), 1, 0),
                ("Tech Modern", "ai", "both", "Sleek tech-focused design", color_schemes.get("Tech Modern"), default_font_id, backgrounds.get("Tech Modern"), 1, 0),
                ("Nature Fresh", "ai", "both", "Clean green-themed design", color_schemes.get("Nature Fresh"), default_font_id, backgrounds.get("Nature Fresh"), 1, 0),
                ("Creative Colorful", "ai", "both", "Vibrant multi-colored style", color_schemes.get("Creative Colorful"), default_font_id, backgrounds.get("Creative Colorful"), 1, 0),
                ("Sunset Glow", "ai", "both", "Warm sunset colors", color_schemes.get("Sunset Glow"), default_font_id, backgrounds.get("Sunset Glow"), 1, 0),
                ("Arctic Ice", "ai", "both", "Cool refreshing tones", color_schemes.get("Arctic Ice"), default_font_id, backgrounds.get("Arctic Ice"), 1, 0),
                ("Midnight Express", "ai", "both", "Dark night sleek theme", color_schemes.get("Midnight Express"), default_font_id, backgrounds.get("Midnight Express"), 1, 0),
                ("Royal Purple", "ai", "both", "Luxurious purple tones", color_schemes.get("Royal Purple"), default_font_id, backgrounds.get("Royal Purple"), 1, 0)
            ]
            cursor.executemany("INSERT INTO tbl_templates (name, template_type, available_for, description, color_scheme_id, font_id, background_id, is_active, is_default) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)", template_defaults)
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return jsonify({"success": True, "message": "Theme tables created with default data"})
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/themes/templates", methods=["GET", "POST", "PUT", "DELETE"])
def admin_manage_templates():
    """Manage presentation templates"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        if request.method == "GET":
            template_type = request.args.get("type", "all")
            if template_type == "all":
                cursor.execute("SELECT * FROM tbl_templates ORDER BY is_default DESC, name ASC")
            else:
                cursor.execute("SELECT * FROM tbl_templates WHERE template_type = %s ORDER BY is_default DESC, name ASC", (template_type,))
            templates = cursor.fetchall()
            
            # Convert boolean values and fetch related data
            for t in templates:
                t["is_active"] = bool(t["is_active"])
                t["is_default"] = bool(t["is_default"])
                
                # Fetch color scheme
                if t.get("color_scheme_id"):
                    cursor.execute("SELECT * FROM tbl_color_schemes WHERE id = %s", (t["color_scheme_id"],))
                    color_scheme = cursor.fetchone()
                    if color_scheme:
                        t["color_scheme"] = color_scheme
                
                # Fetch font
                if t.get("font_id"):
                    cursor.execute("SELECT * FROM tbl_fonts WHERE id = %s", (t["font_id"],))
                    font = cursor.fetchone()
                    if font:
                        t["font"] = font
                
                # Fetch background
                if t.get("background_id"):
                    cursor.execute("SELECT * FROM tbl_backgrounds WHERE id = %s", (t["background_id"],))
                    background = cursor.fetchone()
                    if background:
                        t["background"] = background
            
            cursor.close()
            conn.close()
            return jsonify(templates)
        
        elif request.method == "POST":
            data = request.get_json()
            name = data.get("name")
            template_type = data.get("template_type", "ai")
            available_for = data.get("available_for", "both")
            description = data.get("description", "")
            thumbnail = data.get("thumbnail")
            color_scheme_id = data.get("color_scheme_id")
            font_id = data.get("font_id")
            background_id = data.get("background_id")
            is_active = data.get("is_active", True)
            
            if not name:
                cursor.close()
                conn.close()
                return jsonify({"error": "Template name is required"}), 400
            
            # Check for duplicate template name
            cursor.execute("SELECT id FROM tbl_templates WHERE LOWER(name) = LOWER(%s)", (name,))
            if cursor.fetchone():
                cursor.close()
                conn.close()
                return jsonify({"error": f"A template with the name '{name}' already exists. Please choose a different name."}), 400
            
            # If color_scheme_id is required but not provided, return error
            if not color_scheme_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Color scheme is required. Please select a color scheme."}), 400
            
            # Auto-create image background if a background image URL was provided
            background_image_url = data.get("background_image_url")
            if background_image_url:
                # Create a new image-type background entry automatically
                bg_name = f"{name} Background"
                cursor.execute(
                    "INSERT INTO tbl_backgrounds (name, background_type, image_url, created_by) VALUES (%s, %s, %s, %s)",
                    (bg_name, "image", background_image_url, session.get("user_id"))
                )
                conn.commit()
                background_id = cursor.lastrowid
            
            cursor.execute(
                "INSERT INTO tbl_templates (name, template_type, available_for, description, thumbnail, color_scheme_id, font_id, background_id, is_active, created_by) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                (name, template_type, available_for, description, thumbnail, color_scheme_id, font_id, background_id, is_active, session.get("user_id"))
            )
            conn.commit()
            template_id = cursor.lastrowid
            
            # Clear dynamic themes cache to ensure new template is loaded
            try:
                from ppt_generator import clear_dynamic_themes_cache
                clear_dynamic_themes_cache()
            except:
                pass
            
            log_audit_action(session.get("user_id"), "ADD_TEMPLATE", f"Added template: {name} ({template_type}, available_for: {available_for})")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "id": template_id, "message": "Template added successfully"})
        
        elif request.method == "PUT":
            data = request.get_json()
            template_id = data.get("id")
            name = data.get("name")
            description = data.get("description")
            is_active = data.get("is_active")
            is_default = data.get("is_default")
            color_scheme_id = data.get("color_scheme_id")
            font_id = data.get("font_id")
            background_id = data.get("background_id")
            
            if not template_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Template ID is required"}), 400
            
            updates = []
            params = []
            
            if name is not None:
                updates.append("name = %s")
                params.append(name)
            if description is not None:
                updates.append("description = %s")
                params.append(description)
            if is_active is not None:
                updates.append("is_active = %s")
                params.append(is_active)
            if color_scheme_id is not None:
                updates.append("color_scheme_id = %s")
                params.append(color_scheme_id if color_scheme_id else None)
            if font_id is not None:
                updates.append("font_id = %s")
                params.append(font_id if font_id else None)
            if background_id is not None:
                updates.append("background_id = %s")
                params.append(background_id if background_id else None)
            if is_default is not None and is_default:
                # Unset other defaults
                cursor.execute("UPDATE tbl_templates SET is_default = FALSE WHERE template_type = (SELECT template_type FROM tbl_templates WHERE id = %s)", (template_id,))
                updates.append("is_default = TRUE")
            
            params.append(template_id)
            
            if updates:
                cursor.execute(f"UPDATE tbl_templates SET {', '.join(updates)} WHERE id = %s", params)
                conn.commit()
                
                # Clear dynamic themes cache to ensure changes are reflected
                try:
                    from ppt_generator import clear_dynamic_themes_cache
                    clear_dynamic_themes_cache()
                except:
                    pass
                
                log_audit_action(session.get("user_id"), "UPDATE_TEMPLATE", f"Updated template ID: {template_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Template updated successfully"})
        
        elif request.method == "DELETE":
            template_id = request.args.get("id")
            if not template_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Template ID is required"}), 400
            
            # Check if it's a default template
            cursor.execute("SELECT name, is_default FROM tbl_templates WHERE id = %s", (template_id,))
            template = cursor.fetchone()
            
            if template and template["is_default"]:
                cursor.close()
                conn.close()
                return jsonify({"error": "Cannot delete default template"}), 400
            
            cursor.execute("DELETE FROM tbl_templates WHERE id = %s AND is_default = FALSE", (template_id,))
            conn.commit()
            log_audit_action(session.get("user_id"), "DELETE_TEMPLATE", f"Deleted template ID: {template_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Template deleted successfully"})
    
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/themes/fonts", methods=["GET", "POST", "PUT", "DELETE"])
def admin_manage_fonts():
    """Manage fonts"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        if request.method == "GET":
            cursor.execute("SELECT * FROM tbl_fonts ORDER BY is_default DESC, display_name ASC")
            fonts = cursor.fetchall()
            
            for f in fonts:
                f["is_active"] = bool(f["is_active"])
                f["is_default"] = bool(f["is_default"])
            
            cursor.close()
            conn.close()
            return jsonify(fonts)
        
        elif request.method == "POST":
            data = request.get_json()
            name = data.get("name")
            display_name = data.get("display_name", name)
            font_family = data.get("font_family")
            font_url = data.get("font_url", "")
            
            if not name or not font_family:
                cursor.close()
                conn.close()
                return jsonify({"error": "Font name and font family are required"}), 400
            
            # Check for duplicate font name
            cursor.execute("SELECT id FROM tbl_fonts WHERE LOWER(name) = LOWER(%s) OR LOWER(display_name) = LOWER(%s)", (name, display_name))
            if cursor.fetchone():
                cursor.close()
                conn.close()
                return jsonify({"error": f"A font with the name '{name}' already exists. Please choose a different name."}), 400
            
            cursor.execute(
                "INSERT INTO tbl_fonts (name, display_name, font_family, font_url, created_by) VALUES (%s, %s, %s, %s, %s)",
                (name, display_name, font_family, font_url, session.get("user_id"))
            )
            conn.commit()
            font_id = cursor.lastrowid
            log_audit_action(session.get("user_id"), "ADD_FONT", f"Added font: {name}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "id": font_id, "message": "Font added successfully"})
        
        elif request.method == "PUT":
            data = request.get_json()
            font_id = data.get("id")
            name = data.get("name")
            display_name = data.get("display_name")
            font_family = data.get("font_family")
            font_url = data.get("font_url")
            is_active = data.get("is_active")
            is_default = data.get("is_default")
            
            if not font_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Font ID is required"}), 400
            
            updates = []
            params = []
            
            if name is not None:
                updates.append("name = %s")
                params.append(name)
            if display_name is not None:
                updates.append("display_name = %s")
                params.append(display_name)
            if font_family is not None:
                updates.append("font_family = %s")
                params.append(font_family)
            if font_url is not None:
                updates.append("font_url = %s")
                params.append(font_url)
            if is_active is not None:
                updates.append("is_active = %s")
                params.append(is_active)
            if is_default is not None and is_default:
                cursor.execute("UPDATE tbl_fonts SET is_default = FALSE")
                updates.append("is_default = TRUE")
            
            params.append(font_id)
            
            if updates:
                cursor.execute(f"UPDATE tbl_fonts SET {', '.join(updates)} WHERE id = %s", params)
                conn.commit()
                log_audit_action(session.get("user_id"), "UPDATE_FONT", f"Updated font ID: {font_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Font updated successfully"})
        
        elif request.method == "DELETE":
            font_id = request.args.get("id")
            if not font_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Font ID is required"}), 400
            
            cursor.execute("SELECT name, is_default FROM tbl_fonts WHERE id = %s", (font_id,))
            font = cursor.fetchone()
            
            if font and font["is_default"]:
                cursor.close()
                conn.close()
                return jsonify({"error": "Cannot delete default font"}), 400
            
            cursor.execute("DELETE FROM tbl_fonts WHERE id = %s AND is_default = FALSE", (font_id,))
            conn.commit()
            log_audit_action(session.get("user_id"), "DELETE_FONT", f"Deleted font ID: {font_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Font deleted successfully"})
    
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/themes/colors", methods=["GET", "POST", "PUT", "DELETE"])
def admin_manage_colors():
    """Manage color schemes"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        if request.method == "GET":
            cursor.execute("SELECT * FROM tbl_color_schemes ORDER BY is_default DESC, name ASC")
            colors = cursor.fetchall()
            
            for c in colors:
                c["is_active"] = bool(c["is_active"])
                c["is_default"] = bool(c["is_default"])
            
            cursor.close()
            conn.close()
            return jsonify(colors)
        
        elif request.method == "POST":
            data = request.get_json()
            name = data.get("name")
            primary_color = data.get("primary_color")
            secondary_color = data.get("secondary_color", "")
            accent_color = data.get("accent_color", "")
            background_color = data.get("background_color", "#ffffff")
            text_color = data.get("text_color", "#333333")
            
            if not name or not primary_color:
                cursor.close()
                conn.close()
                return jsonify({"error": "Name and primary color are required"}), 400
            
            # Check for duplicate color scheme name
            cursor.execute("SELECT id FROM tbl_color_schemes WHERE LOWER(name) = LOWER(%s)", (name,))
            if cursor.fetchone():
                cursor.close()
                conn.close()
                return jsonify({"error": f"A color scheme with the name '{name}' already exists. Please choose a different name."}), 400
            
            cursor.execute(
                "INSERT INTO tbl_color_schemes (name, primary_color, secondary_color, accent_color, background_color, text_color, created_by) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                (name, primary_color, secondary_color, accent_color, background_color, text_color, session.get("user_id"))
            )
            conn.commit()
            color_id = cursor.lastrowid
            log_audit_action(session.get("user_id"), "ADD_COLOR_SCHEME", f"Added color scheme: {name}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "id": color_id, "message": "Color scheme added successfully"})
        
        elif request.method == "PUT":
            data = request.get_json()
            color_id = data.get("id")
            name = data.get("name")
            primary_color = data.get("primary_color")
            secondary_color = data.get("secondary_color")
            accent_color = data.get("accent_color")
            background_color = data.get("background_color")
            text_color = data.get("text_color")
            is_active = data.get("is_active")
            is_default = data.get("is_default")
            
            if not color_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Color scheme ID is required"}), 400
            
            updates = []
            params = []
            
            if name is not None:
                updates.append("name = %s")
                params.append(name)
            if primary_color is not None:
                updates.append("primary_color = %s")
                params.append(primary_color)
            if secondary_color is not None:
                updates.append("secondary_color = %s")
                params.append(secondary_color)
            if accent_color is not None:
                updates.append("accent_color = %s")
                params.append(accent_color)
            if background_color is not None:
                updates.append("background_color = %s")
                params.append(background_color)
            if text_color is not None:
                updates.append("text_color = %s")
                params.append(text_color)
            if is_active is not None:
                updates.append("is_active = %s")
                params.append(is_active)
            if is_default is not None and is_default:
                cursor.execute("UPDATE tbl_color_schemes SET is_default = FALSE")
                updates.append("is_default = TRUE")
            
            params.append(color_id)
            
            if updates:
                cursor.execute(f"UPDATE tbl_color_schemes SET {', '.join(updates)} WHERE id = %s", params)
                conn.commit()
                log_audit_action(session.get("user_id"), "UPDATE_COLOR_SCHEME", f"Updated color scheme ID: {color_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Color scheme updated successfully"})
        
        elif request.method == "DELETE":
            color_id = request.args.get("id")
            if not color_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Color scheme ID is required"}), 400
            
            cursor.execute("SELECT name, is_default FROM tbl_color_schemes WHERE id = %s", (color_id,))
            color = cursor.fetchone()
            
            if color and color["is_default"]:
                cursor.close()
                conn.close()
                return jsonify({"error": "Cannot delete default color scheme"}), 400
            
            cursor.execute("DELETE FROM tbl_color_schemes WHERE id = %s AND is_default = FALSE", (color_id,))
            conn.commit()
            log_audit_action(session.get("user_id"), "DELETE_COLOR_SCHEME", f"Deleted color scheme ID: {color_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Color scheme deleted successfully"})
    
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/themes/backgrounds", methods=["GET", "POST", "PUT", "DELETE"])
def admin_manage_backgrounds():
    """Manage backgrounds"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        if request.method == "GET":
            bg_type = request.args.get("type", "all")
            if bg_type == "all":
                cursor.execute("SELECT * FROM tbl_backgrounds ORDER BY is_default DESC, name ASC")
            else:
                cursor.execute("SELECT * FROM tbl_backgrounds WHERE background_type = %s ORDER BY is_default DESC, name ASC", (bg_type,))
            backgrounds = cursor.fetchall()
            
            for b in backgrounds:
                b["is_active"] = bool(b["is_active"])
                b["is_default"] = bool(b["is_default"])
            
            cursor.close()
            conn.close()
            return jsonify(backgrounds)
        
        elif request.method == "POST":
            data = request.get_json()
            name = data.get("name")
            bg_type = data.get("background_type", "solid")
            image_url = data.get("image_url", "")
            gradient_colors = data.get("gradient_colors")
            solid_color = data.get("solid_color", "")
            
            if not name:
                cursor.close()
                conn.close()
                return jsonify({"error": "Background name is required"}), 400
            
            # Check for duplicate background name
            cursor.execute("SELECT id FROM tbl_backgrounds WHERE LOWER(name) = LOWER(%s)", (name,))
            if cursor.fetchone():
                cursor.close()
                conn.close()
                return jsonify({"error": f"A background with the name '{name}' already exists. Please choose a different name."}), 400
            
            if bg_type == "image" and not image_url:
                cursor.close()
                conn.close()
                return jsonify({"error": "Image URL is required for image backgrounds"}), 400
            
            if bg_type == "solid" and not solid_color:
                cursor.close()
                conn.close()
                return jsonify({"error": "Solid color is required"}), 400
            
            if bg_type == "gradient" and not gradient_colors:
                cursor.close()
                conn.close()
                return jsonify({"error": "Gradient colors are required"}), 400
            
            cursor.execute(
                "INSERT INTO tbl_backgrounds (name, background_type, image_url, gradient_colors, solid_color, created_by) VALUES (%s, %s, %s, %s, %s, %s)",
                (name, bg_type, image_url, json.dumps(gradient_colors) if gradient_colors else None, solid_color, session.get("user_id"))
            )
            conn.commit()
            bg_id = cursor.lastrowid
            log_audit_action(session.get("user_id"), "ADD_BACKGROUND", f"Added background: {name}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "id": bg_id, "message": "Background added successfully"})
        
        elif request.method == "PUT":
            data = request.get_json()
            bg_id = data.get("id")
            name = data.get("name")
            bg_type = data.get("background_type")
            image_url = data.get("image_url")
            gradient_colors = data.get("gradient_colors")
            solid_color = data.get("solid_color")
            is_active = data.get("is_active")
            is_default = data.get("is_default")
            
            if not bg_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Background ID is required"}), 400
            
            updates = []
            params = []
            
            if name is not None:
                updates.append("name = %s")
                params.append(name)
            if bg_type is not None:
                updates.append("background_type = %s")
                params.append(bg_type)
            if image_url is not None:
                updates.append("image_url = %s")
                params.append(image_url)
            if gradient_colors is not None:
                updates.append("gradient_colors = %s")
                params.append(json.dumps(gradient_colors))
            if solid_color is not None:
                updates.append("solid_color = %s")
                params.append(solid_color)
            if is_active is not None:
                updates.append("is_active = %s")
                params.append(is_active)
            if is_default is not None and is_default:
                cursor.execute("UPDATE tbl_backgrounds SET is_default = FALSE")
                updates.append("is_default = TRUE")
            
            params.append(bg_id)
            
            if updates:
                cursor.execute(f"UPDATE tbl_backgrounds SET {', '.join(updates)} WHERE id = %s", params)
                conn.commit()
                log_audit_action(session.get("user_id"), "UPDATE_BACKGROUND", f"Updated background ID: {bg_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Background updated successfully"})
        
        elif request.method == "DELETE":
            bg_id = request.args.get("id")
            if not bg_id:
                cursor.close()
                conn.close()
                return jsonify({"error": "Background ID is required"}), 400
            
            cursor.execute("SELECT name, is_default FROM tbl_backgrounds WHERE id = %s", (bg_id,))
            bg = cursor.fetchone()
            
            if bg and bg["is_default"]:
                cursor.close()
                conn.close()
                return jsonify({"error": "Cannot delete default background"}), 400
            
            cursor.execute("DELETE FROM tbl_backgrounds WHERE id = %s AND is_default = FALSE", (bg_id,))
            conn.commit()
            log_audit_action(session.get("user_id"), "DELETE_BACKGROUND", f"Deleted background ID: {bg_id}")
            
            cursor.close()
            conn.close()
            return jsonify({"success": True, "message": "Background deleted successfully"})
    
    except Exception as e:
        conn.rollback()
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


# API endpoints for customers to fetch active design assets
@app.route("/api/themes/templates", methods=["GET"])
def get_templates():
    """Get active templates for customers"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        template_type = request.args.get("type", "ai")
        
        # Get templates with color scheme, font, and background info
        query = """
            SELECT 
                t.id, t.name, t.description, t.thumbnail, t.template_type,
                t.color_scheme_id, t.font_id, t.background_id,
                cs.primary_color, cs.secondary_color, cs.accent_color, cs.background_color, cs.text_color,
                f.font_family, f.display_name as font_name,
                b.background_type, b.image_url, b.gradient_colors, b.solid_color
            FROM tbl_templates t
            LEFT JOIN tbl_color_schemes cs ON t.color_scheme_id = cs.id
            LEFT JOIN tbl_fonts f ON t.font_id = f.id
            LEFT JOIN tbl_backgrounds b ON t.background_id = b.id
            WHERE t.is_active = TRUE 
                AND (t.template_type = %s OR t.available_for = 'both')
            ORDER BY t.is_default DESC, t.name ASC
        """
        cursor.execute(query, (template_type,))
        templates = cursor.fetchall()
        
        # Format the response
        formatted_templates = []
        for t in templates:
            template_data = {
                'id': t['id'],
                'name': t['name'],
                'description': t['description'],
                'thumbnail': t['thumbnail'],
                'template_type': t['template_type'],
            }
            
            # Add color scheme if available
            if t['color_scheme_id']:
                template_data['color_scheme'] = {
                    'id': t['color_scheme_id'],
                    'primary_color': t['primary_color'],
                    'secondary_color': t['secondary_color'],
                    'accent_color': t['accent_color'],
                    'background_color': t['background_color'],
                    'text_color': t['text_color']
                }
            
            # Add background if available
            if t['background_id']:
                template_data['background'] = {
                    'id': t['background_id'],
                    'bg_type': t['background_type'],
                    'image_url': t['image_url'],
                    'gradient_colors': t['gradient_colors'],
                    'solid_color': t['solid_color']
                }
            
            # Add font if available
            if t['font_id']:
                template_data['font'] = {
                    'id': t['font_id'],
                    'font_family': t['font_family'],
                    'font_name': t['font_name']
                }
            
            formatted_templates.append(template_data)
        
        cursor.close()
        conn.close()
        return jsonify(formatted_templates)
    except Exception as e:
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/api/themes/fonts", methods=["GET"])
def get_fonts():
    """Get active fonts for customers"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT id, name, display_name, font_family, font_url FROM tbl_fonts WHERE is_active = TRUE ORDER BY is_default DESC, display_name ASC")
        fonts = cursor.fetchall()
        
        cursor.close()
        conn.close()
        return jsonify(fonts)
    except Exception as e:
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/api/themes/colors", methods=["GET"])
def get_color_schemes():
    """Get active color schemes for customers"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT id, name, primary_color, secondary_color, accent_color, background_color, text_color FROM tbl_color_schemes WHERE is_active = TRUE ORDER BY is_default DESC, name ASC")
        colors = cursor.fetchall()
        
        cursor.close()
        conn.close()
        return jsonify(colors)
    except Exception as e:
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/api/themes/backgrounds", methods=["GET"])
def get_backgrounds():
    """Get active backgrounds for customers"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        bg_type = request.args.get("type", "all")
        if bg_type == "all":
            cursor.execute("SELECT id, name, background_type, image_url, gradient_colors, solid_color, thumbnail FROM tbl_backgrounds WHERE is_active = TRUE ORDER BY is_default DESC, name ASC")
        else:
            cursor.execute("SELECT id, name, background_type, image_url, gradient_colors, solid_color, thumbnail FROM tbl_backgrounds WHERE is_active = TRUE AND background_type = %s ORDER BY is_default DESC, name ASC", (bg_type,))
        backgrounds = cursor.fetchall()
        
        # Parse JSON gradient_colors
        for bg in backgrounds:
            if bg["gradient_colors"]:
                try:
                    bg["gradient_colors"] = json.loads(bg["gradient_colors"])
                except:
                    pass
        
        cursor.close()
        conn.close()
        return jsonify(backgrounds)
    except Exception as e:
        cursor.close()
        conn.close()
        return jsonify({"error": str(e)}), 500


@app.route("/admin/api/themes/upload", methods=["POST"])
def admin_upload_theme_file():
    """Upload theme assets (templates, backgrounds, fonts)"""
    auth_check = admin_required()
    if auth_check:
        return jsonify({"error": "Unauthorized"}), 401
    
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400
    
    # Get file type from form
    file_type = request.form.get('type', 'background')
    
    # Define allowed extensions and MIME types
    allowed_extensions = {
        'background': {'png', 'jpg', 'jpeg', 'gif', 'svg'},
        'font': {'ttf', 'woff', 'woff2', 'otf'},
        'template': {'png', 'jpg', 'jpeg'}
    }
    
    # Define allowed MIME types
    allowed_mime_types = {
        'image/png': 'png',
        'image/jpeg': 'jpg',
        'image/jpeg': 'jpeg',
        'image/gif': 'gif',
        'image/svg+xml': 'svg',
        'font/ttf': 'ttf',
        'font/woff': 'woff',
        'font/woff2': 'woff2',
        'font/otf': 'otf',
        'application/x-font-ttf': 'ttf',
        'application/x-font-woff': 'woff',
        'application/font-woff': 'woff',
        'application/font-woff2': 'woff2',
        'application/x-font-otf': 'otf',
        'application/vnd.ms-fontobject': 'otf'
    }
    
    # Check file extension
    ext = file.filename.rsplit('.', 1)[-1].lower() if '.' in file.filename else ''
    if not ext:
        return jsonify({"error": "File has no extension"}), 400
    
    # Get allowed extensions based on file type
    type_extensions = allowed_extensions.get(file_type, allowed_extensions['background'])
    if ext not in type_extensions:
        return jsonify({"error": f"File type '.{ext}' not allowed for {file_type}. Allowed: {', '.join(type_extensions)}"}), 400
    
    # Validate MIME type
    file_mime_type = file.content_type
    
    # For font files, browsers often send application/octet-stream
    # So we also check if the extension is a font type
    is_font_by_extension = ext in {'ttf', 'woff', 'woff2', 'otf'}
    
    if file_mime_type and file_mime_type not in allowed_mime_types:
        # Allow application/octet-stream for font files if extension is valid
        if not (file_mime_type == 'application/octet-stream' and is_font_by_extension):
            return jsonify({"error": f"Invalid MIME type: {file_mime_type}. Allowed types: {', '.join(allowed_mime_types.keys())}"}), 400
    
    # If no MIME type or unknown, try to determine from extension
    if not file_mime_type or file_mime_type == 'application/octet-stream':
        mime_from_ext = {
            'ttf': 'font/ttf',
            'woff': 'font/woff',
            'woff2': 'font/woff2',
            'otf': 'font/otf',
            'png': 'image/png',
            'jpg': 'image/jpeg',
            'jpeg': 'image/jpeg',
            'gif': 'image/gif',
            'svg': 'image/svg+xml'
        }.get(ext)
        if mime_from_ext:
            file_mime_type = mime_from_ext
    
    # Create uploads directory if not exists
    upload_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'theme_uploads')
    try:
        os.makedirs(upload_dir, exist_ok=True)
    except OSError as e:
        return jsonify({"error": f"Failed to create upload directory: {str(e)}"}), 500
    
    # Generate unique filename
    import uuid
    filename = f"{uuid.uuid4().hex}_{file.filename}"
    filepath = os.path.join(upload_dir, filename)
    
    # Save file with error handling
    try:
        file.save(filepath)
    except Exception as e:
        return jsonify({"error": f"Failed to save file: {str(e)}"}), 500
    
    # Verify file was saved
    if not os.path.exists(filepath):
        return jsonify({"error": "File was not saved properly"}), 500
    
    # Get file size
    file_size = os.path.getsize(filepath)
    max_size = 10 * 1024 * 1024  # 10MB max
    if file_size > max_size:
        os.remove(filepath)
        return jsonify({"error": f"File too large. Maximum size: 10MB"}), 400
    
    # Return the URL path
    file_url = f"/theme_uploads/{filename}"
    
    log_audit_action(session.get("user_id"), "UPLOAD_THEME_FILE", f"Uploaded {file_type}: {filename} ({file_size} bytes)")
    
    return jsonify({
        "success": True,
        "url": file_url,
        "filename": filename,
        "size": file_size,
        "type": ext
    })


# Serve theme uploaded files
@app.route("/theme_uploads/<filename>")
def serve_theme_file(filename):
    return send_from_directory(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'theme_uploads'), filename)


# -------------------------------------------------
# SERVE PREVIEW IMAGES
# -------------------------------------------------

@app.route("/generated_previews/<ppt_folder>/<img_name>")
def preview_image(ppt_folder, img_name):
    if "user_id" not in session:
        return redirect(url_for("login"))

    folder_path = os.path.join(PREVIEW_DIR, ppt_folder)
    return send_from_directory(folder_path, img_name)

# -------------------------------------------------

# RUN APP
# -------------------------------------------------

if __name__ == "__main__":
    # Install any missing Google Fonts on first run
    try:
        from install_fonts import ensure_fonts_installed
        ensure_fonts_installed(quiet=False)
    except Exception as e:
        print(f"[Fonts] Auto-install skipped: {e}")

    # Deactivate variable/problematic Google fonts (they don't render in PowerPoint)
    try:
        _conn = get_db_connection()
        _cur = _conn.cursor()
        _variable = ['Roboto', 'Open Sans', 'Montserrat', 'Playfair Display', 'DM Sans', 'Inter',
                      'Raleway', 'Nunito', 'Oswald', 'Merriweather', 'Libre Baskerville',
                      'Noto Sans', 'Work Sans', 'Quicksand', 'Rubik', 'Karla', 'Josefin Sans',
                      'Cabin', 'Manrope', 'Outfit', 'Space Grotesk', 'Sora',
                      'Plus Jakarta Sans', 'Source Sans 3']
        _ph = ','.join(['%s'] * len(_variable))
        _cur.execute(f"UPDATE tbl_fonts SET is_active = FALSE WHERE name IN ({_ph})", _variable)
        _conn.commit()
        _cur.close()
        _conn.close()
    except Exception as e:
        print(f"[Fonts] DB cleanup skipped: {e}")

    app.run(debug=True)
