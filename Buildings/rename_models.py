# rename script for chiller plant control 
# mig, June 2020

import buildingspy.development.refactor ar r

r.move_class("Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController",
	     "Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Controller")





# variable name renames

Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController
ySta : yStaSet

Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Up
y : yUp

Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Down
y : yDow


