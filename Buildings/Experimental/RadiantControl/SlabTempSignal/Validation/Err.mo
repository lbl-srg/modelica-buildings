within Buildings.Experimental.RadiantControl.SlabTempSignal.Validation;
model Err "Validation model for slab temperature error block"

    final parameter Real TSlabStpt(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=294.3;
  Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=TSlabStpt/5,
    freqHz=1/86400,
    phase(displayUnit="rad"),
    offset=TSlabStpt)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSlaStpt(k=TSlabStpt)
    "Temperature above high limit"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Error error annotation (Placement(transformation(extent={{6,4},{26,24}})));
equation
  connect(sin.y, error.TSla) annotation (Line(points={{-18,30},{-10,30},{-10,15},
          {4,15}},  color={0,0,127}));
  connect(TSlaStpt.y, error.TSlaSet) annotation (Line(points={{-18,-10},{-12,
          -10},{-12,11},{4,11}},
                           color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This validates the slab error model, ie the difference between the slab temperature and its setpoint.
</p>
</html>"),experiment(StartTime=0.0, StopTime=172000.0, Tolerance=1e-06),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/RadiantControl/SlabTempSignal/Validation/Err.mos"
        "Simulate and plot"),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Err;
