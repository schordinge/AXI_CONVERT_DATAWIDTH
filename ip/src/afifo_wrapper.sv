// =================================================================================================
// Copyright (c) 2021 - TsingHua rights reserved. 
// =================================================================================================
//
// Module         : afifo_wrapper
// Function       : afifo_wrapper
// file tree      : afifo_wrapper
//                      |_  afifo
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded By   contents
// 1.0        2023/10/30   yao.luo     create
//
// =================================================================================================

module afifo_wrapper #
(
    parameter U_DLY	     = 1 //for simulation
)
(
    input           wclk        ,
    input           wrst        ,
    input           rclk        ,
    input           rrst        ,
    if_fifo.slave   ifs_fifo 
);
    afifo #
    (
        .FIFO_WIDTHBIT                  (ifs_fifo.DW           ),
        .FIFO_DEPTHBIT                  (ifs_fifo.DP           ),
        .FIFO_NAFULL_SIZE               (ifs_fifo.NF           ),//>=5
        .FIFO_NAEMPTY_SIZE              (ifs_fifo.NA           ),//>=5
        .FIFO_READ_DELAY                (ifs_fifo.RL           ),             
        .FIFO_RAM_TYPE                  (ifs_fifo.RT           )            
    ) u_afifo
    (
        .fifo_wclk                       (         wclk         ),
        .fifo_wrst                       (         wrst         ),
        .fifo_wen                        (ifs_fifo.wen          ),
        .fifo_wdata                      (ifs_fifo.wdata        ),
        .fifo_nafull                     (ifs_fifo.nafull       ),
        .fifo_nfull                      (ifs_fifo.nfull        ),
        .fifo_rclk                       (         rclk         ),
        .fifo_rrst                       (         rrst         ),
        .fifo_ren                        (ifs_fifo.ren          ),
        .fifo_rdata                      (ifs_fifo.rdata        ),
        .fifo_rvld                       (ifs_fifo.rvld         ),
        .fifo_naempty                    (ifs_fifo.naempty      ),
        .fifo_nempty                     (ifs_fifo.nempty       ),
        .fifo_rcnt                       (ifs_fifo.rcnt         ),//fifo used count
        .fifo_wcnt                       (ifs_fifo.wcnt         ),//fifo used count
        .fifo_underflow                  (ifs_fifo.underflow    ),//first error side , 1: r, 0: w
        .fifo_overflow                   (ifs_fifo.overflow     )
    );
endmodule			