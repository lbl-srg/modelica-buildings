# once fully functonal and implemented, remove file from repo and copy script to the PR text
import buildingspy.development.refactor as r

# This is a very sequential script

path = "Buildings.Controls.OBC.ASHRAE.G36."

# Rename packages - change the purpose of packages [fixme: edit info section in AHU and TerminalUnit, used to be Atomic and Composite]
r.move_class(path + "Composite",
             path + "TerminalUnit")
r.move_class(path + "Atomic",
             path + "AHU")

# keep in mind that now all models from Atomic think that they are in AHU, etc.

# To previous Composite
r.move_class(path + "TerminalUnit.EconomizerMultiZone",
             path + "AHU.Economizer.EconomizerMultiZone")
r.move_class(path + "TerminalUnit.EconomizerSingleZone",
             path + "AHU.Economizer.EconomizerMultiZone")

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
r.move_class(path + "AHU.VAVSingleZoneTSupSet", #note the model rename
             path + "AHU.SetPoints.VAVSingleZoneTSupSet")
r.move_class(path + "AHU.VAVSingleZoneTSupSet", #note the model rename
             path + "AHU.SetPoints.VAVSingleZoneTSupSet")
r.move_class(path + "AHU.ZoneSetpoint", #note the model rename, since one needs to look into the model to figure out what kind of setpoint
             path + "AHU.SetPoints.ZoneTSet") #note model rename
r.move_class(path + "AHU.TrimRespondLogic", #note the model rename, as decided in the meeting.
             path + "AHU.SetPoints.TrimAndRespond") #note model rename








# Info:
# Move validation tests
# r.move_class(“Buildings.Controls.OBC.CDL.Logical.Validation.Greater”,
#              “Buildings.Controls.OBC.CDL.Continuous.Validation.Greater”)
