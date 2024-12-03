`timescale 1ns/1ps
`define CLK_MACRO(CLK,T) bit CLK; initial begin CLK = 0; forever # T CLK = ~CLK; end
`define RST_MACRO(RST,T) bit RST; initial begin RST = 1; # T; RST=0; end

module tb ;
`CLK_MACRO(s_axi_aclk,3)
`RST_MACRO(s_axi_arst,8)
`CLK_MACRO(m_axi_aclk,5)
`RST_MACRO(m_axi_arst,8)

parameter   TC_NAME="AXI_CONVERT_DATAWIDTH";
integer fptr=$fopen($sformatf("log_%s.log",TC_NAME));
integer     prt_en=1;
integer     log_en=1;
integer     err=0;

`ifdef SEED
integer     seed=`SEED;
`else
integer     seed=0;
`endif

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

bfm_axic #(.TC_NAME("DUT0"),.S_AW(64),.S_IW(12),.S_DW( 32),.M_AW(64),.M_IW(12),.M_DW(64))dut0(s_axi_aclk,~s_axi_arst,m_axi_aclk,~m_axi_arst);
bfm_axic #(.TC_NAME("DUT1"),.S_AW(64),.S_IW(12),.S_DW( 64),.M_AW(64),.M_IW(12),.M_DW(64))dut1(s_axi_aclk,~s_axi_arst,m_axi_aclk,~m_axi_arst);
bfm_axic #(.TC_NAME("DUT2"),.S_AW(64),.S_IW(12),.S_DW(128),.M_AW(64),.M_IW(12),.M_DW(64))dut2(s_axi_aclk,~s_axi_arst,m_axi_aclk,~m_axi_arst);
bfm_axic #(.TC_NAME("DUT3"),.S_AW(60),.S_IW(12),.S_DW(128),.M_AW(64),.M_IW(12),.M_DW(64))dut3(s_axi_aclk,~s_axi_arst,m_axi_aclk,~m_axi_arst);
bfm_axic #(.TC_NAME("DUT4"),.S_AW(64),.S_IW(14),.S_DW(128),.M_AW(64),.M_IW(12),.M_DW(64))dut4(s_axi_aclk,~s_axi_arst,m_axi_aclk,~m_axi_arst);
bfm_axic #(.TC_NAME("DUT5"),.S_AW(60),.S_IW(10),.S_DW(128),.M_AW(64),.M_IW(12),.M_DW(64))dut5(s_axi_aclk,~s_axi_arst,m_axi_aclk,~m_axi_arst);


initial
begin
    integer i;
    repeat(100)@(posedge s_axi_aclk);

    repeat(100)begin
        dut0.gen_axi_ar();
        dut0.gen_axi_aw();
        dut0.gen_axi_wd();
        dut0.gen_axi_rd();
        dut0.gen_axi_wb();

        dut1.gen_axi_ar();
        dut1.gen_axi_aw();
        dut1.gen_axi_wd();
        dut1.gen_axi_rd();
        dut1.gen_axi_wb();

        dut2.gen_axi_ar();
        dut2.gen_axi_aw();
        dut2.gen_axi_wd();
        dut2.gen_axi_rd();
        dut2.gen_axi_wb();

        dut3.gen_axi_ar();
        dut3.gen_axi_aw();
        dut3.gen_axi_wd();
        dut3.gen_axi_rd();
        dut3.gen_axi_wb();

        dut4.gen_axi_ar();
        dut4.gen_axi_aw();
        dut4.gen_axi_wd();
        dut4.gen_axi_rd();
        dut4.gen_axi_wb();

        dut5.gen_axi_ar();
        dut5.gen_axi_aw();
        dut5.gen_axi_wd();
        dut5.gen_axi_rd();
        dut5.gen_axi_wb();
    end

    dut0.wait_end();
    dut1.wait_end();
    dut2.wait_end();
    dut3.wait_end();
    dut4.wait_end();
    dut5.wait_end();
    repeat(100)@(posedge s_axi_aclk);
    dut0.check_fifo();
    dut1.check_fifo();
    dut2.check_fifo();
    dut3.check_fifo();
    dut4.check_fifo();
    dut5.check_fifo();
    if(err)begin my_print(1,$sformatf("tb.err!!!"));while(1);end
    my_print(0,$sformatf("pass!!!"));
    $stop(2);
end


endmodule			
