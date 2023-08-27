wget https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/fluent-bit/fluent-bit.yaml

fluent-bit.yaml

ServiceAccount fluent-bit in amazon-cloudwatch NS
ClusterRole fluent-bit-role 
ClusterRoleBinding fluent-bit-role-binding (fluent-bit-role  and service account fluent-bit)
ConfigMap fluent-bit-config   ${HTTP_SERVER}   ${HTTP_PORT}

DaemonSet fluent-bit image: public.ecr.aws/aws-observability/aws-for-fluent-bit:stable

