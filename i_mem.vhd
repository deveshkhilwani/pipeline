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
	 0=>"0001000001000001",
	 1=>"0001000011000011",
	 2=>"0001000101000101",
	 --3=>"0001111000000111",
	 3=>"0111001010101010",
	 --4=>"0000011011011000",
	 4=>"0110001001010101",
	 --4=>"0100000001000000",
	 --5=>"0100010001000001",
	 --6=>"0100100001000010",
	 --0=>"0100110110000010",
     --2=>"0000000000000000",
--others=>"0011000000000010"
others=>"1111111111111111"
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

