ifndef include/sbs/ogre.mk
include/sbs/ogre.mk = done

include sbs/gcc.mk

all.mesh.xml = $(filter %.mesh.xml,$(all))
all.mesh = $(all.mesh.xml:.xml=)

%.mesh: %.mesh.xml | %/..; OgreXMLConverter -q $< $@ #$(tag)

CPPFLAGS +=\
	-isystem$(includedir)/OGRE\
	-isystem/usr/include/OGRE\

LDLIBS +=\
	-lOgreMain\

endif
