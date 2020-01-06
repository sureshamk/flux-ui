# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
RUN apk add esh
COPY nginx.conf.esh setup.sh /
EXPOSE 80
ENV BASE_API '/'
ENV END_POINT 'http://flux'
CMD ["sh", "-c", "sh setup.sh && nginx -g 'daemon off;'"]
