#!/bin/bash

echo "- Applying gore transsion fod hack"
cd frameworks/base
curl https://github.com/fjrXTR/android_frameworks_base-AXION/commit/cd9e48a500ab62df97ed0d58df8afa848bd0c189.patch | git am || {
  RET=$?
  git am --abort >/dev/null 2>&1
}
cd ../../


if [ $RET -ne 0 ]; then
  echo "ERROR: Patch is not applied! Maybe it's already patched, or you'll have to adapt it to this specific rom source?"
else
  echo "OK: All patched"
fi
