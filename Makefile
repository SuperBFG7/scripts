MODULES = backup fotos helpers music pi server system
.DEFAULT_GOAL = select
TARGET  = /usr/local/bin/

.PHONY: $(MODULES)

all: clean $(MODULES)

select: clean
	select i in all $(MODULES); do \
		$(MAKE) $$i; \
		break; \
	done 

includes.sh:
	cat */includes.sh | grep -v "#STRIP#" > includes.sh
	cp -iu includes.sh $(TARGET)

clean:
	rm -f includes.sh

$(MODULES): includes.sh
	cp -iu $@/*.sh $(TARGET)
#	$(MAKE) -C $@

uninstall:
	ls */*.sh | while read i; do \
		rm "$(TARGET)"`basename $$i`; \
	done
