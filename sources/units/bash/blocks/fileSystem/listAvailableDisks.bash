# ---
# note   : `exclude` 7 (loops), 11 (ROMs), 251 (swaps)
# ---
function listAvailableDisks {
  lsblk --paths --nodeps --noheadings --exclude 7,11,251 --output NAME,VENDOR,TYPE,SIZE
}
