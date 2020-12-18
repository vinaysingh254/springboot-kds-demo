== Demo - springboot-kds-demo App deployed on Kubernetes

Simple springboot-kds-demo Spring Boot app deployment on Minikube

==== Start Minikube 

- Install Minikube from https://kubernetes.io/docs/tasks/tools/install-minikube/

- Install `kubectl` from https://kubernetes.io/docs/tasks/tools/install-kubectl/

Then, start Minikube:

	minikube start

==== Create and run a simple Spring Boot app

- Create a simple Boot app (You can also use https://start.spring.io/[Spring Initializr] web interface)
+
----
curl https://start.spring.io/starter.zip -d bootVersion=2.0.0.M5 \
     -d dependencies=web,actuator,jpa \
     -d groupId=com.vs.k8s -d artifactId=springboot-kds-demo \
     -d name=springboot-kds-demo -d baseDir=springboot-kds-demo -o springboot-kds-demo.zip
unzip springboot-kds-demo.zip
cd springboot-kds-demo
----


- Add a property enabling the `/application/env` endpoint. This allows us to inspect environment variables added by Kubernetes.
+
.src/main/resources/application.properties
----
endpoints.env.enabled=true
----

- Create a `Dockerfile` so we can package this app as a Docker image
+
.Dockerfile
----
FROM openjdk:8-alpine
ARG JAR_FILE=/target/springboot-kds-demo-1.0-SNAPSHOT.jar
WORKDIR /opt/app
COPY ${JAR_FILE} springboot-kds.jar
ENTRYPOINT ["java", "-jar", "springboot-kds.jar"]
----

- Build the app and the Docker image 
+
NOTE: We are sharing the Docker environment used by Minikube
+
----
eval $(minikube docker-env)
./mvnw clean package
docker build -t springboot-k8s:0.0.1 .
----

- Run a Kubernetes deployment on the running Minikube cluster
+
----
kubectl run springboot-k8s --image springboot-k8s:0.0.1 --port 8080
kubectl expose deployment springboot-k8s --type=NodePort
----

. Test the app
+
----
curl $(minikube service springboot-k8s --url)/ping
----

- Inspect environment variables and Kubernetes deployment/service yaml
+
----
curl $(minikube service springboot-k8s --url)/application/env | python -m json.tool
kubectl get deploy/springboot-k8s -o yaml
kubectl get svc/springboot-k8s -o yaml
----

- Create Deployment and Service YAML files for future repeatable deployments

----
kubectl run springboot-k8s --image springboot-k8s:0.0.1 --port 8080 -o yaml --dry-run \ 
    > springboot-k8s-deployment.yaml
kubectl expose deployment springboot-k8s --type=NodePort -o yaml --dry-run > springboot-k8s-svc.yaml
----

- Delete the resources created for `springboot-k8s`
+
----
kubectl delete all -l run=springboot-k8s
----
