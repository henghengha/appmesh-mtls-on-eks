#!/usr/bin/env bash

set -e

register_server_entries() {
    kubectl exec -n spire spire-server-0 -c spire-server -- /opt/spire/bin/spire-server entry create $@
}


if [ "$1" == "register" ]; then
  echo "Registering an entry for spire agent..."
  register_server_entries \
    -spiffeID spiffe://example.org/ns/spire/sa/spire-agent \
    -selector k8s_sat:cluster:test \
    -selector k8s_sat:agent_ns:spire \
    -selector k8s_sat:agent_sa:spire-agent \
    -node

  echo "Registering an entry for the front app..."
  register_server_entries \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/front \
    -selector k8s:ns:mtls-on-eks \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:front \
    -selector k8s:container-name:envoy

  echo "Registering an entry for the color app - version:red..."
  register_server_entries \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/colorred \
    -selector k8s:ns:mtls-on-eks \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:color \
    -selector k8s:pod-label:version:red \
    -selector k8s:container-name:envoy

  echo "Registering an entry for the color app - version:blue..."
  register_server_entries \
    -parentID spiffe://example.org/ns/spire/sa/spire-agent \
    -spiffeID spiffe://example.org/colorblue \
    -selector k8s:ns:mtls-on-eks \
    -selector k8s:sa:default \
    -selector k8s:pod-label:app:color \
    -selector k8s:pod-label:version:blue \
    -selector k8s:container-name:envoy
