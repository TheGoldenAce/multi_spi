-------------------------------------------------------------------------------
-- Title      : fifo generique
-- Project    : Source files in a directory tree, multiple compilers in same directory
-------------------------------------------------------------------------------
-- File       : fifo_gen.vhdl
-- Author     : yacine benaichouche  <TheGoldenAce@localhost.localdomain>
-- Company    : 
-- Created    : 2019-11-27
-- Last update: 2019-11-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- This is a multi-line project description
-- that can be used as a project dependent part of the file header.
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-27  1.0      TheGoldenAce    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity fifo_gen is

  generic (constant DATA_WIDTH_C : positive := 32;
           constant DATA_DEPTH_C : positive := 4
           );

  port (rst_n     : in  std_logic;
        clk       : in  std_logic;
        we_in     : in  std_logic;
        data_in   : in  std_logic_vector(DATA_WIDTH_C -1 downto 0);
        re_in     : in  std_logic;
        data_out  : out std_logic_vector(DATA_WIDTH_C -1 downto 0);
        full_out  : out std_logic;
        empty_out : out std_logic
        );

end entity fifo_gen;

-------------------------------------------------------------------------------

architecture rtl of fifo_gen is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  type r_memory is array (DATA_DEPTH_C -1 downto 0) of std_logic_vector(DATA_WIDTH_C -1 downto 0);
  signal FIFO_mem : r_memory;

  signal write_index : integer range 0 to DATA_DEPTH_C -1;
  signal read_index  : integer range 0 to DATA_DEPTH_C -1;

  signal r_data_out : std_logic_vector(DATA_WIDTH_C -1 downto 0);
  signal r_full     : std_logic;
  signal r_empty    : std_logic;
  signal r_diff_lap : std_logic;  -- to know if the read write index are on the
  -- same lap (empty or full => readindex =
  -- writeindex 


begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------
  control_process : process(rst_n, clk, we_in, re_in)
  begin
    if(rst_n = '0') then
      write_index <= 0;
      read_index  <= 0;
      r_empty     <= '1';
      r_full      <= '0';
      r_diff_lap  <= '0';
    else
      if (rising_edge(clk)) then
--------------------------------------------------------------------------------
---------------------------------- write cmd------------------------------------
--------------------------------------------------------------------------------
        if(we_in = '1') then
          if(write_index /= read_index or r_diff_lap = '0') then
            FIFO_mem(write_index) <= data_in;
            if (write_index = DATA_DEPTH_C -1) then
              write_index <= 0;
              r_diff_lap  <= '1';
            else
              write_index <= write_index + 1;
            end if;
          end if;
        end if;
--------------------------------------------------------------------------------
----------------------------------- read cmd------------------------------------
--------------------------------------------------------------------------------
        if(re_in = '1') then
          if(write_index /= read_index or r_diff_lap = '1') then
            r_data_out <= FIFO_mem(read_index);
            if(read_index = DATA_DEPTH_C -1) then
              read_index <= 0;
              r_diff_lap <= '0';
            else
              read_index <= read_index +1;
            end if;
          end if;
        end if;


--------------------------------------------------------------------------------
----------------------------------- full/empty----------------------------------
--------------------------------------------------------------------------------

        if (read_index = write_index) then
          if(r_diff_lap = '0') then
            r_empty <= '1';
          else
            r_full <= '1';
          end if;
        else
          r_empty <= '0';
          r_full  <= '0';
        end if;
      end if;
    end if;
  end process;



--------------------------------------------------------------------------------
----------------------------------- outputs ------------------------------------
--------------------------------------------------------------------------------
  data_out  <= r_data_out;
  full_out  <= r_full;
  empty_out <= r_empty;
end rtl;
