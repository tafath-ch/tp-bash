
#!/bin/bash

SEUIL=${1:-80}

UTILISATION=$(df / | awk 'NR==2 {print $(NF-1)}' | tr -d '%')

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : espace disque utilisé à ${UTILISATION}%."
    exit 1
else
    echo "OK : espace disque utilisé à ${UTILISATION}%."
    exit 0
fi
