# Use Python base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy files
COPY app.py .

# Install Flask
RUN pip install flask

# Expose port
EXPOSE 80

# Run the app
CMD ["python", "app.py"]
