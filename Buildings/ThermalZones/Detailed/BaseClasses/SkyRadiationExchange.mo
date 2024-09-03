within Buildings.ThermalZones.Detailed.BaseClasses;
model SkyRadiationExchange
  "Radiative heat exchange with the sky and the ambient"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Integer n(min=1) "Number of constructions";
  parameter Modelica.Units.SI.Area A[n] "Area of exterior constructions";
  parameter Real vieFacSky[n](
    each min=0,
    each max=1) "View factor to sky (=1 for roofs)";
  parameter Modelica.Units.SI.Emissivity absIR[n]
    "Infrared absorptivity of building surface";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port[n] "Heat port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput TOut(final quantity="ThermodynamicTemperature",
                                            final unit = "K", min=0)
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TBlaSky(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0) "Black body sky temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
protected
  parameter Real k[n](
    each unit="W/K4") = {4*A[i]*Modelica.Constants.sigma*absIR[i] for i in 1:n}
    "Constant for radiative heat exchange";
  Modelica.Units.SI.Temperature TEnv[n] "Environment temperature";
  Real TBlaSky4(unit="K4") "Auxiliary variable for radiative heat exchange";
  Real TOut4(unit="K4") "Auxiliary variable for radiative heat exchange";
  Modelica.Units.SI.CoefficientOfHeatTransfer h[n]
    "Radiative heat transfer coefficient";

equation
  TBlaSky4 = TBlaSky^4;
  TOut4 = TOut^4;
  for i in 1:n loop
    TEnv[i] = (vieFacSky[i] * TBlaSky4 + (1-vieFacSky[i]) * TOut4)^(0.25);
    // h[i] uses TEnv[i] instead of (port[i].T+TEnv[i])/2 to avoid
    // a nonlinear equation system
    h[i]  = k[i] * TEnv[i]^3;
    port[i].Q_flow = h[i] * (port[i].T-TEnv[i]);
  end for;
  annotation ( Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,80},{-40,-60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{88,-60},{-74,-74}},
          fillColor={5,135,13},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{2,82},{86,36}},
          pattern=LinePattern.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-40,16},{-30,28},{-14,28},{-6,44},{10,42},{12,46}},
          smooth=Smooth.None,
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{-40,16},{-22,-4},{2,-6},{12,-30},{42,-40},{48,-58}},
          smooth=Smooth.None,
          color={255,0,0},
          thickness=0.5),
        Text(
          extent={{-128,12},{-78,-34}},
          textColor={0,0,127},
          textString="TOut"),
        Text(
          extent={{-130,96},{-80,50}},
          textColor={0,0,127},
          textString="TSky"),
        Text(
          extent={{86,52},{136,6}},
          textColor={0,0,127},
          textString="QIR_flow")}),
        Documentation(info = "<html>
This model computes the infrared radiative heat flow
between exterior building surfaces and the ambient. The ambient consists
of the sky black-body radiation and the outdoor temperature
(which is used as an approximation to the surface temperature of
the ground and neighboring buildings).
</html>",
        revisions="<html>
<ul>
<li>
March 13, 2015, by Michael Wetter:<br/>
Added missing <code>each</code> keywords.
</li>
<li>
June 4 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SkyRadiationExchange;
