#Creating a MiltiStep Build Dockerfile, as a production environment
#Should use production, not development, server and should not worry about copying the new code

#Step1: "Build Phase" - use alpine to create a temporary base image, get "node_module" and run "npm run build" command
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

#/app/build folder will contian all the output from "npm run build", that we care about

#Step 2: "Run Phase" -createa a second image based on "nginx" server,copy the output from "npm run build" folder inside the temporary image and start "nginx" server
FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html

#To run it:
#docker build . 
#docker  run -p 8080:80 <image_id>
#nginx uses port 80 inside the container as a default

#Elasticbeanstalk uses "EXPOSE" to do port mapping