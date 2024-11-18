include $(CURDIR)/.pyproject/Makefile

test: override ARGV += --random-order --random-order-bucket=global
