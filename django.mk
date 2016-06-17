START_DJANGO_URL ?= start-django.sh
START_DJANGO_URL ?= https://gist.githubusercontent.com/TakesxiSximada/7406ab83b4a859b7042e1c9bae68f407/raw/e504b876827e9d8d297f5fef7eb174cc790a0b48/start-django.sh



.PHONY: start-django-sync
django-sync-start-django:
	@# start-django.shを同期します。

	@curl -L -o $(START_DJANGO_PATH) $(START_DJANGO_URL)
