within Buildings.Templates.Plants.Chillers.Components.Controls;
block ControllerG36Debug
  extends Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller(
    dpChiWat_local(final unit="Pa"));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_dTLifMax(k=max(
        TConWatRet_nominal - TChiWatSupMin)) "Maximum chiller lift"
    annotation (Placement(transformation(extent={{-1020,-50},{-1000,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant FIXME_dTLifMin(k=minChiLif)
    "Minimum chiller lift"
    annotation (Placement(transformation(extent={{-1020,-10},{-1000,10}})));
equation
  // FIXME Missing connect statements
  connect(FIXME_dTLifMax.y, staSetCon.uLifMax);
  connect(FIXME_dTLifMin.y, staSetCon.uLifMin);
end ControllerG36Debug;
