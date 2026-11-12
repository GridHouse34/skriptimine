#!/bin/bash
# ==============================================================================
# Skripti nimi: home_backup.sh
# Kirjeldus:    Varundab kõikide süsteemi kasutajate kodukataloogid (/home/*)
#               eraldi .tar.gz arhiividena kausta /home_bcp koos kuupäevaga.
# Käivitamine:  sudo ./home_backup.sh (töötab igast kataloogist)
# ==============================================================================

set -euo pipefail

# Absoluutteed tagavad, et skript töötab sõltumata käivitamise asukohast
SOURCE_BASE="/home"
BACKUP_DIR="/home_bcp"
DATE=$(date +%d.%m.%Y)

# Kontrolli, et skript käivitatakse root-õigustes
if [[ $EUID -ne 0 ]]; then
    echo "VIGA: Palun käivita skript root-õigustes (sudo $0)."
    exit 1
fi

# Loo varunduskaust, kui seda veel ei eksisteeri
if [[ ! -d "$BACKUP_DIR" ]]; then
    mkdir -p "$BACKUP_DIR"
    chmod 700 "$BACKUP_DIR"
    echo "Loodi varunduskataloog: $BACKUP_DIR"
fi

echo "=== Alustan kodukataloogide varundamist ($DATE) ==="

# Käi läbi kõik üksused kataloogis /home
for user_path in "$SOURCE_BASE"/*; do
    if [[ -d "$user_path" ]]; then
        username=$(basename "$user_path")

        # Välista süsteemne lost+found kaust
        if [[ "$username" == "lost+found" ]]; then
            continue
        fi

        archive_name="${username}.${DATE}.tar.gz"
        archive_path="${BACKUP_DIR}/${archive_name}"

        echo "Varundan kasutajat '$username' -> $archive_path ..."

        # -C "$SOURCE_BASE" muudab ajutiselt töökataloogi enne pakkimist
        tar -czpf "$archive_path" -C "$SOURCE_BASE" "$username"
        chmod 600 "$archive_path"
    fi
done

echo "=== Varundamine lõpetatud! Tulemused kaustas $BACKUP_DIR: ==="
ls -lh "$BACKUP_DIR"
