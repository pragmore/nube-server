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

## MOTD

Se muestran los mensajes de bienvenida al ingresar por SSH. Ver archivo `etc/update-motd.d/00-banner`.

## Git

Se inicia un proyecto de git bare y se configura un usuario para que acceda por SSH al servidor.

Ver archivos para ejecutar estas configuraciones en la carpeta `bin/`.
