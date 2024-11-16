# Base image olarak Python kullanıyoruz
FROM python:3.9 as python-app

# Çalışma dizinini ayarla
WORKDIR /app

RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install tesseract

# Gereksinim dosyasını kopyala ve kur
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install "fastapi[standard]"

# Install RapidOCR dependencies



# Uygulama dosyasını kopyala

COPY ./ssl/cert.pem /etc/nginx/ssl/cert.pem
COPY ./ssl/key.pem /etc/nginx/ssl/key.pem

COPY . .


EXPOSE 8000

# Uygulama başlatma komutunu tanımla
CMD ["fastapi","run", "server.py", "--proxy-headers", "--port", "8000"]


