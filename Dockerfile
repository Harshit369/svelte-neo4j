FROM node:14-alpine
WORKDIR /app

COPY ./package*.json ./
RUN npm install
COPY . .

ARG DB_URL
ARG DB_USER
ARG DB_PASSWORD
ARG DB_NAME

ENV DB_URL $DB_URL
ENV DB_USER $DB_USER
ENV DB_PASSWORD $DB_PASSWORD
ENV DB_NAME $DB_NAME


RUN npm run build

FROM nginx
EXPOSE 80
COPY --from=0 /app/public/ /usr/share/nginx/html/