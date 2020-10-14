within Buildings.Controls.OBC.FDE.DOAS.Validation;
model erwTsim "This model simulates erwTsim"
  Buildings.Controls.OBC.FDE.DOAS.erwTsim ERWtemp
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  CDL.Continuous.Sources.Sine raTGen(
    amplitude=2,
    freqHz=1/4800,
    offset=297,
    startTime=0) "Return air temperature simulator."
    annotation (Placement(transformation(extent={{-58,-24},{-38,-4}})));
  CDL.Continuous.Sources.Sine                        oaTGen(
    amplitude=2,
    freqHz=1/4800,
    offset=288,
    startTime=0) "Outside air temperature simulator."
    annotation (Placement(transformation(extent={{-58,-58},{-38,-38}})));
  CDL.Logical.Sources.Pulse erwStartgen(width=0.6, period=2880)
    "Simulates ERW start command."
    annotation (Placement(transformation(extent={{-58,36},{-38,56}})));
  CDL.Logical.Sources.Pulse bypDamsim(width=0.5, period=2880)
    "Simulates bypass damper signal"
    annotation (Placement(transformation(extent={{-58,6},{-38,26}})));
equation
  connect(oaTGen.y, ERWtemp.oaT) annotation (Line(points={{-36,-48},{4,-48},{4,
          -6},{41.6,-6}}, color={0,0,127}));
  connect(raTGen.y, ERWtemp.raT) annotation (Line(points={{-36,-14},{0,-14},{0,
          -2},{41.6,-2}}, color={0,0,127}));
  connect(bypDamsim.y, ERWtemp.bypDam) annotation (Line(points={{-36,16},{0,16},
          {0,2},{41.6,2}}, color={255,0,255}));
  connect(erwStartgen.y, ERWtemp.erwStart) annotation (Line(points={{-36,46},{4,
          46},{4,6},{41.6,6}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 29, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.erwTsim\">
Buildings.Controls.OBC.FDE.DOAS.erwTsim</a>.
</p>
</html>"),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"));
end erwTsim;
