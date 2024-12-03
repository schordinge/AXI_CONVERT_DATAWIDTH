// =================================================================================================
// Copyright(C) 2023 - TsingHua rights reserved. 
// =================================================================================================
//
// Module         : interface_define.sv
// Function       : public interface define
// File tree      : interface_define         : 
//                      |__ if_fifo          : normal   sync fifo wr/rd
//                      |__ if_fifo_wr       : normal   sync fifo wr
//                      |__ if_fifo_rd       : normal   sync fifo rd
//                      |__ if_ram           : simple   sync dport ram
//                      |__ if_ram_wr        : ram_wr   interface
//                      |__ if_ram_rd        : ram_rd   interface
//                      |__ if_cif           : cif      interface
//                      |__ if_reg           : reg      interface
//                      |__ if_gpio          : gpio     interface
//                      |__ if_axis          : axis     interface
//                      |__ if_axi_lite      : axi_lite interface
//                      |__ if_axi           : axi      interface
//                      |__ if_xilinx_pcie   : xilinx   pcie_cq_cc_rq_rc  interface
//                      |__ if_xilinx_msi    : xilinx   msi  interface
//                      |__ if_user_msi      : user     msi  interface
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by         Contents
// 1.0        2023/10/27   yao.luo            create
// 1.1        2023/11/18   yao.luo            delete all clk&rst @ interface to avoild vivado bug
// 1.2        2023/11/18   yao.luo            add gpio,axilite,axi interface
// 1.3        2024/7/25    yao.luo            add xilinx pcie interface
// =================================================================================================

`ifndef INTERFACE_DEFINE
`define INTERFACE_DEFINE

interface if_fifo #
(
    parameter DW                        = 8             ,//FIFO_WIDTHBIT    
    parameter DP                        = 8             ,//FIFO_DEPTHBIT    
    parameter NA                        = 10            ,//FIFO_NAFULL_SIZE 
    parameter NF                        = 10            ,//FIFO_NAEMPTY_SIZE
    parameter RL                        = 0             ,//FIFO_READ_DELAY  
    parameter RT                        = "AUTO"         //"BRAM","DRAM","URAM","AUTO" 
)
(
);
    logic                               wen             ;
    logic   [DW-1:0]                    wdata           ;
    logic                               nafull          ;
    logic                               nfull           ;
    logic                               ren             ;
    logic   [DW-1:0]                    rdata           ;
    logic                               rvld            ;
    logic                               naempty         ;
    logic                               nempty          ;
    logic   [DP  :0]                    rcnt            ;
    logic   [DP  :0]                    wcnt            ;
    logic                               underflow       ;
    logic                               overflow        ;

    modport master(
        output                          wen        ,
        output                          wdata      ,
        input                           nafull     ,
        input                           nfull      ,
        output                          ren        ,
        input                           rdata      ,
        input                           rvld       ,
        input                           naempty    ,
        input                           nempty     ,
        input                           rcnt       ,
        input                           wcnt       ,
        input                           underflow  ,
        input                           overflow    
    );

    modport slave(
        input                           wen        ,
        input                           wdata      ,
        output                          nafull     ,
        output                          nfull      ,
        input                           ren        ,
        output                          rdata      ,
        output                          rvld       ,
        output                          naempty    ,
        output                          nempty     ,
        output                          rcnt       ,
        output                          wcnt       ,
        output                          underflow  ,
        output                          overflow    
    );
endinterface

interface if_fifo_wr #
(
    parameter DW                        = 8             ,//FIFO_WIDTHBIT    
    parameter DP                        = 8             ,//FIFO_DEPTHBIT    
    parameter NA                        = 10            ,//FIFO_NAFULL_SIZE 
    parameter NF                        = 10            ,//FIFO_NAEMPTY_SIZE
    parameter RL                        = 0             ,//FIFO_READ_DELAY  
    parameter RT                        = "AUTO"         //"BRAM","DRAM","URAM","AUTO" 
)
(
);
    logic                               wen        ;
    logic   [DW-1:0]                    wdata      ;
    logic                               nafull     ;
    logic                               nfull      ;
    logic   [DP  :0]                    wcnt       ;
    logic                               overflow   ;
    
    modport master(
        output                          wen        ,
        output                          wdata      ,
        input                           nafull     ,
        input                           nfull      ,
        input                           wcnt       ,
        input                           overflow 
    );

    modport slave (
        input                           wen        ,
        input                           wdata      ,
        output                          nafull     ,
        output                          nfull      ,
        output                          wcnt       ,
        output                          overflow 
    );
