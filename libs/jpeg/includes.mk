
INCLUDES+=-Iinclude
INCLUDES+=-I$(PROJECT_HOME)/libs/netpbm/include
CSOURCES=$(wildcard csrc/*.c)
VSOURCE_BASE=$(basename $(notdir $(CSOURCES)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))
