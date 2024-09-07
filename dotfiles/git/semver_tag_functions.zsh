
# === Git semantic version tags ===

# get the latest annotated tag in a semantic versioning format and extract the major, minor, patch, and prerelease identifiers
function _git_latest_version_tag() {
  # Get the latest annotated tag
  latest_tag=$(git for-each-ref --sort=-taggerdate --format '%(refname:strip=2)' refs/tags | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?$' | head -n 1)

  # Check if a tag was found
  if [[ -z "$latest_tag" ]]; then
    echo "No annotated tags found in the repository."
    return 1
  fi

  # Extract the major, minor, patch numbers, and prerelease identifiers
  if [[ "$latest_tag" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?$ ]]; then
    _git_latest_version_tag__major=${match[1]}
    _git_latest_version_tag__minor=${match[2]}
    _git_latest_version_tag__patch=${match[3]}
    _git_latest_version_tag__prerelease=${match[4]}
  else
    echo "Latest tag is not in the semantic versioning format: $latest_tag"
    return 1
  fi
}

function _git_print_latest_version_tag() {
  latest_tag=$(git for-each-ref --sort=-taggerdate --format '%(refname:strip=2)' refs/tags | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?$' | head -n 1)
  
  if [[ -z "$latest_tag" ]]; then
    echo "No annotated tags found in the repository."
    return 1
  fi
  echo $latest_tag
}

# create a new Git tag in a semantic versioning format from the provided major, minor, patch numbers, and optional prerelease identifier
function _git_make_semantic_version_tag() {
  if [[ $# -lt 3 || $# -gt 4 ]]; then
    echo "Error: Invalid number of arguments.\nUsage: _git_make_semantic_version_tag <major> <minor> <patch> [prerelease]"
    return 1
  fi

  major=$1
  minor=$2
  patch=$3
  prerelease=$4

  if [[ -n "$prerelease" ]]; then
    new_tag="v${major}.${minor}.${patch}-${prerelease}"
  else
    new_tag="v${major}.${minor}.${patch}"
  fi

  git tag -a $new_tag -m "Release $new_tag"
  echo "Created new tag: $new_tag"
}

# create a git tag for a new minor version
function _git_increment_minor_version_tag() {
  _git_latest_version_tag

  if [[ $? -ne 0 ]]; then
    echo "Latest tag is not in the semantic versioning format: $latest_tag"
    return 1
  fi

  _git_make_semantic_version_tag \
    $_git_latest_version_tag__major \
    $((_git_latest_version_tag__minor + 1)) \
    0
}

# create a git tag for a new patch version with optional prerelease identifier
function _git_increment_patch_version_tag() {
  _git_latest_version_tag

  if [[ $? -ne 0 ]]; then
    echo "Latest tag is not in the semantic versioning format: $latest_tag"
    return 1
  fi

  if [[ $# -eq 1 ]]; then
    prerelease=$1
    _git_make_semantic_version_tag \
      $_git_latest_version_tag__major \
      $_git_latest_version_tag__minor \
      $_git_latest_version_tag__patch \
      $prerelease
  else
    _git_make_semantic_version_tag \
      $_git_latest_version_tag__major \
      $_git_latest_version_tag__minor \
      $((_git_latest_version_tag__patch + 1))
  fi
}

function _git_init_semantic_version_tag() {
  _git_make_semantic_version_tag 0 1 0
}

function _git_delete_latest_version_tag() {
  latest_tag=$(git for-each-ref --sort=-taggerdate --format '%(refname:strip=2)' refs/tags | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?$' | head -n 1)

  if [[ -z "$latest_tag" ]]; then
    echo "No annotated tags found in the repository."
    return 1
  fi
  git tag -d $latest_tag
}