endinterface

interface if_fifo_rd #
(
    parameter DW                        = 8             ,//FIFO_WIDTHBIT    
    parameter DP                        = 8             ,//FIFO_DEPTHBIT    
    parameter NA                        = 10            ,//FIFO_NAFULL_SIZE 
    parameter NF                        = 10            ,//FIFO_NAEMPTY_SIZE
    parameter RL                        = 0             ,//FIFO_READ_DELAY  
    parameter RT                        = "AUTO"         //"BRAM","DRAM","URAM","AUTO" 
)
(
);
    logic                               ren             ;
    logic   [DW-1:0]                    rdata           ;
    logic                               rvld            ;
    logic                               naempty         ;
    logic                               nempty          ; 
    logic   [DP  :0]                    rcnt            ;
    logic                               underflow       ;

    modport master(
        output                          ren             ,
        input                           rdata           ,
        input                           rvld            ,
        input                           naempty         ,
        input                           nempty          , 
        input                           rcnt            ,
        input                           underflow  
    );

    modport slave (
        input                           ren                 ,
        output                          rdata               ,
        output                          rvld                ,
        output                          naempty             ,
        output                          nempty              ,
        output                          rcnt                ,
        output                          underflow  
    );
endinterface

interface if_ram #
(
    parameter W_AW                      = 8                 ,
    parameter W_DW                      = 9                 ,
    parameter R_AW                      = W_AW              ,
    parameter R_DW                      = W_DW              ,
    parameter RL                        = 2                 ,
    parameter RT                        = "AUTO"         //"BRAM","DRAM","URAM","AUTO" 
)
(
);
    logic                               wen                 ;
    logic   [W_AW-1:0]                  waddr               ;
    logic   [W_DW-1:0]                  wdata               ;
    logic                               ren                 ;
    logic                               rvld                ;
    logic   [R_AW-1:0]                  raddr               ;
    logic   [R_DW-1:0]                  rdata               ;

    modport master(
        output                          wen                 ,
        output                          waddr               ,
        output                          wdata               ,
        output                          ren                 ,
        output                          raddr               ,
        input                           rvld                ,
        input                           rdata
    );

    modport slave (
        input                           wen                 ,
        input                           waddr               ,
        input                           wdata               ,
        input                           ren                 ,
        input                           raddr               ,  
        output                          rvld                ,
        output                          rdata
    );
endinterface

interface if_ram_wr #
(
    parameter AW                        = 64                ,
    parameter DW                        = 256               ,
    parameter RT                        = "AUTO"            //"BRAM","DRAM","URAM","AUTO" 
)
(
);
    logic                               wen                 ;
    logic   [ AW-1:0]                   waddr               ;
    logic   [ DW-1:0]                   wdata               ;
    modport master( 
        output                          wen                 ,
        output                          waddr               ,
        output                          wdata
        
    );

    modport slave (
        input                          wen                  ,
        input                          waddr                ,
        input                          wdata        
    );
endinterface

interface if_ram_rd #
(
    parameter AW                       = 64                 ,
    parameter DW                       = 256                ,
    parameter RL                       = 2                  ,
    parameter RT                        = "AUTO"            //"BRAM","DRAM","URAM","AUTO" 
)
(
);
    logic                              ren                  ;
    logic   [ AW-1:0]                  raddr                ; 
    logic                              rvld                 ;
    logic   [ DW-1:0]                  rdata                ;
    modport master(
        output                         ren                  ,
        output                         raddr                ,
        input                          rvld                 ,
        input                          rdata        
        
    );

    modport slave (
        input                          ren                  , 
        input                          raddr                ,
        output                         rvld                 ,
        output                         rdata        
    );
endinterface

interface if_cif #
(
    parameter DW                       = 32                 ,
    parameter KW                       = DW/8               ,
    parameter AW                       = 16                 ,
    parameter EN                       = 0                  ,  
    parameter ST                       = 0                  ,
    parameter ED                       = 0                  

)
(
);
    logic                              req                  ;
    logic                              rw                   ;
    logic   [ AW-1:0]                  addr                 ;
    logic   [ DW-1:0]                  wdata                ;
    logic   [ KW-1:0]                  wstrb                ;
    logic                              ack                  ;
    logic   [ DW-1:0]                  rdata                ;
    modport master(
        output                         req                  ,        
        output                         rw                   ,
        output                         addr                 ,
        output                         wdata                ,
        output                         wstrb                ,
        input                          ack                  ,
        input                          rdata                 
    );

    modport slave (
        input                          req                  ,  
        input                          rw                   ,
        input                          addr                 ,
        input                          wdata                ,
        input                          wstrb                ,
        output                         ack                  ,
        output                         rdata                 
    );  
