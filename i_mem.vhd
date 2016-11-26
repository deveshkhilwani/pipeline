library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i_mem is
port (--clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        instruction_out : out std_logic_vector(15 downto 0)
     );
end entity;

architecture Behavioral of i_mem is

--Declaration of type and signal of a 256 element RAM
--with each element being 8 bit wide.
type ram_t is array (0 to 65535) of std_logic_vector(15 downto 0);
signal ram : ram_t := (
	 0=>"0110000001101010",
	 --1=>"0000110110110000",
     --2=>"0000000000000000",
others=>"0011000000000010"
);--(others => '0'));

begin

--process for read and write operation.
--process(clk)
--begin
    instruction_out <= ram(to_integer(unsigned(address)));
--    if(rising_edge(clk)) then
--        if(we='1') then
--            ram(to_integer(unsigned(address))) <= data_i;
--        end if;
--    end if; 
--end process;

end Behavioral;

