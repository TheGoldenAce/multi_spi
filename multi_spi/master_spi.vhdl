-------------------------------------------------------------------------------
-- Title      : master spi 
-- Project    : Source files in a directory tree, multiple compilers in same directory
-------------------------------------------------------------------------------
-- File       : master_spi.vhdl
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
-- Description: this is a simple master multi slave spi 
-------------------------------------------------------------------------------
-- Copyright (c) 2019 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-11-27  1.0      TheGoldenAce    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std;

-------------------------------------------------------------------------------

entity master_spi is

  generic (constant DATA_WIDTH_C : positive := 32;
           constant DATA_DEPTH_C : positive := 4
           );

  port (rst_n : in std_logic;
        clk   : in std_logic;

        we_in    : in  std_logic;
        data_in  : in  std_logic_vector (DATA_WIDTH_C -1 downto 0);
        full_out : out std_logic;

        MOSI_out : out std_logic;
        Sclk_out : out std_logic;
        SS_out   : out std_logic;
        MISO_in  : in  std_logic);


end entity master_spi;

-------------------------------------------------------------------------------

architecture str of master_spi is

  -----------------------------------------------------------------------------
  -- FIFO instanciation 
  -----------------------------------------------------------------------------

   component fifo_gen
    generic  (constant DATA_WIDTH_C : positive;
                 constant DATA_DEPTH_C : positive
                 );
    port     (rst_n     : in  std_logic;
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
type STATES_type is (IDLE, READ_FIFO, SEND, DELAY, RECIEVE);  -- fsm
signal EP, EF : STATES_type;

-- output registers ----
signal r_MOSI_out : std_logic;
signal r_clk_out  : std_logic;
signal r_SS_out   : std_logic;
signal r_MISO_in  : std_logic;

-- internal registers -------
signal r_data_in  : std_logic_vector(DATA_WIDTH_C -1 downto 0);  -- data captured from slave
signal r_data_out : std_logic_vector(DATA_WIDTH_C -1 downto 0);  -- data to send to slave 
signal data_out   : std_logic_vector(DATA_WIDTH_C -1 downto 0);

signal r_re_in     : std_logic;
signal r_empty_out : std_logic;

signal r_wordLengh   : integer range 0 to DATA_WIDTH_C -1;
signal r_n_wordLengh : integer range 0 to DATA_WIDTH_C -1;
signal r_dataSize    : integer range 0 to DATA_DEPTH_C -1;
signal r_n_dataSize  : integer range 0 to DATA_DEPTH_C -1;

signal time_out   : integer range 0 to 20;  -- time before senfing and recieving
signal n_time_out : integer range 0 to 20;
signal r_Sclk_en  : std_logic;          -- clk gate 



begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------


  input_fifo : fifo_gen
    generic map (DATA_DEPTH_C => DATA_DEPTH_C,
                 DATA_WIDTH_C => DATA_WIDTH_C)
    port map (rst_n     => rst_n,
              clk       => clk,
              we_in     => we_in,
              data_in   => data_in,
              re_in     => r_re_in,
              data_out  => data_out,
              full_out  => full_out,
              empty_out => r_empty_out);


  next_state : process(rst_n, clk)
  begin
    if (rst_n = '1') then
      EP            <= IDLE;
      r_n_dataSize  <= 0;
      r_n_wordLengh <= 0;
    elsif(rising_edge(clk)) then
      EP          <= EF;
      r_wordLengh <= r_n_wordLengh;
      r_dataSize  <= r_n_dataSize;
    end if;
  end process;


  fsm_master : process(rst_n, EP, r_empty_out)  -- r_ss out need affectation
                                                -- for now 
  begin
    if (rst_n = '1') then
      r_data_out <= (others => '0');
      r_data_in  <= (others => '0');
      case EP is
        when IDLE =>
          r_Sclk_en <= '1';
          if (r_empty_out = '1') then
            EF <= IDLE;
          else
            r_re_in <= '1';
            EF      <= READ_FIFO;
          end if;
        when READ_FIFO =>
          r_re_in       <= '0';
          r_data_out    <= data_out;
          r_n_dataSize  <= 0;
          r_n_wordLengh <= 0;
          EF            <= SEND;
        when SEND =>
          r_Sclk_en <= '1';
          if (r_wordLengh < DATA_WIDTH_C -1) then
            r_MOSI_out    <= r_data_out(DATA_WIDTH_C -1 );
            r_data_out    <= r_data_out(DATA_WIDTH_C -2 downto 0) & '0';
            r_n_wordLengh <= r_wordLengh + 1;
            EF            <= SEND;
          else
            EF            <= DELAY;
            r_n_wordLengh <= 0;
          end if;
        when DELAY =>
          r_Sclk_en <= '0';
          if (time_out < 10) then
            EF         <= DELAY;
            n_time_out <= time_out +1;
          else
            n_time_out <= 0;
            EF         <= RECIEVE;
          end if;
        when RECIEVE =>
          r_Sclk_en <= '1';
          if(r_wordLengh < DATA_WIDTH_C -1) then
            r_data_in <= r_data_in(DATA_WIDTH_C -2 downto 0) & r_MISO_in;
            r_n_wordLengh <= r_wordLengh + 1;
            EF        <= RECIEVE;
          else
            EF            <= IDLE;
            r_n_wordLengh <= 0;
          end if;
      end case;
    end if;
  end process;

  MOSI_out  <= r_MOSI_out;
  r_MISO_in <= r_MISO_in;
  Sclk_out  <= r_Sclk_en and clk;
  SS_out    <= '1';






end architecture str;

-------------------------------------------------------------------------------
