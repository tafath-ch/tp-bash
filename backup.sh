
#!/bin/bash

set -Eeuo pipefail

# Dossier à sauvegarder : data par défaut
DOSSIER="${1:-data}"

# Dossier où conserver les sauvegardes
BACKUP_DIR="backups"

# Vérifier que le dossier existe
if [ ! -d "$DOSSIER" ]; then
    echo "ERREUR : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

# Créer le dossier des sauvegardes
mkdir -p "$BACKUP_DIR"

# Générer la date et l'heure
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Nom de l'archive
ARCHIVE="$BACKUP_DIR/backup_${DATE}.tar.gz"

# Créer l'archive compressée
echo "Création de la sauvegarde de '$DOSSIER'..."
tar -czf "$ARCHIVE" "$DOSSIER"

echo "Sauvegarde créée : $ARCHIVE"

# Supprimer les sauvegardes de plus de 7 jours
for fichier in "$BACKUP_DIR"/backup_*.tar.gz; do
    # Ignorer le motif si aucun fichier ne correspond
    [ -f "$fichier" ] || continue

    if find "$fichier" -mtime +7 -print -quit | grep -q .; then
        echo "Suppression de l'ancienne sauvegarde : $fichier"
        rm "$fichier"
    fi
done

echo "Sauvegarde terminée avec succès."
exit 0
