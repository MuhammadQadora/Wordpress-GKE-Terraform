

resource "kubectl_manifest" "wordpress-dep" {
#  depends_on = [kubectl_manifest.pvc-wordpress]
  yaml_body  = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
                                    ### serviceAccountName: pod-sa
      containers:
        - image: "docker.io/muhammadqadora/wordpress"
          name: wordpress
          resources:
            requests:
              cpu: "1000m"
              memory: "2048Mi"
          env:
          - name: WORDPRESS_DB_HOST
            valueFrom:
              configMapKeyRef:
                name: db-name
                key: dh-host
          - name: WORDPRESS_DB_PASSWORD
            valueFrom:
              secretKeyRef:
                name: wp-sql
                key: pass
          - name: WORDPRESS_DB_USER
            valueFrom:
              secretKeyRef:
                name: wp-sql
                key: user
          - name: WORDPRESS_DB_NAME
            valueFrom:
              configMapKeyRef:
                name: db-name
                key: db
          - name: SITE
            value: http://${kubernetes_service.test.status.0.load_balancer.0.ingress.0.ip}
          ports:
            - containerPort: 80
              name: wordpress
          volumeMounts:
            - mountPath: /var/www/html
              name: mypvc
      volumes:
      - name: mypvc
        persistentVolumeClaim:
          claimName: podpvc
YAML
}



resource "kubectl_manifest" "hpa-wordpress" {
  yaml_body = <<YAML
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  labels:
    app: wordpress
  name: wordpress-hpa
spec:
  maxReplicas: 10
  metrics:
  - resource:
      name: cpu
      target:
        averageUtilization: 70
        type: Utilization
    type: Resource
  minReplicas: 4
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wordpress

YAML
}


resource "kubernetes_service" "test" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
  }
  spec {
    selector = {
      app = "wordpress"
    }
    port {
      port = 80
      target_port = "80"
    }
    type = "LoadBalancer"
  }
}



output "load_balancer_hostname" {
  value = kubernetes_service.test.status.0.load_balancer.0.ingress.0.ip
}


