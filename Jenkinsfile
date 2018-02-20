node {
    /**
     * Definición de variables que usaremos en nuestro pipeline
     * Serán visibles en todos los stages
     */
    def app
    def firstRound
    def secondRound

    /**
     * Clonado del repositorio. 
     * Es un comando "rápido" que nos ofrece jenkins a través del plugin de Pipeline Scm Step Plugin (https://wiki.jenkins.io/display/JENKINS/Pipeline+SCM+Step+Plugin)
     */
    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */
        checkout scm
    }

    /**
     * Build de imagen de docker
     * -> Se usa el plugin "ansiColor" para que la salida sea más clara y con colores
     * -> Se usa la función "dir" que nos ofrece jenkins para situarnos en el directorio que nos interesa
     * -> Usamos la variable de entorno de Jenkins "env.WORKSPACE" que es el directorio donde se ha clonado el proyecto. Para saber las variables de entorno disponibles en vuestro jenkins local (http://localhost:8080/job/dafsd/pipeline-syntax/globals)
     * -> Hacemos el build de docker con la función "docker.build". ESta función esta dissonible gracias al plugin de Docker (https://plugins.jenkins.io/docker-workflow). Podéis consultar la documentación del plugin pero es bastante farragosa (https://jenkins.io/doc/book/pipeline/docker/)
     */
    stage('Build image') {
        /* Build docker image and save it to app var */
        ansiColor('xterm') {
            dir("${env.WORKSPACE}") {
                app = docker.build("demo-nodeapp")
            }
        }
    }    

    /**
     * Ejecución de tests simple
     * En este paso ejecutamos los tests dentro de nuestro contenedor de docker
     * -> Usamos la variable "app" que tiene la referencia a la imagen de docker que hemos construido
     * -> Al hacer el "app.inside", también disponible por el plugin de docker, jenkins está ejecutando un "docker run [params]" donde los parámetros son unos que le pone jenkins por defecto concatenados con los que le pasemos por parámetro. En este caso le pasamos el usuario "-u root:root" para que todo lo que se ejecute dentro de docker lo haga con usuario root. En la salida de consola de jenkins veremos el comando completo que se ejecuta en este paso. 
     * -> Luego dentro del contenedor ejecutamos un comando de shell que entra en una carpeta y ejecuta los tests de nuestra app con "npm test"
     */
    stage('Test') {        
        ansiColor('xterm') {
            app.inside("-u root:root") {                
                sh 'cd /usr/src/app && npm test'                            
            }                
        }
    }    

    /**
     * Ejecución de tareas en paralelo dentro de docker
     * -> Tenemos 3 suites: Test, Core y Unit
     * -> Se ejecutan llas suites de Test y Core a la vez y después, la suite de Unit
     * -> Guardamos el resultado de las ejecuciones en una variable y luego comprobamos si ha ido bien todo o ha fallado algo
     * -> Para controlar el fallo de la suite usamos los bloques try/catch
     */                                
    stage('Test en paralelo') {        
        ansiColor('xterm') {
            app.inside("-u root:root") { 

                try {
                    parallel Test: {
                        stage('Suite Test') {                            
                            sh 'cd /usr/src/app && npm test'                            
                        }
                    }, TestCore: {
                       stage('Suite Core') {
                            sh 'cd /usr/src/app && npm run testCore'                                                        
                       }
                    }

                    firstRound = true
                } catch (error) {
                    firstRound = false
                }

                try {                    
                    stage('Suite Unit') {
                        sh 'cd /usr/src/app && npm run testUnit'
                    }                    
                    secondRound = true
                } catch (error) {
                    secondRound = false
                }

                if (firstRound && secondRound) {
                    currentBuild.result = 'SUCCESS'
                } else {
                    currentBuild.result = 'FAILURE'
                }


                /**
                 * Ejecución de otro job según la rama que se ha compilado.
                 * En este paso añadimos una comprobación sobre el nombre de la rama
                 * -> Si la rama es "master", ejecutamos un job llamado "master-external"
                 */                                
                /*if (env.BRANCH_NAME == "master") {
                    build job: 'master-external', parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME)], wait: false
                }*/

                echo "RESULT: ${currentBuild.result}"

            }
        }
    }

}
