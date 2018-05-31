FROM node:latest
MAINTAINER Elias Neves

ENV PORT=3000
WORKDIR /var/www
COPY . /var/www
RUN npm install
ENTRYPOINT ["npm", "start"]
EXPOSE $PORT
