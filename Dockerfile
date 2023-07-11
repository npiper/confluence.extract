FROM bobswiftapps/acli:latest


# Set environment variable for non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone to Europe/London
RUN ln -fs /usr/share/zoneinfo/Europe/London /etc/localtime && \
    apt-get update && \
    apt-get install -y tzdata && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Update package lists and install dependencies - Groovy, Pandoc + Dependencies
RUN apt-get update && \
    apt-get install -y pandoc pandoc-citeproc texlive-xetex texlive-fonts-recommended texlive-latex-recommended 

# Create a mounting directory called ./data
RUN mkdir -p /opt/acli/data
