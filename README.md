#  OpenShift SpringBoot REST API Deploy on Postgres(Local Postgres)

Spring Boot developers can easily deploy REST API on Open shift and connect to local Postgres

# Technology or Tools Stack before you start.
  * Java
  * Spring Boot
  * Openshift CRC 1.14/1.15
  * Spring Tools 4 for Eclipse
  
# Spring Boot REST API deploy on OpenShift CRC using odo.

Scope of the project is to deploy spring boot REST API on Openshift and scale up to mulitple instance connected to your local POSTGRES.

# Create Project in Openshift

Once you login into openshift, go to Projects which you can find in the Home section on Left Sidebar and click on Create Project. 
Enter the project details as "library" and click on create.
<img src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/CreateProject.png">

# Install postgres and setup username and password
  Now click on Administrator and go to Developer Section.Firstly we will deploy PostgreSQL Database. From +Add click on Database and search for PostgreSQL.
  Note the username and password
<img src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/postgres-persistent.png">

Select PostgreSQL and then Instantiate Template. Enter the database credentials as you wish and click on Create.
<img src="hhttps://github.com/ngecom/openshiftSpringBootPostgres/blob/master/PostgresTemplate.png">

# Verify status of POD and Environemnt details
Now the database pod will be created and you can see the pod in Topology. Click on the pod and you can see the status of the pod. Click on the pod name in the Resources tab to see the pod details.
If you want to see the pod credentials then go to Terminal and enter the below command.
<img src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/VerifyEnvVariables.png">
  sh-4.2$ env | grep POST
      POSTGRESQL_PORT_5432_TCP_ADDR=172.30.102.169
      POSTGRESQL_PORT=tcp://172.30.102.169:5432
      POSTGRESQL_SERVICE_PORT_POSTGRESQL=5432
      POSTGRESQL_PORT_5432_TCP=tcp://172.30.102.169:5432
      POSTGRESQL_SERVICE_HOST=172.30.102.169
      POSTGRESQL_DATABASE=sampledb
      POSTGRESQL_PASSWORD=demo
      POSTGRESQL_PORT_5432_TCP_PORT=5432
      POSTGRESQL_VERSION=10
      POSTGRESQL_PREV_VERSION=9.6
      POSTGRESQL_SERVICE_PORT=5432
      POSTGRESQL_USER=demo
      POSTGRESQL_PORT_5432_TCP_PROTO=tcp
# Execute the Script in Database      
  Example table book is available in below script. You can create in newly created database.  If your are not familiar how to connect to postgres follow next section
  <href src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/sql/createTable.sql">

# How to connect to Postgres manually in Openshift and execute above script.
  There are multiple ways to create tables. Below is the easiest option you can connect to postgres
     - Select the Topology on left Menu and select the postgres POD
     - <img src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/ConnectPostgresCreateTable.png">

#  Create Secret in workload section

Administrator tab and go to Config Map section. Click on Create From YAML. Add the values to the YAML file and it will look like below and 
add to project also

 apiVersion: v1
 kind: Secret
 metadata:
   name: db-config
   namespace: library
 type: Opaque
 stringData:
   POSTGRESQL_SERVICE_HOST: postgresql
   POSTGRESQL_DATABASE: bookdb
   POSTGRESQL_PASSWORD: ngbilling
   POSTGRESQL_SERVICE_PORT: '5432'
   POSTGRESQL_USER: ngbilling
   
<img src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/ConfigMap.png">  

# Git pull the code locally
    * git init
    * git pull https://github.com/ngecom/openshiftSpringBootPostgres.git
    * mvn package
    * Verify locally by executing "java -jar bookStore.jar"  connect to your local DB by verify password
    
# Change the application.properties by give Openshift username and Password 
  * spring.datasource.url=jdbc:postgresql://${POSTGRESQL_SERVICE_HOST:localhost}:${POSTGRESQL_SERVICE_PORT:5432}/${POSTGRESQL_DATABASE:bookdb}
  * spring.datasource.username=${POSTGRESQL_USER:ngbilling}
  * spring.datasource.password=${POSTGRESQL_PASSWORD:ngbilling}
  
  ** Execute mvn package again to take latest properties
  
# Login to openshift as developer and Create Spring Boot Web component in Openshift

    * rakesh@rakesh-ThinkPad-P50:~/MyWorks/Openshift/helloopenshift$ odo create java bookshop --binary=target/bookStore.jar
    * rakesh@rakesh-ThinkPad-P50:~/MyWorks/Openshift/helloopenshift$ odo push
 
With an odo create command, a configuration file called config.yaml has been created in the local directory of the component that contains information about the component for deployment. You can view the configuration settings of the component in config.yaml if required.
     
# Expose the Web application to Public
    * rakesh@rakesh-ThinkPad-P50:~/MyWorks/Openshift/helloopenshift$ odo url create --port 8080
    * rakesh@rakesh-ThinkPad-P50:~/MyWorks/Openshift/helloopenshift$ odo push
          Validation
           ✓  Checking component [13ms]

          Configuration changes
           ✓  Initializing component
           ✓  Creating component [459ms]

          Applying URL changes
           ✓  URLs are synced with the cluster, no changes are required.

          Pushing to component bookshop of type binary
           ✓  Checking files for pushing [2ms]
           ✓  Waiting for component to start [15s]
           ✓  Syncing files to the component [666ms]
           ✓  Building component [1s]
          ]

# Access the application from outside world through POSTMAN
  * http://bookshop-app-library.apps-crc.testing/books
  * http://bookshop-app-library.apps-crc.testing/addBook
      Input -- {"title":"NgBilling Book", "author":"Ngecom"}
  * http://bookshop-app-library.apps-crc.testing/books/1    
 <img src="https://github.com/ngecom/openshiftSpringBootPostgres/blob/master/postman-findByBook.png">  
     
