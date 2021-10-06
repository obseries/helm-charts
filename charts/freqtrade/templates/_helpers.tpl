{{/*
Return the proper Freqtrade image name
*/}}
{{- define "freqtrade.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "freqtrade.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.git) "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper git image name
*/}}
{{- define "git.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.git "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper s3sync image name
*/}}
{{- define "s3sync.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.s3sync "global" .Values.global) -}}
{{- end -}}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "freqtrade.createConfigmap" -}}
{{- if and .Values.configuration (empty .Values.configurationConfigMap) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a configmap object should be created for s3cmd
*/}}
{{- define "freqtrade.s3cmd.createConfigmap" -}}
{{- if and .Values.database.syncDatabaseWithS3.enabled }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the configuration configmap name
*/}}
{{- define "freqtrade.configmapName" -}}
{{- if .Values.configurationConfigMap -}}
    {{- printf "%s" (tpl .Values.configurationConfigMap $) -}}
{{- else -}}
    {{- printf "%s-configuration" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class
Usage:
{{ include "freqtrade.storageClass" (dict "global" .Values.global "local" .Values.master) }}
*/}}
{{- define "freqtrade.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- if (eq "-" .global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .local.storageClass -}}
              {{- if (eq "-" .local.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .local.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .local.storageClass -}}
        {{- if (eq "-" .local.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .local.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "freqtrade.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
