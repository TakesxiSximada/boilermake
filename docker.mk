COMPOSE_YAML ?= compose.yml
VOLUME_YAML ?= volume.yml
MACHINE ?= docker-machine
COMPOSE ?= docker-compose -f $(COMPOSE_YAML)
VOLUME ?= docker-volume
VOLUME_OPTIONS ?= --conf $(VOLUME_YAML) --compose-yml $(COMPOSE_YAML) -m $(DOCKER_MACHINE_NAME)
DOCKER_INFRA_SERVICES ?= redis mysql fakes3


.PHONY: docker-current
docker-current:
	@# docekr-compose.ymlやdocker-volume.ymlをシンボリックリンクとして生成

	@ln -sf $(COMPOSE_YAML) docker-compose.yml
	@ln -sf $(VOLUME_YAML) docker-volume.yml


.PHONY: docker-uncurrent
docker-uncurrent:
	@# docekr-compose.ymlやdocker-volume.ymlを削除

	@unlink docker-compose.yml
	@unlink docker-volume.yml


.PHONY: docker-ssh
docker-ssh:
	@# docker-machine ssh します。

	@$(MACHINE) ssh $(DOCKER_MACHINE_NAME)


.PHONY: docker-rm
docker-rm:
	@## target="" args="arg1 arg2"
	@# コンテナを削除します。

	@$(COMPOSE) rm $(args) $(target)


.PHONY: docker-ps
docker-ps:
	@# コンテナを確認します

	@$(COMPOSE) ps


.PHONY: docker-warmup
docker-warmup:
	@# ミドルウェアをデーモンモードで起動します。

	@$(COMPOSE) up -d $(DOCKER_INFRA_SERVICES)


.PHONY: docker-cooldown
docker-cooldown:
	@# ミドルウェアを停止します。

	@$(COMPOSE)	stop $(DOCKER_INFRA_SERVICES)


.PHONY: docker-up
docker-up:
	@## target="TARGET1 TARGET2 ..."
	@# targetsで指定したサービスをupで起動します。
	@# 起動中のtargetsは一度停止してからupされます。

	make stop target=$(target)
	$(COMPOSE) up $(target)


.PHONY: docker-run
docker-run:
	@## target="TARGET1 TARGET2 ..." command="/bin/bash"
	@# targetsで指定したサービスをrunで起動します。
	@# 起動中のtargetsは一度停止してからrunされます。

	@make stop target=$(target)
	@$(COMPOSE) run --service-port $(target) $(command)

.PHONY: docker-debug
docker-debug:
	@## target=TARGET
	@# targetsで指定したサービスをrun --service-port /bin/bashで起動します。
	@# 起動中のtargetsは一度停止してから開始されます。

	@make stop target=$(target)
	@make run target=$(target) command=/bin/bash

.PHONY: docker-start
docker-start:
	@## target="TARGET1 TARGET2 ..."
	@# targetで指定したサービスを起動します。
	@# targetを指定しない場合は全てのサービスが対象になります。

	@docker-compose -f $(COMPOSE_YAML) start $(target)


.PHONY: docker-stop
docker-stop:
	@## target="TARGET1 TARGET2 ..."
	@# targetで指定したサービスを停止します。
	@# targetを指定しない場合は全てのサービスが対象になります。

	@docker-compose -f $(COMPOSE_YAML) stop $(target)

.PHONY: docker-kill
docker-kill:
	@## target="TARGET1 TARGET2 ..."
	@# targetで指定したサービスをkillします。
	@# targetを指定しない場合は全てのサービスが対象になります。

	@docker-compose -f $(COMPOSE_YAML) kill $(target)


.PHONY: docker-pull
docker-pull:
	@# docker-compose pullします。

	@$(COMPOSE) pull


.PHONY: docker-build
docker-build:
	@# docker-compose buildします。

	@docker-compose -f $(COMPOSE_YAML) build



.PHONY: docker-create
docker-create:
	@# docker-volume環境構築

	$(VOLUME) directory $(VOLUME_OPTIONS)
	$(VOLUME) add $(VOLUME_OPTIONS)
	$(VOLUME) mount $(VOLUME_OPTIONS)


.PHONY: docker-destroy
docker-destroy:
	@# docker-volume環境構築

	-$(VOLUME) umount $(VOLUME_OPTIONS)
	-$(VOLUME) remove $(VOLUME_OPTIONS)


.PHONY: docker-recreate
docker-recreate: destroy create
	@# docker-volume環境の再構築


.PHONY: docker-attach
docker-attach:
	@## name=VOLUME-NAME
	@# docker-volumeをattachする
	@# nameにはvolume名(docker-volume.ymlのsection名を指定する)

	$(VOLUME) directory $(VOLUME_OPTIONS)
	$(VOLUME) add $(name) $(VOLUME_OPTIONS)
