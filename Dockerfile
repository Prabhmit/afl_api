# Use the official R image from the Rocker project
FROM rocker/r-ver:4.1.0

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('fitzRoy')"
RUN R -e "install.packages('dplyr')"

# Copy the API script and utils
COPY api.R /api.R
COPY util_fns.R /util_fns.R

# Expose port 8000 for the API
EXPOSE 8000

# Run the API
CMD ["Rscript", "/api.R"]
