#!/bin/bash

REPORT="$HOME/Desktop/DrX-Git-Audit.txt"

ROOTS=(

  "$HOME/Documents/GitHub"

  "$HOME/Documents/APPS"

)

{

  echo "========================================"

  echo "DR. X — GIT REPOSITORY AUDIT"

  echo "========================================"

  echo "Generated: $(date)"

  echo

  for ROOT in "${ROOTS[@]}"; do

    [ -d "$ROOT" ] || continue

    while IFS= read -r -d '' GITDIR; do

      REPO="${GITDIR%/.git}"

      echo "----------------------------------------"

      echo "REPOSITORY: $REPO"

      git -C "$REPO" rev-parse \

        --abbrev-ref HEAD 2>/dev/null \

        | sed 's/^/BRANCH: /'

      REMOTE_COUNT=$(

        git -C "$REPO" remote 2>/dev/null |

        wc -l |

        tr -d ' '

      )

      echo "REMOTES CONFIGURED: $REMOTE_COUNT"

      CHANGES=$(

        git -C "$REPO" status \

          --porcelain=v1 \

          --untracked-files=normal 2>/dev/null |

        wc -l |

        tr -d ' '

      )

      echo "LOCAL CHANGES: $CHANGES"

      UPSTREAM=$(

        git -C "$REPO" \

          rev-parse --abbrev-ref \

          --symbolic-full-name '@{upstream}' \

          2>/dev/null

      )

      if [ -n "$UPSTREAM" ]; then

        COUNTS=$(

          git -C "$REPO" \

            rev-list --left-right --count \

            "$UPSTREAM"...HEAD 2>/dev/null

        )

        echo "UPSTREAM: $UPSTREAM"

        echo "BEHIND / AHEAD: $COUNTS"

      else

        echo "UPSTREAM: NONE"

      fi

      echo

    done < <(

      find "$ROOT" \

        -name .git \

        -type d \

        -print0 2>/dev/null

    )

  done

} > "$REPORT"

echo "Audit complete: $REPORT"

echo "No repositories were modified."
