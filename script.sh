#!/usr/bin/env bash

set -euo pipefail

PROJECT_ID=my-project
ALERT_POLICY_NUMBERS=(
  12345  # Alert Policy for A
  23451  # Alert Policy for B
)

policies=()
for num in ${ALERT_POLICY_NUMBERS[@]}; do
  policies+=("projects/${PROJECT_ID}/alertPolicies/${num}")
done
# 配列を `,` で文字列結合
criteria="$(IFS=,; echo "${policies[*]}")"

# TimeZoneをJSTに変更
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# スヌーズ作成
gcloud alpha monitoring snoozes create \
    --display-name="Snooze: Monitoring A & B at night $(date +%F)" \
    --criteria-policies="${criteria}" \
    --start-time="$(date +%F)T22:00:00+0900" \
    --end-time="$(date +%F -d tomorrow)T08:59:59+0900"

# 最新3件のスヌーズ設定を表示
gcloud alpha monitoring snoozes list --sort-by="~interval.end_time" --limit 3
