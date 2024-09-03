within Buildings.Examples.VAVCO2.BaseClasses;
model RoomLeakage "Room leakage model"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
             annotation (choicesAllMatching = true);

  Buildings.Fluid.FixedResistances.PressureDrop res(
    m_flow_nominal=1,
    redeclare package Medium = Medium,
    dp_nominal=1000) "Resistance model"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Modelica.Blocks.Interfaces.RealInput p "Pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)                 annotation (Placement(transformation(extent={{
            90,-10},{110,10}})));

  Buildings.Fluid.Sources.Boundary_pT amb(             redeclare package Medium =Medium,
    nPorts=1,
    use_p_in=true,
    p=101325,
    T=293.15)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(res.port_b, port_b)
    annotation (Line(points={{40,6.10623e-16},{55,6.10623e-16},{55,1.16573e-15},
          {70,1.16573e-15},{70,5.55112e-16},{100,5.55112e-16}},
        color={0,127,255}));
  connect(p, amb.p_in) annotation (Line(points={{-120,1.11022e-15},{-81,
          1.11022e-15},{-81,8},{-42,8}},  color={0,0,127}));
  connect(amb.ports[1], res.port_a) annotation (Line(
      points={{-20,6.66134e-16},{-10,6.66134e-16},{-10,1.27676e-15},{0,
          1.27676e-15},{0,6.10623e-16},{20,6.10623e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
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
        Line(points={{80,0},{90,0}}, color={0,0,255}),
        Text(
          extent={{-136,54},{-104,14}},
          textColor={0,0,255},
          textString="P")}),
    Documentation(info="<html>
<p>
Room leakage used in the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomLeakage;
