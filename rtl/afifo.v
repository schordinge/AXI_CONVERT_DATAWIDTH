// =================================================================================================
// Copyright (c) 2021 - TsingHua rights reserved. 
// =================================================================================================
//
// Module         : afifo
// Function       : async fifo wrapper
// file tree      : afifo
//                      |_  xpm_fifo_async
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded By   contents
// 1.0        2023/10/30   yao.luo     create
//
// =================================================================================================

module afifo #
(
    parameter U_DLY	                        = 1                             ,//for simulation
    parameter FIFO_WIDTHBIT                 = 8                             ,
    parameter FIFO_DEPTHBIT                 = 9                             ,
    parameter FIFO_NAFULL_SIZE              = 10                            ,//>=5
    parameter FIFO_NAEMPTY_SIZE             = 10                            ,//>=5
    parameter FIFO_READ_DELAY               = 1                             ,
    parameter FIFO_RAM_TYPE                 = "AUTO"                         
    //xilinx:"BRAM","DRAM","URAM","AUTO"
    //pango :"DRAM_PANGO":FIFO_READ_DELAY=0/1
    //       "BRAM_PANGO":FIFO_READ_DELAY=0/1
)
(
    input                                   fifo_wclk                       ,
    input                                   fifo_wrst                       ,
    input                                   fifo_wen                        ,
    input       [FIFO_WIDTHBIT-1:0]         fifo_wdata                      ,
    output      reg                         fifo_nafull                     ,
    output                                  fifo_nfull                      ,

    input                                   fifo_rclk                       ,
    input                                   fifo_rrst                       ,//unuse
    input                                   fifo_ren                        ,
    output      [FIFO_WIDTHBIT-1:0]         fifo_rdata                      ,
    output                                  fifo_rvld                       ,
    output      reg                         fifo_naempty                    ,
    output                                  fifo_nempty                     ,

    output      [FIFO_DEPTHBIT:0]           fifo_rcnt                       ,//read  side used count
    output      [FIFO_DEPTHBIT:0]           fifo_wcnt                       ,//write side used count
    output                                  fifo_underflow                  ,//read  side error
    output                                  fifo_overflow                    //write side error

);
localparam FIFO_MEMORY_TYPE=
                (FIFO_RAM_TYPE=="DRAM")?"distributed":
                (FIFO_RAM_TYPE=="BRAM")?"block":
                (FIFO_RAM_TYPE=="URAM")?"ultra":
                (FIFO_RAM_TYPE=="AUTO")?"auto":
                                        FIFO_RAM_TYPE;

localparam READ_MODE=(FIFO_READ_DELAY==0)?"fwft":"std";
wire data_valid;
generate
    if(FIFO_READ_DELAY==0)
        assign fifo_rvld= fifo_ren;
    else 
        assign fifo_rvld= data_valid;
endgenerate

