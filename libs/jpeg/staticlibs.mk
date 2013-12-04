CSOURCES=$(wildcard $(PROJECT_HOME)/libs/jpeg/csrc/*.c)
VSOURCE_BASE=$(basename $(notdir $(CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))
