import subprocess
import logging
import sys
import os

LOG_FILE = "/home/fcheded/farah_custom_data.log"
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(message)s",
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler(sys.stdout)
    ]
)

def run_cmd(command, **kwargs):
    logging.info(f"Running: {command}")
    subprocess.run(command, check=True, **kwargs)
    logging.info(f"Done: {command}")

logging.info("Starting MongoDB provisioning script.")

# Step 1: Update package lists
logging.info("Updating package lists...")
run_cmd(["sudo", "apt", "update", "-y"])

# Step 2: Upgrade installed packages
logging.info("Upgrading installed packages...")
run_cmd("sudo DEBIAN_FRONTEND=noninteractive apt upgrade -yq", shell=True)

# Step 3: Install nano if not already installed
logging.info("Ensuring nano is installed...")
nano_check = subprocess.run(["which", "nano"], capture_output=True)
if nano_check.returncode != 0:
    run_cmd("sudo DEBIAN_FRONTEND=noninteractive apt install -y nano", shell=True)
else:
    logging.info("Nano is already installed.")

# Step 4: Install gnupg and curl
logging.info("Installing gnupg and curl if needed...")
run_cmd("sudo DEBIAN_FRONTEND=noninteractive apt install -y gnupg curl", shell=True)

# Step 5: Add MongoDB GPG key (if not already added)
GPG_PATH = "/usr/share/keyrings/mongodb-server-7.0.gpg"
if not os.path.exists(GPG_PATH):
    logging.info("Adding MongoDB GPG key...")
    run_cmd(
        "curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | "
        f"sudo gpg --batch --yes -o {GPG_PATH} --dearmor",
        shell=True
    )
    logging.info("Done: MongoDB GPG key added.")
else:
    logging.info("MongoDB GPG key already exists.")

# Step 6: Add MongoDB repo (if not already present)
REPO_FILE = "/etc/apt/sources.list.d/mongodb-org-7.0.list"
repo_line = (
    "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] "
    "https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse"
)
if not os.path.exists(REPO_FILE) or repo_line not in open(REPO_FILE).read():
    logging.info("Adding MongoDB repository...")
    run_cmd(
        f"echo '{repo_line}' | sudo tee {REPO_FILE}",
        shell=True
    )
    logging.info("Done: MongoDB repository added.")
else:
    logging.info("MongoDB repository already exists.")

# Step 7: Update package lists again
logging.info("Updating package lists after MongoDB repo added...")
run_cmd(["sudo", "apt", "update", "-y"])
logging.info("Done: package lists updated after MongoDB repo added.")

# Step 8: Install MongoDB components (only if not at desired version)
mongo_packages = [
    "mongodb-org", "mongodb-org-database", "mongodb-org-server",
    "mongodb-mongosh", "mongodb-org-mongos", "mongodb-org-tools"
]
required_version = "7.0.6"
installed = subprocess.run(
    "dpkg -l | grep mongodb-org | grep 7.0.6", shell=True, stdout=subprocess.DEVNULL
)
if installed.returncode != 0:
    logging.info("Installing MongoDB 7.0.6 components...")
    run_cmd(
        "sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_MODE=a "
        f"apt install -y --allow-downgrades {' '.join([f'{pkg}={required_version}' if 'mongosh' not in pkg else pkg for pkg in mongo_packages])}",
        shell=True
    )
    logging.info("Done: MongoDB 7.0.6 installed.")
else:
    logging.info("MongoDB 7.0.6 already installed. Skipping reinstallation.")

# Step 9: Update mongod.conf bindIp setting (only if not already updated)
conf_path = "/etc/mongod.conf"
with open(conf_path, "r") as f:
    config_content = f.read()

if "bindIp: 0.0.0.0" not in config_content:
    logging.info("Updating MongoDB bindIp setting to listen to all sources...")
    run_cmd(["sudo", "sed", "-i", "s/bindIp: 127.0.0.1/bindIp: 0.0.0.0/", conf_path])
    logging.info("Done: bindIp updated.")
else:
    logging.info("MongoDB bindIp already set to 0.0.0.0.")

# Step 10: Enable MongoDB service
logging.info("Ensuring MongoDB service is enabled...")
enabled = subprocess.run(
    ["sudo", "systemctl", "is-enabled", "mongod"],
    stdout=subprocess.PIPE, stderr=subprocess.PIPE
)
if b"enabled" not in enabled.stdout:
    run_cmd(["sudo", "systemctl", "enable", "mongod"])
else:
    logging.info("MongoDB service already enabled.")

# Step 11: Restart MongoDB service
logging.info("Restarting MongoDB service...")
run_cmd(["sudo", "systemctl", "restart", "mongod"])
logging.info("MongoDB service restarted.")

logging.info(f"Script execution completed. Logs stored in {LOG_FILE}")