
INCLUDES+=-Iinclude
INCLUDES+=-I../../libs/netpbm/include
CSOURCES=$(wildcard csrc/*.c)
VSOURCE_BASE=$(basename $(notdir $(CSOURCES)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))
