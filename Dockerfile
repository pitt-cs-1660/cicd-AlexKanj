# Stage 1: Build dependencies
FROM python:3.11-buster AS builder

# Set working directory
WORKDIR /app

# Upgrade pip and install poetry
RUN pip install --upgrade pip && pip install poetry

# Copy poetry files and install dependencies
COPY pyproject.toml poetry.lock ./

# Ensure Poetry creates a virtual environment and installs dependencies
RUN poetry config virtualenvs.create true \&& poetry config virtualenvs.in-project true\&& poetry install --no-root --no-interaction --no-ansi

COPY . .

# Stage 2: Production image
FROM python:3.11-buster AS prod

# Copy installed dependencies from the builder stage
COPY --from=builder /app /app

WORKDIR /app

# Expose FastAPI port
EXPOSE 8000

# Set environment variable to use the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]


