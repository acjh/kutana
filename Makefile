.PHONY: all test docs

all: run

install:
	python3 -m pip install .

run:
	python3 -m kutana --config example/config.yml --plugins example/plugins

collectmessages:
	python3 kutana/i18n/cli.py collect -c example -s example/plugins/i18n/ru.yml

docs:
	python3 -m pip install sphinx recommonmark
	sphinx-apidoc --separate -o docs/src/ . $(PWD)/setup.py; \
		cd docs; make clean; make html

test:
	python3 -m coverage run -m --include=kutana/* pytest tests/
	python3 -m coverage report -m --fail-under=100

test-debug:
	PYTHONASYNCIODEBUG=1 python3 -m coverage run -m --include=kutana/* pytest tests/
	python3 -m coverage report -m --fail-under=100

lint:
	python3 -m flake8 kutana/ --count --select=E9,F63,F7,F82 --show-source --statistics
	python3 -m flake8 kutana/ --count --max-complexity=10 --max-line-length=127 --statistics

tunnel:
	vk-tunnel --insecure=1 --http-protocol=https --ws-protocol=wss --host=0.0.0.0 --port=8080
