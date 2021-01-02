#!/system/bin/sh

# decode url, otherwise application won't start
urldecode(){
  str=$(echo "$1" | sed 's/+/ /g;s/%\(..\)/\\x\1/g;')
  str=$(echo "$str" | sed 's/ /%20/g;')
  echo -e "$str"
}

TITLE=$1

# get web app intent
INTENT=$(sqlite3 /data/data/com.android.launcher/databases/launcher.db "SELECT intent FROM favorites WHERE title='$TITLE'")

# if web app is not found, return error and a list of available web apps
if [[ -z "$INTENT" ]]
then
   WEBAPPS=$(sqlite3 /data/data/com.android.launcher/databases/launcher.db "SELECT \"      \"||title FROM favorites WHERE title IS NOT ''")
   WEBAPPS=$(echo "$WEBAPPS" | egrep '^      ')
   echo "Unknown webapp '$TITLE', currently available:\n$WEBAPPS"
   exit 1
fi

# clean up intent and break it up for easier parsing
INTENT=$(urldecode "$INTENT" | sed ':a;N;$!ba;s/\n//g' | sed 's/;/\n/g')

# get action 
ACTION=$(echo "$INTENT" | grep action= | sed 's/action=//g')

# clean up and prepare extra_keys
EXTRA_KEYS=$(echo "$INTENT" | grep org.chromium)
EXTRA_KEYS=$(echo "$EXTRA_KEYS" | egrep -v '(webapp_splash_screen_url)')
EXTRA_KEYS=$(echo "$EXTRA_KEYS" | sed -E 's/^B.(org.chromium[^=]+)=(.*)$/           --ez \1 \2/g')
EXTRA_KEYS=$(echo "$EXTRA_KEYS" | sed -E 's/^S.(org.chromium[^=]+)=(.*)$/           --es \1 \2/g')
EXTRA_KEYS=$(echo "$EXTRA_KEYS" | sed -E 's/^([li]).(org.chromium[^=]+)=(.*)$/           --e\1 \2 \3/g')

# start web app
/system/bin/am start -a $ACTION $EXTRA_KEYS
