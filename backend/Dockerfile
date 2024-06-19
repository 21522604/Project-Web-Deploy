# Dockerfile

# Sử dụng image chính thức của Node.js với tag LTS (Long Term Support)
FROM node:14
# Thiết lập thư mục làm việc (working directory) trong container
WORKDIR /app

# Sao chép các tệp package.json và package-lock.json (nếu có) vào image
COPY package*.json ./

# Cài đặt các dependency của ứng dụng Node.js
RUN npm install

# Sao chép mã nguồn của ứng dụng vào thư mục làm việc trong container
COPY . .

# Mở cổng mặc định cho ứng dụng Next.js (thay đổi cổng tùy theo cấu hình của ứng dụng)
EXPOSE 8080

# Lệnh để khởi động cả MySQL và ứng dụng Next.js khi container được chạy
CMD ["npm", "start"]
