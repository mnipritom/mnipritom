_2["getSystemPackageManager"]=$(
  function getSystemPackageManager {
    eval "${_0[getHostDistribution]}"
    eval "${_0[getHostDistributionPackageManager]}"
    local hostDistribution=$(
      getHostDistribution
    )
    local hostDistributionPackageManager=$(
      getHostDistributionPackageManager "$hostDistribution"
    )
    printf "%s" "$hostDistributionPackageManager"
    unset -f getHostDistribution
    unset -f getHostDistributionPackageManager
  }
  declare -f getSystemPackageManager
  unset -f getSystemPackageManager
)
