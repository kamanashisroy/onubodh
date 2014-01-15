STRTRANS_CSOURCES=$(wildcard $(PROJECT_HOME)/transform/strtrans/vsrc/*.c)
STRTRANS_VSOURCE_BASE=$(basename $(notdir $(STRTRANS_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(STRTRANS_VSOURCE_BASE)))
