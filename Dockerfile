# Stage 1: Base image with Python
FROM python:3.11-slim

# Set environment variables to prevent buffering
ENV PYTHONUNBUFFERED 1

# Install uv, the package manager used by this project
RUN pip install uv

# Set the working directory in the container
WORKDIR /app

# Copy the dependency definition files
COPY pyproject.toml ./

# Install dependencies using uv
# Using --system to install in the system Python environment
RUN uv pip install --system -r pyproject.toml

# Copy the rest of the application source code
COPY . .

# Copy the example environment file. In a real-world scenario, you would
# mount a .env file or use a secret management system.
COPY .env.example .env

# Expose the port the app runs on
EXPOSE 2024

# The command to run the application
# Note: --allow-blocking is used as per the quickstart guide for local development.
# For production, you might want to review this setting.
CMD ["uvx", "--refresh", "--from", "langgraph-cli[inmem]", "--with-editable", ".", "--python", "3.11", "langgraph", "dev", "--allow-blocking", "--port", "2024", "--host", "0.0.0.0"]