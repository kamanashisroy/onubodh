
-include .config.mk
-include $(SHOTODOL_HOME)/plugin.mk

all:makecore makeankhi makeshotodol

makeankhi:
	$(BUILD) -C ankhi/scale
	$(BUILD) -C ankhi/convert
	$(BUILD) -C ankhi/imgtrix
	$(BUILD) -C ankhi/cv

cleanankhi:
	$(CLEAN) -C ankhi/scale
	$(CLEAN) -C ankhi/convert
	$(CLEAN) -C ankhi/imgtrix
	$(CLEAN) -C ankhi/cv

makecore:
	$(BUILD) -C libs/fastedge
	$(BUILD) -C libs/netpbm
	$(BUILD) -C libs/dryman_kmeans
	$(BUILD) -C libs/jpeg

cleancore:
	$(CLEAN) -C libs/fastedge
	$(CLEAN) -C libs/netpbm
	$(CLEAN) -C libs/dryman_kmeans
	$(CLEAN) -C libs/jpeg

clean:cleancore cleanankhi

include tests/test.mk
