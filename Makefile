
-include .config.mk
-include $(SHOTODOL_HOME)/plugin.mk

all:makecore makeapps makeshotodol

makeapps:
	$(BUILD) -C ankhi/cv

cleanapps:
	$(CLEAN) -C ankhi/cv

makecore:
	$(BUILD) -C libs/fastedge
	$(BUILD) -C libs/netpbm
	$(BUILD) -C libs/dryman_kmeans

cleancore:
	$(CLEAN) -C libs/fastedge
	$(CLEAN) -C libs/netpbm
	$(CLEAN) -C libs/dryman_kmeans

clean:cleancore cleanapps

include tests/test.mk
