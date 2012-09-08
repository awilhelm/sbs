old PATH := $(PATH)
export PATH = $(bindir):$(old PATH)

old LD_LIBRARY_PATH := $(LD_LIBRARY_PATH)
export LD_LIBRARY_PATH = $(libdir):$(old LD_LIBRARY_PATH)
