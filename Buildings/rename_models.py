# rename script for chiller plant control 
# mig, June 2020

import buildingspy.development.refactor ar r

r.move_class("Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController",
	     "Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Controller")
