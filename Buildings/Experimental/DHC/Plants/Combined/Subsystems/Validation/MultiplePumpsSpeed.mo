within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model MultiplePumpsSpeed
  "Validation of the multiple pumps model with speed-controlled pump model"
  extends BaseClasses.MultiplePumps;

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp spe(duration=500)
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
equation
  connect(spe.y, pum.y) annotation (Line(points={{-98,40},{-40,40},{-40,64},{
          -12,64}}, color={0,0,127}));
  connect(spe.y, inp1.u1)
    annotation (Line(points={{-98,40},{114,40},{114,14}}, color={0,0,127}));
  connect(spe.y, inp2.u1) annotation (Line(points={{-98,40},{100,40},{100,-26},
          {114,-26},{114,-30}}, color={0,0,127}));
  connect(inp1.y, pum1.y) annotation (Line(points={{120,-10},{120,-20},{0,-20},
          {0,-28}}, color={0,0,127}));
  connect(inp2.y, pum2.y) annotation (Line(points={{120,-54},{120,-60},{0,-60},
          {0,-68}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/MultiplePumpsSpeed.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end MultiplePumpsSpeed;
