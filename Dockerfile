# Use Amazon Linux 2023 as the base image
FROM --platform=linux/amd64 public.ecr.aws/amazonlinux/amazonlinux:2023

# Update package repositories and install necessary packages
RUN yum update -y && \
    yum install -y httpd && \
    yum clean all

# Copy the HTML file into the container
COPY ./src/index.html /var/www/html/

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start the Apache HTTP server
CMD ["httpd", "-D", "FOREGROUND"]
