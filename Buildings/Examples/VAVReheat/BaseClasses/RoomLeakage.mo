within Buildings.Examples.VAVReheat.BaseClasses;
model RoomLeakage "Room leakage model"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Volume VRoo "Room volume";
  parameter Boolean use_windPressure=false
    "Set to true to enable wind pressure"
    annotation(Evaluate=true);
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    dp_nominal=50,
    m_flow_nominal=VRoo*1.2/3600) "Resistance model"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Fluid.Sources.Outside_CpLowRise
                        amb(redeclare package Medium = Medium, nPorts=1,
    s=s,
    azi=azi,
    Cp0=if use_windPressure then 0.6 else 0)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium = Medium,
      allowFlowReversal=true) "Sensor for mass flow rate" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,0})));
  Modelica.Blocks.Math.Gain ACHInf(k=1/VRoo/1.2*3600, y(unit="1/h"))
    "Air change per hour due to infiltration"
    annotation (Placement(transformation(extent={{12,30},{32,50}})));
  parameter Real s "Side ratio, s=length of this wall/length of adjacent wall";
  parameter Modelica.SIunits.Angle azi "Surface azimuth (South:0, West:pi/2)";

equation
  connect(res.port_b, port_b) annotation (Line(points={{40,6.10623e-16},{55,
          6.10623e-16},{55,1.16573e-15},{70,1.16573e-15},{70,5.55112e-16},{100,
          5.55112e-16}},                                   color={0,127,255}));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-60,0.2},{-80,0.2},{-80,5.55112e-16},{-100,5.55112e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.ports[1], senMasFlo1.port_a) annotation (Line(
      points={{-40,6.66134e-16},{-20,6.66134e-16},{-20,7.25006e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo1.port_b, res.port_a) annotation (Line(
      points={{5.55112e-16,-1.72421e-15},{10,-1.72421e-15},{10,6.10623e-16},{20,
          6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo1.m_flow, ACHInf.u) annotation (Line(
      points={{-10,11},{-10,40},{10,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Ellipse(
          extent={{-80,40},{0,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,127,255}),
        Rectangle(
          extent={{20,12},{80,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{20,6},{80,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Line(points={{-100,0},{-80,0}}, color={0,0,255}),
        Line(points={{0,0},{20,0}}, color={0,0,255}),
        Line(points={{80,0},{90,0}}, color={0,0,255})}),
    Documentation(info="<html>
<p>
Room leakage.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomLeakage;
