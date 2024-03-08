# ☁️ Nube, by Pragmore

Set up y configuraciones de un servidor Ubuntu.

* Servidor Nginx
* Servidor [Bialet](https://github.com/bialet/bialet)
* Servidor Git
* Certificados con Certbot (no esta incluido el set up y configuración)

## Comandos para administrar

Se administra con systemctl

Recargar la configuración de Nginx sin reiniciar.

```bash
sudo systemctl reload nginx
```

Parar todos los procesos de Bialet.

```bash
sudo systemctl stop bialet
```

Iniciar o reiniciar todos los procesos de Bialet (hay que hacerlo por separado).

```bash
sudo systemctl restart bialet-dev.ar
sudo systemctl restart bialet-bialet.org
sudo systemctl restart bialet-pragmore-web
```

## Git

![image](https://github.com/pragmore/nube-server/assets/142173/fe1ab9b5-0e3c-49b1-a98c-5964ea7760d8)

Se inicia un proyecto de git bare y se configura un usuario para que acceda por SSH al servidor.

Ver archivos para ejecutar estas configuraciones en la carpeta `bin/`.

Se configura el servidor como remoto.

```bash
git remote add prod user@server
```

Y se actualiza con

```bash
git push prod
```

## MOTD

![image](https://github.com/pragmore/nube-server/assets/142173/fc747929-970b-464e-8e2b-5603bc85a173)


Se muestran los mensajes de bienvenida al ingresar por SSH. Ver archivo `etc/update-motd.d/00-banner`.
