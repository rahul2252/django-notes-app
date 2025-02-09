FROM python:3.9

WORKDIR /app

# Install system dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt before installing dependencies
COPY requirements.txt /app/

# Upgrade pip and install dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir mysqlclient  # Explicitly install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt  # Install all dependencies

# Copy the entire project
COPY . /app/

EXPOSE 8000

# Start Gunicorn with the correct WSGI module
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "notesapp.wsgi:application"]