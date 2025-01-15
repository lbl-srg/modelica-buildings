within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Validation;
model Enable
  "Validation sequence for enabling and disabling chiller plant"

  parameter Real aveTWetBul(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
      "Chilled water supply set temperature";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable
    disPlaSch(
    final schTab=[0,0;
                  10*60,1;
                  19*3600,0;
                  24*3600,0],
    ignReq=1)
    "Disable plant without waterside economizer, due to schedule"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable
    disPlaReq(
    final schTab=[0,0;
                  6*3600,1;
                  19*3600,0;
                  24*3600,0],
    ignReq=1)
    "Disable plant without waterside economizer, due to lack of request"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable
    disPlaOutTem(final schTab=[0,0; 1*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to low outdoor temperature"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=3)
    "Chiller plant requests above the number of ignored requests"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOutTem(
    final k=293.15) "Constant outdoor temperature above lockout"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable chiPlaReq2(
    final table=[0,1;
                 6.5*3600,1;
                 9*3600,2;
                 9*3600 + 600,0;
                 19*3600,0;
                 24*3600,1],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conOutTem1(
    final k=282.15)
    "Constant outdoor temperature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable chiPlaReq3(
    final table=[0,1;
                 6.5*3600,1;
                 9*3600,2;
                 14*3600,3;
                 19*3600,3;
                 24*3600,1],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin outTem1(
    final amplitude=7.5,
    final freqHz=1/(24*3600),
    final offset=275.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));

equation
  connect(conOutTem.y, disPlaSch.TOut)
    annotation (Line(points={{2,70},{24,70},{24,95.8},{38,95.8}}, color={0,0,127}));
  connect(chiPlaReq2.y[1], reaToInt2.u)
    annotation (Line(points={{-38,10},{-22,10}}, color={0,0,127}));
  connect(reaToInt2.y, disPlaReq.chiPlaReq) annotation (Line(points={{2,10},{20,
          10},{20,14},{38,14}}, color={255,127,0}));
  connect(conOutTem1.y, disPlaReq.TOut)
    annotation (Line(points={{2,-20},{24,-20},{24,5.8},{38,5.8}}, color={0,0,127}));
  connect(chiPlaReq3.y[1], reaToInt3.u)
    annotation (Line(points={{-38,-70},{-22,-70}}, color={0,0,127}));
  connect(reaToInt3.y, disPlaOutTem.chiPlaReq) annotation (Line(points={{2,-70},
          {20,-70},{20,-66},{38,-66}}, color={255,127,0}));
  connect(outTem1.y, disPlaOutTem.TOut)
    annotation (Line(points={{2,-100},{24,-100},{24,-74.2},{38,-74.2}}, color={0,0,127}));
  connect(conInt.y, disPlaSch.chiPlaReq) annotation (Line(points={{2,110},{20,
          110},{20,104},{38,104}}, color={255,127,0}));
annotation (
  experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/PlantEnable/Validation/Enable.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable.Enable</a>.
It shows different conditions to enable and disable the plant.
</p>
<ul>
<li>
For instance <code>disPlaReq</code>, the input <code>chiPlaReq</code> becomes
greater than the ignorable request <code>ignReq</code> at 32400 seconds and
becomes less than the ignorable request at 33000 seconds. The plant is enabled
at 32400 seconds, but becomes disabled at 33300 seconds. It allows the plant
being enabled for 15 minutes and then becomes disabled.
</li>
<li>
For instance <code>disPlaOutTem</code>, the input <code>TOut</code> becomes
greater than the lockout temperature <code>TChiLocOut</code> at 4382.seconds.
The plant becomes enabled. At 39877.7 seconds, the input <code>TOut</code>
becomes lower than the lockeout temperature <code>TChiLocOut</code> by 0.556
&deg;C. The plant becomes disabled.
</li>
<li>
For instance <code>disPlaSch</code>, the chiller enabing schedule specifies
that the plant should be enabled at 600 seconds. However, the plant becomes
enabled at 900 seconds as it allows the plant being disabled for 15 minutes.
The plant becomes disabled at 68400 seconds, which is specified as in the
plant scheduling.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 12, 2020, by Milica Grahovac:<br/>
Removed tests related to initial stage determination. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1831\">issue 1831</a>.
Updated tests to include schedule based reference results.
</li>
<li>
March 20, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}}),
        graphics={
        Text(
          extent={{40,90},{106,74}},
          textColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Disable plant 
due to inactive schedule"),
        Text(
          extent={{40,0},{98,-12}},
          textColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Disable plant 
due to zero request"),
        Text(
          extent={{40,-82},{120,-96}},
          textColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Disable plant 
due to low outdoor temperature")}));
end Enable;
