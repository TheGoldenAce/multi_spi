-------------------------------------------------------------------------------
-- Title      : tb_fifo_gen
-- Project    : Source files in a directory tree, multiple compilers in same directory
-------------------------------------------------------------------------------
-- File       : tb_fifo_gen.vhdl
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
-- Description: tst bench for generique fifo 
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

entity tb_fifo_gen is
end entity tb_fifo_gen;

-------------------------------------------------------------------------------

architecture tb of tb_fifo_gen is
  component fifo_gen
    generic (constant DATA_WIDTH_C :positive  ;
             constant DATA_DEPTH_C :positive 
             );

    port (rst_n     : in  std_logic;
          clk       : in  std_logic;
          we_in     : in  std_logic;
          data_in   : in  std_logic_vector (DATA_WIDTH_C -1 downto 0);
          re_in     : in  std_logic;
          data_out  : out std_logic_vector (DATA_WIDTH_C -1 downto 0);
          full_out  : out std_logic;
          empty_out : out std_logic);
  end component;


  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  constant DATA_WIDTH_C : positive := 32;
  constant DATA_DEPTH_C : positive := 4;

  signal rst_n     : std_logic;
  signal clk       : std_logic;
  signal we_in     : std_logic;
  signal data_in   : std_logic_vector (DATA_WIDTH_C -1 downto 0);
  signal re_in     : std_logic;
  signal data_out  : std_logic_vector (DATA_WIDTH_C -1 downto 0);
  signal full_out  : std_logic;
  signal empty_out : std_logic;

  constant TbPeriod : time      := 10 ns;
  signal TbClock    : std_logic := '0';



begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  dut : fifo_gen
    generic map (DATA_DEPTH_C => DATA_DEPTH_C,
                 DATA_WIDTH_C => DATA_WIDTH_C)
    port map (rst_n     => rst_n,
              clk       => clk,
              we_in     => we_in,
              data_in   => data_in,
              re_in     => re_in,
              data_out  => data_out,
              full_out  => full_out,
              empty_out => empty_out);

  -- Clock generation
  TbClock <= not TbClock after TbPeriod/2;

  -- EDIT: Check that clk is really your main clock signal
  clk <= TbClock;

  stimuli : process
  begin
    -- EDIT Adapt initialization as needed
    we_in   <= '0';
    data_in <= (others => '0');
    re_in   <= '0';
    -- Reset generation
    -- EDIT: Check that rst_n is really your reset signal
    rst_n   <= '0';
    wait for 10 * TbPeriod;
    rst_n   <= '1';
    wait for 10 * TbPeriod;
    data_in <= x"00000001";
    we_in   <= '1';
    wait for TbPeriod;
    we_in   <= '0';
    wait for TbPeriod;
    data_in <= x"ffffffff";
    we_in   <= '1';
    wait for TbPeriod;
    we_in   <= '0';
    wait for 2 * TbPeriod;
    re_in   <= '1';
    wait for TbPeriod;
    re_in   <= '0';
    wait for 2 * TbPeriod;
    re_in   <= '1';
    wait for TbPeriod;
    re_in   <= '0';
    wait for 2* TbPeriod;
    data_in <= x"00001111";
    we_in   <= '1';
    wait for TbPeriod;
    we_in   <= '0';
    wait for 2 * TbPeriod;
    re_in   <= '1';
    wait for TbPeriod;
    re_in   <= '0';

    wait;
  end process;

end tb;

-------------------------------------------------------------------------------
