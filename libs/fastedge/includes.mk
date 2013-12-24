
INCLUDES+=-Iinclude
FASTEDGE_CSOURCES=$(wildcard csrc/*.c)
FASTEDGE_VSOURCE_BASE=$(basename $(notdir $(FASTEDGE_CSOURCES)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(FASTEDGE_VSOURCE_BASE)))
