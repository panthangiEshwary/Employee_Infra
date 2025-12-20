global:
  resolve_timeout: 5m

route:
  receiver: "n8n"
  group_wait: 10s
  group_interval: 30s
  repeat_interval: 2m

receivers:
  - name: "n8n"
    webhook_configs:
      - url: "http://n8n:5678/webhook/prometheus-alert"
        send_resolved: true
