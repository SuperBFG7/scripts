MODULES = fotos music pi system
.DEFAULT_GOAL = select
TARGET  = /usr/local/bin/

.PHONY: $(MODULES)

all: clean $(MODULES)

select:
	select i in all $(MODULES); do \
		$(MAKE) $$i; \
		break; \
	done 

includes.sh:
	cat */includes.sh > includes.sh
	cp -iu includes.sh $(TARGET)

clean:
	rm -f includes.sh

$(MODULES): includes.sh
	cp -iu $@/*.sh $(TARGET)
#	$(MAKE) -C $@
