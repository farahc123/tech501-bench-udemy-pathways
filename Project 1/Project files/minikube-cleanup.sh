#!/bin/bash

minikube ssh "
USAGE=\$(df -h / | tail -1 | awk '{print \$5}' | sed 's/%//')
THRESHOLD=85
echo \"Current disk usage: \${USAGE}%\"
if [ \"\$USAGE\" -ge \"\$THRESHOLD\" ]; then
  echo \"Disk usage is above or equal to \${THRESHOLD}%, running cleanup...\"
  echo \"Listing dangling volumes:\"
  docker volume ls -f dangling=true
  echo \"Running prune...\"
  docker system prune -a --volumes -f
  echo \"Cleanup complete.\"
else
  echo \"Disk usage below threshold, no cleanup needed.\"
fi
"
