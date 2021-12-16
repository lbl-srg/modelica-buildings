within Buildings.HeatTransfer.Radiosity;
model OutdoorRadiosity
  "Model for the outdoor radiosity that strikes the window"
  parameter Modelica.Units.SI.Area A "Area of receiving surface";
  parameter Real vieFacSky(final min=0, final max=1)
    "View factor from receiving surface to sky (=1 for roofs)";
  parameter Boolean linearize=false "Set to true to linearize emissive power"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize));
  Real TRad4(unit="K4") "4th power of the mean outdoor temperature";
  Modelica.Units.SI.Temperature TRad "Mean radiant temperature";

  Modelica.Blocks.Interfaces.RealInput TOut(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Outside temperature" annotation (Placement(transformation(extent={{
            -140,-60},{-100,-20}}), iconTransformation(extent={{-140,-60},{-100,
            -20}})));
  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Black body sky temperature" annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{
            -100,60}})));
  Buildings.HeatTransfer.Interfaces.RadiosityOutflow JOut
    "Radiosity that flows out of component" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent=
            {{100,-10},{120,10}})));
protected
  final parameter Real T03(
    min=0,
    final unit="K3") = T0^3 "3rd power of temperature T0";
  final parameter Real T04(
    min=0,
    final unit="K4") = T0^4 "4th power of temperature T0";
equation
  TRad4 = (vieFacSky*TBlaSky^4 + (1 - vieFacSky)*TOut^4);
  JOut = A*Modelica.Constants.sigma*TRad4;
  TRad = if linearize then (TRad4 + 3*T04)/(4*T03) else TRad4^(1/4);

  annotation (
    Icon(graphics={
        Text(
          extent={{-96,-10},{-54,-52}},
          textColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{64,16},{94,-12}},
          textColor={0,0,127},
          textString="J"),
        Line(
          points={{6,-36},{28,-8},{20,-8},{28,-8},{28,-16},{28,-16}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{6,-36},{42,-36},{34,-30},{42,-36},{36,-42}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{6,28},{28,0},{20,0},{28,0},{28,8},{28,8}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{6,28},{42,28},{34,34},{42,28},{36,22}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{6,28},{28,56},{20,56},{28,56},{28,48},{28,48}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{4,74},{-34,-42}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,-42},{66,-60}},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-150,142},{150,102}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-96,72},{-54,30}},
          textColor={0,0,127},
          textString="TBlaSky")}),
    defaultComponentName="radOut",
    Documentation(info="<html>
<p>
Model for the infrared radiosity balance of the outdoor environment.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
June 27, 2013, by Michael Wetter:<br/>
Changed model because the outflowing radiosity has been changed to be a non-negative quantity.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
February 10, 2012, by Wangda Zuo:<br/>
Fixed a bug in the temperature linearization.
</li>
<li>
February 8, 2012 by Michael Wetter:<br/>
Changed implementation to use the same equations as is used for opaque walls.
</li>
<li>
August 18, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorRadiosity;
