{{- define "librechat-admin-panel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "librechat-admin-panel.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "librechat-admin-panel.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
app.kubernetes.io/name: {{ include "librechat-admin-panel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: admin-panel
app.kubernetes.io/part-of: librechat
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "librechat-admin-panel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "librechat-admin-panel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: admin-panel
{{- end }}

{{- define "librechat-admin-panel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "librechat-admin-panel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "librechat-admin-panel.secretName" -}}
{{- if .Values.existingSecretName }}
{{- .Values.existingSecretName }}
{{- else }}
{{- include "librechat-admin-panel.fullname" . }}
{{- end }}
{{- end }}
