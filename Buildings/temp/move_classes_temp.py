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

r.move_class("Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.Valve",
             "Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.Validation.VAVSupplyTemperature_Valve");

# add all renamed validation models (any starting with VAV, valve should be SupplySignal_valve)
