# Demo Jenkins CI
En este repositorio está el código necesario para la demo de la charla de Jenkins de la 1ª jornada de formación interempresas (le cambiaremos el nombre, si...)

# ¿En qué consiste la demo?
En la demo veremos cómo usando jenkins podemos integrar nuestro repositorio de github para que, con cada cambio que subamos al respositorio se ejecuten nuestros tests (test o lo que queramos) en jenkins usando los Pipelines. 
- Tendremos nuestro jenkins en local.
- Configuraremos un repositorio de código en github con nuestra aplicación.
- Engancharemos jenkins con github y veremos la MAJIA de los pipelines. 

# ¿Qué hay realmente aquí?
El código que hay aquí es la aplicación que vamos a probar. Es una aplicación de ejemplo con nodejs que no hace practicamente nada, pero tiene una configuración básica para ejecución de unas suites de tests. Es todo "de palo", lo importante en la demo no es el código de la app sino cómo ejecutar eso con jenkins. Me he basado en una app que encontré en https://getintodevops.com

La aplicación está "dockerizada". Es decir, tiene un archivo Dockerfile con el que podemos construir y levantar un contenedor de docker que ejecuta la aplicación. Esto es necesario ya que jenkins construirá y levantará ese contenedor para lanzar los tests. 

## Para levantar la instancia de jenkins
Ejecutar el script `start-jenkins.sh` que está en la carpeta `scripts` de este repo. La instancia de jenkins estará accesible en http://localhost:8080. con usuario y password `admin`
## Para ejecutar nuestra aplicación
Ejecutar el script `start-app.sh` que está en la carpeta `scripts` de este repo. La aplicación estará disponible en http://localhost:8001.
### Para conectar a nuestro contenedor levantado con la app y ejecutar los tests
Ejecutar `docker exec demo-jenkins-app bash` y conectaremos por consola al contendor de nuestra app. Allí dentro podemos ejecutar los tests con `npm run test`
## Para borrar todo
Ejecutar el script `delete-all.sh` que está en la carpeta `scripts` de este repo