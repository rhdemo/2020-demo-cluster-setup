# Datagrid Service
Scripts to install DG 8.0 in the `datagrid-demo` project.

## Default Configuration
- Uses Infinispan 10.1.2.Final upstream image
- Distributed mode
    - Each key/value is distributed across two nodes
- Entries stored off-heap

## Endpoints
- HOTROD & REST
    - service = datagrid-service
    - route = datagrid-service-datagrid-demo.apps.summit-mcm1.openshift.redhatkeynote.com:11222

All services can be reached directly via:
`datagrid-service.datagrid-demo.svc.cluster.local`

## Cache Configurations
Additional cache/counter configurations can be added to the `config/batch` as required by issuing a PR or contacting `remerson`.
