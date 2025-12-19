groups:
  - name: employee-app-alerts
    rules:

      - alert: EmployeeAppDown
        expr: up{job="employee-app"} == 0
        for: 30s
        labels:
          severity: critical
        annotations:
          description: "Employee Application is DOWN"

      - alert: EmployeeNodeExporterDown
        expr: up{job="employee-node-exporter"} == 0
        for: 30s
        labels:
          severity: critical
        annotations:
          description: "Employee Node Exporter is DOWN"

      - alert: EmployeeHighCPUUsage
        expr: (1 - avg(rate(node_cpu_seconds_total{mode="idle"}[2m]))) * 100 > 80
        for: 1m
        labels:
          severity: warning
        annotations:
          description: "Employee App CPU usage > 80%"

      - alert: EmployeeHighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 75
        for: 1m
        labels:
          severity: warning
        annotations:
          description: "Employee App memory usage > 75%"
