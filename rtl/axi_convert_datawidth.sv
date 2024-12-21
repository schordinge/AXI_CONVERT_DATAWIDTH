// =================================================================================================
// Copyright (c) 2021 - TsingHua rights reserved. 
// =================================================================================================
//
// Module         : axi_convert_datawidth
// Function       : support axi clock domain change and data wdith change
//                  1. axi data width change support 1/2/4/8 times ,other case not support
//                  2. axi data width only support 16/32/64/128/256/512/1024,other case not support
//                  3. axi_arsize or axi_awsize must = DW/8,other case not support
//                  4. axi_len must <=16 beats
// file tree      : axi_convert_datawidth
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded By   contents
// 1.0        2024/12/1    yao.luo     create
//
// =================================================================================================
module axi_convert_datawidth #
(
    parameter U_DLY         = 1             ,     

    parameter S_AW          = 64            , //slave.adress width   
    parameter S_IW          = 12            , //slave.id width  
    parameter S_DW          = 128           , //slave.data width
    parameter S_KW          = S_DW/8        , //slave.wstrb width 
    parameter S_SW          = 3             , //slave.size width

    parameter M_AW          = 64            , //master.adress width   
    parameter M_IW          = 12            , //master.id width  
    parameter M_DW          = 64            , //master.data width
    parameter M_KW          = M_DW/8        , //master.wstrb width 
    parameter M_SW          = 3             , //master.size width
    parameter M_BURST_LEN   = 8               //master size burst beats
)
(
    //axi.slave.clock&reset
    input    logic                          s_axi_aclk              ,
    input    logic                          s_axi_aresetn           ,
    //axi.slave.arch
    input    logic[S_AW-1:0]                s_axi_araddr            ,
    input    logic[1:0]                     s_axi_arburst           ,
    input    logic[3:0]                     s_axi_arcache           ,
    input    logic[S_IW-1:0]                s_axi_arid              ,
    input    logic[7:0]                     s_axi_arlen             ,
    input    logic                          s_axi_arlock            ,
    input    logic[2:0]                     s_axi_arprot            ,
    input    logic[3:0]                     s_axi_arqos             ,
    output   logic                          s_axi_arready           ,
    input    logic[3:0]                     s_axi_arregion          ,
    input    logic[S_SW-1:0]                s_axi_arsize            ,
    input    logic                          s_axi_arvalid           ,
    //axi.slave.awch
    input    logic[S_AW-1:0]                s_axi_awaddr            ,
    input    logic[1:0]                     s_axi_awburst           ,
    input    logic[3:0]                     s_axi_awcache           ,
    input    logic[S_IW-1:0]                s_axi_awid              ,
    input    logic[7:0]                     s_axi_awlen             ,
    input    logic                          s_axi_awlock            ,
    input    logic[2:0]                     s_axi_awprot            ,
    input    logic[3:0]                     s_axi_awqos             ,
    output   logic                          s_axi_awready           ,
    input    logic[3:0]                     s_axi_awregion          ,
    input    logic[S_SW-1:0]                s_axi_awsize            ,
    input    logic                          s_axi_awvalid           ,
    //axi.slave.bch
    output   logic[S_IW-1:0]                s_axi_bid               ,
    input    logic                          s_axi_bready            ,
    output   logic[1:0]                     s_axi_bresp             ,
    output   logic                          s_axi_bvalid            ,
    //axi.slave.rch
    output   logic[S_DW-1:0]                s_axi_rdata             ,
    output   logic[S_IW-1:0]                s_axi_rid               ,
    output   logic                          s_axi_rlast             ,
    input    logic                          s_axi_rready            ,
    output   logic[1:0]                     s_axi_rresp             ,
    output   logic                          s_axi_rvalid            ,
    //axi.slave.wch
    input    logic[S_DW-1:0]                s_axi_wdata             ,
    input    logic                          s_axi_wlast             ,
    output   logic                          s_axi_wready            ,
    input    logic[S_KW-1:0]                s_axi_wstrb             ,
    input    logic                          s_axi_wvalid            ,
    
    //axi.master.clock&reset
    input    logic                          m_axi_aclk              ,
    input    logic                          m_axi_aresetn           ,
    //axi.master.arch
    output   logic[M_AW-1:0]                m_axi_araddr            ,
    output   logic[1:0]                     m_axi_arburst           ,
    output   logic[3:0]                     m_axi_arcache           ,
    output   logic[M_IW-1:0]                m_axi_arid              ,
    output   logic[7:0]                     m_axi_arlen             ,
    output   logic                          m_axi_arlock            ,
    output   logic[2:0]                     m_axi_arprot            ,
    output   logic[3:0]                     m_axi_arqos             ,
    input    logic                          m_axi_arready           ,
    output   logic[3:0]                     m_axi_arregion          ,
    output   logic[M_SW-1:0]                m_axi_arsize            ,
    output   logic                          m_axi_arvalid           ,
    //axi.master.awch
    output   logic[M_AW-1:0]                m_axi_awaddr            ,
    output   logic[1:0]                     m_axi_awburst           ,
    output   logic[3:0]                     m_axi_awcache           ,
    output   logic[M_IW-1:0]                m_axi_awid              ,
    output   logic[7:0]                     m_axi_awlen             ,
    output   logic                          m_axi_awlock            ,
    output   logic[2:0]                     m_axi_awprot            ,
    output   logic[3:0]                     m_axi_awqos             ,
    input    logic                          m_axi_awready           ,
    output   logic[3:0]                     m_axi_awregion          ,
    output   logic[M_SW-1:0]                m_axi_awsize            ,
    output   logic                          m_axi_awvalid           ,
    //axi.master.bch
    input    logic[M_IW-1:0]                m_axi_bid               ,
    output   logic                          m_axi_bready            ,
    input    logic[1:0]                     m_axi_bresp             ,
    input    logic                          m_axi_bvalid            ,
    //axi.master.rch
    input    logic[M_DW-1:0]                m_axi_rdata             ,
    input    logic[M_IW-1:0]                m_axi_rid               ,
    input    logic                          m_axi_rlast             ,
    output   logic                          m_axi_rready            ,
    input    logic[1:0]                     m_axi_rresp             ,
    input    logic                          m_axi_rvalid            ,
    //axi.master.wch
    output   logic[M_DW-1:0]                m_axi_wdata             ,
    output   logic                          m_axi_wlast             ,
    input    logic                          m_axi_wready            ,
    output   logic[M_KW-1:0]                m_axi_wstrb             ,
    output   logic                          m_axi_wvalid            ,
    //debug output
    input    logic                          ila_clk                 ,             
    input    logic                          ila_rstn                ,
    output   logic[6-1:0]                   ila_fifo_nempty         ,    
    output   logic[6-1:0]                   ila_fifo_naempty        ,        
    output   logic[6-1:0]                   ila_fifo_nfull          ,    
    output   logic[6-1:0]                   ila_fifo_nafull         ,    
    output   logic[6-1:0]                   ila_fifo_underflow      ,        
    output   logic[6-1:0]                   ila_fifo_overflow               
);
// =================================================================================================
// localparams                                                                                  
// =================================================================================================
localparam DWT          =(S_DW<M_DW)?(M_DW/S_DW):(S_DW/M_DW);
localparam DWT_LOG2     =(DWT==1)?1:$clog2(DWT);
//fifos width
localparam FIFO_AW_DW   =
                            $bits(m_axi_awaddr  )+
                            $bits(m_axi_awburst )+
                            $bits(m_axi_awcache )+
                            $bits(m_axi_awid    )+
                            $bits(m_axi_awlen   )+
                            $bits(m_axi_awlock  )+
                            $bits(m_axi_awprot  )+
                            $bits(m_axi_awqos   )+
                            $bits(m_axi_awregion)+
                            $bits(m_axi_awsize  ) 
                        ;
