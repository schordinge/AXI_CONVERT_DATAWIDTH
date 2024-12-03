

module bfm_axic #
(
    parameter TC_NAME="AXIC"           ,
    parameter S_AW = 64                ,
    parameter S_IW = 12                ,
    parameter S_DW = 128               ,
    parameter S_KW = S_DW/8            ,
    parameter S_SW = $clog2(S_KW)      ,
    parameter M_AW = S_AW              ,
    parameter M_IW = S_IW              ,
    parameter M_DW = 64                ,
    parameter M_KW = M_DW/8            ,
    parameter M_SW = $clog2(M_KW)       
)
(
    input s_axi_aclk    ,
    input s_axi_aresetn ,
    input m_axi_aclk    ,
    input m_axi_aresetn 
);

integer fptr=$fopen($sformatf("log_%s.log",TC_NAME));
integer     prt_en=1;
integer     log_en=1;
integer     err=0;

task my_print;
    input integer err_add;
    input string str;
    begin
        err=err_add+err;
        if(prt_en)$display("time=%8d",$time,$sformatf("-%11s:",TC_NAME),str);
        if(log_en)$fdisplay(fptr,"time=%8d",$time,$sformatf("-%11s:",TC_NAME),str);
        if(err)$stop(2);
    end
endtask 

