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

  port (rst_n    : in  std_logic;
        clk      : in  std_logic;
        we_in    : in  std_logic;
        data_in  : in  std_logic_vector(DATA_WIDTH_C -1 downto 0);
        re_out   : out std_logic;
        data_out : out std_logic_vector(DATA_WIDTH_C -1 downto 0);
        full     : out std_logic;
        empty    : out std_logic
        );

end entity fifo_gen;

-------------------------------------------------------------------------------

architecture rtl of fifo_gen is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  type r_memory is array (DATA_DEPTH_C -1 downto 0) of std_logic_vector(DATA_WIDTH_C -1 downto 0);
  signal FIFO_mem : r_memory;

  signal write_index : integer DATA_DEPTH_C -1;
  signal read_index  : integer DATA_DEPTH_C -1;

  signal r_re_out   : std_logic;
  signal r_data_out : std_logic_vector(DATA_WIDTH_C -1 downto 0);
  signal r_full     : std_logic;
  signal r_empty    : std_logic;
  

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------
  control_process : process(rst_n, clk, we_in)
    if(rst_n = '0') then
      








    
end architecture str;

-------------------------------------------------------------------------------
