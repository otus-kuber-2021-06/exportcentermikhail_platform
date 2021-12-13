local env = std.extVar('qbec.io/env');
local p = import '../params.libsonnet';
local params = p.components.recommendationservice;

[
  {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
      "name": params.name,
    },
    "spec": {
      "selector": {
        "matchLabels": {
          "app": params.name,
        },
      },
      "template": {
        "metadata": {
          "labels": {
            "app": params.name,
          },
        },
        "spec": {
          "terminationGracePeriodSeconds": 5,
          "containers": [
            {
              "name": "server",
              "image": params.image,
              "ports": [
                {
                  "containerPort": params.containerPort,
                },
              ],
              "readinessProbe": {
                "periodSeconds": 5,
                "exec": {
                  "command": [
                    "/bin/grpc_health_probe",
                    "-addr=:8080"
                  ],
                },
              },
              "livenessProbe": {
                "periodSeconds": 5,
                "exec": {
                  "command": [
                    "/bin/grpc_health_probe",
                    "-addr=:8080"
                  ],
                },
              },
              "env": [
                {
                  "name": "PORT",
                  "value": "8080"
                },
                {
                  "name": "PRODUCT_CATALOG_SERVICE_ADDR",
                  "value": "productcatalogservice:3550"
                },
                {
                  "name": "ENABLE_PROFILER",
                  "value": "0"
                },
              ],
              "resources": {
                "requests": {
                  "cpu": "100m",
                  "memory": "220Mi"
                },
                "limits": {
                  "cpu": "200m",
                  "memory": "450Mi"
                },
              },
            },
          ],
        },
      },
    },
  },
  {
  "apiVersion": "v1",
  "kind": "Service",
  "metadata": {
    "name": params.name,
  },
  "spec": {
    "type": "ClusterIP",
    "selector": {
      "app": params.name,
    },
    "ports": [
        {
        "name": "grpc",
        "port": params.servicePort,
        "targetPort": params.containerPort,
        },
      ],
    },
  },
]
