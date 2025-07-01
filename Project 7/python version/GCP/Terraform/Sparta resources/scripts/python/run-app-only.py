import subprocess
import logging
import sys
import os

LOG_FILE = "/home/fcheded/farah_running_app_only.log"
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(sys.stdout)
    ]
)

logging.info("Changing directory to application folder...")
os.chdir("/repo/nodejs20-sparta-test-app/app")

logging.info("Installing npm dependencies...")
subprocess.run(["sudo", "npm", "install"], check=True)

# Note in log only — like your original script
logging.info("Setting up database connection... (mongodb://10.0.3.4:27017/posts)")
os.environ["DB_HOST"] = "mongodb://10.0.1.2:27017/posts"

logging.info("Seeding the database...")
subprocess.run(["node", "seeds/seed.js"], check=True)

logging.info("Stopping the application using PM2...")
subprocess.run(["pm2", "delete", "app.js"], check=False)  # No error if not running

logging.info("Starting the application using PM2...")
subprocess.run(["pm2", "start", "app.js"], check=True)

logging.info(f"Script execution completed. Logs stored in {LOG_FILE}")