if_axi      #(.DW(S_DW),.AW(S_AW),.IDSIZE(S_IW)) s_axi();
if_axi      #(.DW(M_DW),.AW(M_AW),.IDSIZE(M_IW)) m_axi();
axi_convert_datawidth #  
(
    .S_AW  (S_AW     ),
    .S_IW  (S_IW     ),
    .S_DW  (S_DW     ),
    .S_KW  (S_KW     ),
    .S_SW  (S_SW     ),
    .M_AW  (M_AW     ),
    .M_IW  (M_IW     ),
    .M_DW  (M_DW     ),
    .M_KW  (M_KW     ),
    .M_SW  (M_SW     )
)
dut
(
    //axi.clock&reset   
    .s_axi_aclk             (s_axi_aclk       ),//input    wire                           
    .s_axi_aresetn          (s_axi_aresetn    ),//input    wire                           
    .s_axi_araddr           (s_axi.araddr     ),//input    wire [AXI_ADDR_WIDTH-1:0]      
    .s_axi_arburst          (s_axi.arburst    ),//input    wire [1:0]                     
    .s_axi_arcache          (s_axi.arcache    ),//input    wire [3:0]                     
    .s_axi_arid             (s_axi.arid       ),//input    wire [AXI_ID_WIDTH-1:0]         
    .s_axi_arlen            (s_axi.arlen      ),//input    wire [7:0]                     
    .s_axi_arlock           (s_axi.arlock     ),//input    wire                           
    .s_axi_arprot           (s_axi.arprot     ),//input    wire [2:0]                     
    .s_axi_arqos            (s_axi.arqos      ),//input    wire [3:0]                     
    .s_axi_arready          (s_axi.arready    ),//output   wire                           
    .s_axi_arregion         (s_axi.arregion   ),//input    wire [3:0]                     
    .s_axi_arsize           (s_axi.arsize     ),//input    wire [AXI_ID_WIDTH-1:0]         
    .s_axi_arvalid          (s_axi.arvalid    ),//input    wire                           
    .s_axi_awaddr           (s_axi.awaddr     ),//input    wire [AXI_ADDR_WIDTH-1:0]      
    .s_axi_awburst          (s_axi.awburst    ),//input    wire [1:0]                     
    .s_axi_awcache          (s_axi.awcache    ),//input    wire [3:0]                     
    .s_axi_awid             (s_axi.awid       ),//input    wire [AXI_ID_WIDTH-1:0]         
    .s_axi_awlen            (s_axi.awlen      ),//input    wire [7:0]                     
    .s_axi_awlock           (s_axi.awlock     ),//input    wire                           
    .s_axi_awprot           (s_axi.awprot     ),//input    wire [2:0]                     
    .s_axi_awqos            (s_axi.awqos      ),//input    wire [3:0]                     
    .s_axi_awready          (s_axi.awready    ),//output   wire                           
    .s_axi_awregion         (s_axi.awregion   ),//input    wire [3:0]                     
    .s_axi_awsize           (s_axi.awsize     ),//input    wire [AXI_ID_WIDTH-1:0]         
    .s_axi_awvalid          (s_axi.awvalid    ),//input    wire                           
    .s_axi_bid              (s_axi.bid        ),//output   wire [AXI_ID_WIDTH-1:0]         
    .s_axi_bready           (s_axi.bready     ),//input    wire                           
    .s_axi_bresp            (s_axi.bresp      ),//output   wire [1:0]                     
    .s_axi_bvalid           (s_axi.bvalid     ),//output   wire                           
    .s_axi_rdata            (s_axi.rdata      ),//output   wire [AXI_DATA_WIDTH-1:0]      
    .s_axi_rid              (s_axi.rid        ),//output   wire [AXI_ID_WIDTH-1:0]         
    .s_axi_rlast            (s_axi.rlast      ),//output   wire                           
    .s_axi_rready           (s_axi.rready     ),//input    wire                           
    .s_axi_rresp            (s_axi.rresp      ),//output   wire [1:0]                     
    .s_axi_rvalid           (s_axi.rvalid     ),//output   wire                           
    .s_axi_wdata            (s_axi.wdata      ),//input    wire [AXI_DATA_WIDTH-1:0]      
    .s_axi_wlast            (s_axi.wlast      ),//input    wire                           
    .s_axi_wready           (s_axi.wready     ),//output   wire                           
    .s_axi_wstrb            (s_axi.wstrb      ),//input    wire [AXI_DATA_WIDTH/8-1:0]    
    .s_axi_wvalid           (s_axi.wvalid     ),//input    wire          
    
    //axi.clock&reset   
    .m_axi_aclk             (m_axi_aclk       ),//input    wire                           
    .m_axi_aresetn          (m_axi_aresetn    ),//input    wire                           
    .m_axi_araddr           (m_axi.araddr     ),//output   wire [AXI_ADDR_WIDTH-1:0]      
    .m_axi_arburst          (m_axi.arburst    ),//output   wire [1:0]                     
    .m_axi_arcache          (m_axi.arcache    ),//output   wire [3:0]                     
    .m_axi_arid             (m_axi.arid       ),//output   wire [AXI_ID_WIDTH-1:0]         
    .m_axi_arlen            (m_axi.arlen      ),//output   wire [7:0]                     
    .m_axi_arlock           (m_axi.arlock     ),//output   wire                           
    .m_axi_arprot           (m_axi.arprot     ),//output   wire [2:0]                     
    .m_axi_arqos            (m_axi.arqos      ),//output   wire [3:0]                     
    .m_axi_arready          (m_axi.arready    ),//input    wire                           
    .m_axi_arregion         (m_axi.arregion   ),//output   wire [3:0]                     
    .m_axi_arsize           (m_axi.arsize     ),//output   wire [AXI_ID_WIDTH-1:0]         
    .m_axi_arvalid          (m_axi.arvalid    ),//output   wire                           
    .m_axi_awaddr           (m_axi.awaddr     ),//output   wire [AXI_ADDR_WIDTH-1:0]      
    .m_axi_awburst          (m_axi.awburst    ),//output   wire [1:0]                     
    .m_axi_awcache          (m_axi.awcache    ),//output   wire [3:0]                     
    .m_axi_awid             (m_axi.awid       ),//output   wire [AXI_ID_WIDTH-1:0]         
    .m_axi_awlen            (m_axi.awlen      ),//output   wire [7:0]                     
    .m_axi_awlock           (m_axi.awlock     ),//output   wire                           
    .m_axi_awprot           (m_axi.awprot     ),//output   wire [2:0]                     
    .m_axi_awqos            (m_axi.awqos      ),//output   wire [3:0]                     
    .m_axi_awready          (m_axi.awready    ),//input    wire                           
    .m_axi_awregion         (m_axi.awregion   ),//output   wire [3:0]                     
    .m_axi_awsize           (m_axi.awsize     ),//output   wire [AXI_ID_WIDTH-1:0]         
    .m_axi_awvalid          (m_axi.awvalid    ),//output   wire                           
    .m_axi_bid              (m_axi.bid        ),//input    wire [AXI_ID_WIDTH-1:0]         
    .m_axi_bready           (m_axi.bready     ),//output   wire                           
    .m_axi_bresp            (m_axi.bresp      ),//input    wire [1:0]                     
    .m_axi_bvalid           (m_axi.bvalid     ),//input    wire                           
    .m_axi_rdata            (m_axi.rdata      ),//input    wire [AXI_DATA_WIDTH-1:0]      
    .m_axi_rid              (m_axi.rid        ),//input    wire [AXI_ID_WIDTH-1:0]         
    .m_axi_rlast            (m_axi.rlast      ),//input    wire                           
    .m_axi_rready           (m_axi.rready     ),//output   wire                           
    .m_axi_rresp            (m_axi.rresp      ),//input    wire [1:0]                     
    .m_axi_rvalid           (m_axi.rvalid     ),//input    wire                           
    .m_axi_wdata            (m_axi.wdata      ),//output   wire [AXI_DATA_WIDTH-1:0]      
    .m_axi_wlast            (m_axi.wlast      ),//output   wire                           
    .m_axi_wready           (m_axi.wready     ),//input    wire                           
    .m_axi_wstrb            (m_axi.wstrb      ),//output   wire [AXI_DATA_WIDTH/8-1:0]    
    .m_axi_wvalid           (m_axi.wvalid     ),//output   wire                            
    //ila
    .ila_clk                (s_axi_aclk       ),//input   wire                            
    .ila_rstn               (s_axi_aresetn    ) //input   wire                            
);
//init
initial begin
    s_axi.arvalid=0;
    s_axi.awvalid=0;
    s_axi.wvalid =0;
    s_axi.bready =1;
    s_axi.rready =1;

    m_axi.arready=1;
    m_axi.awready=1;
    m_axi.wready =1;
    m_axi.bvalid =0;
    m_axi.rvalid =0;
