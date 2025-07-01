import subprocess
import logging
import sys
import os
from pathlib import Path

LOG_FILE = "/home/fcheded/farah_custom_data.log"
APP_USER = "fcheded"
REPO_PATH = f"/home/{APP_USER}/repo"
APP_DIR = f"{REPO_PATH}/nodejs20-sparta-test-app/app"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(sys.stdout)
    ]
)

def run_cmd(cmd, **kwargs):
    logging.info(f"Running: {cmd}")
    subprocess.run(cmd, check=True, **kwargs)
    logging.info(f"Done: {cmd}")

def apt_install(packages):
    for pkg in packages:
        result = subprocess.run(
            ["dpkg", "-s", pkg], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        if result.returncode != 0:
            logging.info(f"Installing package: {pkg}")
            run_cmd(["sudo", "DEBIAN_FRONTEND=noninteractive", "apt-get", "install", "-y", pkg])
        else:
            logging.info(f"Package {pkg} already installed")

logging.info("Updating package lists...")
run_cmd(["sudo", "apt-get", "update", "-y"])

logging.info("Upgrading installed packages...")
run_cmd("sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq", shell=True)

apt_install(["nano", "git"])

logging.info("Installing Nginx...")
apt_install(["nginx"])
run_cmd(["sudo", "systemctl", "enable", "nginx"])
run_cmd(["sudo", "systemctl", "reload", "nginx"])

logging.info("Configuring Nginx reverse proxy...")
run_cmd(
    ["sudo", "sed", "-i",
     "s|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|",
     "/etc/nginx/sites-available/default"]
)

logging.info("Checking Nginx configuration syntax...")
run_cmd(["sudo", "nginx", "-t"])

logging.info("Reloading Nginx...")
run_cmd(["sudo", "systemctl", "reload", "nginx"])

logging.info("Downloading and installing Node.js 20.x...")
run_cmd(
    "sudo DEBIAN_FRONTEND=noninteractive bash -c \"curl -fsSL https://deb.nodesource.com/setup_20.x | bash -\"",
    shell=True
)
apt_install(["nodejs"])

logging.info("Checking Node.js and npm versions...")
run_cmd(["node", "-v"])
run_cmd(["npm", "-v"])

# Clone repo if missing
if not Path(REPO_PATH).exists():
    logging.info("Cloning the application repository...")
    run_cmd(["sudo", "git", "clone", "https://github.com/farahc123/tech501-sparta-app.git", REPO_PATH])
else:
    logging.info("Repository already cloned.")

# Change ownership to fcheded user
run_cmd(["sudo", "chown", "-R", f"{APP_USER}:{APP_USER}", REPO_PATH])

os.chdir(APP_DIR)

# Check for mongoose and install node modules if missing
node_modules_path = Path(APP_DIR) / "node_modules"
if not node_modules_path.exists():
    logging.info("node_modules not found — installing dependencies...")
    run_cmd(["npm", "install"])
else:
    try:
        subprocess.run(["node", "-e", "require('mongoose')"], check=True, stdout=subprocess.DEVNULL)
        logging.info("Mongoose already installed.")
    except subprocess.CalledProcessError:
        logging.warning("mongoose not found — cleaning and reinstalling dependencies...")
        run_cmd(["rm", "-rf", "node_modules", "package-lock.json"])
        run_cmd(["npm", "install"])

# Check and install PM2 globally if missing
pm2_check = subprocess.run("which pm2", shell=True, stdout=subprocess.DEVNULL)
if pm2_check.returncode != 0:
    logging.info("Installing PM2 globally...")
    run_cmd(["sudo", "npm", "install", "-g", "pm2"])
else:
    logging.info("PM2 already installed.")

os.environ["DB_HOST"] = "mongodb://10.0.1.2:27017/posts"

logging.info("Seeding the database...")
try:
    run_cmd(["node", "seeds/seed.js"])
except subprocess.CalledProcessError as e:
    logging.error("Database seeding failed.")
    logging.error(e)
    sys.exit(1)
else:
    logging.info("Database seeding completed.")

logging.info("Stopping PM2 app (if running)...")
subprocess.run(["pm2", "delete", "app.js"], check=False)

logging.info("Starting app with PM2...")
run_cmd(["pm2", "start", "app.js"])

logging.info(f"Script execution completed. Logs stored in {LOG_FILE}")
