#!/bin/bash -xe

. "/srv/deployment/integration/slave-scripts/bin/mw-set-env.sh"

LOG_DIR="$WORKSPACE/log"
LOG_FILE="$LOG_DIR/update_sql.log"
UPDATE="php $MW_INSTALL_PATH/maintenance/update.php"

mkdir -p $LOG_DIR

# Dry run the updating script with logging
#
# IT IS NOT DRY RUN !! The post-db maintenance scripts are being run which
# breaks at least Flow and Wikibase. Most probably an issue in MediaWiki core
# update.php script.
#
# Issue logged as bug 67163
#
# Might want to restore the sleep(1) below later on
#$UPDATE --quiet --quick --schema $LOG_FILE

# delete unless it has some content
[ -s $LOG_FILE ] || rm $LOG_FILE

# Running --schema insert an entry in `updatelog` table which vary by unix
# epoch.  When rerunning the update.php script without --schema, we end up with
# a duplicate key for ul_key.
# Sleeping for one second will ensure the second call of update.php has a
# different unix timestamp and hence a different key.
#
# -- hashar 2014-06-25
#
# Commented out since --schema is commented out above
#sleep 1

# Actually run the update
$UPDATE --quick
