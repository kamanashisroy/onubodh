
PROJECT_OBJDIR=$(PROJECT_HOME)/build/.objects/
OBJECTS+=$(PROJECT_OBJDIR)/imageio.o
OBJECTS+=$(PROJECT_OBJDIR)/fast-edge.o
OBJECTS+=$(PROJECT_OBJDIR)/shotodol_fastedge.o
OBJECTS+=$(PROJECT_OBJDIR)/dryman_kmeans.o
LIBS+=-lm
#LIBS+=-lopencv_core -lopencv_imgproc
include $(PROJECT_HOME)/libs/jpeg/staticlibs.mk
include $(PROJECT_HOME)/ankhi/imgtrix/staticlibs.mk
include $(PROJECT_HOME)/ankhi/imgstruct/staticlibs.mk
include $(PROJECT_HOME)/ankhi/tangle/staticlibs.mk
include $(PROJECT_HOME)/transform/strtrans/staticlibs.mk
include $(PROJECT_HOME)/libs/xmlparser/staticlibs.mk
include $(PROJECT_HOME)/libs/markdownparser/staticlibs.mk
#include $(PROJECT_HOME)/libs/png/staticlibs.mk
