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
    
--<<<<<<< HEAD
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

    component flag_forwarding_block is
          port (
            ex_flag_en: in std_logic_vector (1 downto 0);       --carry_enable is the significant bit
            mem_flag_en: in std_logic_vector (1 downto 0);
            wb_flag_en: in std_logic_vector (1 downto 0);

            ex_flag_value: in std_logic_vector(1 downto 0) ;    --carry_flag is the significant bit
            mem_flag_value: in std_logic_vector(1 downto 0) ;
            wb_flag_value: in std_logic_vector(1 downto 0) ;
            global_flag_value: in std_logic_vector(1 downto 0) ;

            cz_dependence: in std_logic_vector(1 downto 0) ;    --carry_enable is the significant bit
            nop_bit: out std_logic                              --nop_bit is cleared when we have to convert to nop
          ) ;
    end component ; -- flag_forward_block

    component HDU_Data is
        port(
            source_reg_address1: in std_logic_vector(2 downto 0);
            source_reg_address2: in std_logic_vector(2 downto 0);
            instruction_word: in std_logic_vector(15 downto 0);
            rr_mem_write: in std_logic; --mem write of instructionin RR stage
            rr_z_en: in std_logic;
            PE_Flag: in std_logic;
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
            PC_MUX1_sel: out std_logic_vector(1 downto 0);
            PC_MUX2_sel: out std_logic;
            flush_assign: out std_logic_vector(3 downto 0)
        );
    end component;


