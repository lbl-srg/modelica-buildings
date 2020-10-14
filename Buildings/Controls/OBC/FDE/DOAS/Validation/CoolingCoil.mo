within Buildings.Controls.OBC.FDE.DOAS.Validation;
model CoolingCoil "This model simulates CoolingCoil"

  parameter Real erwDPadj(
   final unit="K",
   final displayUnit="degC",
   final quantity="ThermodynamicTemperature")=5
   "Value subtracted from ERW supply air dewpoint.";

  Buildings.Controls.OBC.FDE.DOAS.CoolingCoil Cooling(erwDPadj=278.15)
    annotation (Placement(transformation(extent={{48,-24},{68,-4}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse SFproof(
    width=0.8,
    period=5760,
    startTime=300)
      annotation (Placement(transformation(extent={{-62,60},{-42,80}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine saTGen(
    amplitude=3,
    freqHz=1/4800,
    phase=0.87266462599716,
    offset=295,
    startTime=0)
    annotation (Placement(transformation(extent={{-26,40},{-6,60}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ccTGen(
    amplitude=3,
    freqHz=1/4800,
    phase=0,
    offset=293,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,-28},{-40,-8}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse dehumMode(
    width=0.5,
    period=4700,
    startTime=1000)
    annotation (Placement(transformation(extent={{-26,-6},{-6,14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine supCooGen(
    amplitude=2,
    freqHz=1/3100,
    offset=293,
    startTime=12)
    annotation (Placement(transformation(extent={{-62,16},{-42,36}})));
   Buildings.Controls.OBC.CDL.Continuous.Sources.Sine erwTGen(
    amplitude=3,
    freqHz=1/4800,
    phase=0,
    offset=294,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,-66},{-40,-46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine erwHumGen(
    amplitude=10,
    freqHz=1/3600,
    offset=60,
    startTime=1250)
      annotation (Placement(transformation(extent={{-26,-48},{-6,-28}})));
equation
  connect(SFproof.y, Cooling.supFanProof) annotation (Line(points={{-40,70},{18,
          70},{18,-5.6},{45.8,-5.6}}, color={255,0,255}));
  connect(saTGen.y, Cooling.saT) annotation (Line(points={{-4,50},{12,50},{12,
          -8.4},{45.8,-8.4}},
                        color={0,0,127}));
  connect(ccTGen.y, Cooling.ccT) annotation (Line(points={{-38,-18},{14,-18},{14,
          -17.2},{45.8,-17.2}}, color={0,0,127}));
  connect(dehumMode.y, Cooling.dehumMode) annotation (Line(points={{-4,4},{0,4},
          {0,-14.6},{45.8,-14.6}}, color={255,0,255}));
  connect(supCooGen.y, Cooling.supCooSP) annotation (Line(points={{-40,26},{6,26},
          {6,-11.2},{45.8,-11.2}}, color={0,0,127}));
  connect(erwHumGen.y, Cooling.erwHum) annotation (Line(points={{-4,-38},{14,
          -38},{14,-19.8},{45.8,-19.8}},
                                    color={0,0,127}));
  connect(erwTGen.y, Cooling.erwT) annotation (Line(points={{-38,-56},{18,-56},{
          18,-22.4},{45.8,-22.4}}, color={0,0,127}));
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
September 17, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.FDE.DOAS.CoolingCoil\">
Buildings.Controls.OBC.FDE.DOAS.CoolingCoil</a>.
</p>
</html>"),
    experiment(StopTime=5760, __Dymola_Algorithm="Dassl"));
end CoolingCoil;
