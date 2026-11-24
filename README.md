# Homework Session 11 - VPS Setup, Security Hardening & Firewall UFW

Kho lưu trữ bài tập thực hành **Session 11 - DevOps** thực hiện trực tiếp trên máy chủ Cloud VPS (`163.223.9.193`).

---

## Danh Mục Bài Tập

| Bài tập | Nội dung chính | Thư mục | Tệp & Ảnh minh chứng | Trạng thái |
| :--- | :--- | :--- | :--- | :---: |
| **Bài tập 1** | Khởi tạo & kết nối SSH tới Ubuntu VPS (`163.223.9.193`) | [`ex_01/`](ex_01/) | `vps_cloud_specs.png`, `ex01_ssh_login.png`, `README.md` | Hoàn thành |
| **Bài tập 2** | Tạo user `deploy` (sudo), cài Docker Engine + Compose & thêm vào group `docker` | [`ex_02/`](ex_02/) | `setup-deploy-docker.sh`, `commands.txt`, `ex02_deploy_docker.png` | Hoàn thành |
| **Bài tập 3** | Bảo mật SSH Key cho `deploy`, vô hiệu hóa `PermitRootLogin` & `PasswordAuthentication` | [`ex_03/`](ex_03/) | `harden-ssh.sh`, `commands.txt`, `ex03_ssh_hardening.png` | Hoàn thành |
| **Bài tập 4** | Cấu hình UFW (`deny incoming`, mở `22` & `8080`) và kiểm chứng Nginx `8080` vs `8081` | [`ex_04/`](ex_04/) | `setup-ufw.sh`, `ex04_ufw_status.png`, `ex04_port_8080_vs_8081.png` | Hoàn thành |

---

## Tóm tắt kết quả thực tế trên VPS `163.223.9.193`

1. **Ex01:** Truy cập SSH vào VPS `linux30515` (`Ubuntu 20.04.4 LTS`, `1 CPU`, `1 GB RAM`, `20 GB Disk`).
2. **Ex02:** User `deploy` (`uid=1001`) thuộc nhóm `sudo` (`27`) và `docker` (`117`); chạy được `Docker version 26.1.3` và `Docker Compose version v5.7.0`.
3. **Ex03:** Cấu hình `PermitRootLogin no`, `PasswordAuthentication no` trong `/etc/ssh/sshd_config`. Kiểm chứng `ssh root@163.223.9.193` bị từ chối (`Permission denied (publickey)`), `ssh deploy@163.223.9.193` đăng nhập thành công bằng SSH Key.
4. **Ex04:** Kích hoạt UFW (`Default: deny incoming`), mở `22/tcp` và `8080/tcp`. Truy cập `http://163.223.9.193:8080` trả về `HTTP/1.1 200 OK`, truy cập `http://163.223.9.193:8081` bị chặn (`Connection timed out`).
