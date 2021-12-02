#!/bin/bash
#
# git-shll no-interactive-login 
echo -e "Hola \e[35;1m$USER\e[0m, has iniciado sesión correctamente."
echo -e "Para configurar ejecuta los siguientes comandos en la carpeta de tu app:"
echo -e "  git init"
echo -e "  git remote add prod $USER@nube.pragmore.com:git/\e[33;1mnombre-de-la-app\e[0m"