localparam FIFO_AR_DW   = FIFO_AW_DW;
localparam FIFO_WD_DW   =
                            $bits(m_axi_wlast  )+
                            $bits(m_axi_wstrb  )+ 
                            $bits(m_axi_wdata  )
                        ;
localparam FIFO_RD_DW   =
                            $bits(s_axi_rid     )+
                            $bits(s_axi_rresp   )+
                            $bits(s_axi_rlast   )+ 
                            $bits(s_axi_rdata   )
                        ;   
localparam FIFO_WB_DW   =
                            $bits(s_axi_bid     )+
                            $bits(s_axi_bresp   ) 
                        ;                                               
// =================================================================================================
// singles defines                                                                                  
// =================================================================================================
logic                       s_axi_arst  ,m_axi_arst     ;
logic [M_AW-1:0]            s_mux_awaddr,s_mux_araddr   ;
logic [M_IW-1:0]            s_mux_awid  ,s_mux_arid     ;
logic [8   -1:0]            s_mux_awlen ,s_mux_arlen    ;
logic [M_SW-1:0]            s_mux_awsize,s_mux_arsize   ;
integer                     i           ,j              ;
logic [DWT_LOG2-1:0]        w_cnt       ,r_cnt          ;

if_fifo#(.DW(FIFO_AW_DW),.DP(5),.NA( 8),.NF(10),.RL(0)) if_aw_fifo();
if_fifo#(.DW(FIFO_AR_DW),.DP(5),.NA( 8),.NF(10),.RL(0)) if_ar_fifo();
if_fifo#(.DW(FIFO_WD_DW),.DP(7),.NA(64),.NF(10),.RL(0)) if_wd_fifo();
if_fifo#(.DW(8         ),.DP(9),.NA( 8),.NF(10),.RL(0)) if_rl_fifo();
if_fifo#(.DW(FIFO_RD_DW),.DP(7),.NA(64),.NF(10),.RL(0)) if_rd_fifo();
if_fifo#(.DW(FIFO_WB_DW),.DP(5),.NA( 8),.NF(10),.RL(0)) if_wb_fifo();


