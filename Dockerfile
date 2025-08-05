
# Stage 1 : Build the Next app
FROM node:current-alpine3.22 As builder
WORKDIR /app
COPY nextapp/package*.json ./nextapp/
RUN npm install --prefix /app/nextapp
COPY nextapp/ ./nextapp
RUN npm run build --prefix /app/nextapp
RUN npm run export --prefix /app/nextapp

# Stage 2 : Server the build using nginx
FROM nginx:stable-alpine

#Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

#copy the exported static file from builder stage to nginx folder 
COPY --from=builder /app/nextapp/out /usr/share/nginx/html

#Expose the port 80
EXPOSE 80

#start nginx server 
CMD ["nginx","-g","deamon off;"]
