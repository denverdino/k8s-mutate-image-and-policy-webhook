GENERATED_DIR=generated-$(date +%Y%m%d)

kubectl delete -f test.yaml
kubectl delete -f ${GENERATED_DIR}/
sleep 10

rm -fr ${GENERATED_DIR}

./generate-certs-and-config.sh
kubectl apply -f ${GENERATED_DIR}/