afifo_wrapper u_aw_fifo(.wclk(s_axi_aclk),.wrst(s_axi_arst),.rclk(m_axi_aclk),.rrst(m_axi_arst),.ifs_fifo(if_aw_fifo.slave));
afifo_wrapper u_ar_fifo(.wclk(s_axi_aclk),.wrst(s_axi_arst),.rclk(m_axi_aclk),.rrst(m_axi_arst),.ifs_fifo(if_ar_fifo.slave));
afifo_wrapper u_wd_fifo(.wclk(s_axi_aclk),.wrst(s_axi_arst),.rclk(m_axi_aclk),.rrst(m_axi_arst),.ifs_fifo(if_wd_fifo.slave));
afifo_wrapper u_rl_fifo(.wclk(s_axi_aclk),.wrst(s_axi_arst),.rclk(s_axi_aclk),.rrst(s_axi_arst),.ifs_fifo(if_rl_fifo.slave));
afifo_wrapper u_rd_fifo(.wclk(m_axi_aclk),.wrst(m_axi_arst),.rclk(s_axi_aclk),.rrst(s_axi_arst),.ifs_fifo(if_rd_fifo.slave));
afifo_wrapper u_wb_fifo(.wclk(m_axi_aclk),.wrst(m_axi_arst),.rclk(s_axi_aclk),.rrst(s_axi_arst),.ifs_fifo(if_wb_fifo.slave));
// =================================================================================================
// assignment                                                                                 
// =================================================================================================
assign s_axi_arst       =~s_axi_aresetn     ;
assign m_axi_arst       =~m_axi_aresetn     ;
// =================================================================================================
// fifos write handle                                                                                
// =================================================================================================
//aw&ar
assign s_axi_awready    = if_aw_fifo.nafull ;
assign s_axi_arready    = if_ar_fifo.nafull & if_rl_fifo.nafull;
always@(posedge s_axi_aclk or posedge s_axi_arst)begin
    if(s_axi_arst)begin
        if_aw_fifo.wen<='b0;
        if_ar_fifo.wen<='b0;
        if_rl_fifo.wen<='b0;
    end
    else begin
        if_aw_fifo.wen<=#U_DLY s_axi_awvalid & s_axi_awready;
        if_ar_fifo.wen<=#U_DLY s_axi_arvalid & s_axi_arready;
        if_rl_fifo.wen<=#U_DLY s_axi_arvalid & s_axi_arready;
    end