end

parameter DP=16;
//ar channel
logic[DP-1:0]                  wptr_ar=0                 ;
logic[DP-1:0]                  rptr_ar=0                 ;
logic[M_AW-1:0]                m_axi_araddr   [0:2**DP-1];   
logic[1:0]                     m_axi_arburst  [0:2**DP-1];   
logic[3:0]                     m_axi_arcache  [0:2**DP-1];   
logic[M_IW-1:0]                m_axi_arid     [0:2**DP-1];   
logic[7:0]                     m_axi_arlen    [0:2**DP-1];   
logic                          m_axi_arlock   [0:2**DP-1];   
logic[2:0]                     m_axi_arprot   [0:2**DP-1];   
logic[3:0]                     m_axi_arqos    [0:2**DP-1];   
logic[3:0]                     m_axi_arregion [0:2**DP-1];   
logic[M_SW-1:0]                m_axi_arsize   [0:2**DP-1];   
//aw channel
logic[DP-1:0]                  wptr_aw=0                 ;
logic[DP-1:0]                  rptr_aw=0                 ;
logic[M_AW-1:0]                m_axi_awaddr   [0:2**DP-1]; 
logic[1:0]                     m_axi_awburst  [0:2**DP-1]; 
logic[3:0]                     m_axi_awcache  [0:2**DP-1]; 
logic[M_IW-1:0]                m_axi_awid     [0:2**DP-1]; 
logic[7:0]                     m_axi_awlen    [0:2**DP-1]; 
logic                          m_axi_awlock   [0:2**DP-1]; 
logic[2:0]                     m_axi_awprot   [0:2**DP-1]; 
logic[3:0]                     m_axi_awqos    [0:2**DP-1]; 
logic[3:0]                     m_axi_awregion [0:2**DP-1]; 
logic[M_SW-1:0]                m_axi_awsize   [0:2**DP-1]; 
//w channel
logic[DP-1:0]                  wptr_wd=0                ;
logic[DP-1:0]                  rptr_wd=0                ;
logic[M_DW-1:0]                m_axi_wdata   [0:2**DP-1]; 
logic[M_KW-1:0]                m_axi_wstrb   [0:2**DP-1]; 
logic                          m_axi_wlast   [0:2**DP-1]; 
//r channel
logic[DP-1:0]                  wptr_rd=0                ;
logic[DP-1:0]                  rptr_rd=0                ;
logic[S_DW-1:0]                s_axi_rdata   [0:2**DP-1];
logic                          s_axi_rlast   [0:2**DP-1];
logic[2-1:0]                   s_axi_rresp   [0:2**DP-1];
logic[S_IW-1:0]                s_axi_rid     [0:2**DP-1];
//b channel
logic[DP-1:0]                  wptr_wb=0                ;
logic[DP-1:0]                  rptr_wb=0                ;
logic[S_IW-1:0]                s_axi_bid     [0:2**DP-1];
logic[1:0]                     s_axi_bresp   [0:2**DP-1];

