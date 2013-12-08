
PROJECT_OBJDIR=$(PROJECT_HOME)/build/.objects/
OBJECTS+=$(PROJECT_OBJDIR)/imageio.o
OBJECTS+=$(PROJECT_OBJDIR)/fast-edge.o
OBJECTS+=$(PROJECT_OBJDIR)/shotodol_fastedge.o
OBJECTS+=$(PROJECT_OBJDIR)/dryman_kmeans.o
OBJECTS+=$(PROJECT_OBJDIR)/ImageManipulateAvg.o
LIBS+=-lm
include $(PROJECT_HOME)/libs/jpeg/staticlibs.mk
#include $(PROJECT_HOME)/libs/png/staticlibs.mk
