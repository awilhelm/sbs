ifndef include/smpb/ogre.mk
include/smpb/ogre.mk = done

include smpb/gcc.mk

all.mesh.xml = $(filter %.mesh.xml,$(all))
all.mesh = $(all.mesh.xml:.xml=)

%.mesh: %.mesh.xml | %/..; OgreXMLConverter -q $< $@ #$(tag)

CPPFLAGS +=\
	-isystem$(includedir)/OGRE\
	-isystem/usr/include/OGRE\

LDLIBS +=\
	-lOgreMain\

endif
