#_!/bin/make -f
# -*- makefile -*-
# SPDX-License-Identifier: MIT
#{
# Copyright 2018-present Samsung Electronics France
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#}

default: all
	@echo "log: For more info type: make help "

project?=bmp085-sensor
runtime ?= node
export runtime
srcs_dir ?= .
srcs ?= ${project}.js
run_args ?=
main_src ?= test.js
NODE_PATH:=${NODE_PATH}:.
export NODE_PATH

IOTJS_EXTRA_MODULE_PATH?=${CURDIR}/iotjs_modules:${CURDIR}/iotjs_modules
export IOTJS_EXTRA_MODULE_PATH

iotjs-async_url?=https://github.com/rzr/iotjs-async

help:
	@echo "## Usage: "

all: build
	@echo "log: $@: $^"

setup/%:
	${@F}

node_modules: package.json
	npm install

package-lock.json: package.json
	rm -fv "$@"
	npm install
	ls "$@"

setup/node: node_modules
	@echo "NODE_PATH=$${NODE_PATH}"
	node --version
	npm --version

setup: setup/${runtime}
	@echo "log: $@: $^"

build/%: setup ${runtime}_modules
	@echo "log: $@: $^"

build/node: setup node_modules
	@echo "log: $@: $^"

build: build/${runtime}
	@echo "log: $@: $^"

run/%: ${main_src} build
	${@F} $< ${run_args}

run/npm: ${main_src} setup
	npm start

run: run/${runtime}
	@echo "log: $@: $^"

clean:
	rm -rf ${tmp_dir}

cleanall: clean
	rm -f *~

distclean: cleanall
	rm -rf node_modules

test/npm: package.json
	npm test

test: test/${runtime}

start: run
	@echo "log: $@: $^"

iotjs_modules/async:
	-mkdir -p ${@D}
	git clone --recursive --depth 1 ${iotjs-async_url} $@

iotjs_modules: iotjs_modules/async
	ls $@

setup/iotjs: ${runtime}_modules
	${@F} -h ||:
