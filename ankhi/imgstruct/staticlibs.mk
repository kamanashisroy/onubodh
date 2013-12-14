IMGSTRUCT_CSOURCES=$(wildcard $(PROJECT_HOME)/ankhi/imgstruct/vsrc/*.c)
IMGSTRUCT_VSOURCE_BASE=$(basename $(notdir $(IMGSTRUCT_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(IMGSTRUCT_VSOURCE_BASE)))
