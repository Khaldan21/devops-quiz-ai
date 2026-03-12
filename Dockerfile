FROM python:3.11-slim

WORKDIR /app

# Layer caching: copy requirements first, install, THEN copy code
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy everything else
COPY . .

# Initialise the database schema at build time
RUN python -c "import db; db.init_db()"

# Port variable (Render overrides at runtime)
ENV PORT=5000

# Shell-form CMD so $PORT expands correctly
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --workers 2 app:app"]