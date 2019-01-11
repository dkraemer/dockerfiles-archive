FROM node:8 AS build
RUN apt-get update \
 && apt-get upgrade -y --with-new-pkgs
RUN git clone https://github.com/dkraemer/stackedit.git /src
WORKDIR /src
RUN git checkout v5.13.3
RUN npm install
ENV NODE_ENV production
RUN npm run build

FROM scratch
COPY --from=build /src/dist /app
