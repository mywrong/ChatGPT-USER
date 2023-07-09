FROM python:3.10.12 as builder
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
COPY requirements_advanced.txt .
RUN pip install --user --no-cache-dir -r requirements.txt
# RUN pip install --user --no-cache-dir -r requirements_advanced.txt

FROM python:3.10.12
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY . /app
WORKDIR /app
ENV dockerrun=yes
CMD ["python3", "-u", "ChuanhuChatbot.py","2>&1", "|", "tee", "/var/log/application.log"]
