
FROM debian:buster

ENV PACKAGE="nginx vim curl"
# ---------------------- # Étape 1 : Installation des dépendances de base ----------------------
RUN apt update \
    && apt upgrade -y \
    && apt install -y $PACKAGE

# -------------------------- # Étape 2 : Génération du certificat SSL --------------------------
RUN mkdir -p /etc/nginx/ssl \
    && apt install openssl -y \
    # génération du certificat SSL
    && openssl \
        # req crée et traite principalement des demandes de certificats au format PKCS#10. 
        # Elle peut en outre créer des certificats auto-signés.
        req \ 
        # -x509 pour préciser le type du certificat.
        -x509 \
        # avec l’option -nodes, notre clef privée se retrouvera simplement sans mot de passe pour eviter que OpenSSL 
        # nous demander un mot de passe au demarrage du container
        -nodes \
        # l'endroit ou on souhaite stocker le certificat SSL
        -out /etc/nginx/ssl/inception.crt \
        # l'endroit ou on souhaite la clé du certificat SSL
        -keyout /etc/nginx/ssl/inception.key \
        # préremplir les informations du certificat SSL
        -subj "/C=CA/ST=QC/L=Québec/O=42/OU=42/CN=gle-roux.42.fr/UID=gle-roux"
        
# ------------------------------- # Étape 3 : Configuration de NGINX -------------------------------
RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

# ------------------------------- # Étape 5 : Lancement de NGINX -------------------------------
CMD [ "nginx", "-g", "daemon off;" ]