#!/bin/bash
# ==============================================================================
# Script: setup-ufw.sh (Exercise 04 - SS11)
# Mô tả : Cấu hình tường lửa UFW (Deny incoming mặc định, mở port 22 & 8080)
#         và chạy thử 2 container Nginx ở cổng 8080 và 8081 để đối chiếu.
# Chạy  : sudo bash setup-ufw.sh
# ==============================================================================
set -euo pipefail

echo "=== [1/4] Thiết lập chính sách mặc định UFW (Chặn mọi kết nối đến, cho phép đi ra) ==="
ufw default deny incoming
ufw default allow outgoing

echo "=== [2/4] Mở cổng SSH (22/tcp) TRƯỚC khi bật UFW và mở cổng ứng dụng 8080/tcp ==="
ufw allow 22/tcp
ufw allow 8080/tcp

echo "=== [3/4] Kích hoạt Firewall UFW và kiểm tra trạng thái ==="
ufw --force enable
ufw status verbose

echo "=== [4/4] Khởi chạy container Nginx tại cổng 8080 (cho phép) và 8081 (bị chặn) ==="
docker rm -f nginx-8080 nginx-8081 2>/dev/null || true
docker run -d --name nginx-8080 -p 8080:80 nginx:latest
docker run -d --name nginx-8081 -p 8081:80 nginx:latest
docker ps --filter "name=nginx-"
