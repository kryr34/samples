library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity trafficLight is
port (
    clk     : in std_logic;

    led_arr : out std_logic_vector(7 downto 0);

    -- RYG
    RYG_0   : out std_logic_vector(2 downto 0);
    RYG_1   : out std_logic_vector(2 downto 0);

    seg_0   : out std_logic_vector(6 downto 0);
    seg_1   : out std_logic_vector(6 downto 0));
end trafficLight;

architecture Traffic of trafficLight is
    signal counter_clk  : integer := 0;
    signal counter_half_sec    : integer := 109;

    signal sec          : std_logic := '0';

    signal countdown    : integer;
begin

process(clk)
    begin

    if (rising_edge(clk)) then
        if (counter_clk >= 50000000 / 2) then
            counter_clk <= 0;
            sec <= '1';
        else
            counter_clk <= counter_clk + 1;
            sec <= '0';
        end if;
    end if;

    if (rising_edge(sec)) then
        if (counter_half_sec <= 0) then
            counter_half_sec <= 109;
        else
            counter_half_sec <= counter_half_sec - 1;
        end if;
    end if;

    case counter_half_sec is
        when 109 downto 66 => RYG_0 <= "100";  RYG_1 <= "001"; countdown <= counter_half_sec / 2 - 27;
        when  65 downto 55 => RYG_0 <= "100";  RYG_1 <= "010"; countdown <= counter_half_sec / 2 - 27;
        when  54 downto 11 => RYG_0 <= "001";  RYG_1 <= "100"; countdown <= counter_half_sec / 2;
        when  10 downto  0 => RYG_0 <= "010";  RYG_1 <= "100"; countdown <= counter_half_sec / 2;
        when others => null;
    end case;

    case countdown mod 10 is
        when 9 => seg_0 <= "0010000";
        when 8 => seg_0 <= "0000000";
        when 7 => seg_0 <= "1111000";
        when 6 => seg_0 <= "0000010";
        when 5 => seg_0 <= "0010010";
        when 4 => seg_0 <= "0011001";
        when 3 => seg_0 <= "0110000";
        when 2 => seg_0 <= "0100100";
        when 1 => seg_0 <= "1111001";
        when 0 => seg_0 <= "1000000";
        when others => seg_0 <= "1111111";
    end case;

    case countdown / 10 is
        when 9 => seg_1 <= "0010000";
        when 8 => seg_1 <= "0000000";
        when 7 => seg_1 <= "1111000";
        when 6 => seg_1 <= "0000010";
        when 5 => seg_1 <= "0010010";
        when 4 => seg_1 <= "0011001";
        when 3 => seg_1 <= "0110000";
        when 2 => seg_1 <= "0100100";
        when 1 => seg_1 <= "1111001";
        when 0 => seg_1 <= "1000000";
        when others => seg_1 <= "1111111";
    end case;
end process;
    led_arr <= std_logic_vector(to_unsigned(counter_half_sec, led_arr'length));
end Traffic;
