heroku pgbackups:capture --expire --app frozen-lake-9035
curl -o /tmp/latest.dump `heroku pgbackups:url --app frozen-lake-9035`
pg_restore --verbose --clean --no-acl --no-owner --data-only -h localhost -d use/development /tmp/latest.dump
