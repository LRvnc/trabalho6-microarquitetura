module top(input  logic        sysclk, 
           output logic [31:0] WriteData, DataAdr, 
           output logic        MemWrite,
           output       [3:0]  led,
           output              led5_r, led5_g, led5_b, led6_r, led6_g, led6_b,
           output       [3:0]  VGA_R, VGA_G, VGA_B, 
           output              VGA_HS_O, VGA_VS_O);

  logic [31:0] PC, Instr, ReadData;

  wire pixel_clk, reset;
  wire [8:0] vaddr; // 2^9 = 512
  
  // instantiate processor and memories
  arm arm(sysclk, reset, PC, Instr, MemWrite, DataAdr, 
          WriteData, ReadData);
  imem imem(PC, Instr);
  dmem dmem(sysclk, MemWrite, DataAdr, WriteData, ReadData);

  // VGA controller
  power_on_reset por(sysclk, reset);
  clk_wiz_1 clockdiv(pixel_clk, sysclk); // 25MHz
  vga video(pixel_clk, reset, ReadData, vaddr, VGA_R, VGA_G, VGA_B, VGA_HS_O, VGA_VS_O);
  
endmodule