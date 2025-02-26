FROM docker/whalesay

# TODO: Set default environment variable here
ENV WHALE_LANGUAGE="English"

# TODO: Copy entrypoint script and set permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
# entrypoint is the script that will be executed when the container starts
ENTRYPOINT ["/entrypoint.sh"]
