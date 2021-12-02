#!/bin/bash
#
# git-shll no-interactive-login 
echo -e "Hola \e[1m$USER\e[0m, has iniciado sesión correctamente."
echo -e "El siguiente paso es configurar el deploy."
echo -e "Para eso ejecuta los siguientes comandos dentro de la carpeta de tu app:"
echo ""
echo -e "  git init"
echo -e "  git remote add prod $USER@nube.pragmore.com:git/\e[33;1mnombre-de-tu-app\e[0m"
echo ""
echo -e "Lamentable no cuentas con acceso SSH, por lo que vamos a cerrar la sesión."
echo ""
echo -e "Si necesitas ayuda puedes ir a \e[34;4mhttps://nube.pragmore.com/ayuda\e[0m"
