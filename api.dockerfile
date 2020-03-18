FROM node:13-alpine as build-api

WORKDIR /api
COPY ./api/package*.json ./
RUN npm install
COPY ./api/ .
RUN npm run build


FROM node:13-alpine as production-stage

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
COPY ./api/package*.json ./
USER node

RUN npm ci --only=production

COPY --chown=node:node ./api/ .
COPY --chown=node:node --from=build-api /api/dist ./dist

EXPOSE 3000

CMD [ "node", "dist/main.js"]
