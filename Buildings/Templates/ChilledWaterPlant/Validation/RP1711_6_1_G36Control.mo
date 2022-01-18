within Buildings.Templates.ChilledWaterPlant.Validation;
model RP1711_6_1_G36Control
  "Parallel Chillers, Variable Primary CHW, Constant CW, Headered Pumps"
  extends
    Buildings.Templates.ChilledWaterPlant.Validation.BaseWaterCooledParallel(
    redeclare Buildings.Templates.ChilledWaterPlant.Validation.UserProject.RP1711_6_1_G36Control chw);
  Controls.OBC.CDL.Continuous.Sources.Constant dpCHWRem[chw.con.nSenDpCHWRem](
    y(each final unit="Pa"),
    each k=1e4)
    "Remote DP sensors"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
equation
  connect(dpCHWRem.y, busCHW.dpCHWRem) annotation (Line(points={{68,-60},{20,-60},
          {20,60},{30,60}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end RP1711_6_1_G36Control;
