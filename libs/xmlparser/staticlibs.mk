XMLPARSER_CSOURCES=$(wildcard $(ONUBODH_HOME)/libs/xmlparser/vsrc/*.c)
XMLPARSER_VSOURCE_BASE=$(basename $(notdir $(XMLPARSER_CSOURCES)))
OBJECTS+=$(addprefix $(ONUBODH_HOME)/build/.objects/, $(addsuffix .o,$(XMLPARSER_VSOURCE_BASE)))
