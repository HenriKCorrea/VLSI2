#
# Compiler flags
#
CC = g++
CFLAGS = -Wextra


#Additional Directories to be included by compiler
IDIR := -I ./external/verilog-vcd-parser/src/
IDIR := $(IDIR) -I ./external/verilog-vcd-parser/build/
#IDIR := $(IDIR) -I Application/DHCPServer/Header/

#Dependencies to be compiled
SRC := $(wildcard ./src/*.cpp) #Get all .c files in directory
SRC := $(SRC) $(wildcard ./external/verilog-vcd-parser/src/*.cpp) 
SRC := $(SRC) ./external/verilog-vcd-parser/build/VCDParser.cpp 
SRC := $(SRC) ./external/verilog-vcd-parser/build/VCDScanner.cpp 
#SRC := $(SRC) External/pcap/Lib/libpcap.a

#Ouput file name
TARGET = vcdanalisys

#
# Release build settings
#
RELDIR = ./build/
RELTARGET = $(RELDIR)$(TARGET).out
RELCFLAGS = $(CFLAGS) -O3 -DNDEBUG

#
# Debug build settings
#
DBGDIR = ./build/
DBGTARGET = $(DBGDIR)$(TARGET)_dbg.out
DBGCFLAGS = $(CFLAGS) -g -O0 -DDEBUG


#Optional make commands to be called by the user
.PHONY: clean debug prep_dbg prep_rel release remake runrel rundbg 

# Default build
all: debug release

#
# Debug rules
#
debug: dependencies prep_dbg
	$(CC) -o $(DBGTARGET) $(SRC) $(IDIR) $(DBGCFLAGS)

#
# Release rules
#
release: dependencies prep_rel
	$(CC) -o $(RELTARGET) $(SRC) $(IDIR) $(RELCFLAGS)

#
# Execute dependencies makefiles
#
dependencies:
	$(MAKE) parser-srcs -C ./external/verilog-vcd-parser/

#
# Other rules
#
prep_dbg:
	@if test ! -d $(DBGDIR); then mkdir -p $(DBGDIR); fi	#If DBGDIR do not exists, create dir	
	
prep_rel:
	@if test ! -d $(RELDIR); then mkdir -p $(RELDIR); fi	#If RELDIR do not exists, create dir

remake: clean all

clean:
	@if test -e $(DBGTARGET); then rm $(DBGTARGET); fi	#If DBGTARGET file exists, remove it
	@if test -e $(RELTARGET); then rm $(RELTARGET); fi	#If RELTARGET file exists, remove it
	$(MAKE) clean -C ./external/verilog-vcd-parser/

runrel:
	$(RELTARGET)
	
rundbg:
	$(DBGTARGET)