--=======
    component DataRegister is
        generic (data_width:integer);
        port (Din: in std_logic_vector(data_width-1 downto 0);
              Dout: out std_logic_vector(data_width-1 downto 0);
              clk, enable: in std_logic);
    end component;

    component generic_mux_2to1 is
    generic(data_width:integer);
          port (
            input1: in std_logic_vector(data_width-1 downto 0) ;        --selct is '1'
            input0: in std_logic_vector(data_width-1 downto 0) ;        --selct is '0'
            output0: out std_logic_vector(data_width-1 downto 0) ;
            select_signal: in std_logic
                ) ; 
    end component ; -- mux_2to1
    component generic_mux_4to1 is
    generic(data_width:integer);
          port (
            input0: in std_logic_vector(data_width-1 downto 0) ;--when select signal is "00"
            input1: in std_logic_vector(data_width-1 downto 0) ;--when select signal is "01"
            input2: in std_logic_vector(data_width-1 downto 0) ;--when select signal is "10"
            input3: in std_logic_vector(data_width-1 downto 0) ;--when select signal is "11"
            output0: out std_logic_vector(data_width-1 downto 0) ;
            select_signal: in std_logic_vector(1 downto 0)
                ) ; 
    end component ; -- mux_4to1

    component mux_4to1 is
      port (
        input0: in std_logic_vector(15 downto 0) ;
        input1: in std_logic_vector(15 downto 0) ;
        input2: in std_logic_vector(15 downto 0) ;
        input3: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: in std_logic_vector(1 downto 0)
      ) ;
    end component ; -- mux_4to1
    component mux_2to1 is
      port (
        input0: in std_logic_vector(15 downto 0) ;
        input1: in std_logic_vector(15 downto 0) ;
        output0: out std_logic_vector(15 downto 0) ;
        select_signal: in std_logic
      ) ;
    end component ; -- mux_2to1
    component RF_decoder is
       port (x: in std_logic_vector(2 downto 0); y: out std_logic_vector(6 downto 0));
    end component;
    component shift7 is
       port(x: in std_logic_vector(8 downto 0);
        y: out std_logic_vector(15 downto 0));
    end component;
    component reg_file is
       port(A1: in std_logic_vector(2 downto 0);
        A2: in std_logic_vector(2 downto 0);
        A3: in std_logic_vector(2 downto 0);
        D3: in std_logic_vector(15 downto 0);
        D1: out std_logic_vector(15 downto 0);
        D2: out std_logic_vector(15 downto 0);
        clk,reset: in std_logic;
        --control signals
        RF_write: in std_logic
        --rout_0,rout_1,rout_2,rout_3,rout_4,rout_5,rout_6,rout_7: out std_logic_vector(15 downto 0)
        );
    end component;

    component adder is
        port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;
    component full_adder is
        port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(16 downto 0));
    end component;
    component xorer is
       port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;
    component nander is
       port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0));
    end component;


    component sign_ext6 is
       port(x: in std_logic_vector(5 downto 0);
        y: out std_logic_vector(15 downto 0));
    end component;

   component sign_ext9 is
       port(x: in std_logic_vector(8 downto 0);
        y: out std_logic_vector(15 downto 0));
    end component;

    component Decoder is
    port(
        instruction_word: in std_logic_vector(15 downto 0);
        control_word: out std_logic_vector(19 downto 0); 
        Rs1: out std_logic_vector(2 downto 0); 
        Rs2: out std_logic_vector(2 downto 0); 
        Rd: out std_logic_vector(2 downto 0);
        CZ_depend: out std_logic_vector(1 downto 0)

    );
    end component;

    component special_pe is
      port( input0: in std_logic_vector(7 downto 0);
            output0: out std_logic_vector(7 downto 0);
            Rsel: out std_logic_vector(2 downto 0);
            flag: out std_logic);
    end component;

    component alu is
        port (x,y: in std_logic_vector(15 downto 0); z: out std_logic_vector(15 downto 0);
                carry,zero: out std_logic;
                --control signals
                op_code:in std_logic_vector(1 downto 0));
    end component;

    component bram is
        port (clk : in std_logic;
            address : in std_logic_vector(15 downto 0);
            we : in std_logic;
            data_i : in std_logic_vector(15 downto 0);
            data_o : out std_logic_vector(15 downto 0)
         );
    end component;
    component i_mem is
    port (--clk : in std_logic;
        address : in std_logic_vector(15 downto 0);
        instruction_out : out std_logic_vector(15 downto 0)
         );
    end component;



    component I_Fetch is 
        port(
            PC_MUX2_sel: in std_logic; --select signal for 2to1 MUX
            PC_MUX1_sel: in std_logic_vector(1 downto 0); --select signal of 4to1 MUX
            R7_ID: in std_logic_vector(15 downto 0);
            R7_RR: in std_logic_vector(15 downto 0);
            R7_EX: in std_logic_vector(15 downto 0);
            R7_MEM: in std_logic_vector(15 downto 0);
            PC_plus1: out std_logic_vector(15 downto 0);
            PC: out std_logic_vector(15 downto 0);
            IW: out std_logic_vector(15 downto 0);
            R7_write,reset: in std_logic;
            clk: in std_logic
            );
    end component;

    component ID is 
        port(
            IW: in std_logic_vector(15 downto 0);
            PC: in std_logic_vector(15 downto 0);
            PE_Flag: out std_logic;
            PE_input_sel: in std_logic;
            PE_input: in std_logic_vector(7 downto 0);
            control_word: out std_logic_vector(14 downto 0);
            PE_out: out std_logic_vector(7 downto 0);
            Rs1: out std_logic_vector(2 downto 0);
            Rs2: out std_logic_vector(2 downto 0);
            Rd: out std_logic_vector(2 downto 0);
            SE6: out std_logic_vector(15 downto 0);
            ID_MUX: out std_logic_vector(15 downto 0);
            is_LMSM: out std_logic;
            CZ_depend: out std_logic_vector(1 downto 0)
            );
    end component;

    component RR is
          port (
            RF_write: in std_logic ;
            reg_file_A1: in std_logic_vector(2 downto 0) ;
            reg_file_A2: in std_logic_vector(2 downto 0) ;
            reg_file_A3: in std_logic_vector(2 downto 0) ;
            reg_file_D3: in std_logic_vector(15 downto 0) ;
            ex_data: in std_logic_vector(15 downto 0) ;
            mem_data: in std_logic_vector(15 downto 0) ;
            wb_data: in std_logic_vector(15 downto 0) ;
            incremented_PC: in std_logic_vector(15 downto 0) ;
            input1_mux_sel: in std_logic_vector(2 downto 0) ;
            input2_mux_sel: in std_logic_vector(2 downto 0) ;
            is_LMSM: in std_logic ;
            alu_a_input: out std_logic_vector(15 downto 0) ;
            alu_b_input: out std_logic_vector(15 downto 0) ;
            LMSM_memaddress_out: out std_logic_vector(15 downto 0) ;
            LMSM_memaddress_in: in std_logic_vector(15 downto 0) ;
            clk,reset: in std_logic
          ) ;
    end component ; -- RR


    component EX is    
        port(
            Rs1, Rs2: in std_logic_vector(15 downto 0);
            SE_6: in std_logic_vector(15 downto 0);
            alu_a_sel, alu_b_sel: in std_logic;
            alu_op: in std_logic_vector(1 downto 0);
            alu_out: out std_logic_vector(15 downto 0);
            c_out: out std_logic;
            z_out: out std_logic
            );
    end component;

    component MEM is 
        port(
            Rs1: in std_logic_vector(15 downto 0);
            mem_address_sel: in std_logic;
            RA_plus_n: in std_logic_vector(15 downto 0); --for LM, SM
            alu_out: in std_logic_vector(15 downto 0);
            mem_write: in std_logic;
            mem_out: out std_logic_vector(15 downto 0);
            updated_z_flag: out std_logic;
            z_flag_in,z_enable,is_load_type: in std_logic;
            clk: in std_logic
            );
    end component;

    component WB is 
        port(
            wb_address_sel: in std_logic_vector(1 downto 0);
            mem_out: in std_logic_vector(15 downto 0); --for LM, SM
            alu_out: in std_logic_vector(15 downto 0); --arithmetic instructions
            PC_plus_Imm_or_shifter: in std_logic_vector(15 downto 0);
            flag_out: in std_logic_vector(1 downto 0);
            RF_write: in std_logic;
            flag_write: in std_logic_vector(1 downto 0);
            global_flag_out: out std_logic_vector(1 downto 0);
            Rs1: in std_logic_vector(15 downto 0);

            --WB_Rd: out std_logic_vector(2 downto 0);
            WB_MUX_out: out std_logic_vector(15 downto 0)
            );
    end component;

    component generic_staller is
    generic(data_width:integer);
      port (
        control_word: in std_logic_vector(data_width-1 downto 0) ;      
        pipelined_control_word : out std_logic_vector(data_width-1 downto 0); 
        NOP_mux_sel : in std_logic;
        flush: in std_logic
            );
    end component; 


-->>>>>>> 8df1c7e9c6625a725a0285da5631555be69d8172


end package;  -- components 
