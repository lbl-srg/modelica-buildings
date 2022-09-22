within Buildings.Templates.ChilledWaterPlants.Validation;
model A14_G36Control
  "Parallel chillers, variable primary, constant speed CW pumps, headered pumps"
  extends Buildings.Templates.ChilledWaterPlants.Validation.Base(redeclare
      Buildings.Templates.ChilledWaterPlants.Validation.UserProject.A14_G36Control
      CHI);

  Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatRem[CHI.ctr.nSenDpChiWatRem](
     y(each final unit="Pa"), each k=1e4) "Remote DP sensors"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

equation
  connect(dpChiWatRem.y, bus.dpChiWatRem) annotation (Line(points={{2,60},{20,
          60},{20,40},{30,40}},
                            color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end A14_G36Control;
