MARKDOWNPARSER_CSOURCES=$(wildcard $(ONUBODH_HOME)/libs/markdownparser/vsrc/*.c)
MARKDOWNPARSER_VSOURCE_BASE=$(basename $(notdir $(MARKDOWNPARSER_CSOURCES)))
OBJECTS+=$(addprefix $(ONUBODH_HOME)/build/.objects/, $(addsuffix .o,$(MARKDOWNPARSER_VSOURCE_BASE)))
