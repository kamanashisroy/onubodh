STRTRANS_CSOURCES=$(wildcard $(ONUBODH_HOME)/transform/strtrans/vsrc/*.c)
STRTRANS_VSOURCE_BASE=$(basename $(notdir $(STRTRANS_CSOURCES)))
OBJECTS+=$(addprefix $(ONUBODH_HOME)/build/.objects/, $(addsuffix .o,$(STRTRANS_VSOURCE_BASE)))
