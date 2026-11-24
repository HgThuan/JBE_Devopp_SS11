#!/bin/bash
# ==============================================================================
# Script: setup-deploy-docker.sh (Exercise 02 - SS11)
# Mô tả : Tạo user 'deploy' có quyền sudo, cài Docker Engine + Docker Compose plugin,
#         và thêm user 'deploy' vào group 'docker' trên Ubuntu.
# Chạy  : sudo bash setup-deploy-docker.sh
# ==============================================================================
set -euo pipefail

echo "=== [1/5] Tạo user 'deploy' và cấp quyền sudo ==="
if id "deploy" &>/dev/null; then
    echo "User 'deploy' đã tồn tại."
else
    useradd -m -s /bin/bash deploy
    echo "Đã tạo user 'deploy' với shell /bin/bash và thư mục /home/deploy."
fi

# Thêm vào nhóm sudo và cho phép chạy sudo (tùy chọn NOPASSWD để tiện tự động hóa CI/CD)
usermod -aG sudo deploy
echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy
chmod 440 /etc/sudoers.d/deploy

echo "=== [2/5] Cài đặt các gói phụ thuộc & Docker GPG key ==="
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "=== [3/5] Thêm Docker official APT repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== [4/5] Cài đặt Docker Engine và Docker Compose plugin ==="
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

echo "=== [5/5] Thêm user 'deploy' vào group 'docker' và kiểm tra ==="
usermod -aG docker deploy

echo "Kiểm tra dưới quyền user 'deploy':"
su - deploy -c "id && docker --version && docker compose version"
