# Stage 1: Build dependencies
FROM python:3.11-buster AS builder

# Set working directory
WORKDIR /app

# Upgrade pip and install poetry
RUN pip install --upgrade pip && pip install poetry

# Copy poetry files and install dependencies
COPY . .

# Ensure Poetry creates a virtual environment and installs dependencies
RUN poetry config virtualenvs.create true && poetry install --no-root --no-interaction --no-ansi

# Stage 2: Production image
FROM python:3.11-buster AS prod

WORKDIR /app

# Copy application files
COPY . .

# Copy installed dependencies from the builder stage
COPY --from=builder /app /app

# Set environment variable to use the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# # Ensure uvicorn is installed inside the container
# RUN /app/.venv/bin/pip

# Expose FastAPI port
EXPOSE 8000
