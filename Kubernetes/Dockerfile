# Use the official Python base image
FROM python:3.8
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Set the working directory inside the container
WORKDIR /app

# Install core dependencies.
RUN apt-get update && apt-get install -y libpq-dev build-essential
# Install dependencies
COPY Kubernetes/script/atsllm/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY Kubernetes/script/atsllm/. /app/

# Expose the port your Django app will run on
EXPOSE 8000

CMD ["python3", "app.py"]
