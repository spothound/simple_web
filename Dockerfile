FROM node:14
WORKDIR /usr/src/app
COPY web_app/package*.json ./
RUN npm install
COPY . .
EXPOSE 8000
CMD [ "node", "server.js" ]
