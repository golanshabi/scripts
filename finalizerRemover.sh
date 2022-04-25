#!/bin/sh
namespace=-n $2
object=$1
if [ "$2" == "" ]; then
  for namespace_name in $(kubectl get $object -A | awk '$2 != "NAME" { print $1 ":" $2 }')
  do
    namespace_name=(${namespace_name//:/ })
    kubectl patch $object ${namespace_name[1]} -n ${namespace_name[0]} -p '{"metadata":{"finalizers":null}}' --type=merge
  done
    
else
  for OUTPUT in $(kubectl get $object -n $namespace | awk '$1 != "NAME" { print $1}')
  do
    kubectl patch $object $OUTPUT $namespace -p '{"metadata":{"finalizers":null}}' --type=merge
  done
fi

