#!/bin/bash -xe

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

LOG_DIR="$WORKSPACE/log"
LOG_FILE="$LOG_DIR/update_sql.log"
UPDATE="php $MW_INSTALL_PATH/maintenance/update.php"

mkdir -p $LOG_DIR

# Dry run the updating script with logging
$UPDATE --quiet --quick --schema $LOG_FILE

# delete unless it has some content
[ -s $LOG_FILE ] || rm $LOG_FILE

# Actually run the update
$UPDATE --quick
