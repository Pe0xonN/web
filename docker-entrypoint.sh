#! /bin/sh -eux

mkdir -p $HOME/.config/rclone

mkdir -p $HOME/rclone/cache

if [ "$RCLONE_CONFIG_BASE64" != "" ]; then
  echo "[INFO] Config Rclone from RCLONE_CONFIG_BASE64 env"
  echo $RCLONE_CONFIG_BASE64 | base64 -d > $HOME/.config/rclone/rclone.conf
  echo "[INFO] Config Rclone from RCLONE_CONFIG_BASE64 completed"
fi

rclone serve webdav --vfs-cache-mode writes --addr :7860 --cache-dir $HOME/rclone/cache --user "$USER" --pass "$PASS" td_hf: