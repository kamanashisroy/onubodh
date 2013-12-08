JPEG_CSOURCES=$(wildcard $(PROJECT_HOME)/libs/jpeg/csrc/*.c)
JPEG_VSOURCE_BASE=$(basename $(notdir $(JPEG_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(JPEG_VSOURCE_BASE)))
LIBS+=-ljpeg
