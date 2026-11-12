#!/bin/bash
# ==============================================================================
# Skripti nimi: backupexec.sh
# Kirjeldus:    Automaatne varundusskript: kontrollib vaba ruumi, valib parima
#               kompressori, arvestab .backupignore failiga, testib arhiivi
#               avanemist ja SHA-256 kontrollsummat, logib ning hoiab alles 3
#               viimast varukoopiat.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="${SCRIPT_DIR}/praks2"
SRC_PARENT="$BASE_DIR"
SRC_NAME="src"
SRC_PATH="${SRC_PARENT}/${SRC_NAME}"
BACKUP_DIR="${BASE_DIR}/backup"
LOG_DIR="${BASE_DIR}/logs"
LOG_FILE="${LOG_DIR}/backup.log"
KEEP_COUNT=3

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log_msg() {
    local level="$1"
    local message="$2"
    local line="[ $(date '+%F %T') ] [$level] $message"
    echo "$line"
    echo "$line" >> "$LOG_FILE"
}

# Ajutine kaust ja automaatne puhastus skripti lõppedes
TMP_DIR=$(mktemp -d)
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

log_msg "INFO" "=== BACKUP START: alustan kausta $SRC_PATH varundamist ==="

# 1. Lähtekausta kontroll
if [[ ! -d "$SRC_PATH" ]]; then
    log_msg "ERROR" "Lähtekausta $SRC_PATH ei leitud!"
    exit 1
fi

# 2. Vaba ruumi kontroll
SRC_SIZE=$(du -sb "$SRC_PATH" | awk '{print $1}')
FREE_SPACE=$(df -B1 "$BACKUP_DIR" | awk 'NR==2{print $4}')
REQUIRED_SPACE=$(( SRC_SIZE * 12 / 10 + 1048576 ))

log_msg "INFO" "Lähtekausta suurus: ${SRC_SIZE} B | Vaba ruum: ${FREE_SPACE} B"
if [[ "$FREE_SPACE" -lt "$REQUIRED_SPACE" ]]; then
    log_msg "ERROR" "Pole piisavalt vaba ruumi! Vaja: ${REQUIRED_SPACE} B, vaba: ${FREE_SPACE} B."
    exit 1
fi

# 3. Parima kompressori valik (zstd -> xz -> gzip)
if command -v zstd &>/dev/null; then
    EXT="tar.zst"
    COMPRESS_ARGS=(-I "zstd -19 -T0")
    DECOMPRESS_ARGS=(-I "zstd -d")
    COMP_NAME="zstd"
elif command -v xz &>/dev/null; then
    EXT="tar.xz"
    COMPRESS_ARGS=(-J)
    DECOMPRESS_ARGS=(-J)
    COMP_NAME="xz"
else
    EXT="tar.gz"
    COMPRESS_ARGS=(-z)
    DECOMPRESS_ARGS=(-z)
    COMP_NAME="gzip"
fi
log_msg "INFO" "Valitud kompressor: $COMP_NAME (.$EXT)"

# 4. Failinime koostamine ja olemasolu kontroll
TIMESTAMP=$(date '+%F_%H-%M-%S')
ARCHIVE_NAME="${SRC_NAME}_${TIMESTAMP}.${EXT}"
TMP_ARCHIVE="${TMP_DIR}/${ARCHIVE_NAME}"
FINAL_ARCHIVE="${BACKUP_DIR}/${ARCHIVE_NAME}"

if [[ -e "$FINAL_ARCHIVE" ]]; then
    log_msg "ERROR" "Arhiiv $FINAL_ARCHIVE on juba olemas!"
    exit 1
fi

# 5. .backupignore kontroll
TAR_EXCLUDE_ARGS=()
if [[ -f "${SRC_PATH}/.backupignore" ]]; then
    TAR_EXCLUDE_ARGS+=(--exclude-from="${SRC_PATH}/.backupignore")
    log_msg "INFO" "Kasutan välistusreegleid failist ${SRC_PATH}/.backupignore"
fi

# 6. Pakkimine ajutisse kausta
tar "${TAR_EXCLUDE_ARGS[@]}" "${COMPRESS_ARGS[@]}" -cf "$TMP_ARCHIVE" -C "$SRC_PARENT" "$SRC_NAME"

# 7. Arhiivi sisu ja avanemise kontroll
FILE_COUNT=$(tar "${DECOMPRESS_ARGS[@]}" -tf "$TMP_ARCHIVE" | wc -l)
if [[ "$FILE_COUNT" -lt 2 ]]; then
    log_msg "ERROR" "Arhiiv on tühi või vigane (kirjeid: $FILE_COUNT)!"
    exit 1
fi
log_msg "INFO" "Arhiivi terviklikkus kontrollitud (kirjeid arhiivis: $FILE_COUNT)."

# 8. SHA-256 kontrollsumma loomine ja kontroll
(
    cd "$TMP_DIR"
    sha256sum "$ARCHIVE_NAME" > "${ARCHIVE_NAME}.sha256"
    sha256sum -c "${ARCHIVE_NAME}.sha256" >/dev/null
)
log_msg "INFO" "SHA-256 kontrollsumma kontrollitud: OK"

# 9. Teisaldamine lõppkausta
mv "$TMP_ARCHIVE" "$FINAL_ARCHIVE"
mv "${TMP_ARCHIVE}.sha256" "${FINAL_ARCHIVE}.sha256"

ARCHIVE_SIZE=$(du -h "$FINAL_ARCHIVE" | awk '{print $1}')
log_msg "INFO" "Varukoopia salvestatud: $FINAL_ARCHIVE (suurus: $ARCHIVE_SIZE)"

# 10. Ainult viimase 3 koopia hoidmine
OLD_ARCHIVES=$(ls -1t "${BACKUP_DIR}/${SRC_NAME}_"*.tar.* 2>/dev/null | grep -v '\.sha256$' | tail -n +$((KEEP_COUNT + 1)) || true)
if [[ -n "$OLD_ARCHIVES" ]]; then
    while IFS= read -r old_file; do
        rm -f "$old_file" "${old_file}.sha256"
        log_msg "INFO" "Eemaldati vana varukoopia: $(basename "$old_file")"
    done <<< "$OLD_ARCHIVES"
fi

log_msg "INFO" "=== BACKUP END: varundamine õnnestus edukalt! ==="
