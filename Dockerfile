FROM perl:5.40

# Set the working directory
WORKDIR /app

# Copy cpanfile
COPY cpanfile /app/cpanfile

# Install dependencies
RUN cpanm --notest --installdeps .

# Copy the application code
COPY . /app

# Start the application
CMD ["perl", "app", "prefork", "-l", "http://*:3000", "-m", "production"]

# Expose the application port
EXPOSE 3000
