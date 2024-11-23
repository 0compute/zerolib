include $(CURDIR)/.flake/Makefile

test: override ARGV += --random-order --random-order-bucket=global
