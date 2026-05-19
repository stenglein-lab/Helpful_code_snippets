#!/usr/bin/env bash
#
# retrieve github contribution data using curl
#
# Query the GitHub GraphQL API for contribution data over time.
# Outputs raw JSON responses (one per year) to stdout.
#
# Usage: see usage() below or run with -h

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
USERNAME=""
YEARS=()
GITHUB_API="https://api.github.com/graphql"

# ---------------------------------------------------------------------------
# Usage
# ---------------------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Query the GitHub GraphQL API for contribution calendar data.
Outputs one raw JSON blob per year to stdout.

Options:
  -u, --username USERNAME   GitHub username to query (required)

  -t, --token TOKEN         GitHub personal access token (required)

  -y, --year YEAR           Year to retrieve (can be specified multiple times,
                            e.g. -y 2022 -y 2023); defaults to the current year

  -h, --help                Show this help message and exit

Examples:
  # Single year using made-up access token
  $(basename "$0") -u stenglein-lab -t ghp_abc123 -y 2023

  # Multiple years
  $(basename "$0") -u stenglein-lab -t ghp_abc123 -y 2022 -y 2023 -y 2024

  # Pipe output to your own JSON tool
  $(basename "$0") -u stenglein-lab -t ghp_abc123 -y 2023 | my_json_tool

Notes:
  - The GitHub API limits contributionsCollection to a maximum span of one year,
    so this script issues one request per year.
  - Generate a personal access token at:
    https://github.com/settings/tokens
    Required scopes: read:user (and repo for private repository data)
  - Beware non-secure use of token as command-line argument

EOF
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--username)
      USERNAME="$2"
      shift 2
      ;;
    -t|--token)
      TOKEN="$2"
      shift 2
      ;;
    -y|--year)
      YEARS+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option '$1'" >&2
      echo "Run '$(basename "$0") --help' for usage." >&2
      exit 1
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------
if [[ -z "$USERNAME" ]]; then
  usage
  echo "Error: --username is required." >&2
  exit 1
fi

if [[ -z "$TOKEN" ]]; then
  usage
  echo "Error: no GitHub token provided." >&2
  echo "  Use --token or set the GITHUB_TOKEN environment variable." >&2
  exit 1
fi

# Default to current year if none specified
if [[ ${#YEARS[@]} -eq 0 ]]; then
  YEARS+=("$(date +%Y)")
fi

# Basic sanity check on year values
for Y in "${YEARS[@]}"; do
  if ! [[ "$Y" =~ ^[0-9]{4}$ ]]; then
    usage
    echo "Error: '$Y' does not look like a valid 4-digit year." >&2
    exit 1
  fi
done

# ---------------------------------------------------------------------------
# GraphQL query (single-line; variables passed separately in JSON body)
# ---------------------------------------------------------------------------
QUERY='query($userName: String!, $from: DateTime!, $to: DateTime!) { user(login: $userName) { contributionsCollection(from: $from, to: $to) { contributionCalendar { totalContributions weeks { contributionDays { contributionCount date } } } } } }'

# ---------------------------------------------------------------------------
# Main loop — one request per year
# ---------------------------------------------------------------------------
for YEAR in "${YEARS[@]}"; do
  echo "--- Fetching contributions for $USERNAME in $YEAR ---" >&2

  curl -s \
    -o ${YEAR}.json \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -X POST "$GITHUB_API" \
    --data @- <<EOF
{
  "query": "$QUERY",
  "variables": {
    "userName": "$USERNAME",
    "from": "${YEAR}-01-01T00:00:00.000Z",
    "to":   "${YEAR}-12-31T23:59:59.000Z"
  }
}
EOF
done



