within Buildings.HeatTransfer.Radiosity;
model OutdoorRadiosity
  "Model for the outdoor radiosity that strikes the window"
  parameter Modelica.SIunits.Area A "Area of receiving surface";
  parameter Real F_sky(min=0, max=1)
    "View factor from receiving surface to sky";
  parameter Boolean linearize=false "Set to true to linearize emissive power"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.Temperature T0=293.15
    "Temperature used to linearize radiative heat transfer"
    annotation (Dialog(enable=linearize), Evaluate=true);
  output Modelica.SIunits.HeatFlux jSky "Radiosity flux of the clear sky";
  output Real TRad4(unit="K4") "4th power of the mean outdoor temperature";
  output Modelica.SIunits.Temperature TRad "Mean outdoor temperature";
  Modelica.Blocks.Interfaces.RealInput f_clr(min=0, max=1)
    "Fraction of sky that is clear"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port for outside air temperature"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));

  Buildings.HeatTransfer.Interfaces.RadiosityOutflow JOut
    "Radiosity that flows out of component"
  annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{120,
            10}})));
protected
 final parameter Real T03(min=0, unit="K3")=T0^3 "3rd power of temperature T0"
 annotation(Evaluate=true);
 final parameter Real T05(min=0, unit="K5")=T0^5 "5th power of temperature T0"
 annotation(Evaluate=true);
equation
  jSky = 5.31E-13 * (if linearize then T05*heatPort.T else heatPort.T^6);
  TRad4 = (((1-F_sky) + (1-f_clr)*F_sky) *
         (if linearize then T03*heatPort.T else heatPort.T^4)
         + f_clr*F_sky*jSky/Modelica.Constants.sigma);
  JOut = -A * Modelica.Constants.sigma * TRad4;
  TRad = if linearize then TRad4/T03 else TRad4^(1/4);
  heatPort.Q_flow = 0;
  annotation (Diagram(graphics), Icon(graphics={
        Text(
          extent={{-84,110},{-42,68}},
          lineColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-84,20},{-40,-20}},
          lineColor={0,0,127},
          textString="f_clr"),
        Text(
          extent={{64,16},{94,-12}},
          lineColor={0,0,127},
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
          lineColor={0,0,0}),           Text(
        extent={{-150,142},{150,102}},
        textString="%name",
        lineColor={0,0,255})}),
defaultComponentName="radOut",
Documentation(info="<html>
Model for the long-wave radiosity balance of the outdoor environment.
The computation is according to TARCOG 2006.
</p>
<h4>References</h4>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</html>", revisions="<html>
<ul>
<li>
August 18 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end OutdoorRadiosity;
