# once fully functonal and implemented:
# - remove this file from repo and copy script to the PR text
# - look for fixmes in info section of any new packages, or edit info sections of any renamed packages
#-----------------------------------------------------------------------------------------------------
import buildingspy.development.refactor as r

# This is a very sequential script, the order matters

path = "Buildings.Controls.OBC.ASHRAE.G36."


# Models

# Rename packages - change the purpose of packages [fixme: edit info section in AHU and TerminalUnit, used to be Atomic and Composite]
rve_class(path + "Composite",
             path + "TerminalUnit")
rve_class(path + "Atomic",
             path + "AHU")

# keep in mind that now all models from Atomic think that they are in AHU, etc.

# From previous Composite

rve_class(path + "TerminalUnit.EconomizerMultiZone",
             path + "AHU.Economizer.EconomizerMultiZone")
rve_class(path + "TerminalUnit.EconomizerSingleZone",
             path + "AHU.Economizer.EconomizerSingleZone")


# From previous Atomic

# To Coils
rve_class(path + "AHU.HeatingAndCoolingCoilValves",
             path + "AHU.Coils.HeatingAndCoolingCoilValves")

# To Economizer
rve_class(path + "AHU.EconDamperPositionLimitsMultiZone",
             path + "AHU.Economizer.Subsequences.EconDamperPositionLimitsMultiZone")
rve_class(path + "AHU.EconDamperPositionLimitsSingleZone",
             path + "AHU.Economizer.Subsequences.EconDamperPositionLimitsSingleZone")
rve_class(path + "AHU.EconEnableDisableMultiZone",
             path + "AHU.Economizer.Subsequences.EconEnableDisableMultiZone")
rve_class(path + "AHU.EconEnableDisableSingleZone",
             path + "AHU.Economizer.Subsequences.EconEnableDisableSingleZone")
rve_class(path + "AHU.EconModulationMultiZone",
             path + "AHU.Economizer.Subsequences.EconModulationMultiZone")
rve_class(path + "AHU.EconModulationSingleZone",
             path + "AHU.Economizer.Subsequences.EconModulationSingleZone")

# To SetPoints
rve_class(path + "AHU.OperationModeSelector", #note the model rename, as decided in the meeting. both new packages are introduced at this point
             path + "AHU.SetPoints.OperationMode")
rve_class(path + "AHU.OutdoorAirFlowSetpoint_MultiZone", #note the model rename, keep consistency
             path + "AHU.SetPoints.OutdoorAirFlowSetpointMultiZone")
rve_class(path + "AHU.OutdoorAirFlowSetpoint_SingleZone", #note the model rename, keep consistency
             path + "AHU.SetPoints.OutdoorAirFlowSetpointSingleZone")
rve_class(path + "AHU.VAVSingleZoneTSupSet", #note the model rename
             path + "AHU.SetPoints.VAVSingleZoneTSupSet")
rve_class(path + "AHU.VAVMultiZoneTSupSet", #note the model rename, as decided in the meeting.
             path + "AHU.SetPoints.VAVMultiZoneTSupSet") #note model rename
rve_class(path + "AHU.ZoneSetpoint", #note the model rename, since one needs to look into the model to figure out what kind of setpoint
             path + "AHU.SetPoints.ZoneTSet") #note model rename
rve_class(path + "AHU.TrimRespondLogic", #note the model rename, as decided in the meeting.
             path + "AHU.SetPoints.TrimAndRespond") #note model rename


# Validation Models

# From previous Composite.Validation
rve_class(path + "TerminalUnit.Validation.EconomizerMultiZone_Disable",
             path + "AHU.Economizer.Validation.EconomizerMultiZone_Disable")
rve_class(path + "TerminalUnit.Validation.EconomizerMultiZone_Mod_DamLim",
             path + "AHU.Economizer.Validation.EconomizerMultiZone_Mod_DamLim")
rve_class(path + "TerminalUnit.Validation.EconomizerSingleZone_Disable",
             path + "AHU.Economizer.Validation.EconomizerSingleZone_Disable")
rve_class(path + "TerminalUnit.Validation.EconomizerSingleZone_Mod_DamLim",
             path + "AHU.Economizer.Validation.EconomizerSingleZone_Mod_DamLim")

# From previous Atomic.Validation

# To Economizer.Subsequences.Validation
rve_class(path + "AHU.Validation.EconDamperPositionLimitsMultiZone_LoopDisable",
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsMultiZone_LoopDisable")
rve_class(path + "AHU.Validation.EconDamperPositionLimitsMultiZone_VOut_flow",
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsMultiZone_VOut_flow")
rve_class(path + "AHU.Validation.EconDamperPositionLimitsSingleZone_Disable", # note that there is no Loop in this sequence, so just Disable
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsSingleZone_Disable")
rve_class(path + "AHU.Validation.EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow",
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow")
rve_class(path + "AHU.Validation.EconEnableDisableMultiZone_FreProSta_ZonSta",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableMultiZone_FreProSta_ZonSta")
rve_class(path + "AHU.Validation.EconEnableDisableMultiZone_TOut_hOut",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableMultiZone_TOut_hOut")
rve_class(path + "AHU.Validation.EconEnableDisableSingleZone_FreProSta_ZonSta",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableSingleZone_FreProSta_ZonSta")
rve_class(path + "AHU.Validation.EconEnableDisableSingleZone_TOut_hOut",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableSingleZone_TOut_hOut")
rve_class(path + "AHU.Validation.EconModulationMultiZone_TSup",
             path + "AHU.Economizer.Subsequences.Validation.EconModulationMultiZone_TSup")
rve_class(path + "AHU.Validation.EconModulationSingleZone_TSup",
             path + "AHU.Economizer.Subsequences.Validation.EconModulationSingleZone_TSup")
rve_class(path + "AHU.Validation.HeatingAndCoolingCoilValves_TRoo",
             path + "AHU.Economizer.Subsequences.Validation.HeatingAndCoolingCoilValves_TRoo")

# To SetPoints.Validation
rve_class(path + "AHU.Validation.OperationMode", # fixme: this might need a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.OperationMode")
rve_class(path + "AHU.Validation.OutdoorAirFlowSetpoint_MultiZone", # renamed for consistency, fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.OutdoorAirFlowSetpointMultiZone")
rve_class(path + "AHU.Validation.OutdoorAirFlowSetpoint_SingleZone", # renamed for consistency, fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.OutdoorAirFlowSetpointSingleZone")
rve_class(path + "AHU.Validation.TrimRespondLogic", # renamed, fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.TrimAndRespond")
rve_class(path + "AHU.Validation.VAVMultiZoneTSupSet", #fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.VAVMultiZoneTSupSet")
rve_class(path + "AHU.Validation.VAVSingleZoneTSupSet_T",
             path + "AHU.SetPoints.Validation.VAVSingleZoneTSupSet_T")
rve_class(path + "AHU.Validation.VAVSingleZoneTSupSet_u",
             path + "AHU.SetPoints.Validation.VAVSingleZoneTSupSet_u")
rve_class(path + "AHU.Validation.ZoneSetpoint",
             path + "AHU.SetPoints.Validation.ZoneTSet") #fixme: needs a rename to indicate the control variable
