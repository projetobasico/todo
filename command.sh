#!/bin/bash

# === CONFIGURE HERE ===
start_date="2017-07-21"
end_date="2025-07-10"
total_days=350   # number of random WEEKDAYS in the range
# ======================

messages=(
  "Fix typo in README"
  "Update dependencies"
  "Refactor user authentication logic"
  "Improve error handling in API"
  "Optimize database queries"
  "Add unit tests for payment service"
  "Update UI for better mobile support"
  "Fix bug in checkout flow"
  "Improve logging for debugging"
  "Add missing translations"
  "Enhance form validation"
  "Update documentation"
  "Implement search functionality"
  "Fix CSS layout issue"
  "Improve image loading performance"
)

# Generate all WEEKDAYS in range (Mon–Fri)
weekday_days=()
current_sec=$(date -d "$start_date" +%s)
end_sec=$(date -d "$end_date" +%s)
while [ $current_sec -le $end_sec ]; do
  day=$(date -d "@$current_sec" +%Y-%m-%d)
  dow=$(date -d "$day" +%u)   # 1=Mon ... 7=Sun
  if [ "$dow" -lt 6 ]; then   # keep Mon–Fri only
    weekday_days+=("$day")
  fi
  current_sec=$((current_sec + 86400))
done

# Randomly pick N weekdays from the list
selected_days=($(printf "%s\n" "${weekday_days[@]}" | shuf -n "$total_days"))

# Loop through chosen weekdays
for day in "${selected_days[@]}"; do
  commits=$((RANDOM % 3 + 1))  # 1–3 commits per day

  for j in $(seq 1 "$commits"); do
    msg=${messages[$RANDOM % ${#messages[@]}]}

    echo "$msg" > file.js
    git add .

    # Random time 08:00–18:59
    hour=$((RANDOM % 11 + 8))
    minute=$((RANDOM % 60))
    second=$((RANDOM % 60))

    GIT_COMMITTER_DATE="$day $hour:$minute:$second" \
    git commit --date="$day $hour:$minute:$second" -m "$msg"
  done
done
