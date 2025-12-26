I=0; while true; do \
PAGE=$(curl -s http://failover.ajaydevops.co.in); \
REGION=$(echo "$PAGE" | awk -F'color:green;">|</h1>' '{print $2}' | tr -d '\n\r\t '); \
NAME=$(echo "$PAGE" | awk -F'color:blue;">|</h2>' '{print $2}' | tr -d '\n\r\t '); \
echo "Traffic reached server in: $REGION ($NAME)"; \
echo "The Count value is $I"; \
I=$((I+1)); sleep 1; \
done