generate
if(FIFO_MEMORY_TYPE=="DRAM_PANGO"||FIFO_MEMORY_TYPE=="BRAM_PANGO")begin
    reg[5:0]                wr_rst_cnt        ;
    reg[5:0]                rd_rst_cnt        ;
    wire                    wr_rst_fin         ;assign wr_rst_fin=wr_rst_cnt[5];
    wire                    rd_rst_fin         ;assign rd_rst_fin=rd_rst_cnt[5];
    wire                    full               ;assign fifo_nfull       =(~full )&wr_rst_fin;
    wire                    empty              ;assign fifo_nempty      =(~empty);
    wire                    almost_full        ;
    wire                    almost_empty       ;
    wire[FIFO_DEPTHBIT:0]   wr_water_level     ;assign fifo_wcnt        =wr_water_level;
    wire[FIFO_DEPTHBIT:0]   rd_water_level     ;assign fifo_rcnt        =rd_water_level;
    reg                     overflow           ;assign fifo_overflow    =overflow;
    reg                     underflow          ;assign fifo_underflow   =underflow; 
    reg                     fifo_ren_1d        ;
    always@(posedge fifo_wclk or posedge fifo_wrst)begin
        if(fifo_wrst)begin
            wr_rst_cnt<='b0;
            fifo_nafull<=1'b0;
            overflow<=1'b0;
        end
        else begin
            wr_rst_cnt<=(wr_rst_fin)?wr_rst_cnt:(wr_rst_cnt+1'b1);
            fifo_nafull <=(~almost_full)  & wr_rst_fin ;
            overflow <=fifo_wen  & full ;
        end
    end

    always@(posedge fifo_rclk or posedge fifo_rrst)begin
        if(fifo_rrst)begin
            rd_rst_cnt<='b0;
            fifo_naempty<=1'b0;
            underflow<=1'b0;
            fifo_ren_1d<=1'b0;
        end
        else begin
            rd_rst_cnt<=(rd_rst_fin)?rd_rst_cnt:(rd_rst_cnt+1'b1);
            fifo_naempty <=(~almost_empty)  & rd_rst_fin ;
            underflow<=fifo_ren  & empty;
            fifo_ren_1d<=fifo_ren;
        end
    end
    
    assign data_valid       =fifo_ren_1d;

    if(FIFO_MEMORY_TYPE=="DRAM_PANGO")begin
        ipm_distributed_fifo_v1_2_dfifo
        #(
            .ADDR_WIDTH       (FIFO_DEPTHBIT                        ) ,  // fifo ADDR_WIDTH width 4 -- 10
            .DATA_WIDTH       (FIFO_WIDTHBIT                        ) ,  // write data width 4 -- 256
            .OUT_REG          ((FIFO_READ_DELAY==0)?0:1             ) ,  // output register   legal value:0 or 1
            .RST_TYPE         ("ASYNC"                              ) ,
            .FIFO_TYPE        ("ASYNC_FIFO"                         ) ,  // fifo type legal value "SYN" or "ASYN"
            .ALMOST_FULL_NUM  (2**FIFO_DEPTHBIT-FIFO_NAFULL_SIZE    ) ,  // almost full number
            .ALMOST_EMPTY_NUM (FIFO_NAEMPTY_SIZE                    )    // almost full number
        )u_ipm_distributed_fifo_dfifo
        (
            .wr_data          (fifo_wdata      ) ,  // input write data
            .wr_en            (fifo_wen        ) ,  // input write enable 1 active
            .wr_clk           (fifo_wclk       ) ,  // input write clock
            .wr_rst           (fifo_wrst       ) ,  // input write reset
            .full             (full            ) ,  // input write full  flag 1 active
            .almost_full      (almost_full     ) ,  // output write almost full
            .wr_water_level   (wr_water_level  ) ,  // output write water level
            .rd_data          (fifo_rdata      ) ,  // output read data
            .rd_en            (fifo_ren        ) ,  // input  read enable
            .rd_clk           (fifo_rclk       ) ,  // input  read clock
            .rd_rst           (fifo_rrst       ) ,  // input read reset
            .empty            (empty           ) ,  // output read empty
            .rd_water_level   (rd_water_level  ) ,
            .almost_empty     (almost_empty    )
        );
    end
    else begin
        wire bfifo_empty,bfifo_almost_empty;
        reg  bfifo_ren,bfifo_ren_1d,bfifo_ren_2d;
        wire[FIFO_WIDTHBIT-1:0] bfifo_rdata;
        wire dfifo_afull;
        reg  dfifo_wen;
        reg [FIFO_WIDTHBIT-1:0] dfifo_wdata;always@(posedge fifo_rclk)dfifo_wdata<=bfifo_rdata;

        ipm2l_fifo_v1_4_bfifo #(
            .c_CAS_MODE          ("36K"                             ),
            .c_WR_DEPTH_WIDTH    (FIFO_DEPTHBIT                     ),    // fifo depth width 9 -- 20   legal value:9~20
            .c_WR_DATA_WIDTH     (FIFO_WIDTHBIT                     ),    // write data width 1 -- 1152 1)WR_BYTE_EN =0 legal value:1~1152  2)WR_BYTE_EN=1  legal value:2^N or 9*2^N
            .c_RD_DEPTH_WIDTH    (FIFO_DEPTHBIT                     ),    // read address width 9 -- 20 legal value:1~20
            .c_RD_DATA_WIDTH     (FIFO_WIDTHBIT                     ),    // read data width 1 -- 1152  1)WR_BYTE_EN =0 legal value:1~1152  2)WR_BYTE_EN=1  legal value:2^N or 9*2^N
            .c_OUTPUT_REG        (0                                 ),    // output register            legal value:0 or 1
            .c_RD_OCE_EN         (0                                 ),
            .c_FAB_REG           (0                                 ),
            .c_RESET_TYPE        ("ASYNC"                           ),    // reset type legal valve "ASYNC_RESET_SYNC_RELEASE" "SYNC_RESET" "ASYNC_RESET"
            .c_POWER_OPT         (0                                 ),    // 0 :normal mode  1:low power mode legal value:0 or 1
            .c_RD_CLK_OR_POL_INV (0                                 ),    // clk polarity invert for output register  legal value: 0 or 1
            .c_WR_BYTE_EN        (0                                 ),    // byte write enable                       legal value: 0 or 1
            .c_BE_WIDTH          (1                                 ),    // byte width legal value: 1~128
            .c_FIFO_TYPE         ("ASYN"                            ),    // fifo type legal value "SYN" or "ASYN"
            .c_ALMOST_FULL_NUM   (2**FIFO_DEPTHBIT-FIFO_NAFULL_SIZE ),    // almost full number
            .c_ALMOST_EMPTY_NUM  (FIFO_NAEMPTY_SIZE                 )     // almost full number
        ) U_ipm2l_fifo_bfifo (
            .wr_clk         ( fifo_wclk      ) ,    // input write clock
            .wr_rst         ( fifo_wrst      ) ,    // input write reset
            .wr_en          ( fifo_wen       ) ,    // input write enable 1 active
            .wr_data        ( fifo_wdata     ) ,    // input write data
            .wr_full        ( full           ) ,    // input write full  flag 1 active
            .wr_byte_en     ( 'b0            ) ,    // input write byte enable
            .almost_full    ( almost_full    ) ,    // output write almost full
            .wr_water_level ( wr_water_level ) ,    // output write water level
            .rd_clk         ( fifo_rclk      ) ,    // input  read clock
            .rd_rst         ( fifo_rrst      ) ,    // input read reset
            .rd_en          ( bfifo_ren      ) ,    // input  read enable
            .rd_data        ( bfifo_rdata    ),
            .rd_oce         ( 1'b0           ) ,    // output read output register enable
            .rd_empty       ( bfifo_empty          ) ,    // output read empty
            .almost_empty   ( bfifo_almost_empty   ) ,    // output read water level
            .rd_water_level ( rd_water_level )
        );
        always@(posedge fifo_rclk or posedge fifo_rrst)begin
            if(fifo_rrst)begin
                bfifo_ren<=1'b0;
                bfifo_ren_1d<=1'b0;
                bfifo_ren_2d<=1'b0;
                dfifo_wen<=1'b0;
            end
            else begin
                bfifo_ren<=rd_rst_fin&(~dfifo_afull)&
                        ((~bfifo_almost_empty)|((~bfifo_empty)&(~bfifo_ren)));
                bfifo_ren_1d<=bfifo_ren;
                bfifo_ren_2d<=bfifo_ren_1d;
                dfifo_wen<=bfifo_ren_2d;
            end
        end

        ipm_distributed_fifo_v1_2_dfifo
        #(
            .ADDR_WIDTH       (4                                    ) ,  // fifo ADDR_WIDTH width 4 -- 10
            .DATA_WIDTH       (FIFO_WIDTHBIT                        ) ,  // write data width 4 -- 256
            .OUT_REG          ((FIFO_READ_DELAY==0)?0:1             ) ,  // output register   legal value:0 or 1
            .RST_TYPE         ("ASYNC"                              ) ,
            .FIFO_TYPE        ("SYNC_FIFO"                          ) ,  // fifo type legal value "SYN" or "ASYN"
            .ALMOST_FULL_NUM  (10                                   ) ,  // almost full number
            .ALMOST_EMPTY_NUM (6                                    )    // almost full number
        )u_ipm_distributed_fifo_dfifo
        (
            .wr_data          (dfifo_wdata     ) ,  // input write data
            .wr_en            (dfifo_wen       ) ,  // input write enable 1 active
            .wr_clk           (fifo_rclk       ) ,  // input write clock
            .wr_rst           (fifo_rrst       ) ,  // input write reset
            .full             (                ) ,  // input write full  flag 1 active
            .almost_full      (dfifo_afull     ) ,  // output write almost full
            .wr_water_level   (                ) ,  // output write water level
            .rd_data          (fifo_rdata      ) ,  // output read data
            .rd_en            (fifo_ren        ) ,  // input  read enable
            .rd_clk           (fifo_rclk       ) ,  // input  read clock
            .rd_rst           (fifo_rrst       ) ,  // input read reset
            .empty            (empty           ) ,  // output read empty
            .rd_water_level   (                ) ,
            .almost_empty     (almost_empty    )
        );
    end
end
else begin
   // xpm_fifo_sync: Synchronous FIFO
   // Xilinx Parameterized Macro, version 2019.2
   wire                         almost_empty    ;//unuse                            
   wire                         almost_full     ;//unuse                            
   wire                         dbiterr         ;//unuse                            
   wire[FIFO_WIDTHBIT-1:0]      dout            ;assign fifo_rdata=dout;            
   wire                         empty           ;        
   wire                         full            ;           
   wire                         overflow        ;assign fifo_overflow=overflow;     
   wire                         prog_empty      ;
   wire                         prog_full       ;  
   wire[FIFO_DEPTHBIT:0]        rd_data_count   ;assign fifo_rcnt=rd_data_count;        
   wire                         rd_rst_busy     ;      
   wire                         sbiterr         ;//unuse      
   wire                         underflow       ;assign fifo_underflow=underflow;       
   wire                         wr_ack          ;//unuse     
   wire[FIFO_DEPTHBIT:0]        wr_data_count   ;assign fifo_wcnt=wr_data_count;          
   wire                         wr_rst_busy     ;      
   wire[FIFO_WIDTHBIT-1:0]      din             ;assign din=fifo_wdata;         
   wire                         injectdbiterr   ;assign injectdbiterr=1'b0;         
   wire                         injectsbiterr   ;assign injectsbiterr=1'b0;         
   wire                         rd_en           ;assign rd_en=fifo_ren;       
   wire                         rst             ;assign rst=fifo_wrst;     
   wire                         sleep           ;assign sleep=1'b0;       
   wire                         rd_clk          ;assign rd_clk=fifo_rclk;     
   wire                         wr_clk          ;assign wr_clk=fifo_wclk;     
   wire                         wr_en           ;assign wr_en=fifo_wen;     
   
   
   always@(posedge fifo_wclk or posedge fifo_wrst)begin
        if(fifo_wrst)begin
            fifo_nafull  <=1'b0;
        end
        else begin
            fifo_nafull  <=#U_DLY (~prog_full ) & (~wr_rst_busy);
        end
   end
   always@(posedge fifo_rclk or posedge fifo_rrst)begin
        if(fifo_rrst)begin
            fifo_naempty <=1'b0;
        end
        else begin
            fifo_naempty <=#U_DLY (~prog_empty) & (~rd_rst_busy);
        end
   end
   assign fifo_nfull=(~full) & (~wr_rst_busy);
   assign fifo_nempty=(~empty)&(~rd_rst_busy); 

    xpm_fifo_async #(
      .CDC_SYNC_STAGES(2),       // DECIMAL 
      .DOUT_RESET_VALUE("0"),    // String
      .ECC_MODE("no_ecc"),       // String
      .FIFO_MEMORY_TYPE(FIFO_MEMORY_TYPE), // String
      .FIFO_READ_LATENCY(FIFO_READ_DELAY),     // DECIMAL
      .FIFO_WRITE_DEPTH(2**FIFO_DEPTHBIT),   // DECIMAL
      .FULL_RESET_VALUE(0),      // DECIMAL
      .PROG_EMPTY_THRESH(FIFO_NAEMPTY_SIZE),    // DECIMAL
      .PROG_FULL_THRESH(2**FIFO_DEPTHBIT-FIFO_NAFULL_SIZE),     // DECIMAL
      .RD_DATA_COUNT_WIDTH(FIFO_DEPTHBIT+1),   // DECIMAL
      .READ_DATA_WIDTH(FIFO_WIDTHBIT),      // DECIMAL
      .READ_MODE(READ_MODE),         // String
      .RELATED_CLOCKS(0),        // DECIMAL
      .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_ADV_FEATURES("1707"), // String
      .WAKEUP_TIME(0),           // DECIMAL
      .WRITE_DATA_WIDTH(FIFO_WIDTHBIT),     // DECIMAL
      .WR_DATA_COUNT_WIDTH(FIFO_DEPTHBIT+1)    // DECIMAL
   )
   xpm_fifo_async_inst (
      .almost_empty(almost_empty),   // 1-bit output: Almost Empty : When asserted, this signal indicates that
                                     // only one more read can be performed before the FIFO goes to empty.

      .almost_full(almost_full),     // 1-bit output: Almost Full: When asserted, this signal indicates that
                                     // only one more write can be performed before the FIFO is full.

      .data_valid(data_valid),       // 1-bit output: Read Data Valid: When asserted, this signal indicates
                                     // that valid data is available on the output bus (dout).

      .dbiterr(dbiterr),             // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
                                     // a double-bit error and data in the FIFO core is corrupted.

      .dout(dout),                   // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
                                     // when reading the FIFO.

      .empty(empty),                 // 1-bit output: Empty Flag: When asserted, this signal indicates that the
                                     // FIFO is empty. Read requests are ignored when the FIFO is empty,
                                     // initiating a read while empty is not destructive to the FIFO.

      .full(full),                   // 1-bit output: Full Flag: When asserted, this signal indicates that the
                                     // FIFO is full. Write requests are ignored when the FIFO is full,
                                     // initiating a write when the FIFO is full is not destructive to the
                                     // contents of the FIFO.

      .overflow(overflow),           // 1-bit output: Overflow: This signal indicates that a write request
                                     // (wren) during the prior clock cycle was rejected, because the FIFO is
                                     // full. Overflowing the FIFO is not destructive to the contents of the
                                     // FIFO.

      .prog_empty(prog_empty),       // 1-bit output: Programmable Empty: This signal is asserted when the
                                     // number of words in the FIFO is less than or equal to the programmable
                                     // empty threshold value. It is de-asserted when the number of words in
                                     // the FIFO exceeds the programmable empty threshold value.

      .prog_full(prog_full),         // 1-bit output: Programmable Full: This signal is asserted when the
                                     // number of words in the FIFO is greater than or equal to the
                                     // programmable full threshold value. It is de-asserted when the number of
                                     // words in the FIFO is less than the programmable full threshold value.

      .rd_data_count(rd_data_count), // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the
                                     // number of words read from the FIFO.

      .rd_rst_busy(rd_rst_busy),     // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read
                                     // domain is currently in a reset state.

      .sbiterr(sbiterr),             // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected
                                     // and fixed a single-bit error.

      .underflow(underflow),         // 1-bit output: Underflow: Indicates that the read request (rd_en) during
                                     // the previous clock cycle was rejected because the FIFO is empty. Under
                                     // flowing the FIFO is not destructive to the FIFO.

      .wr_ack(wr_ack),               // 1-bit output: Write Acknowledge: This signal indicates that a write
                                     // request (wr_en) during the prior clock cycle is succeeded.

      .wr_data_count(wr_data_count), // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
                                     // the number of words written into the FIFO.

      .wr_rst_busy(wr_rst_busy),     // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
                                     // write domain is currently in a reset state.

      .din(din),                     // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
                                     // writing the FIFO.

      .injectdbiterr(injectdbiterr), // 1-bit input: Double Bit Error Injection: Injects a double bit error if
                                     // the ECC feature is used on block RAMs or UltraRAM macros.

      .injectsbiterr(injectsbiterr), // 1-bit input: Single Bit Error Injection: Injects a single bit error if
                                     // the ECC feature is used on block RAMs or UltraRAM macros.

      .rd_clk(rd_clk),               // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
                                     // running clock.

      .rd_en(rd_en),                 // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
                                     // signal causes data (on dout) to be read from the FIFO. Must be held
                                     // active-low when rd_rst_busy is active high.

      .rst(rst),                     // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
                                     // unstable at the time of applying reset, but reset must be released only
                                     // after the clock(s) is/are stable.

      .sleep(sleep),                 // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
                                     // block is in power saving mode.

      .wr_clk(wr_clk),               // 1-bit input: Write clock: Used for write operation. wr_clk must be a
                                     // free running clock.

      .wr_en(wr_en)                  // 1-bit input: Write Enable: If the FIFO is not full, asserting this
                                     // signal causes data (on din) to be written to the FIFO. Must be held
                                     // active-low when rst or wr_rst_busy is active high.

   );
end
   // End of xpm_fifo_sync_inst instantiation
endgenerate				
endmodule			