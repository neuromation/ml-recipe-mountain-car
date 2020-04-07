include Makefile

CMD_PREPARE=\
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get -qq update && \
  apt-get -qq install -y --no-install-recommends pandoc >/dev/null

CMD_NBCONVERT=\
  $(JUPYTER_SCREEN) \
  jupyter nbconvert \
  --execute \
  --no-prompt \
  --no-input \
  --to=asciidoc \
  --ExecutePreprocessor.timeout=600 \
  --output=/tmp/out \
  $(PROJECT_PATH_ENV)/$(NOTEBOOKS_DIR)/mountain_car_dqn.ipynb && \
  echo "Test succeeded: PROJECT_PATH_ENV=$(PROJECT_PATH_ENV) TRAINING_MACHINE_TYPE=$(TRAINING_MACHINE_TYPE)"


.PHONY: _generate_random_label_32
_generate_random_label_32:
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -n1 -c32

.PHONY: test_jupyter
test_jupyter: JUPYTER_CMD=bash -c '$(CMD_PREPARE) && $(CMD_NBCONVERT)'
test_jupyter: jupyter

.PHONY: test_jupyter_baked
test_jupyter_baked: PROJECT_PATH_ENV=/project-local
test_jupyter_baked:
	neuro run $(RUN_EXTRA) \
		--preset $(TRAINING_MACHINE_TYPE) \
		$(CUSTOM_ENV_NAME) \
		bash -c '$(CMD_PREPARE) && $(CMD_NBCONVERT)'