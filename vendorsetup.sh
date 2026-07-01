#!/bin/bash

RET1=0
RET2=0

echo "- Applying gore transsion fod hack"
cd frameworks/base
curl -sL https://github.com/fjrXTR/android_frameworks_base-AXION/commit/cd9e48a500ab62df97ed0d58df8afa848bd0c189.patch | git am || {
  RET1=$?
  git am --abort >/dev/null 2>&1
}
cd ../../

echo "- Applying system/sepolicy native_app_zygote visibility patch"
cd system/sepolicy
curl -sL https://raw.githubusercontent.com/Delterium/patches/seventeen/sepoilicy/sepolicy_patch.patch | git apply || {
  RET2=$?
}
cd ../../

if [ $RET1 -ne 0 ]; then
  echo "ERROR: frameworks/base patch is not applied! Maybe it's already patched, or you'll have to adapt it to this specific rom source?"
else
  echo "OK: frameworks/base patched successfully"
fi

if [ $RET2 -ne 0 ]; then
  echo "ERROR: system/sepolicy patch is not applied! Maybe it's already patched, or you'll have to adapt it to this specific rom source?"
else
  echo "OK: system/sepolicy patched successfully"
fi