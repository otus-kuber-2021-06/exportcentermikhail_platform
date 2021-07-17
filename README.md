# exportcentermikhail_platform
exportcentermikhail Platform repository

### Знакомство с Kubernetes, основные понятия и архитектура
> Разберитесь почему все pod в namespace kube-system восстановились после удаления. Укажите причину в описании PR

core-dns - Deployment, который следит за количеством реплик и перезапускает поды при их удалении
kube-proxy - Daemonset, аналогично Deployment следит за работой подов на каждой ноде Kubernetes
kube-apiserver, kube-scheduler, etcd - Static pod, за которыми следит systemd служба kubelet, манифесты хранятся по пути /etc/kubernetes/manifests
storage-provisioner - аналогичный Static pod, является аддоном Kubernetes и его конфиг хранится в /etc/kubernetes/addons

### Kubernetes controllers. ReplicaSet, Deployment, DaemonSet

> Определите, что необходимо добавить в манифест, исправьте его и примените вновь.

В логах kubectl:

error: error validating "kubernetes-controllers/frontend-replicaset.yaml": error validating data: ValidationError(ReplicaSet.spec): missing required field "selector" in io.k8s.api.apps.v1.ReplicaSetSpec; if you choose to ignore these errors, turn validation off with --validate=false

Ошибка указывает на то, что не хватает поля selector в разделе spec Replicaset. Добавлен selector с отброром подов по label app=frontend

> Руководствуясь материалами лекции опишите произошедшую ситуацию, почему обновление ReplicaSet не повлекло обновление запущенных pod?

- ReplicaSet не имеет механизма обновления, он только следит за тем, чтобы было запущено заданное количество реплик, даже если образ из которого запущен контейнер в поде не соответствует манифесту.

> Задание со *

1. В первом случае, для аналога blue-green указываем параметр **maxSurge: 100%** чтобы поднять три (по количеству реплик) новых пода, после этого, три старых пода перейдут в статус Terminating
2. Во втором случае, для reverse rolling update указываем параметры **maxUnavailable: 1, maxSurge: 0** Таким образом, мы запрещаем создавать новые поды для обновления, но разрешаем "убивать" один старый.

> Задание с **
1. Манифест node-exporter-daemonset взять в официального github prometheus-operator. Для запуска в локальном kind, изменил в манифесте
**namespace: default**
**serviceAccountName: default**
2. DaemonSet из используемого мной манифеста уже был описан так, чтобы запускаться на всех нодах кластера.
На нодах control-plane указан taint **Taints: node-role.kubernetes.io/master:NoSchedule**, но в манифесте указано следующее
>      tolerations:
>      - operator: Exists
Согласно документации, такая конструкция, указанная в манифесте, позволяет подам этого daemonset запускаться на любой ноде с любым указанным Taint.

### Безопасность и управление доступом
1. task01
- Создан sa bob с CluterRole admin
- Создан sa dave без (cluster)rolebinding

2. task02
- Создан namespace prometheus
- Создан sa carol
- Создана кластерная роль sa-role с правами выполнять get, list, watch над ресурсом pod
- Создан ClusterRoleBinding, назначающий кластерную роль sa-role группе сервисных аккаунтов в namespace prometheus

3. task03
- Создан namespace dev
- Создан sa jane
- Создан ClusterRoleBinding, назначающий кластерную роль admin sa jane
- Создан sa ken
- Создан ClusterRoleBinding, назначающий кластерную роль view sa ken