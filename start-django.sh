#! /usr/bin/env sh
set -e
set -x
### variables ####
# PROJECT_ROOT=${PROJECT_ROOT:/srv/service/djangoexample}
# SUPERUSER_NAME=${SUPERUSER_NAME:root}
# SUPERUSER_EMAIL=${SUPERUSER_EMAIL:test@example.com}
# SUPERUSER_PASSWORD=${SUPERUSER_EMAIL:PASSWORD}
# WORKER_NUM=${WORKER_NUM:1}
# LOG_LEVEL=${LOG_LEVEL:DEBUG}
# WSGI_FILE=${WSGI_FILE:wsgi}
##################

PYTHON=$PROJECT_ROOT/env/bin/python
WORKDIR=$PROJECT_ROOT/src
INITIALIZED_FILE=$PROJECT_ROOT/var/initialized

cd $WORKDIR

if [ ! -e $INITIALIZED_FILE ];then
    $PYTHON manage.py migrate
    echo "from django.contrib.auth.models import User; (User.objects.first() or User.objects.create_superuser(\"$SUPERUSER_NAME\", \"$SUPERUSER_EMAIL\", \"$SUPERUSER_PASSWORD\"))" | $PYTHON manage.py shell
    touch $INITIALIZED_FILE
fi

$PROJECT_ROOT/env/bin/gunicorn -w $WORKER_NUM -b 0.0.0.0:8000 --chdir $WORKDIR --log-level $LOG_LEVEL $WSGI_FILE
