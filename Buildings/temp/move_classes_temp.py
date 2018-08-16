import buildingspy.development.refactor as r

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Controller",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller");
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Economizers",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers");
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints");
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.Validation",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Validation");
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers");
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints");

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.VAVSupplyFan", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan")
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.VAVSupplySignals", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals")
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.VAVSupplyTemperature", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature")

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.VAVSupplyFan", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.SupplyFan")
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.VAVSupplyTemperature", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.SupplyTemperature")
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.Valve", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.SupplySignals_Valve")

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.VAVSupply", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply")

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation.VAVSupply_T", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation.Supply_T")
r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation.VAVSupply_u", \
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Validation.Supply_u")

# add all renamed validation models (any starting with VAV, valve should be SupplySignal_valve)
