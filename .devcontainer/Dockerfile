FROM jetpackio/devbox:latest

# Installing your devbox project
WORKDIR /code
USER root:root
# RUN mkdir -p /var/lib/gems/3.0.0 && \
#     chmod -R 777 /var/lib/gems/3.0.0 && \
RUN mkdir -p /code && chown ${DEVBOX_USER}:${DEVBOX_USER} /code
USER ${DEVBOX_USER}:${DEVBOX_USER}
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.json devbox.json
COPY --chown=${DEVBOX_USER}:${DEVBOX_USER} devbox.lock devbox.lock



RUN devbox run -- echo "Installed Packages."

RUN devbox shellenv --init-hook >> ~/.profile
