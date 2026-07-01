#!/bin/bash

RET1=0
RET2=0


cd frameworks/base
if git log -50 --oneline | grep -q "Add HBM Trigger for Transsion UDFPS"; then
  echo "- frameworks/base is already patched, skipping."
else
  echo "- Applying frameworks/base fod patch..."
  curl -sL https://github.com/fjrXTR/android_frameworks_base-AXION/commit/cd9e48a500ab62df97ed0d58df8afa848bd0c189.patch | git am || {
    RET1=$?
    git am --abort >/dev/null 2>&1
  }
fi
cd ../../

cd system/sepolicy
if [ -f "public/native_app_zygote.te" ]; then
  echo "- system/sepolicy is already patched, skipping."
else
  echo "- Applying system/sepolicy native_app_zygote visibility patch..."
  
  sed -i 's/^type native_app_zygote, domain;/#type native_app_zygote, domain;/g' private/native_app_zygote.te
  
  echo "type native_app_zygote, domain;" > public/native_app_zygote.te
  
  if [ -f "public/native_app_zygote.te" ]; then
    echo "OK: system/sepolicy patched locally."
  else
    RET2=1
  fi
fi
cd ../../

if [ $RET1 -ne 0 ]; then
  echo "ERROR: frameworks/base patch is not applied! Maybe you need to run 'git -C frameworks/base am --abort'?"
else
  echo "OK: frameworks/base check passed"
fi

if [ $RET2 -ne 0 ]; then
  echo "ERROR: system/sepolicy patch is not applied! Please check permissions."
else
  echo "OK: system/sepolicy check passed"
fi