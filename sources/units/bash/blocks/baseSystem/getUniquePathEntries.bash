function getUniquePathEntries {
  local uniquePathEntries="$(
    printf "%s" "$PATH" \
    | tr ":" "\n" \
    | sort --unique \
    | tr "\n" ":"
  )"
  printf "%s" "$uniquePathEntries"
}
