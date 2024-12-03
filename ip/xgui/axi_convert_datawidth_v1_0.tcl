# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "M_AW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_DW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_IW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_KW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "M_SW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_AW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_DW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_IW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_KW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_SW" -parent ${Page_0}
  ipgui::add_param $IPINST -name "U_DLY" -parent ${Page_0}


}

proc update_PARAM_VALUE.M_AW { PARAM_VALUE.M_AW } {
	# Procedure called to update M_AW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AW { PARAM_VALUE.M_AW } {
	# Procedure called to validate M_AW
	return true
}

proc update_PARAM_VALUE.M_DW { PARAM_VALUE.M_DW } {
	# Procedure called to update M_DW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_DW { PARAM_VALUE.M_DW } {
	# Procedure called to validate M_DW
	return true
}

proc update_PARAM_VALUE.M_IW { PARAM_VALUE.M_IW } {
	# Procedure called to update M_IW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_IW { PARAM_VALUE.M_IW } {
	# Procedure called to validate M_IW
	return true
}

proc update_PARAM_VALUE.M_KW { PARAM_VALUE.M_KW } {
	# Procedure called to update M_KW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_KW { PARAM_VALUE.M_KW } {
	# Procedure called to validate M_KW
	return true
}

proc update_PARAM_VALUE.M_SW { PARAM_VALUE.M_SW } {
	# Procedure called to update M_SW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_SW { PARAM_VALUE.M_SW } {
	# Procedure called to validate M_SW
	return true
}

proc update_PARAM_VALUE.S_AW { PARAM_VALUE.S_AW } {
	# Procedure called to update S_AW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AW { PARAM_VALUE.S_AW } {
	# Procedure called to validate S_AW
	return true
}

proc update_PARAM_VALUE.S_DW { PARAM_VALUE.S_DW } {
	# Procedure called to update S_DW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_DW { PARAM_VALUE.S_DW } {
	# Procedure called to validate S_DW
	return true
}

proc update_PARAM_VALUE.S_IW { PARAM_VALUE.S_IW } {
	# Procedure called to update S_IW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_IW { PARAM_VALUE.S_IW } {
	# Procedure called to validate S_IW
	return true
}

proc update_PARAM_VALUE.S_KW { PARAM_VALUE.S_KW } {
	# Procedure called to update S_KW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_KW { PARAM_VALUE.S_KW } {
	# Procedure called to validate S_KW
	return true
}

proc update_PARAM_VALUE.S_SW { PARAM_VALUE.S_SW } {
	# Procedure called to update S_SW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_SW { PARAM_VALUE.S_SW } {
	# Procedure called to validate S_SW
	return true
}

proc update_PARAM_VALUE.U_DLY { PARAM_VALUE.U_DLY } {
	# Procedure called to update U_DLY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.U_DLY { PARAM_VALUE.U_DLY } {
	# Procedure called to validate U_DLY
	return true
}


proc update_MODELPARAM_VALUE.U_DLY { MODELPARAM_VALUE.U_DLY PARAM_VALUE.U_DLY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.U_DLY}] ${MODELPARAM_VALUE.U_DLY}
}

proc update_MODELPARAM_VALUE.S_AW { MODELPARAM_VALUE.S_AW PARAM_VALUE.S_AW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_AW}] ${MODELPARAM_VALUE.S_AW}
}

proc update_MODELPARAM_VALUE.S_IW { MODELPARAM_VALUE.S_IW PARAM_VALUE.S_IW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_IW}] ${MODELPARAM_VALUE.S_IW}
}

proc update_MODELPARAM_VALUE.S_DW { MODELPARAM_VALUE.S_DW PARAM_VALUE.S_DW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_DW}] ${MODELPARAM_VALUE.S_DW}
}

proc update_MODELPARAM_VALUE.S_KW { MODELPARAM_VALUE.S_KW PARAM_VALUE.S_KW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_KW}] ${MODELPARAM_VALUE.S_KW}
}

proc update_MODELPARAM_VALUE.S_SW { MODELPARAM_VALUE.S_SW PARAM_VALUE.S_SW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_SW}] ${MODELPARAM_VALUE.S_SW}
}

proc update_MODELPARAM_VALUE.M_AW { MODELPARAM_VALUE.M_AW PARAM_VALUE.M_AW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_AW}] ${MODELPARAM_VALUE.M_AW}
}

proc update_MODELPARAM_VALUE.M_IW { MODELPARAM_VALUE.M_IW PARAM_VALUE.M_IW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_IW}] ${MODELPARAM_VALUE.M_IW}
}

proc update_MODELPARAM_VALUE.M_DW { MODELPARAM_VALUE.M_DW PARAM_VALUE.M_DW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_DW}] ${MODELPARAM_VALUE.M_DW}
}

proc update_MODELPARAM_VALUE.M_KW { MODELPARAM_VALUE.M_KW PARAM_VALUE.M_KW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_KW}] ${MODELPARAM_VALUE.M_KW}
}

proc update_MODELPARAM_VALUE.M_SW { MODELPARAM_VALUE.M_SW PARAM_VALUE.M_SW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_SW}] ${MODELPARAM_VALUE.M_SW}
}