endinterface

interface if_reg #
(
    parameter DW                       = 32                 ,
    parameter NUM                      = 32                  

)
(
    input [NUM*2 -1:0]                TYPE                  ,    
    input [NUM*DW-1:0]                INIT                      
);
    logic   [ NUM*DW-1:0]              wdata                ;
    logic   [ NUM*DW-1:0]              rdata                ;
    logic   [ NUM*1 -1:0]              wtrig                ;
    logic   [ NUM*1 -1:0]              rtrig                ;
    modport master(
        input                          TYPE                 ,
        input                          INIT                 ,
        output                         wdata                ,
        input                          rdata                , 
        output                         wtrig                ,
        output                         rtrig                 
    );

    modport slave (
        input                          TYPE                 ,
        input                          INIT                 ,
        input                          wdata                ,
        output                         rdata                ,
        input                          wtrig                ,
        input                          rtrig                 
    );  
endinterface

interface if_gpio #
(
    parameter DW                       = 1                  
)
(
);
    logic   [DW-1:0]                   i                    ;
    logic   [DW-1:0]                   o                    ;
    logic   [DW-1:0]                   t                    ;//0=out;1=iin
    modport master(
        input                          i                    , 
        output                         o                    ,
        output                         t                  
    );

    modport slave (
        output                         i                     ,
        input                          o                     ,
        input                          t                      
    );  
endinterface


interface if_axis #
(
    parameter DW                       = 32                 ,
    parameter KW                       = DW/8                   
)
(
);
    logic                              tready               ;
    logic                              tvalid               ;
    logic                              tlast                ;
    logic   [ DW-1:0]                  tdata                ;
    logic   [ KW-1:0]                  tkeep                ;
    modport master(
        input                          tready               ,        
        output                         tvalid               ,
        output                         tlast                ,
        output                         tdata                ,
        output                         tkeep                 
    );

    modport slave (
        output                         tready               ,
        input                          tvalid               ,
        input                          tlast                ,
        input                          tdata                ,
        input                          tkeep                 
    );  
endinterface

interface if_axi_lite #
(
    parameter DW                        = 32                 ,
    parameter AW                        = 32                 
)
(
);
    logic   [AW-1:0]                    araddr              ;
    logic   [2:0]                       arprot              ;//unuse
    logic                               arready             ;
    logic                               arvalid             ;

    logic   [AW-1:0]                    awaddr              ;
    logic   [2:0]                       awprot              ;//unuse
    logic                               awready             ;
    logic                               awvalid             ;

    logic                               bready              ;
    logic   [1:0]                       bresp               ;//fix 0
    logic                               bvalid              ;

    logic   [DW-1:0]                    rdata               ;
    logic                               rready              ;
    logic   [1:0]                       rresp               ;//fix 0
    logic                               rvalid              ;

    logic   [DW-1:0]                    wdata               ;
    logic                               wready              ;
    logic   [DW/8-1:0]                  wstrb               ;//unuse
    logic                               wvalid              ;
    modport master(
        output                          araddr              ,
        output                          arprot              ,
        input                           arready             ,
        output                          arvalid             ,
        
        output                          awaddr              ,
        output                          awprot              ,
        input                           awready             ,
        output                          awvalid             ,
        
        output                          bready              ,
        input                           bresp               ,
        input                           bvalid              ,
        
        input                           rdata               ,
        output                          rready              ,
        input                           rresp               ,
        input                           rvalid              ,
        
        output                          wdata               ,
        input                           wready              ,
        output                          wstrb               ,
        output                          wvalid               
    );

    modport slave (
        input                           araddr              ,
        input                           arprot              ,
        output                          arready             ,
        input                           arvalid             ,
                
        input                           awaddr              ,
        input                           awprot              ,
        output                          awready             ,
        input                           awvalid             ,
                
        input                           bready              ,
        output                          bresp               ,
        output                          bvalid              ,
                
        output                          rdata               ,
        input                           rready              ,
        output                          rresp               ,
        output                          rvalid              ,
                
        input                           wdata               ,
        output                          wready              ,
        input                           wstrb               ,
        input                           wvalid               
    );  
endinterface

