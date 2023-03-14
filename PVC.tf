resource "kubectl_manifest" "storage-class" {
  yaml_body = <<YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: filestore-example
provisioner: filestore.csi.storage.gke.io
volumeBindingMode: Immediate
allowVolumeExpansion: true
parameters:
  tier: standard
  network: default

YAML
}

resource "kubectl_manifest" "pvc-claim" {
  yaml_body = <<YAML
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: podpvc
spec:
  accessModes:
  - ReadWriteMany
  storageClassName: filestore-example
  resources:
    requests:
      storage: 1Ti

YAML
}