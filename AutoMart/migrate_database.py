"""
AutoMart Cloud Database Setup & Migration Script
This script migrates your local database tables and data to any cloud MySQL database
(e.g., TiDB Cloud, Aiven, Clever Cloud, Railway, etc.) and provides the exact
environment variables to set in Render.
"""

import sys
import os
import urllib.parse
import pymysql

LOCAL_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'automart_db'
}

TABLES = [
    'Users',
    'Admin',
    'Brands',
    'Cars',
    'VehicleImages',
    'Wishlist',
    'ContactRequests'
]

def parse_connection_string(conn_str):
    """Parses a MySQL connection URI into connection parameters."""
    conn_str = conn_str.strip()
    if conn_str.startswith('jdbc:mysql://'):
        conn_str = conn_str[len('jdbc:'):]
    
    if not conn_str.startswith('mysql://'):
        conn_str = 'mysql://' + conn_str
        
    parsed = urllib.parse.urlparse(conn_str)
    
    host = parsed.hostname
    port = parsed.port if parsed.port else 3306
    user = parsed.username if parsed.username else 'root'
    password = parsed.password if parsed.password else ''
    database = parsed.path.lstrip('/') if parsed.path else 'defaultdb'
    
    return {
        'host': host,
        'port': port,
        'user': user,
        'password': password,
        'database': database
    }

def main():
    print("=" * 65)
    print("      🚗 AutoMart - Cloud Database Migration Utility 🚗")
    print("=" * 65)

    remote_config = {}

    if len(sys.argv) > 1:
        arg = sys.argv[1]
        if '://' in arg or '@' in arg:
            remote_config = parse_connection_string(arg)
        else:
            remote_config['host'] = arg
            remote_config['port'] = int(sys.argv[2]) if len(sys.argv) > 2 else 3306
            remote_config['user'] = sys.argv[3] if len(sys.argv) > 3 else 'root'
            remote_config['password'] = sys.argv[4] if len(sys.argv) > 4 else ''
            remote_config['database'] = sys.argv[5] if len(sys.argv) > 5 else 'defaultdb'
    else:
        print("\nEnter your Cloud Database Details (TiDB Cloud, Aiven, etc.)")
        print("You can paste the entire Connection URI (e.g., mysql://user:pass@host:port/db)")
        print("or press Enter to enter individual fields.\n")
        
        uri_input = input("Connection URI (leave blank to enter fields individually): ").strip()
        if uri_input:
            remote_config = parse_connection_string(uri_input)
        else:
            remote_config['host'] = input("Host (e.g. gateway01... or mysql-...): ").strip()
            port_input = input("Port [default: 3306 or 28631]: ").strip()
            remote_config['port'] = int(port_input) if port_input else 3306
            remote_config['user'] = input("User (e.g. avnadmin, root, xxx.root): ").strip()
            remote_config['password'] = input("Password: ").strip()
            db_input = input("Database Name [default: defaultdb]: ").strip()
            remote_config['database'] = db_input if db_input else 'defaultdb'

    print("\n[1/4] Connecting to Local Database (localhost:3306)...")
    try:
        local_conn = pymysql.connect(
            host=LOCAL_CONFIG['host'],
            port=LOCAL_CONFIG['port'],
            user=LOCAL_CONFIG['user'],
            password=LOCAL_CONFIG['password'],
            database=LOCAL_CONFIG['database']
        )
        local_cursor = local_conn.cursor(pymysql.cursors.DictCursor)
        print("  -> Connected successfully to local 'automart_db'!")
    except Exception as e:
        print(f"  ❌ ERROR connecting to local database: {e}")
        print("     Ensure your local MySQL server is running on port 3306.")
        return

    print(f"\n[2/4] Connecting to Cloud Database ({remote_config['host']}:{remote_config['port']})...")
    try:
        remote_conn = pymysql.connect(
            host=remote_config['host'],
            port=remote_config['port'],
            user=remote_config['user'],
            password=remote_config['password'],
            database=remote_config['database'],
            ssl={'ssl': {}},
            connect_timeout=20
        )
        remote_cursor = remote_conn.cursor()
        print("  -> Connected successfully to Cloud Database!")
    except Exception as e:
        print(f"  ❌ ERROR connecting to Cloud Database: {e}")
        print("     Check that the host, port, user, and password are correct and the service is running.")
        local_conn.close()
        return

    print("\n[3/4] Creating tables and schema on Cloud Database...")
    schema_path = os.path.join(os.path.dirname(__file__), 'database', 'automart_schema.sql')
    if os.path.exists(schema_path):
        with open(schema_path, 'r', encoding='utf-8') as f:
            sql_script = f.read()

        remote_cursor.execute("SET FOREIGN_KEY_CHECKS=0;")
        for stmt in sql_script.split(';'):
            stmt = stmt.strip()
            if stmt and ('CREATE TABLE' in stmt.upper() or 'ALTER TABLE' in stmt.upper()):
                try:
                    remote_cursor.execute(stmt)
                except Exception as err:
                    print(f"     Notice: {err}")
        remote_conn.commit()
        print("  -> Schema & tables verified successfully!")
    else:
        print("  -> Schema file not found, will rely on existing remote tables.")

    print("\n[4/4] Migrating data from Local to Cloud Database...")
    remote_cursor.execute("SET FOREIGN_KEY_CHECKS=0;")

    for table in TABLES:
        try:
            local_cursor.execute(f"SELECT * FROM `{table}`")
            rows = local_cursor.fetchall()
            if not rows:
                print(f"  -> {table}: 0 records (empty table, skipped).")
                continue

            columns = rows[0].keys()
            col_names = ', '.join([f"`{c}`" for c in columns])
            placeholders = ', '.join(['%s'] * len(columns))
            insert_sql = f"REPLACE INTO `{table}` ({col_names}) VALUES ({placeholders})"

            for row in rows:
                values = tuple(row.values())
                remote_cursor.execute(insert_sql, values)

            remote_conn.commit()
            print(f"  -> {table}: {len(rows)} records migrated successfully.")
        except Exception as err:
            print(f"  ❌ Warning on table '{table}': {err}")

    remote_cursor.execute("SET FOREIGN_KEY_CHECKS=1;")
    remote_conn.commit()

    local_conn.close()
    remote_conn.close()

    jdbc_url = f"jdbc:mysql://{remote_config['host']}:{remote_config['port']}/{remote_config['database']}?useSSL=true&sslMode=REQUIRED"

    print("\n" + "=" * 65)
    print("  🎉 MIGRATION COMPLETED SUCCESSFULLY! 🎉")
    print("=" * 65)
    print("\nSet these Environment Variables in your Render Dashboard:")
    print("-" * 65)
    print(f"DB_URL      : {jdbc_url}")
    print(f"DB_USER     : {remote_config['user']}")
    print(f"DB_PASSWORD : {remote_config['password']}")
    print("-" * 65)
    print("\nAfter updating Render Environment Variables, click 'Manual Deploy' > 'Deploy latest commit' in Render!")

if __name__ == '__main__':
    main()