interface if_axi #
(
    parameter DW                        = 64                 ,
    parameter AW                        = 64                 ,
    parameter ARSIZE                    = $clog2(DW/8)       ,
    parameter IDSIZE                    = 12                 ,
    parameter BURST_FIXED               =2'b00               ,
    parameter BURST_INCR                =2'b01               ,//default
    parameter BURST_WRAP                =2'b10               ,
    parameter CACHE_NBUFF               =4'b0000             ,             
    parameter CACHE_BUFF                =4'b0001             ,
    parameter NCACHE_NBUFF              =4'b0010             ,
    parameter NCACHE_BUFF               =4'b0011              //default
)
(
);
    logic   [AW-1:0]                    araddr               ;
    logic   [1:0]                       arburst              ;//fix increase mode
    logic   [3:0]                       arcache              ;//NCACHE_BUFF  recommended
    logic   [IDSIZE-1:0]                arid                 ;
    logic   [7:0]                       arlen                ;//0~15 when arburst=BURST_WRAP;0~255 when arburst=BURST_INCR 
    logic                               arlock               ;//fix 0
    logic   [2:0]                       arprot               ;//unuse
    logic   [3:0]                       arqos                ;//unuse
    logic                               arready              ;
    logic   [3:0]                       arregion             ;
    logic   [ARSIZE-1:0]                arsize               ;//2**ARSIZE<=DW/8,less than the native data width is not recommended
    logic                               arvalid              ;


    logic   [AW-1:0]                    awaddr               ;
    logic   [1:0]                       awburst              ;
    logic   [3:0]                       awcache              ;
    logic   [IDSIZE-1:0]                awid                 ;
    logic   [7:0]                       awlen                ;
    logic   [0:0]                       awlock               ;
    logic   [2:0]                       awprot               ;
    logic   [3:0]                       awqos                ;
    logic                               awready              ;
    logic   [3:0]                       awregion             ;
    logic   [ARSIZE-1:0]                awsize               ;
    logic                               awvalid              ;

    logic   [IDSIZE-1:0]                bid                  ;
    logic                               bready               ;
    logic   [1:0]                       bresp                ;//fix 0
    logic                               bvalid               ;
 
    logic   [DW-1:0]                    rdata                ;
    logic   [IDSIZE-1:0]                rid                  ;
    logic                               rlast                ;
    logic                               rready               ;
    logic   [1:0]                       rresp                ;//fix 0
    logic                               rvalid               ;
 
    logic   [DW-1:0]                    wdata                ;
    logic                               wlast                ;
    logic                               wready               ;
    logic   [DW/8-1:0]                  wstrb                ;//unuse
    logic                               wvalid               ;

    modport master(
        output                          araddr              ,
        output                          arburst             ,
        output                          arcache             ,
        output                          arid                ,
        output                          arlen               ,
        output                          arlock              ,
        output                          arprot              ,
        output                          arqos               ,
        input                           arready             ,
        output                          arregion            ,
        output                          arsize              ,
        output                          arvalid             ,
        
        output                          awaddr              ,
        output                          awburst             ,
        output                          awcache             ,
        output                          awid                ,
        output                          awlen               ,
        output                          awlock              ,
        output                          awprot              ,
        output                          awqos               ,
        input                           awready             ,
        output                          awregion            ,
        output                          awsize              ,
        output                          awvalid             ,

        input                           bid                 ,
        output                          bready              ,
        input                           bresp               ,
        input                           bvalid              ,
        
        input                           rdata               ,
        input                           rid                 ,
        input                           rlast               ,
        output                          rready              ,
        input                           rresp               ,
        input                           rvalid              ,
        
        output                          wdata               ,
        output                          wlast               ,
        input                           wready              ,
        output                          wstrb               ,
        output                          wvalid               
    );

    modport slave (
        input                           araddr              ,
        input                           arburst             ,
        input                           arcache             ,
        input                           arid                ,
        input                           arlen               ,
        input                           arlock              ,
        input                           arprot              ,
        input                           arqos               ,
        output                          arready             ,
        input                           arregion            ,
        input                           arsize              ,
        input                           arvalid             ,
                
        input                           awaddr              ,
        input                           awburst             ,
        input                           awcache             ,
        input                           awid                ,
        input                           awlen               ,
        input                           awlock              ,
        input                           awprot              ,
        input                           awqos               ,
        output                          awready             ,
        input                           awregion            ,
        input                           awsize              ,
        input                           awvalid             ,

        output                          bid                 ,        
        input                           bready              ,
        output                          bresp               ,
        output                          bvalid              ,
                
        output                          rdata               ,
        output                          rid                 ,
        output                          rlast               ,
        input                           rready              ,
        output                          rresp               ,
        output                          rvalid              ,
                
        input                           wdata               ,
        input                           wlast               ,
        output                          wready              ,
        input                           wstrb               ,
        input                           wvalid               
    );  
