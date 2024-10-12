FROM node:22 AS build
RUN npm i -g typescript

WORKDIR /app

COPY package*.json .
RUN npm ci
COPY . .
RUN tsc


FROM node:22 AS production

WORKDIR /app
COPY package*.json .
RUN npm ci --only=production
COPY --from=build /app/bin ./bin


CMD ["npm", "run", "start:prod"]