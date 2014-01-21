XMLPARSER_CSOURCES=$(wildcard $(PROJECT_HOME)/libs/xmlparser/vsrc/*.c)
XMLPARSER_VSOURCE_BASE=$(basename $(notdir $(XMLPARSER_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(XMLPARSER_VSOURCE_BASE)))
