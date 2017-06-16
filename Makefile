BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/input
OUTPUTDIR=$(BASEDIR)/deploy

S3_BUCKET=vfw3285
CLOUDFRONT_ID=EARYRCOOE3IYT

DEBUG ?= 0

help:
	@echo 'Makefile for a Jekyll                                                     '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make pushupdate		      posts deploy folder to CDN         '
	@echo '   make publish                        generate using production settings '
	@echo '   make devserver                      start/restart local server         '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	jekyll build -d $(OUTPUTDIR)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

devserver:
	jekyll server

pushupdate:
	aws s3 rm --recursive s3://$(S3_BUCKET)
	aws s3 sync $(OUTPUTDIR) s3://$(S3_BUCKET) --acl public-read --cache-control max-age=2592000,public
	aws cloudfront create-invalidation --distribution-id $(CLOUDFRONT_ID) --path "/*"


publish: clean html pushupdate

.PHONY: html help clean serve devserver stopserver pushupdate publish
