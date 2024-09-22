#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install required dependencies
sudo apt install -y python3 python3-pip nodejs npm

# Install Python dependencies
pip3 install -r requirements.txt

# Install Node.js dependencies
cd ui && npm install

# Set up a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install FastAPI and Uvicorn for the backend
pip install fastapi uvicorn

# Create a systemd service file for Devika
cat << EOF | sudo tee /etc/systemd/system/devika.service
[Unit]
Description=Devika AI Service
After=network.target

[Service]
User=pi
WorkingDirectory=/home/pi/devika
ExecStart=/home/pi/devika/venv/bin/python3 devika.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the Devika service
sudo systemctl enable devika.service
sudo systemctl start devika.service

# Configure Nginx as a reverse proxy
sudo apt install -y nginx
cat << EOF | sudo tee /etc/nginx/sites-available/devika
server {
    listen 80;
    server_name localhost;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable the Nginx configuration
sudo ln -s /etc/nginx/sites-available/devika /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

echo "Raspberry Pi environment setup complete. Devika should now be accessible on your local network."
