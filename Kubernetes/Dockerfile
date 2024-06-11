# Use the official Python base image
FROM python:3.11
# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Set the working directory inside the container
WORKDIR /app

# Install core dependencies.
RUN apt-get update && apt-get install -y libpq-dev build-essential
# Install dependencies
COPY Kubernetes/script/CV_Improver/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project files into the container
COPY Kubernetes/script/CV_Improver/. /app/

# Expose the port your Django app will run on
EXPOSE 8501

ENTRYPOINT ["streamlit","run" ]
CMD ["./Streamlit_App/app.py"]