end

always@ (*)begin
    s_mux_awaddr = (S_AW>=M_AW)?s_axi_awaddr[0+:M_AW]:{'b0,s_axi_awaddr};
    s_mux_awid   = (S_IW>=M_IW)?s_axi_awid  [0+:M_IW]:{'b0,s_axi_awid  };
    s_mux_araddr = (S_AW>=M_AW)?s_axi_araddr[0+:M_AW]:{'b0,s_axi_araddr};
    s_mux_arid   = (S_IW>=M_IW)?s_axi_arid  [0+:M_IW]:{'b0,s_axi_arid  };

    if(S_DW<M_DW)begin
        s_mux_awlen  = (s_axi_awlen+1)/DWT-1;
        s_mux_awsize = s_axi_awsize+DWT_LOG2;
        s_mux_arlen  = (s_axi_arlen+1)/DWT-1;
        s_mux_arsize = s_axi_arsize+DWT_LOG2;
    end
    else if(S_DW==M_DW)begin
        s_mux_awlen  = s_axi_awlen  ;
        s_mux_awsize = s_axi_awsize ;
        s_mux_arlen  = s_axi_arlen  ;
        s_mux_arsize = s_axi_arsize ;
    end
    else begin
        s_mux_awlen  = (s_axi_awlen+1)*DWT-1;
        s_mux_awsize = s_axi_awsize-DWT_LOG2;
        s_mux_arlen  = (s_axi_arlen+1)*DWT-1;
        s_mux_arsize = s_axi_arsize-DWT_LOG2;
    end
end

always@(posedge s_axi_aclk)begin
    if_aw_fifo.wdata<=#U_DLY{ 
        s_mux_awaddr  ,
        s_axi_awburst ,
        s_axi_awcache ,
        s_mux_awid    ,
        s_mux_awlen   ,
        s_axi_awlock  ,
        s_axi_awprot  ,
        s_axi_awqos   ,
        s_axi_awregion,
        s_mux_awsize   
    };
    if_ar_fifo.wdata<=#U_DLY{ 
        s_mux_araddr  ,
        s_axi_arburst ,
        s_axi_arcache ,
        s_mux_arid    ,
        s_mux_arlen   ,
        s_axi_arlock  ,
        s_axi_arprot  ,
        s_axi_arqos   ,
        s_axi_arregion,
        s_mux_arsize   
    };
    if_rl_fifo.wdata<=#U_DLY{ 
        s_axi_arlen   
    };
end
//wd
generate
    if(S_DW<M_DW)begin
        assign s_axi_wready  = if_wd_fifo.nafull;

        always@(posedge s_axi_aclk or posedge s_axi_arst)begin
            if(s_axi_arst)begin
                w_cnt<='b0;
                if_wd_fifo.wen<='b0;
            end
            else begin
                w_cnt<=#U_DLY(s_axi_wvalid & s_axi_wready & s_axi_wlast)?'b0:
                             (s_axi_wvalid & s_axi_wready)?(w_cnt+1'b1):
                              w_cnt;
                if_wd_fifo.wen<=#U_DLY s_axi_wvalid & s_axi_wready & (s_axi_wlast|(&w_cnt));
            end
        end

        always@(posedge s_axi_aclk)begin
            if_wd_fifo.wdata[0+   w_cnt*(S_DW)+:S_DW]<=#U_DLY s_axi_wdata;
            if(w_cnt=='b0)begin 
                if_wd_fifo.wdata[M_DW+M_KW-1:M_DW]<=#U_DLY {'b0,s_axi_wstrb};
            end
            else begin
                if_wd_fifo.wdata[M_DW+w_cnt*(S_KW)+:S_KW]<=#U_DLY s_axi_wstrb;
            end
            if_wd_fifo.wdata[M_DW+M_KW]              <=#U_DLY s_axi_wlast;
        end
    end
    else if(S_DW==M_DW)begin
        assign s_axi_wready  = if_wd_fifo.nafull;

        always@(posedge s_axi_aclk or posedge s_axi_arst)begin
            if(s_axi_arst)begin
                if_wd_fifo.wen<='b0;
            end
            else begin
                if_wd_fifo.wen<=#U_DLY s_axi_wvalid & s_axi_wready;
            end
        end

        always@(posedge s_axi_aclk)begin
            if_wd_fifo.wdata<=#U_DLY{ s_axi_wlast,s_axi_wstrb,s_axi_wdata};
        end
    end
    else begin
        logic [M_DW-1:0] lock_wdata[DWT-1:0];
        logic [M_KW-1:0] lock_wstrb[DWT-1:0];
        logic [1   -1:0] lock_wlast[DWT-1:0];

        assign s_axi_wready  = if_wd_fifo.nafull & w_cnt=='b0;

        always@(posedge s_axi_aclk or posedge s_axi_arst)begin
            if(s_axi_arst)begin
                w_cnt         <='b0;
                if_wd_fifo.wen<='b0;
            end
            else begin
                w_cnt         <=#U_DLY (s_axi_wvalid & s_axi_wready)?(w_cnt+1'b1):(w_cnt!='b0)?(w_cnt+1'b1):'b0;
                if_wd_fifo.wen<=#U_DLY (s_axi_wvalid & s_axi_wready)|w_cnt!='b0;
            end
        end

        //lock slave.wdata
        always@(posedge s_axi_aclk)begin
            for(i=0;i<DWT;i++)begin
                if(s_axi_wvalid & s_axi_wready)begin
                    lock_wlast[i]<=#U_DLY s_axi_wlast&(i==DWT-1)   ;
                    lock_wstrb[i]<=#U_DLY s_axi_wstrb[i*M_KW+:M_KW];
                    lock_wdata[i]<=#U_DLY s_axi_wdata[i*M_DW+:M_DW];
                end
            end
        end
        //write fifo data
        always@(posedge s_axi_aclk)begin
            if(w_cnt=='b0)begin
                if_wd_fifo.wdata<=#U_DLY {
                    1'b0,
                    s_axi_wstrb[0+:M_KW],
                    s_axi_wdata[0+:M_DW]
                };
            end
            else begin
                if_wd_fifo.wdata<=#U_DLY {
                    lock_wlast[w_cnt],
                    lock_wstrb[w_cnt],
                    lock_wdata[w_cnt]
                };
            end
        end
    end
endgenerate
//rd
generate
    if(S_DW<M_DW)begin
        logic [S_DW -1:0]lock_rdata[DWT-1:0];
        logic [1    -1:0]lock_rlast[DWT-1:0];

        assign m_axi_rready  = if_rd_fifo.nafull & r_cnt=='b0;

        always@(posedge m_axi_aclk or posedge m_axi_arst)begin
            if(m_axi_arst)begin
                r_cnt         <='b0;
                if_rd_fifo.wen<='b0;
            end
            else begin
                r_cnt         <=#U_DLY (m_axi_rvalid & m_axi_rready)?(r_cnt+1'b1):(r_cnt!='b0)?(r_cnt+1'b1):'b0;
                if_rd_fifo.wen<=#U_DLY (m_axi_rvalid & m_axi_rready)|r_cnt!='b0;
            end
        end

        //lock slave.rdata
        always@(posedge m_axi_aclk)begin
            for(j=0;j<DWT;j++)begin
                if(m_axi_rvalid & m_axi_rready)begin
                    lock_rlast[j]<=#U_DLY m_axi_rlast&(j==DWT-1)   ; 
                    lock_rdata[j]<=#U_DLY m_axi_rdata[j*S_DW+:S_DW];
                end
            end
        end
        //read fifo wdata
        always@(posedge m_axi_aclk)begin
            if(r_cnt=='b0)begin
                if_rd_fifo.wdata[0+:(S_DW+1)]<=#U_DLY {
                    1'b0,
                    m_axi_rdata[0+:S_DW]
                };
            end
            else begin
                if_rd_fifo.wdata[0+:(S_DW+1)]<=#U_DLY {
                    lock_rlast[r_cnt],
                    lock_rdata[r_cnt]
                };
            end
        end
        always@(posedge m_axi_aclk)begin
            //lock rresp&rid at first beat
            if(r_cnt=='b0)begin
                if(S_IW<=M_IW)begin
                    if_rd_fifo.wdata[(S_DW+1)+:(S_IW+2)]<=#U_DLY{m_axi_rid[0+:S_IW],m_axi_rresp};
                end
                else begin
                    if_rd_fifo.wdata[(S_DW+1)+:(S_IW+2)]<=#U_DLY{{(S_IW-M_IW){1'b0}},m_axi_rid[0+:M_IW],m_axi_rresp};
                end
            end
        end
    end
    else if(S_DW==M_DW)begin
        assign m_axi_rready  = if_rd_fifo.nafull;

        always@(posedge m_axi_aclk or posedge m_axi_arst)begin
            if(m_axi_arst)begin
                if_rd_fifo.wen<='b0;
            end
            else begin
                if_rd_fifo.wen<=#U_DLY m_axi_rvalid & m_axi_rready;
            end
        end

        always@(posedge m_axi_aclk)begin
            if(S_IW<=M_IW)begin
                if_rd_fifo.wdata<=#U_DLY{m_axi_rid[0+:S_IW],m_axi_rresp,m_axi_rlast,m_axi_rdata};
            end
            else begin
                if_rd_fifo.wdata<=#U_DLY{ {(S_IW-M_IW){1'b0}},m_axi_rid[0+:M_IW],m_axi_rresp,m_axi_rlast,m_axi_rdata};
            end
        end
    end
    else begin
        assign m_axi_rready  = if_rd_fifo.nafull ;

        always@(posedge m_axi_aclk or posedge m_axi_arst)begin
            if(m_axi_arst)begin
                r_cnt<='b0;
                if_rd_fifo.wen<='b0;
            end
            else begin
                r_cnt<=#U_DLY(m_axi_rvalid & m_axi_rready & m_axi_rlast)?'b0:
                             (m_axi_rvalid & m_axi_rready)?(r_cnt+1'b1):
                              r_cnt;
                if_rd_fifo.wen<=#U_DLY m_axi_rvalid & m_axi_rready & (m_axi_rlast|(&r_cnt));
            end
        end

        always@(posedge m_axi_aclk)begin
            if_rd_fifo.wdata[r_cnt*M_DW+:M_DW]<=#U_DLY m_axi_rdata;
        end

        always@(posedge m_axi_aclk)begin
            if(S_IW<=M_IW)begin
                if_rd_fifo.wdata[S_DW+:(1+2+S_IW)]<=#U_DLY{m_axi_rid[0+:S_IW],m_axi_rresp,m_axi_rlast};
            end
            else begin
                if_rd_fifo.wdata[S_DW+:(1+2+S_IW)]<=#U_DLY{ 'b0,m_axi_rid,m_axi_rresp,m_axi_rlast};
            end
        end
    end
endgenerate
//wb
assign m_axi_bready  = if_wb_fifo.nafull;
always@(posedge m_axi_aclk or posedge m_axi_arst)begin
    if(m_axi_arst)begin
        if_wb_fifo.wen<='b0;
    end
    else begin
        if_wb_fifo.wen<=#U_DLY m_axi_bvalid & m_axi_bready;
    end
end
always@(posedge m_axi_aclk)begin
    if(S_IW<=M_IW)begin
        if_wb_fifo.wdata<=#U_DLY{m_axi_bid[0+:S_IW],m_axi_bresp};
    end
    else begin
        if_wb_fifo.wdata<=#U_DLY{'b0,m_axi_bid,m_axi_bresp};
    end
end

// =================================================================================================
// fifos read                                                                                 
// =================================================================================================
//aw&wd
assign if_aw_fifo.ren  =if_aw_fifo.nempty & (m_axi_awready |(~m_axi_awvalid));
assign if_wd_fifo.ren  =if_wd_fifo.nempty & (m_axi_wready  |(~m_axi_wvalid ));
always@(posedge m_axi_aclk or posedge m_axi_arst)begin
    if(m_axi_arst)begin
        m_axi_awvalid   <= 'b0;
        m_axi_wvalid    <= 'b0;
    end
    else begin
        m_axi_awvalid   <=#U_DLY  (if_aw_fifo.rvld)?1'b1:(m_axi_awready)?1'b0:m_axi_awvalid;
        m_axi_wvalid    <=#U_DLY  (if_wd_fifo.rvld)?1'b1:(m_axi_wready )?1'b0:m_axi_wvalid ;
    end
end
always@(posedge m_axi_aclk)begin
    if(if_aw_fifo.rvld)begin
        {
            m_axi_awaddr   ,
            m_axi_awburst  ,
            m_axi_awcache  ,
            m_axi_awid     ,
            m_axi_awlen    ,
            m_axi_awlock   ,
            m_axi_awprot   ,
            m_axi_awqos    ,
            m_axi_awregion ,
            m_axi_awsize   
        }<=#U_DLY if_aw_fifo.rdata  ;
    end
    if(if_wd_fifo.rvld)begin
        {
            m_axi_wlast ,
            m_axi_wstrb ,
            m_axi_wdata  
        }<=#U_DLY if_wd_fifo.rdata  ;
    end
end

//wb
assign if_wb_fifo.ren  =if_wb_fifo.nempty & (s_axi_bready |(~s_axi_bvalid));
always@(posedge s_axi_aclk or posedge s_axi_arst)begin
    if(s_axi_arst)begin
        s_axi_bvalid    <= 'b0;
    end
    else begin
        s_axi_bvalid    <=#U_DLY  (if_wb_fifo.rvld)?1'b1:(s_axi_bready)?1'b0:s_axi_bvalid;
    end
end
always@(posedge s_axi_aclk)begin
    if(if_wb_fifo.rvld)begin
        {
            s_axi_bid  ,
            s_axi_bresp  
        }<=#U_DLY if_wb_fifo.rdata  ;
    end
end

//ar split
logic      ar_split_run;
logic[7:0] ar_orign_len;
logic[7:0] ar_split_len;
logic[7:0] ar_split_len_dec;
assign if_ar_fifo.ren   =if_ar_fifo.nempty & m_axi_arready & (~ar_split_run);
assign ar_orign_len     =if_ar_fifo.rdata[
                                     (
                                        $bits(m_axi_arlock   )+
                                        $bits(m_axi_arprot   )+
                                        $bits(m_axi_arqos    )+
                                        $bits(m_axi_arregion )+
                                        $bits(m_axi_arsize   )
                                     )
                                     +:8];   
assign ar_split_len_dec=ar_split_len-M_BURST_LEN;

always@(posedge m_axi_aclk or posedge m_axi_arst)begin
    if(m_axi_arst)begin
        ar_split_run    <= 'b0;
        ar_split_len    <= 'b0;
        m_axi_arvalid   <= 'b0;
    end
    else begin
        if(if_ar_fifo.rvld)begin
            ar_split_run    <=#U_DLY 1'b1;
            ar_split_len    <=#U_DLY ar_orign_len+1;
            m_axi_arvalid   <=#U_DLY 1'b1;
        end
        else if(ar_split_run & m_axi_arready)begin
            if(ar_split_len>M_BURST_LEN)begin
                ar_split_run    <=#U_DLY 1'b1;
                ar_split_len    <=#U_DLY ar_split_len-M_BURST_LEN;
                m_axi_arvalid   <=#U_DLY 1'b1;
            end
            else begin
                ar_split_run    <=#U_DLY 1'b0;
                ar_split_len    <=#U_DLY  'b0;
                m_axi_arvalid   <=#U_DLY 1'b0;
            end
        end
    end
end
always@(posedge m_axi_aclk)begin
    if(if_ar_fifo.rvld)begin
         {
            m_axi_araddr   ,
            m_axi_arburst  ,
            m_axi_arcache  ,
            m_axi_arid     ,
            m_axi_arlen    ,
            m_axi_arlock   ,
            m_axi_arprot   ,
            m_axi_arqos    ,
            m_axi_arregion ,
            m_axi_arsize   
        }<=#U_DLY if_ar_fifo.rdata  ;
        //split first beat
        if(ar_orign_len>M_BURST_LEN)begin
            m_axi_arlen<=#U_DLY M_BURST_LEN-1;
        end
    end
    else if(ar_split_run & m_axi_arready)begin
        m_axi_arlen<=#U_DLY (ar_split_len_dec>M_BURST_LEN)?(M_BURST_LEN-1):(ar_split_len_dec-1);
        m_axi_araddr<=#U_DLY m_axi_araddr+M_BURST_LEN*M_KW;
    end
end

//r
assign if_rd_fifo.ren  =if_rd_fifo.nempty & (s_axi_rready |(~s_axi_rvalid));
assign if_rl_fifo.ren  =s_axi_rvalid & s_axi_rready & s_axi_rlast;
always@(posedge s_axi_aclk or posedge s_axi_arst)begin
    if(s_axi_arst)begin
        s_axi_rvalid    <= 'b0;
    end
    else begin
        s_axi_rvalid    <=#U_DLY  (if_rd_fifo.rvld)?1'b1:(s_axi_rready)?1'b0:s_axi_rvalid;
    end
end
logic      s_axi_rlast_r;
logic [7:0]s_axi_rcnt;
always@(posedge s_axi_aclk or posedge s_axi_arst)begin
    if(s_axi_arst)begin
        s_axi_rcnt      <= 'b0;
    end
    else begin
        if(s_axi_rvalid & s_axi_rready & s_axi_rlast)
            s_axi_rcnt<=#U_DLY 'b0;
        else if(s_axi_rvalid & s_axi_rready)    
            s_axi_rcnt<=#U_DLY s_axi_rcnt+1'b1;
    end
end

always@(posedge s_axi_aclk)begin
    if(if_rd_fifo.rvld)begin
        {
            s_axi_rid      ,
            s_axi_rresp    ,
            s_axi_rlast_r  ,
            s_axi_rdata   
        }<=#U_DLY if_rd_fifo.rdata  ;
    end
end
assign s_axi_rlast=s_axi_rlast_r & s_axi_rcnt==if_rl_fifo.rdata;
// =================================================================================================
// debug output                                                                                
// =================================================================================================
logic  ila_rst;
assign ila_rst=~ila_rstn;
always@(posedge ila_clk or posedge ila_rst)begin
    if(ila_rst)begin
        ila_fifo_nempty   <='b0;
        ila_fifo_naempty  <='b0;
        ila_fifo_nfull    <='b0;
        ila_fifo_nafull   <='b0;
        ila_fifo_underflow<='b0;
        ila_fifo_overflow <='b0;
    end
    else begin
        ila_fifo_nempty   <={
            if_aw_fifo.nempty,
            if_ar_fifo.nempty,
            if_rl_fifo.nempty,
            if_wd_fifo.nempty,
            if_rd_fifo.nempty,
            if_wb_fifo.nempty
        };
        ila_fifo_naempty   <={
            if_aw_fifo.naempty,
            if_ar_fifo.naempty,
            if_rl_fifo.naempty,
            if_wd_fifo.naempty,
            if_rd_fifo.naempty,
            if_wb_fifo.naempty
        };
        ila_fifo_nfull   <={
            if_aw_fifo.nfull,
            if_ar_fifo.nfull,
            if_rl_fifo.nfull,
            if_wd_fifo.nfull,
            if_rd_fifo.nfull,
            if_wb_fifo.nfull
        };
        ila_fifo_nafull   <={
            if_aw_fifo.nafull,
            if_ar_fifo.nafull,
            if_rl_fifo.nafull,
            if_wd_fifo.nafull,
            if_rd_fifo.nafull,
            if_wb_fifo.nafull
        };
        ila_fifo_underflow   <={
            if_aw_fifo.underflow,
            if_ar_fifo.underflow,
            if_rl_fifo.underflow,
            if_wd_fifo.underflow,
            if_rd_fifo.underflow,
            if_wb_fifo.underflow
        }|ila_fifo_underflow;
        ila_fifo_overflow   <={
            if_aw_fifo.overflow,
            if_ar_fifo.overflow,
            if_rl_fifo.overflow,
            if_wd_fifo.overflow,
            if_rd_fifo.overflow,
            if_wb_fifo.overflow
        }|ila_fifo_overflow;
    end
end

endmodule