task gen_axi_ar;
    integer byte_len ;
    byte_len=({$random()}[4:0])*S_KW;
    if(byte_len==0)byte_len=S_KW;

    s_axi.araddr      =$random()    ;m_axi_araddr   [wptr_ar]=s_axi.araddr      ; 
    s_axi.arburst     =$random()    ;m_axi_arburst  [wptr_ar]=s_axi.arburst     ; 
    s_axi.arcache     =$random()    ;m_axi_arcache  [wptr_ar]=s_axi.arcache     ; 
    s_axi.arid        =$random()    ;m_axi_arid     [wptr_ar]=s_axi.arid        ; 
    s_axi.arlen       =byte_len/S_KW-1  ;m_axi_arlen    [wptr_ar]=byte_len/M_KW-1   ; 
    s_axi.arlock      =$random()    ;m_axi_arlock   [wptr_ar]=s_axi.arlock      ; 
    s_axi.arprot      =$random()    ;m_axi_arprot   [wptr_ar]=s_axi.arprot      ; 
    s_axi.arqos       =$random()    ;m_axi_arqos    [wptr_ar]=s_axi.arqos       ; 
    s_axi.arregion    =$random()    ;m_axi_arregion [wptr_ar]=s_axi.arregion    ; 
    s_axi.arsize      =S_SW             ;m_axi_arsize   [wptr_ar]=M_SW              ; 
    wptr_ar++;
    @(posedge s_axi_aclk);
        s_axi.arvalid=1;
    while(1)begin
        @(posedge s_axi_aclk);
        if(s_axi.arready)begin
            s_axi.arvalid=0;
            break;
        end
    end
