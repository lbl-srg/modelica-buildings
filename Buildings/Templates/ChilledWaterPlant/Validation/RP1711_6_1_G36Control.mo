within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_1_G36Control
  "Parallel Chillers, Variable Primary Chilled Water, Constant Condenser Water, Headered Pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Validation.BaseWaterCooled(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_1_G36Control chw);

  Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatRem[chw.con.nSenDpChiWatRem](
    y(each final unit="Pa"),
    each k=1e4)
    "Remote DP sensors"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

equation
  connect(dpChiWatRem.y, bus.dpChiWatRem) annotation (Line(points={{2,60},{20,60},
          {20,60},{30,60}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_1_G36Control;
