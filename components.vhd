library std;
library ieee;
use ieee.std_logic_1164.all;

package components is

    component priority_encoder_4to2 is
        port(
            x : in  std_logic_vector(3 downto 0);
            y : out std_logic_vector(1 downto 0)
            );
    end component;

    component comparator3 is
    	port(
			x: in std_logic_vector(2 downto 0) ;
			y: in std_logic_vector(2 downto 0);
			equal_flag: out std_logic
			);
    end component;

     component comparator5 is
    	port(
			x: in std_logic_vector(4 downto 0) ;
			y: in std_logic_vector(4 downto 0);
			equal_flag: out std_logic
			);
    end component;

    component data_forwarding_block is
        port(
            source_reg_address: in std_logic_vector(2 downto 0) ;
            ex_RF_write: in std_logic ;
            ex_destination_reg_address: in std_logic_vector(2 downto 0) ;
            mem_RF_write: in std_logic ;
            mem_destination_reg_address: in std_logic_vector(2 downto 0) ;
            wb_RF_write: in std_logic ;
            wb_destination_reg_address: in std_logic_vector(2 downto 0) ;
            data_select: out std_logic_vector(2 downto 0)
            );
    end component;

    component HDU_Data is
        port(
            source_reg_address1: in std_logic_vector(2 downto 0);
            source_reg_address2: in std_logic_vector(2 downto 0);
            instruction_word: in std_logic_vector(15 downto 0);
            rr_mem_write: in std_logic;
            rr_z_en: in std_logic;
            rr_destination_reg_address: in std_logic_vector(2 downto 0);
            R7_en: out std_logic;
            IF_ID_en: out std_logic;
            NOP_mux_sel: out std_logic
        );
    end component;

    component HDU_Control is
        port(
            ID_R7d: in std_logic_vector(2 downto 0);
            RR_R7d: in std_logic_vector(2 downto 0);
            EX_R7d: in std_logic_vector(2 downto 0);
            MEM_R7d: in std_logic_vector(2 downto 0);
            PC_MUX1_sel: out std_logic;
            PC_MUX2_sel: out std_logic_vector(1 downto 0);
            flush_assign: out std_logic_vector(3 downto 0)
        );
    end component;




end package;  -- components 
