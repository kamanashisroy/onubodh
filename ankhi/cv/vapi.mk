
SHOTODOL_CORE_PATH=$(SHOTODOL_HOME)/core/
PROJECT_LIB_PATH=$(PROJECT_HOME)/libs/
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/fastedge/vapi --pkg shotodol_fastedge
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/netpbm/vapi --pkg shotodol_netpbm
VAPI+=--vapidir=$(PROJECT_LIB_PATH)/dryman_kmeans/vapi --pkg shotodol_dryman_kmeans
VAPI+=--vapidir=$(PROJECT_HOME)/ankhi/imgtrix/vapi --pkg shotodol_imgtrix
LIBRARY_NAME=shotodol_cv
