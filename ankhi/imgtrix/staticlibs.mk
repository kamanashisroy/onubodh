IMGTRIX_CSOURCES=$(wildcard $(PROJECT_HOME)/ankhi/imgtrix/vsrc/*.c)
IMGTRIX_VSOURCE_BASE=$(basename $(notdir $(IMGTRIX_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(IMGTRIX_VSOURCE_BASE)))
