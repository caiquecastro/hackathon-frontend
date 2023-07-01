# build environment
FROM node:18-alpine as react-build
WORKDIR /app

ARG API_URL

ENV BACKEND_URL=${API_URL}

RUN env

COPY . ./
RUN yarn
RUN yarn build

# server environment
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template

COPY --from=react-build /app/build /usr/share/nginx/html

ARG API_URL

ENV PORT 8080
ENV HOST 0.0.0.0
ENV BACKEND_URL=${API_URL}

EXPOSE 8080
CMD sh -c "envsubst '\$PORT \$BACKEND_URL' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
