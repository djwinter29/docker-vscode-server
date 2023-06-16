FROM arm64v8/python:3.9.17-slim-bookworm

# hadolint ignore=DL3008
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    # support env timezones 
    tzdata \
    gnome-keyring wget curl ca-certificates \
    # development tools build-essential
    git \
    # clean up
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# install vscode-server
# hadolint ignore=DL4006
RUN wget -q -O- https://aka.ms/install-vscode-server/setup.sh | sh
# install VS Code (code-server)
#RUN curl -fsSL https://code-server.dev/install.sh | sh
#RUN code-server --install-extension ms-python.python 


COPY requirements.txt ./
RUN pip install -r requirements.txt

# copy scripts
COPY src/* /usr/local/bin/

# entrypoint
ENTRYPOINT [ "start-vscode" ]

# expose port
EXPOSE 8000
EXPOSE 5000