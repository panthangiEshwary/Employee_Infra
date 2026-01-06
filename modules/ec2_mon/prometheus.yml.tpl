global:
  scrape_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: ["alertmanager:9093"]

rule_files:
  - "alert-rules.yml"

scrape_configs:
  - job_name: "employee-app"
    metrics_path: "/actuator/prometheus"
    static_configs:
      - targets:
          - "${app_private_ip}:8080"

  - job_name: "employee-node-exporter"
    static_configs:
      - targets:
          - "${app_private_ip}:9100"
