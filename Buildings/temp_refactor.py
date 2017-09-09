# once fully functonal and implemented:
# - remove this file from repo and copy script to the PR text
# - look for fixmes in info section of any new packages, or edit info sections of any renamed packages
#-----------------------------------------------------------------------------------------------------
import buildingspy.development.refactor as r

# This is a very sequential script, the order matters

path = "Buildings.Controls.OBC.ASHRAE.G36."


# Models

# Rename packages - change the purpose of packages [fixme: edit info section in AHU and TerminalUnit, used to be Atomic and Composite]
r.move_class(path + "Composite",
             path + "TerminalUnit")
r.move_class(path + "Atomic",
             path + "AHU")

# keep in mind that now all models from Atomic think that they are in AHU, etc.

# From previous Composite

r.move_class(path + "TerminalUnit.EconomizerMultiZone",
             path + "AHU.Economizer.EconomizerMultiZone")
r.move_class(path + "TerminalUnit.EconomizerSingleZone",
             path + "AHU.Economizer.EconomizerSingleZone")


# From previous Atomic

# To Coils
r.move_class(path + "AHU.HeatingAndCoolingCoilValves",
             path + "AHU.Coils.HeatingAndCoolingCoilValves")

# To Economizer
r.move_class(path + "AHU.EconDamperPositionLimitsMultiZone",
             path + "AHU.Economizer.Subsequences.EconDamperPositionLimitsMultiZone")
r.move_class(path + "AHU.EconDamperPositionLimitsSingleZone",
             path + "AHU.Economizer.Subsequences.EconDamperPositionLimitsSingleZone")
r.move_class(path + "AHU.EconEnableDisableMultiZone",
             path + "AHU.Economizer.Subsequences.EconEnableDisableMultiZone")
r.move_class(path + "AHU.EconEnableDisableSingleZone",
             path + "AHU.Economizer.Subsequences.EconEnableDisableSingleZone")
r.move_class(path + "AHU.EconModulationMultiZone",
             path + "AHU.Economizer.Subsequences.EconModulationMultiZone")
r.move_class(path + "AHU.EconModulationSingleZone",
             path + "AHU.Economizer.Subsequences.EconModulationSingleZone")

# To SetPoints
r.move_class(path + "AHU.OperationModeSelector", #note the model rename, as decided in the meeting. both new packages are introduced at this point
             path + "AHU.SetPoints.OperationMode")
r.move_class(path + "AHU.OutdoorAirFlowSetpoint_MultiZone", #note the model rename, keep consistency
             path + "AHU.SetPoints.OutdoorAirFlowSetpointMultiZone")
r.move_class(path + "AHU.OutdoorAirFlowSetpoint_SingleZone", #note the model rename, keep consistency
             path + "AHU.SetPoints.OutdoorAirFlowSetpointSingleZone")
r.move_class(path + "AHU.VAVSingleZoneTSupSet", #note the model rename
             path + "AHU.SetPoints.VAVSingleZoneTSupSet")
r.move_class(path + "AHU.VAVMultiZoneTSupSet", #note the model rename, as decided in the meeting.
             path + "AHU.SetPoints.VAVMultiZoneTSupSet") #note model rename
r.move_class(path + "AHU.ZoneSetpoint", #note the model rename, since one needs to look into the model to figure out what kind of setpoint
             path + "AHU.SetPoints.ZoneTSet") #note model rename
r.move_class(path + "AHU.TrimRespondLogic", #note the model rename, as decided in the meeting.
             path + "AHU.SetPoints.TrimAndRespond") #note model rename


# Validation Models

# From previous Composite.Validation
r.move_class(path + "TerminalUnit.Validation.EconomizerMultiZone_Disable",
             path + "AHU.Economizer.Validation.EconomizerMultiZone_Disable")
r.move_class(path + "TerminalUnit.Validation.EconomizerMultiZone_Mod_DamLim",
             path + "AHU.Economizer.Validation.EconomizerMultiZone_Mod_DamLim")
r.move_class(path + "TerminalUnit.Validation.EconomizerSingleZone_Disable",
             path + "AHU.Economizer.Validation.EconomizerSingleZone_Disable")
r.move_class(path + "TerminalUnit.Validation.EconomizerSingleZone_Mod_DamLim",
             path + "AHU.Economizer.Validation.EconomizerSingleZone_Mod_DamLim")

# From previous Atomic.Validation

# To Economizer.Subsequences.Validation
r.move_class(path + "AHU.Validation.EconDamperPositionLimitsMultiZone_LoopDisable",
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsMultiZone_LoopDisable")
r.move_class(path + "AHU.Validation.EconDamperPositionLimitsMultiZone_VOut_flow",
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsMultiZone_VOut_flow")
r.move_class(path + "AHU.Validation.EconDamperPositionLimitsSingleZone_Disable", # note that there is no Loop in this sequence, so just Disable
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsSingleZone_Disable")
r.move_class(path + "AHU.Validation.EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow",
             path + "AHU.Economizer.Subsequences.Validation.EconDamperPositionLimitsSingleZone_FanSpe_VOut_flow")
r.move_class(path + "AHU.Validation.EconEnableDisableMultiZone_FreProSta_ZonSta",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableMultiZone_FreProSta_ZonSta")
r.move_class(path + "AHU.Validation.EconEnableDisableMultiZone_TOut_hOut",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableMultiZone_TOut_hOut")
r.move_class(path + "AHU.Validation.EconEnableDisableSingleZone_FreProSta_ZonSta",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableSingleZone_FreProSta_ZonSta")
r.move_class(path + "AHU.Validation.EconEnableDisableSingleZone_TOut_hOut",
             path + "AHU.Economizer.Subsequences.Validation.EconEnableDisableSingleZone_TOut_hOut")
r.move_class(path + "AHU.Validation.EconModulationMultiZone_TSup",
             path + "AHU.Economizer.Subsequences.Validation.EconModulationMultiZone_TSup")
r.move_class(path + "AHU.Validation.EconModulationSingleZone_TSup",
             path + "AHU.Economizer.Subsequences.Validation.EconModulationSingleZone_TSup")
r.move_class(path + "AHU.Validation.HeatingAndCoolingCoilValves_TRoo",
             path + "AHU.Economizer.Subsequences.Validation.HeatingAndCoolingCoilValves_TRoo")

# To SetPoints.Validation
r.move_class(path + "AHU.Validation.OperationMode", # fixme: this might need a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.OperationMode")
r.move_class(path + "AHU.Validation.OutdoorAirFlowSetpoint_MultiZone", # renamed for consistency, fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.OutdoorAirFlowSetpointMultiZone")
r.move_class(path + "AHU.Validation.OutdoorAirFlowSetpoint_SingleZone", # renamed for consistency, fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.OutdoorAirFlowSetpointSingleZone")
r.move_class(path + "AHU.Validation.TrimRespondLogic", # renamed, fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.TrimAndRespond")
r.move_class(path + "AHU.Validation.VAVMultiZoneTSupSet", #fixme: needs a rename to indicate the control variable
             path + "AHU.SetPoints.Validation.VAVMultiZoneTSupSet")
r.move_class(path + "AHU.Validation.VAVSingleZoneTSupSet_T",
             path + "AHU.SetPoints.Validation.VAVSingleZoneTSupSet_T")
r.move_class(path + "AHU.Validation.VAVSingleZoneTSupSet_u",
             path + "AHU.SetPoints.Validation.VAVSingleZoneTSupSet_u")
r.move_class(path + "AHU.Validation.ZoneSetpoint",
             path + "AHU.SetPoints.Validation.ZoneTSet") #fixme: needs a rename to indicate the control variable