endinterface

interface if_xilinx_pcie #
(
    parameter DW                       = 64                 ,
    parameter KW                       = DW/32              ,    
    parameter CQUW                     = 88                 ,    
    parameter CCUW                     = 33                 ,    
    parameter RQUW                     = 62                 ,    
    parameter RCUW                     = 75                 ,    
    parameter UW                       = CQUW                          
)
(
);
    logic [DW-1:0]          tdata   ;
    logic [KW-1:0]          tkeep   ;
    logic                   tlast   ;
    logic                   tready  ;
    logic [UW-1:0]          tuser   ;
    logic                   tvalid  ;

    modport master(
        input            tready     ,        
        output           tdata      ,
        output           tkeep      ,
        output           tlast      ,
        output           tuser      , 
        output           tvalid       
    );

    modport slave (
        output           tready     ,
        input            tdata      ,
        input            tkeep      ,
        input            tlast      ,
        input            tuser      ,
        input            tvalid      
    );  
endinterface

interface if_xilinx_pcie_cfg #
(
    parameter DW                       = 32                 ,
    parameter KW                       = DW/8               ,
    parameter AW                       = 10                          
)
(
);
    logic [AW-1:0]          addr            ;
    logic [7:0]             function_number ;
    logic                   write           ;
    logic [DW-1:0]          write_data      ;
    logic [KW-1:0]          byte_enable     ;
    logic                   read            ;
    logic [DW-1:0]          read_data       ;
    logic                   read_write_done ;
    logic                   debug_access    ;
    modport master(
        output           addr               ,        
        output           function_number    ,
        output           write              ,
        output           write_data         ,
        output           byte_enable        , 
        output           read               , 
        input            read_data          , 
        input            read_write_done    , 
        output           debug_access         
    );

    modport slave (
        input            addr               ,       
        input            function_number    ,
        input            write              ,
        input            write_data         ,
        input            byte_enable        , 
        input            read               , 
        output           read_data          , 
        output           read_write_done    , 
        input            debug_access         
    );  
endinterface

interface if_xilinx_msi #
(
    parameter DW        = 1+5+32
)
(
);
    logic [3    : 0]    enable                      ;//output PF0~PF3,only PF0 is used
    logic [11   : 0]    mmenable                    ;//output 2**mmenable[3:0]=PF0's msi interupt number
    logic               mask_update                 ;//output unuse
    logic [31   : 0]    mask_data                   ;//output rec msi interupt vector
    logic [31   : 0]    irq_trig                    ;//input  send msi interupt vector
    logic [31   : 0]    pend_data                   ;//input  send msi interupt pending vector
    logic               pend_data_v                 ;//input  send msi interupt pending valid
    logic               sent                        ;//output 
    modport master(
        input           enable                     ,        
        input           mmenable                   ,
        input           mask_update                ,
        input           mask_data                  ,
        output          irq_trig                   , 
        output          pend_data                  , 
        output          pend_data_v                , 
        input           sent                        
    );

    modport slave (
        output           enable                     , 
        output           mmenable                   ,
        output           mask_update                ,
        output           mask_data                  ,
        input            irq_trig                   , 
        input            pend_data                  , 
        input            pend_data_v                , 
        output           sent                       
    );  
endinterface

interface if_user_msi #
(
    parameter DW        = 1+5+32
)
(
);
    logic               cfg_msi_grant              ;//output
    logic               cfg_msi_en                 ;//output
    logic [31   : 0]    cfg_msi_mask               ;//output
    logic               ven_msi_req                ;//input
    logic [ 2   : 0]    ven_msi_func_num           ;//input
    logic [ 2   : 0]    ven_msi_tc                 ;//input
    logic [ 4   : 0]    ven_msi_vector             ;//input
    logic [31   : 0]    ven_msi_pending            ;//input
    modport master(
        input           cfg_msi_grant              ,        
        input           cfg_msi_en                 ,
        input           cfg_msi_mask               ,
        output          ven_msi_req                ,
        output          ven_msi_func_num           , 
        output          ven_msi_tc                 , 
        output          ven_msi_vector             , 
        output          ven_msi_pending             
    );

    modport slave (
        output          cfg_msi_grant             , 
        output          cfg_msi_en                ,
        output          cfg_msi_mask              ,
        input           ven_msi_req               ,
        input           ven_msi_func_num          , 
        input           ven_msi_tc                , 
        input           ven_msi_vector            , 
        input           ven_msi_pending           
    );  
endinterface


`endif