endtask
//check m_axi_ar
always@(posedge m_axi_aclk)begin
    if(m_axi.arvalid&m_axi.arready)begin
        if(m_axi.araddr  !=m_axi_araddr   [rptr_ar])my_print(1,$sformatf("err!!!m_axi.araddr   rec=%h,exp=%h",m_axi.araddr  ,m_axi_araddr   [rptr_ar]));
        if(m_axi.arburst !=m_axi_arburst  [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arburst  rec=%h,exp=%h",m_axi.arburst ,m_axi_arburst  [rptr_ar]));
        if(m_axi.arcache !=m_axi_arcache  [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arcache  rec=%h,exp=%h",m_axi.arcache ,m_axi_arcache  [rptr_ar]));
        if(m_axi.arid    !=m_axi_arid     [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arid     rec=%h,exp=%h",m_axi.arid    ,m_axi_arid     [rptr_ar]));
        if(m_axi.arlen   !=m_axi_arlen    [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arlen    rec=%h,exp=%h",m_axi.arlen   ,m_axi_arlen    [rptr_ar]));
        if(m_axi.arlock  !=m_axi_arlock   [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arlock   rec=%h,exp=%h",m_axi.arlock  ,m_axi_arlock   [rptr_ar]));
        if(m_axi.arprot  !=m_axi_arprot   [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arprot   rec=%h,exp=%h",m_axi.arprot  ,m_axi_arprot   [rptr_ar]));
        if(m_axi.arqos   !=m_axi_arqos    [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arqos    rec=%h,exp=%h",m_axi.arqos   ,m_axi_arqos    [rptr_ar]));
        if(m_axi.arregion!=m_axi_arregion [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arregion rec=%h,exp=%h",m_axi.arregion,m_axi_arregion [rptr_ar]));
        if(m_axi.arsize  !=m_axi_arsize   [rptr_ar])my_print(1,$sformatf("err!!!m_axi.arsize   rec=%h,exp=%h",m_axi.arsize  ,m_axi_arsize   [rptr_ar]));
        rptr_ar++;
    end
end

task gen_axi_aw;
    integer byte_len ;
    byte_len=({$random()}[4:0])*S_KW;
    if(byte_len==0)byte_len=S_KW;

    s_axi.awaddr      =$random()    ;m_axi_awaddr   [wptr_aw]=s_axi.awaddr      ; 
    s_axi.awburst     =$random()    ;m_axi_awburst  [wptr_aw]=s_axi.awburst     ; 
    s_axi.awcache     =$random()    ;m_axi_awcache  [wptr_aw]=s_axi.awcache     ; 
    s_axi.awid        =$random()    ;m_axi_awid     [wptr_aw]=s_axi.awid        ; 
    s_axi.awlen       =byte_len/S_KW-1  ;m_axi_awlen    [wptr_aw]=byte_len/M_KW-1   ; 
    s_axi.awlock      =$random()    ;m_axi_awlock   [wptr_aw]=s_axi.awlock      ; 
    s_axi.awprot      =$random()    ;m_axi_awprot   [wptr_aw]=s_axi.awprot      ; 
    s_axi.awqos       =$random()    ;m_axi_awqos    [wptr_aw]=s_axi.awqos       ; 
    s_axi.awregion    =$random()    ;m_axi_awregion [wptr_aw]=s_axi.awregion    ; 
    s_axi.awsize      =S_SW             ;m_axi_awsize   [wptr_aw]=M_SW              ; 
    wptr_aw++;
    @(posedge s_axi_aclk);
        s_axi.awvalid=1;
    while(1)begin
        @(posedge s_axi_aclk);
        if(s_axi.awready)begin
            s_axi.awvalid=0;
            break;
        end
    end
endtask
//check m_axi_aw
always@(posedge m_axi_aclk)begin
    if(m_axi.awvalid&m_axi.awready)begin
        if(m_axi.awaddr  !=m_axi_awaddr   [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awaddr   rec=%h,exp=%h",m_axi.awaddr  ,m_axi_awaddr   [rptr_aw]));
        if(m_axi.awburst !=m_axi_awburst  [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awburst  rec=%h,exp=%h",m_axi.awburst ,m_axi_awburst  [rptr_aw]));
        if(m_axi.awcache !=m_axi_awcache  [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awcache  rec=%h,exp=%h",m_axi.awcache ,m_axi_awcache  [rptr_aw]));
        if(m_axi.awid    !=m_axi_awid     [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awid     rec=%h,exp=%h",m_axi.awid    ,m_axi_awid     [rptr_aw]));
        if(m_axi.awlen   !=m_axi_awlen    [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awlen    rec=%h,exp=%h",m_axi.awlen   ,m_axi_awlen    [rptr_aw]));
        if(m_axi.awlock  !=m_axi_awlock   [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awlock   rec=%h,exp=%h",m_axi.awlock  ,m_axi_awlock   [rptr_aw]));
        if(m_axi.awprot  !=m_axi_awprot   [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awprot   rec=%h,exp=%h",m_axi.awprot  ,m_axi_awprot   [rptr_aw]));
        if(m_axi.awqos   !=m_axi_awqos    [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awqos    rec=%h,exp=%h",m_axi.awqos   ,m_axi_awqos    [rptr_aw]));
        if(m_axi.awregion!=m_axi_awregion [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awregion rec=%h,exp=%h",m_axi.awregion,m_axi_awregion [rptr_aw]));
        if(m_axi.awsize  !=m_axi_awsize   [rptr_aw])my_print(1,$sformatf("err!!!m_axi.awsize   rec=%h,exp=%h",m_axi.awsize  ,m_axi_awsize   [rptr_aw]));
        rptr_aw++;
    end
end

task gen_axi_wd;
    integer byte_len ,cnt;

    logic [7:0]wdata[0:1023];
    logic      wstrb[0:1023];

    byte_len=({$random()}[4:0])*S_KW;
    if(byte_len==0)byte_len=S_KW;

    for(int i=0;i<byte_len;i++)begin
        wdata[i]=$random();
        wstrb[i]=$random();
    end
    cnt=byte_len/M_KW+((byte_len%M_KW)?1:0);
    for(int i=0;i<cnt;i++)begin
        for(int j=0;j<M_KW;j++)begin
            m_axi_wdata[wptr_wd][j*8+:8]  =((i*M_KW+j)>=byte_len)?'bx:wdata[i*M_KW+j];
            m_axi_wstrb[wptr_wd][j+:1]    =((i*M_KW+j)>=byte_len)?'b0:wstrb[i*M_KW+j];
            m_axi_wlast[wptr_wd]          =i==cnt-1;
        end
        wptr_wd++;
    end
    
    cnt=0;
    while(1)begin
        @(posedge s_axi_aclk);
            if(s_axi.wvalid&s_axi.wready)cnt=cnt+S_KW;
            if(cnt>=byte_len)begin
                s_axi.wvalid=0;
                break;
            end
            else begin
                s_axi.wvalid=1;
                for(int i=0;i<S_KW;i++)begin
                    s_axi.wdata[(i%S_KW)*8+:8]  =wdata[i+cnt];
                    s_axi.wstrb[(i%S_KW)+:1]    =wstrb[i+cnt];
                    s_axi.wlast                 =(i+cnt+S_KW)>=byte_len;
                end
            end
    end
endtask
//check m_axi_w
always@(posedge m_axi_aclk)begin
    if(m_axi.wvalid&m_axi.wready)begin
        if(m_axi.wdata !=m_axi_wdata[rptr_wd])my_print(1,$sformatf("err!!!m_axi.wdata  rec=%h,exp=%h",m_axi.wdata ,m_axi_wdata[rptr_wd]));
        if(m_axi.wstrb !=m_axi_wstrb[rptr_wd])my_print(1,$sformatf("err!!!m_axi.wstrb  rec=%h,exp=%h",m_axi.wstrb ,m_axi_wstrb[rptr_wd]));
        if(m_axi.wlast !=m_axi_wlast[rptr_wd])my_print(1,$sformatf("err!!!m_axi.wlast  rec=%h,exp=%h",m_axi.wlast ,m_axi_wlast[rptr_wd]));
        rptr_wd++;
    end
end

task gen_axi_rd;
    integer byte_len ,cnt;

    logic [7     :0]rdata[0:1023];
    logic [1     :0]rresp   ;
    logic [M_IW-1:0]rid   ;

    byte_len=({$random()}[4:0])*M_KW;
    if(byte_len==0)byte_len=M_KW;

    for(int i=0;i<byte_len;i++)begin
        rdata[i]=$random();
    end
    rresp=$random();
    rid=$random();

    cnt=byte_len/S_KW+((byte_len%S_KW)?1:0);
    for(int i=0;i<cnt;i++)begin
        for(int j=0;j<S_KW;j++)begin
            s_axi_rdata[wptr_rd][j*8+:8]  =((i*S_KW+j)>=byte_len)?'bx:rdata[i*S_KW+j];
            s_axi_rresp[wptr_rd]          =rresp;
            s_axi_rid  [wptr_rd]          =rid;
            s_axi_rlast[wptr_rd]          =i==cnt-1;
        end
        wptr_rd++;
    end
    
    cnt=0;
    while(1)begin
        @(posedge m_axi_aclk);
            if(m_axi.rvalid&m_axi.rready)cnt=cnt+M_KW;
            if(cnt>=byte_len)begin
                m_axi.rvalid=0;
                break;
            end
            else begin
                m_axi.rvalid=1;
                for(int i=0;i<M_KW;i++)begin
                    m_axi.rdata[(i%M_KW)*8+:8]  =rdata[i+cnt];
                    m_axi.rresp                 =rresp;
                    m_axi.rid                   =rid;
                    m_axi.rlast                 =(i+cnt+M_KW)>=byte_len;
                end
            end
    end
endtask
//check s_axi_r
always@(posedge s_axi_aclk)begin
    if(s_axi.rvalid&s_axi.rready)begin
        if(s_axi.rdata !=s_axi_rdata[rptr_rd])my_print(1,$sformatf("err!!!s_axi.rdata  rec=%h,exp=%h",s_axi.rdata ,s_axi_rdata[rptr_rd]));
        if(s_axi.rresp !=s_axi_rresp[rptr_rd])my_print(1,$sformatf("err!!!s_axi.rresp  rec=%h,exp=%h",s_axi.rresp ,s_axi_rresp[rptr_rd]));
        if(s_axi.rid   !=s_axi_rid  [rptr_rd])my_print(1,$sformatf("err!!!s_axi.rid    rec=%h,exp=%h",s_axi.rid   ,s_axi_rid  [rptr_rd]));
        if(s_axi.rlast !=s_axi_rlast[rptr_rd])my_print(1,$sformatf("err!!!s_axi.rlast  rec=%h,exp=%h",s_axi.rlast ,s_axi_rlast[rptr_rd]));
        rptr_rd++;
    end
end

task gen_axi_wb;
    m_axi.bid         =$random()    ;s_axi_bid       [wptr_wb]=m_axi.bid       ; 
    m_axi.bresp       =$random()    ;s_axi_bresp     [wptr_wb]=m_axi.bresp     ; 
    wptr_wb++;
    @(posedge m_axi_aclk);
        m_axi.bvalid=1;
    while(1)begin
        @(posedge m_axi_aclk);
        if(m_axi.bready)begin
            m_axi.bvalid=0;
            break;
        end
    end
endtask
//check s_axi_b
always@(posedge s_axi_aclk)begin
    if(s_axi.bvalid&s_axi.bready)begin
        if(s_axi.bid    !=s_axi_bid    [rptr_wb])my_print(1,$sformatf("err!!!s_axi.bid   rec=%h,exp=%h",s_axi.bid   ,s_axi_bid    [rptr_wb]));
        if(s_axi.bresp  !=s_axi_bresp  [rptr_wb])my_print(1,$sformatf("err!!!s_axi.bresp rec=%h,exp=%h",s_axi.bresp ,s_axi_bresp  [rptr_wb]));
        rptr_wb++;
    end
end

task wait_end;
    wait(rptr_ar==wptr_ar);
    wait(rptr_aw==wptr_aw);
    wait(rptr_wd==wptr_wd);
    wait(rptr_rd==wptr_rd);
    wait(rptr_wb==wptr_wb);
endtask
task check_fifo;
    if(dut.ila_fifo_nempty      !=0    )begin my_print(1,$sformatf("ila_fifo_nempty   .err!!!"));while(1);end
    if(dut.ila_fifo_naempty     !=0    )begin my_print(1,$sformatf("ila_fifo_naempty  .err!!!"));while(1);end
    if(dut.ila_fifo_nfull       !=5'h1f)begin my_print(1,$sformatf("ila_fifo_nfull    .err!!!"));while(1);end
    if(dut.ila_fifo_nafull      !=5'h1f)begin my_print(1,$sformatf("ila_fifo_nafull   .err!!!"));while(1);end
    if(dut.ila_fifo_underflow   !=0    )begin my_print(1,$sformatf("ila_fifo_underflow.err!!!"));while(1);end
    if(dut.ila_fifo_overflow    !=0    )begin my_print(1,$sformatf("ila_fifo_overflow .err!!!"));while(1);end
endtask
endmodule