LIBSTD = libs/stdlib/
LOWLEVEL = libs/lowlevel/
LIBS = $(LIBSTD)std.lib $(LOWLEVEL)lowlevel.lib
SRCS = hello.asm
ASMFLAGS = -g -el -z0 -ilibs
TARGET = hello.com

CLEAN = $(addsuffix .clean,$(dir $(LIBS)))

ASM = motorrc8
LIB = xlib
LINK = xlink

DEPDIR := .d
$(shell mkdir -p $(DEPDIR) >/dev/null)
DEPFLAGS = -d$(DEPDIR)/$*.Td

ASSEMBLE = $(ASM) $(DEPFLAGS) $(ASMFLAGS)
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

$(TARGET) : $(notdir $(SRCS:asm=obj)) $(LIBS)
	$(LINK) -sEntry -m$(@:com=sym) -o$@ -thc8c $+

%.obj : %.asm
%.obj : %.asm $(DEPDIR)/%.d
	$(ASSEMBLE) -o$@ $<
	$(POSTCOMPILE)

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

clean : $(CLEAN)
	rm -rf $(TARGET) $(notdir $(SRCS:asm=obj)) $(DEPDIR)

%.clean:
	@$(MAKE) -C $* clean

$(LIBS):
	@$(MAKE) -C $(@D)

include $(wildcard $(patsubst %,$(DEPDIR)/%.d,$(basename $(notdir $(SRCS)))))
