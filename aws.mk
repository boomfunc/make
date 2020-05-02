# This Makefile describes some useful aws cli operations.
include common.mk

# Get the aws bin path.
AWS := $(or $(shell which aws),/usr/local/bin/aws)

AWS_S3_ACL?=private
AWS_CACHE_CONTROL?='public, max-age=0, s-maxage=31536000, must-revalidate'

.PHONY: aws-s3-sync
aws-s3-sync:
	#### Node( '$(NODE)' ).Call( '$@' )
	@$(call COMMON_SHELL_VAR_DEFINED,AWS_S3_BUCKET)
	@$(call COMMON_SHELL_VAR_DEFINED,AWS_S3_BUCKET_PATH)
	$(AWS) s3 sync . s3://$(AWS_S3_BUCKET)/$(AWS_S3_BUCKET_PATH) \
		--delete \
		--exclude 'Makefile' \
		--acl $(AWS_S3_ACL) \
		--cache-control $(AWS_CACHE_CONTROL)

.PHONY: aws-cf-create-invalidation
aws-cf-create-invalidation:
	#### Node( '$(NODE)' ).Call( '$@' )
	@$(call COMMON_SHELL_VAR_DEFINED,AWS_DISTRIBUTION_ID)
	$(AWS) cloudfront create-invalidation \
		--distribution-id $(AWS_DISTRIBUTION_ID) \
		--paths '/$(AWS_S3_BUCKET_PATH)/*'

.PHONY: aws-ecr-login
aws-ecr-login:
	#### Node( '$(NODE)' ).Call( '$@' )
	@$(call COMMON_SHELL_VAR_DEFINED,AWS_ACCESS_KEY_ID)
	@$(call COMMON_SHELL_VAR_DEFINED,AWS_SECRET_ACCESS_KEY)
	@$(call COMMON_SHELL_VAR_DEFINED,AWS_DEFAULT_REGION)
	$(AWS) ecr get-login | sed 's@-e none@@'
