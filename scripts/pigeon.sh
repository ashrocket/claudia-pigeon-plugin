#!/bin/bash
# pigeon.sh — Claudia Pigeon API client
# Usage: pigeon.sh {send|poll|health|check} [args...]
set -euo pipefail

: "${PIGEON_URL:?PIGEON_URL is not set}"
: "${PIGEON_API_KEY:?PIGEON_API_KEY is not set}"

cmd_send() {
  local type="" title="" body="" html="" project=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --type)    type="$2";    shift 2 ;;
      --title)   title="$2";   shift 2 ;;
      --body)    body="$2";    shift 2 ;;
      --html)    html="$2";    shift 2 ;;
      --project) project="$2"; shift 2 ;;
      *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
  done

  if [[ -z "$type" || -z "$title" ]]; then
    echo '{"ok":false,"error":"--type and --title are required"}' >&2
    exit 1
  fi

  local content_field="body"
  local content_value="$body"
  if [[ -n "$html" ]]; then
    content_field="html"
    content_value="$html"
  fi

  local payload=$(jq -n \
    --arg type "$type" \
    --arg title "$title" \
    --arg content "$content_value" \
    --arg project "${project:-}" \
    '{
      type: $type,
      title: $title,
      instance: {
        model: "claude-code-plugin",
        session_id: "pigeon-plugin",
        project: ($project | if . == "" then "pigeon-plugin" else . end),
        source: "claude-code-plugin"
      }
    }' | jq --arg field "$content_field" --arg val "$content_value" \
    '.[$field] = ($val | if . == "" then null else . end)'
  )

  curl -s -X POST "${PIGEON_URL}/api/messages" \
    -H "Authorization: Bearer ${PIGEON_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$payload"
}

cmd_poll() {
  local msg_id="$1"
  local max_polls=60  # 5 minutes at 5s intervals
  local poll_count=0

  if [[ -z "$msg_id" ]]; then
    echo '{"ok":false,"error":"message_id required"}' >&2
    exit 1
  fi

  while (( poll_count < max_polls )); do
    local resp=$(curl -s "${PIGEON_URL}/api/replies/${msg_id}" \
      -H "Authorization: Bearer ${PIGEON_API_KEY}")

    local reply=$(echo "$resp" | jq -r '.data.reply // empty' 2>/dev/null || true)
    if [[ -n "$reply" ]]; then
      echo "$resp"
      return 0
    fi

    sleep 5
    (( poll_count++ ))
  done

  echo '{"ok":false,"error":"poll timeout after 5 minutes"}' >&2
  exit 1
}

cmd_health() {
  curl -s "${PIGEON_URL}/api/health" \
    -H "Authorization: Bearer ${PIGEON_API_KEY}" 2>/dev/null || \
    echo '{"ok":false,"error":"server unreachable"}'
}

cmd_check() {
  local health=$(cmd_health)
  local ok=$(echo "$health" | jq '.ok // false')

  jq -n \
    --argjson pigeon_ok "$ok" \
    '{
      pigeon_url: $ENV.PIGEON_URL,
      pigeon_configured: ($ENV.PIGEON_API_KEY != ""),
      pigeon_health: $pigeon_ok,
      curl_available: true,
      jq_available: true
    }' | jq '.pigeon_health = (if .pigeon_health then "healthy" else "unhealthy" end)'
}

# Main dispatch
case "${1:-}" in
  send)   shift; cmd_send "$@" ;;
  poll)   shift; cmd_poll "$@" ;;
  health) cmd_health ;;
  check)  cmd_check ;;
  *)
    echo "Usage: pigeon.sh {send|poll|health|check}" >&2
    exit 1
    ;;
esac
