FROM node:latest


WORKDIR /app


COPY . /app


RUN npm install


EXPOSE 9005


ENTRYPOINT ["node"]

CMD ["server.js"]
