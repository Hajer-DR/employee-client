FROM node:alpine As builder

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

RUN npm run build --prod

FROM nginx:1.21.3


COPY --from=builder /usr/src/app/dist/employee-client/ /usr/share/nginx/html

RUN rm -rf /etc/nginx/conf.d/default.conf

COPY ./docker/nginx.conf /etc/nginx/conf.d
