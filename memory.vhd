library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram is
port (clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        we : in std_logic;
        data_i : in std_logic_vector(15 downto 0);
        data_o : out std_logic_vector(15 downto 0)
     );
end entity;

architecture Behavioral of bram is

--Declaration of type and signal of a 256 element RAM
--with each element being 8 bit wide.
type ram_t is array (0 to 100) of std_logic_vector(15 downto 0);
signal ram : ram_t := (
     0=>"0100111110000000",
others=>"0000000000000000"
);--(others => '0'));

begin

--process for read and write operation.
process(clk)
begin
    data_o <= ram(to_integer(unsigned(address)));
    if(rising_edge(clk)) then
        if(we='1') then
            ram(to_integer(unsigned(address))) <= data_i;
        end if;
    end if; 
end process;

end Behavioral;

