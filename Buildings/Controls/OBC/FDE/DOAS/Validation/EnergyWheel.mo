within Buildings.Controls.OBC.FDE.DOAS.Validation;
model EnergyWheel "This model simulates EnergyWheel."


  parameter Real recSet(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=7
   "Energy recovery set point.";
  parameter Real recSetDelay(
    final unit="s",
    final quantity="Time")=300
    "Minimum delay after OAT/RAT delta falls below set point.";
  parameter Real kGain(
    final unit="1")=0.00001
    "PID loop gain value.";
  parameter Real conTi(
    final unit="s")=0.00025
    "PID time constant of integrator.";

  Buildings.Controls.OBC.FDE.DOAS.EnergyWheel ERWcon
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse SFproof(
    width=0.75,
    period=5760)
      annotation (Placement(transformation(extent={{-62,72},{-42,92}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoMode(
    width=0.5,
    period=2880)
      annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  CDL.Continuous.Sources.Sine                        oaTGen(
    amplitude=2,
    freqHz=1/4800,
    offset=288,
    startTime=0)
    annotation (Placement(transformation(extent={{-62,-26},{-42,-6}})));
  CDL.Continuous.Sources.Sine raTGen(
    amplitude=2,
    freqHz=1/4800,
    offset=297,
    startTime=0)
    annotation (Placement(transformation(extent={{-62,8},{-42,28}})));
  CDL.Continuous.Sources.Sine                        erwTGen(
    amplitude=6,
    freqHz=1/2100,
    offset=294,
    startTime=12)
    annotation (Placement(transformation(extent={{-62,-58},{-42,-38}})));
  CDL.Continuous.Sources.Sine supPrimGen(
    amplitude=2,
    freqHz=1/3100,
    offset=295,
    startTime=12)
    annotation (Placement(transformation(extent={{-62,-90},{-42,-70}})));
equation
  connect(SFproof.y, ERWcon.supFanProof) annotation (Line(points={{-40,82},{4,82},
          {4,7.8},{47.8,7.8}}, color={255,0,255}));
  connect(ecoMode.y, ERWcon.ecoMode) annotation (Line(points={{-40,50},{0,50},{0,
          4.8},{47.8,4.8}}, color={255,0,255}));
  connect(raTGen.y, ERWcon.raT) annotation (Line(points={{-40,18},{-4,18},{-4,
          1.8},{47.8,1.8}}, color={0,0,127}));
  connect(oaTGen.y, ERWcon.oaT) annotation (Line(points={{-40,-16},{-4,-16},{-4,
          -1.8},{47.8,-1.8}}, color={0,0,127}));
  connect(erwTGen.y, ERWcon.erwT) annotation (Line(points={{-40,-48},{0,-48},{0,
          -4.8},{47.8,-4.8}}, color={0,0,127}));
  connect(supPrimGen.y, ERWcon.supPrimSP) annotation (Line(points={{-40,-80},{4,
          -80},{4,-7.8},{47.8,-7.8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>
September 16, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.EnergyWheel\">
Buildings.Controls.OBC.FDE.DOAS.EnergyWheel</a>.
</p>
</html>"));
end EnergyWheel;
