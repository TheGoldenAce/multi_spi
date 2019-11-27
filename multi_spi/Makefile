# -*- Makefile -*-
# Directory : "~/projects/multi_spi"
# Platform  : GHDL
# Generated : 2019-11-27 10:28:37 TheGoldenAce


# Define compilation command and options

COMPILE = ghdl
OPTION_C =-a
OPTION_E =-e
OPTION_R =-r tb_fifo_gen --vcd=fifo_gen.vcd
SIMU_TIME=--stop-time=1000ns
EXEC=fifo_gen tb_fifo_gen fifo_gen.vcd master_spi

all : $(EXEC)

clean :
	rm -rf *.o $(EXEC) work*.cf

fifo_gen : fifo_gen.vhdl
	$(COMPILE) $(OPTION_C) fifo_gen.vhdl
	$(COMPILE) $(OPTION_E) fifo_gen

master_spi : master_spi.vhdl
	$(COMPILE) $(OPTION_C) master_spi.vhdl
	$(COMPILE) $(OPTION_E) master_spi

tb_fifo_gen: tb_fifo_gen.vhdl
	$(COMPILE) $(OPTION_C) tb_fifo_gen.vhdl
	$(COMPILE) $(OPTION_E) tb_fifo_gen

fifo_gen.vcd : fifo_gen tb_fifo_gen
	$(COMPILE) $(OPTION_R) $(SIMU_TIME)

simu : fifo_gen.vcd
	gtkwave fifo_gen.vcd
### Makefile ends here
