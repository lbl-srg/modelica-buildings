within Buildings.Controls.OBC.Facade.Validation;
model ShadingEnable_Schedule_T_Irr
  "Validation model for deployment of facade control devices such as shades, blinds, glazing, screens"

  // tests response to an uEnable input
  ShadingEnable shaEna(
    final use_solIrr=false)
    "Shading device controller"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  // tests response to a solar irradiance input
  ShadingEnable shaEna1 "Shading device controller"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  // tests response to a temperature input
  ShadingEnable shaEna2(
    use_solIrr=true)
    "Shading device controller"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

protected
  parameter Modelica.SIunits.Temperature TThr(
    final displayUnit="degC") = 300
    "Temperature that enables shading device deployment";
  parameter Modelica.SIunits.Irradiance irrThr = 1000
    "Solar irradiance that enables shading device deployment";

  CDL.Continuous.Sources.Constant T(
    final k=TThr + 5)
    "Temperature (zone or outdoor air)"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  CDL.Continuous.Sources.Sine T1(
    final amplitude=10,
    final freqHz=1/(2*1800),
    final offset=TThr - 10/2)
    "Temperature oscilates from below to above to below the deployment treshold "
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Continuous.Sources.Sine irr2(
    final amplitude=100,
    final freqHz=1/(2*1800),
    final offset=irrThr - (100/2))
    "Solar irradiance oscilates from below to above to below the deployment treshold "
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  CDL.Logical.Sources.Pulse sch(final period=600) "Enable schedule"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  CDL.Logical.Sources.Constant sch1(
    final k=true) "Enable schedule"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Logical.Sources.Constant sch2(
    final k=true) "Enable schedule"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

equation
  connect(T.y, shaEna.T)
    annotation (Line(points={{-119,30},{-100,30},{-100,16},{-82,16}}, color={0,0,127}));
  connect(sch.y, shaEna.uEnable)
    annotation (Line(points={{-119,-10},{-100,-10},{-100,4},{-82,4}}, color={255,0,255}));
  connect(shaEna1.T,T1. y)
    annotation (Line(points={{18,16},{0,16},{0,30},{-19,30}}, color={0,0,127}));
  connect(shaEna1.uEnable,sch1. y)
    annotation (Line(points={{18,4},{0,4},{0,-10},{-19,-10}}, color={255,0,255}));
  connect(shaEna2.uEnable,sch2. y)
    annotation (Line(points={{118,4},{100,4},{100,-10},{81,-10}}, color={255,0,255}));
  connect(irr2.y, shaEna2.irr)
    annotation (Line(points={{81,30},{100,30},{100,10},{118,10}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Facade/Validation/ShadingEnable_Schedule_T_Irr.mos"
        "Simulate and plot"),
    Icon(graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-80},{160,80}}), graphics={
        Text(
          extent={{-138,-54},{-108,-60}},
          lineColor={0,0,127},
          textString="Schedule enable"),
        Text(
          extent={{-38,-54},{0,-60}},
          lineColor={0,0,127},
          textString="Temperature hysteresis"),
        Text(
          extent={{62,-54},{108,-60}},
          lineColor={0,0,127},
          textString="Solar irradiance hysteresis")}),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.Facade.ShadingEnable\">
Buildings.Controls.OBC.Facade.ShadingEnable</a>
for control signals which enable the deployment of facade control devices such as 
shades, blinds, glazing, or screens.
</p>
</html>", revisions="<html>
<ul>
<li>
June 05, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShadingEnable_Schedule_T_Irr;
