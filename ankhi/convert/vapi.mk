
SHOTODOL_CORE_PATH=$(SHOTODOL_HOME)/core/
PROJECT_LIB_PATH=$(PROJECT_HOME)/libs/
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/netpbm/vapi --pkg shotodol_netpbm
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/jpeg/vapi --pkg shotodol_jpeg
LIBRARY_NAME=shotodol_convert
