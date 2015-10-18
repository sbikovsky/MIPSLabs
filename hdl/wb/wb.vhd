-- Generated by PERL program wishbone.pl. Do not edit this file.
--
-- For defines see wishbone.defines
--
-- Generated Sun Oct 18 18:30:29 2015
--
-- Wishbone masters:
--   mips_wbm
--
-- Wishbone slaves:
--   ram_wbs
--     baseadr 0x00000000 - size 0x00000400
--   wbs
--     baseadr 0x00000400 - size 0x00000400
-----------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

package intercon_package is


function "and" (
  l : std_logic_vector;
  r : std_logic)
return std_logic_vector;
end intercon_package;
package body intercon_package is

function "and" (
  l : std_logic_vector;
  r : std_logic)
return std_logic_vector is
  variable result : std_logic_vector(l'range);
begin  -- "and"
  for i in l'range loop
  result(i) := l(i) and r;
end loop;  -- i
return result;
end "and";
end intercon_package;
library IEEE;
use IEEE.std_logic_1164.all;

entity trafic_supervision is

  generic (
    priority     : integer := 1;
    tot_priority : integer := 2);

  port (
    bg           : in  std_logic;       -- bus grant
    ce           : in  std_logic;       -- clock enable
    trafic_limit : out std_logic;
    clk          : in  std_logic;
    reset        : in  std_logic);

end trafic_supervision;

architecture rtl of trafic_supervision is

  signal shreg : std_logic_vector(tot_priority-1 downto 0);
  signal cntr : integer range 0 to tot_priority;

begin  -- rtl

  -- purpose: holds information of usage of latest cycles
  -- type   : sequential
  -- inputs : clk, reset, ce, bg
  -- outputs: shreg('left)
  sh_reg: process (clk,reset)
  begin  -- process shreg
    if reset = '1' then                 -- asynchronous reset (active hi)
      shreg <= (others=>'0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ce='1' then
        shreg <= shreg(tot_priority-2 downto 0) & bg;
      end if;
    end if;
  end process sh_reg;

  -- purpose: keeps track of used cycles
  -- type   : sequential
  -- inputs : clk, reset, shreg('left), bg, ce
  -- outputs: trafic_limit
  counter: process (clk, reset)
  begin  -- process counter
    if reset = '1' then                 -- asynchronous reset (active hi)
      cntr <= 0;
      trafic_limit <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      if ce='1' then
        if bg='1' and shreg(tot_priority-1)='0' then
          cntr <= cntr + 1;
          if cntr=priority-1 then
            trafic_limit <= '1';
          end if;
        elsif bg='0' and shreg(tot_priority-1)='1' then
          cntr <= cntr - 1;
          if cntr=priority then
            trafic_limit <= '0';
          end if;
        end if;
      end if;
    end if;
  end process counter;

end rtl;

library IEEE;
use IEEE.std_logic_1164.all;
use work.intercon_package.all;

entity intercon is
  port (
  -- wishbone master port(s)
  -- mips_wbm
  mips_wbm_dat_i : out std_logic_vector(31 downto 0);
  mips_wbm_ack_i : out std_logic;
  mips_wbm_dat_o : in  std_logic_vector(31 downto 0);
  mips_wbm_we_o  : in  std_logic;
  mips_wbm_sel_o : in  std_logic_vector(3 downto 0);
  mips_wbm_adr_o : in  std_logic_vector(31 downto 0);
  mips_wbm_cyc_o : in  std_logic;
  mips_wbm_stb_o : in  std_logic;
  -- wishbone slave port(s)
  -- ram_wbs
  ram_wbs_dat_o : in  std_logic_vector(31 downto 0);
  ram_wbs_ack_o : in  std_logic;
  ram_wbs_dat_i : out std_logic_vector(31 downto 0);
  ram_wbs_we_i  : out std_logic;
  ram_wbs_sel_i : out std_logic_vector(3 downto 0);
  ram_wbs_adr_i : out std_logic_vector(31 downto 0);
  ram_wbs_cyc_i : out std_logic;
  ram_wbs_stb_i : out std_logic;
  -- wbs
  wbs_dat_o : in  std_logic_vector(31 downto 0);
  wbs_ack_o : in  std_logic;
  wbs_dat_i : out std_logic_vector(31 downto 0);
  wbs_we_i  : out std_logic;
  wbs_sel_i : out std_logic_vector(3 downto 0);
  wbs_adr_i : out std_logic_vector(31 downto 0);
  wbs_cyc_i : out std_logic;
  wbs_stb_i : out std_logic;
  -- clock and reset
  clk   : in std_logic;
  reset : in std_logic);
end intercon;
architecture rtl of intercon is
  signal ram_wbs_ss : std_logic; -- slave select
  signal wbs_ss : std_logic; -- slave select
begin  -- rtl
decoder:block
  signal adr : std_logic_vector(31 downto 0);
begin
adr <= (mips_wbm_adr_o);
ram_wbs_ss <= '1' when adr(31 downto 10)="0000000000000000000000" else
'0';
wbs_ss <= '1' when adr(31 downto 10)="0000000000000000000001" else
'0';
ram_wbs_adr_i <= adr(31 downto 0);
wbs_adr_i <= adr(31 downto 0);
end block decoder;

mux: block
  signal cyc, stb, we, ack : std_logic;
  signal sel : std_logic_vector(3 downto 0);
  signal dat_m2s, dat_s2m : std_logic_vector(31 downto 0);
begin
cyc <= (mips_wbm_cyc_o);
ram_wbs_cyc_i <= ram_wbs_ss and cyc;
wbs_cyc_i <= wbs_ss and cyc;
stb <= (mips_wbm_stb_o);
ram_wbs_stb_i <= stb;
wbs_stb_i <= stb;
we <= (mips_wbm_we_o);
ram_wbs_we_i <= we;
wbs_we_i <= we;
ack <= ram_wbs_ack_o or wbs_ack_o;
mips_wbm_ack_i <= ack;
sel <= (mips_wbm_sel_o);
ram_wbs_sel_i <= sel;
wbs_sel_i <= sel;
dat_m2s <= (mips_wbm_dat_o);
ram_wbs_dat_i <= dat_m2s;
wbs_dat_i <= dat_m2s;
dat_s2m <= (ram_wbs_dat_o and ram_wbs_ss) or (wbs_dat_o and wbs_ss);
mips_wbm_dat_i <= dat_s2m;
end block mux;

end rtl;