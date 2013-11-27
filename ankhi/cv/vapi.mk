
SHOTODOL_CORE_PATH=$(SHOTODOL_HOME)/core/
SHOTODOL_LIB_PATH=$(SHOTODOL_HOME)/libs/
PROJECT_LIB_PATH=$(PROJECT_HOME)/libs/
VAPI+=--vapidir=$(SHOTODOL_LIB_PATH)/propeller/vapi --pkg shotodol_propeller
VAPI+=--vapidir=$(SHOTODOL_LIB_PATH)/iostream/vapi --pkg shotodol_iostream
VAPI+=--vapidir=$(SHOTODOL_LIB_PATH)/str_arms/vapi --pkg shotodol_str_arms
VAPI+=--vapidir=$(SHOTODOL_LIB_PATH)/make100/vapi --pkg shotodol_make100
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/fastedge/vapi --pkg shotodol_fastedge
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/netpbm/vapi --pkg shotodol_netpbm
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/dryman_kmeans/vapi --pkg shotodol_dryman_kmeans
VAPI+=--vapidir=$(SHOTODOL_CORE_PATH)/base/vapi --pkg=shotodol_base
VAPI+=--vapidir=$(SHOTODOL_CORE_PATH)/console/vapi --pkg=shotodol_console
VAPI+=--vapidir=$(SHOTODOL_CORE_PATH)/commands/vapi --pkg=shotodol_commands
VAPI+=--vapidir=$(SHOTODOL_CORE_PATH)/io/vapi --pkg=shotodol_io
LIBRARY_NAME=shotodol_cv
