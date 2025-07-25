# Étape 1 : build React app (Node.js 18 + outils natifs)
FROM node:18 as builder

# Installer Python et outils build nécessaires à node-sass
RUN apt-get update && apt-get install -y python3 make g++ && ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

# Copier le code source
COPY . .

# Installer les dépendances
RUN npm install

# Builder l'app (génère /app/build)
ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build

# Étape 2 : image Nginx minimale pour servir le build
FROM nginx:alpine

# Copier la conf nginx personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers build dans nginx
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
