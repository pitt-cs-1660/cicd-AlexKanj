# Stage 1: Build dependencies
FROM python:3.11-buster AS builder

# Set working directory
WORKDIR /app

# Copy poetry files and install dependencies
COPY . .

# Upgrade pip and install poetry
RUN pip install --upgrade pip && pip install poetry

# Ensure Poetry creates a virtual environment and installs dependencies
RUN poetry config virtualenvs.create false \
&& poetry install --no-root --no-interaction --no-ansi

# Stage 2: Production image
FROM python:3.11-buster AS prod

WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /app /app

COPY . .
# Expose FastAPI port
EXPOSE 8000

# Set environment variable to use the virtual environment
ENV PATH=/app/.venv/bin:$PATH

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]


