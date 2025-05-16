https://access.crunchydata.com/documentation/postgres-operator/latest/quickstart


kubectl taint nodes db1 db=pgsql:NoSchedule
kubectl taint nodes db2 db=pgsql:NoSchedule
kubectl label nodes db1 db=pgsql-main
kubectl label nodes db2 db=pgsql-replica