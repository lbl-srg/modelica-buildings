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
  Error error annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(sin.y, error.TSla) annotation (Line(points={{-18,30},{-10,30},{-10,11},
          {-2,11}}, color={0,0,127}));
  connect(TSlaStpt.y, error.TSlaSet) annotation (Line(points={{-18,-10},{-12,-10},
          {-12,7},{-2,7}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This validates the slab error model, ie the difference between the slab temperature and its setpoint.
</p>
</html>"),experiment(StopTime=172000.0, Tolerance=1e-06),Icon(graphics={
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
