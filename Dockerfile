# Dockerfile
FROM nginx:alpine

# Copy toàn bộ file tĩnh vào thư mục web của Nginx
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Chạy Nginx
CMD ["nginx", "-g", "daemon off;"]

