FROM node:14
COPY . /usr/src/app
WORKDIR /usr/src/app/web_app
RUN npm install
EXPOSE 80
CMD [ "node", "server.js" ]
