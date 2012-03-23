
%.mesh: %.mesh.xml; OgreXMLConverter -q $< $@

CPPFLAGS +=\
	-isystem/usr/include/OGRE\

LDLIBS +=\
	-lOgreMain\

