#!/bin/bash
# ==============================================================================
# Script: harden-ssh.sh (Exercise 03 - SS11)
# Mô tả : Tăng cường bảo mật SSH: Tắt đăng nhập root và tắt xác thực mật khẩu,
#         chỉ cho phép đăng nhập bằng SSH Key qua tài khoản 'deploy'.
# Lưu ý : Đảm bảo đã copy Public Key vào /home/deploy/.ssh/authorized_keys
#         và thử SSH bằng user 'deploy' thành công TRƯỚC khi chạy script này!
# Chạy  : sudo bash harden-ssh.sh
# ==============================================================================
set -euo pipefail

if [ ! -s /home/deploy/.ssh/authorized_keys ]; then
    echo "LỖI: Chưa tìm thấy Public Key trong /home/deploy/.ssh/authorized_keys!"
    echo "Hãy chạy ssh-copy-id deploy@<IP_VPS> trước khi tắt PasswordAuthentication."
    exit 1
fi

echo "=== [1/4] Sao lưu file cấu hình SSH gốc ==="
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

echo "=== [2/4] Cấu hình PermitRootLogin no & PasswordAuthentication no ==="
sed -i -E 's/^#?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -E 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i -E 's/^#?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Kiểm tra các cấu hình đã ghi
grep -E '^(PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)' /etc/ssh/sshd_config

echo "=== [3/4] Kiểm tra cú pháp cấu hình SSH (sshd -t) ==="
sshd -t

echo "=== [4/4] Khởi động lại dịch vụ SSH ==="
systemctl restart ssh
echo "Hoàn tất bảo mật SSH! Hãy mở tab Terminal mới để thử ssh deploy@<IP> và ssh root@<IP>."
