FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    bash \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user first
RUN useradd -m -u 1000 claude
RUN mkdir /home/claude/workspace
RUN chown -R claude:claude /home/claude/workspace
USER claude
WORKDIR /home/claude/workspace

# Ensure local bin is on PATH
ENV PATH="/home/claude/.local/bin:${PATH}"

# Install Claude CLI as the claude user
RUN curl -fsSL -o /tmp/claude-install.sh https://claude.ai/install.sh \
    && chmod 700 /tmp/claude-install.sh \
    && bash /tmp/claude-install.sh \
    && rm -f /tmp/claude-install.sh


# Install RTK
RUN curl -fsSL -o /tmp/rtk-install.sh https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh \
    && chmod 700 /tmp/rtk-install.sh \
    && bash /tmp/rtk-install.sh \
    && rm -f /tmp/rtk-install.sh


# Install Terraform MCP Server (HashiCorp) binary
ARG TERRAFORM_MCP_SERVER_VERSION=1.3.0
RUN ARCH="$(dpkg --print-architecture)" \
    && curl -fsSL -o /tmp/terraform-mcp-server.zip \
       "https://releases.hashicorp.com/terraform-mcp-server/${TERRAFORM_MCP_SERVER_VERSION}/terraform-mcp-server_${TERRAFORM_MCP_SERVER_VERSION}_linux_${ARCH}.zip" \
    && mkdir -p /home/claude/.local/bin \
    && unzip -o -j /tmp/terraform-mcp-server.zip terraform-mcp-server -d /home/claude/.local/bin \
    && chmod 755 /home/claude/.local/bin/terraform-mcp-server \
    && rm -f /tmp/terraform-mcp-server.zip

# Install uv, then the AWS MCP Servers (awslabs) as standalone tools
RUN curl -fsSL -o /tmp/uv-install.sh https://astral.sh/uv/install.sh \
    && chmod 700 /tmp/uv-install.sh \
    && sh /tmp/uv-install.sh \
    && rm -f /tmp/uv-install.sh
RUN uv tool install awslabs.aws-documentation-mcp-server \
    && uv tool install awslabs.aws-iac-mcp-server

# Verify binaries exist (optional safety check)
RUN which claude && which rtk && which terraform-mcp-server && which awslabs.aws-documentation-mcp-server && which awslabs.aws-iac-mcp-server

# Default: run Claude through RTK
CMD ["rtk", "claude"]
