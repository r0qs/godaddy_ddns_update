#!/bin/bash

INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/godaddy_ddns_update"
SERVICE_DIR="/etc/systemd/system"

start() {
  echo "Enabling and starting timer"
  # Enable and start timer
  systemctl enable godaddy_ddns_update.timer
  systemctl start godaddy_ddns_update.timer
}

stop() {
  echo "Disabling and stoping timer"
  # Disable and stop timer
  systemctl stop godaddy_ddns_update.timer
  systemctl disable godaddy_ddns_update.timer
}

install() {
  echo "Installing Godaddy DDNS IP update scripts"
  echo "Installing binary on ${INSTALL_DIR}/godaddy_ddns_update ..."
  # install binary
  cp godaddy_ddns_update ${INSTALL_DIR}
  chmod +x ${INSTALL_DIR}/godaddy_ddns_update

  echo "Copying configuration template to ${CONFIG_DIR} ..."
  # copy template configuration file
  mkdir -p ${CONFIG_DIR}
  cp ddns_data.json ${CONFIG_DIR}

  echo "Installing service on ${SERVICE_DIR}/godaddy_ddns_update.service ..."
  # install service and timer
  cp godaddy_ddns_update.service ${SERVICE_DIR}

  echo "Installing timer on ${SERVICE_DIR}/godaddy_ddns_update.timer ..."
  cp godaddy_ddns_update.timer ${SERVICE_DIR}

  start
}

uninstall() {
  stop
  echo "Uninstalling Godaddy DDNS IP update scripts"
  echo "Removing ${INSTALL_DIR}/godaddy_ddns_update ..."
  rm -f ${INSTALL_DIR}/godaddy_ddns_update
  echo "Removing ${CONFIG_DIR} ..."
  rm -rf ${CONFIG_DIR}
  echo "Removing ${SERVICE_DIR}/godaddy_ddns_update.service ..."
  rm -f ${SERVICE_DIR}/godaddy_ddns_update.service
  echo "Removing ${SERVICE_DIR}/godaddy_ddns_update.timer ..."
  rm -f ${SERVICE_DIR}/godaddy_ddns_update.timer
}

usage()
{
  echo "Godaddy DDNS IP update"
  echo ""
  echo "./setup_godaddy_ddns_update.sh"
  echo "--help"
  echo "--install"
  echo "--remove"
  echo "--start"
  echo "--stop"
  echo ""
}

while [ "$1" != "" ]; do
  cmd=`echo $1 | awk -F= '{print $1}'`
  case $cmd in
    --help)
      usage
      exit
      ;;
    --install)
      install
      ;;
    --remove)
      uninstall
      ;;
    --start)
      start
      ;;
    --stop)
      stop
      ;;
    *)
      echo "ERROR: unknown parameter \"$cmd\""
      usage
      exit 1
      ;;
  esac
  shift
done