within Buildings.Controls.OBC.RooftopUnits.CompressorDR.Validation;
model CompressorDR "Validation model for CompressorDR"

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDR(
    final k1=0.9,
    final k2=0.85,
    final k3=0.8)
    "Regulate compressor speed for demand response"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul(
    final amplitude=-1,
    final period=1800,
    final offset=1)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-92,20},{-72,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conComSpe(
    final k=1)
    "Constant real signal"
    annotation (Placement(transformation(extent={{-92,60},{-72,80}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDR1(
    final k1=0.9,
    final k2=0.85,
    final k3=0.8)
    "Regulate compressor speed for demand response"
    annotation (Placement(transformation(extent={{70,40},{90,60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul1(
    final amplitude=-1,
    final period=1800,
    final offset=2)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{8,20},{28,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conComSpe1(
    final k=1)
    "Constant real signal"
    annotation (Placement(transformation(extent={{8,60},{28,80}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDR2(
    final k1=0.9,
    final k2=0.85,
    final k3=0.8)
    "Regulate compressor speed for demand response"
    annotation (Placement(transformation(extent={{-28,-60},{-8,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul2(
    final amplitude=-1,
    final period=1800,
    final offset=3)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conComSpe2(
    final k=1)
    "Constant real signal"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));

  Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR ComSpeDR3(
    final k1=0.9,
    final k2=0.85,
    final k3=0.8)
    "Regulate compressor speed for demand response"
    annotation (Placement(transformation(extent={{70,-60},{90,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse intPul3(
    final amplitude=2,
    final period=1800,
    final offset=1)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{8,-80},{28,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conComSpe3(
    final k=1)
    "Constant real signal"
    annotation (Placement(transformation(extent={{8,-40},{28,-20}})));

equation
  connect(intPul.y, ComSpeDR.uDemLimLev) annotation (Line(points={{-70,30},{-52,
          30},{-52,44},{-32,44}},
                           color={255,127,0}));
  connect(conComSpe.y, ComSpeDR.uComSpe) annotation (Line(points={{-70,70},{-52,
          70},{-52,56},{-32,56}},
                           color={0,0,127}));
  connect(intPul1.y, ComSpeDR1.uDemLimLev) annotation (Line(points={{30,30},{48,
          30},{48,44},{68,44}},      color={255,127,0}));
  connect(conComSpe1.y, ComSpeDR1.uComSpe) annotation (Line(points={{30,70},{48,
          70},{48,56},{68,56}},      color={0,0,127}));
  connect(intPul2.y, ComSpeDR2.uDemLimLev) annotation (Line(points={{-68,-70},{-50,
          -70},{-50,-56},{-30,-56}},
                                   color={255,127,0}));
  connect(conComSpe2.y, ComSpeDR2.uComSpe) annotation (Line(points={{-68,-30},{-50,
          -30},{-50,-44},{-30,-44}},
                                   color={0,0,127}));

  connect(intPul3.y,ComSpeDR3. uDemLimLev) annotation (Line(points={{30,-70},{48,
          -70},{48,-56},{68,-56}}, color={255,127,0}));
  connect(conComSpe3.y,ComSpeDR3. uComSpe) annotation (Line(points={{30,-30},{48,
          -30},{48,-44},{68,-44}}, color={0,0,127}));
annotation (
    experiment(StopTime=3600, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/CompressorDR/Validation/CompressorDR.mos"
        "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR\">
    Buildings.Controls.OBC.RooftopUnits.CompressorDR.CompressorDR</a>. 
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    July 27, 2023, by Junke Wang and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end CompressorDR;
