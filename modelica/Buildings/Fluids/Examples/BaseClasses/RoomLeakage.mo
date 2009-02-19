within Buildings.Fluids.Examples.BaseClasses;
model RoomLeakage "Room leakage model"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = 
      Modelica.Media.Interfaces.PartialMedium "Medium in the component" 
             annotation (choicesAllMatching = true);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
                       Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
          lineColor={0,0,255},
          textString="P")}),
    Documentation(info="<html>
<p>
Room leakage used in the MIT system model.
</p></html>", revisions="<html>
<ul>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  Buildings.Fluids.FixedResistances.FixedResistanceDpM res(
    m0_flow=1,
    dp0=1000,
    redeclare package Medium = Medium) "Resistance model" 
                                      annotation (Placement(transformation(
          extent={{20,-10},{40,10}}, rotation=0)));

  Modelica.Blocks.Interfaces.RealInput p "Pressure" 
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));
  Modelica_Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium = 
        Medium)                 annotation (Placement(transformation(extent={{
            90,-10},{110,10}}, rotation=0)));

  Modelica_Fluid.Sources.Boundary_pT amb(             redeclare package Medium
      =                                                                          Medium,
    nPorts=1,
    use_p_in=true,
    p=101325,
    T=293.15) 
    annotation (Placement(transformation(extent={{-42,-10},{-22,10}}, rotation=
            0)));
equation
  connect(res.port_b, port_b) 
    annotation (Line(points={{40,0},{55,0},{55,1.16573e-015},{70,1.16573e-015},
          {70,0},{100,0}},
        color={0,127,255}));
  connect(p, amb.p_in) annotation (Line(points={{-120,0},{-81,0},{-81,8},{-44,8}},
                                          color={0,0,127}));
  connect(amb.ports[1], res.port_a) annotation (Line(
      points={{-22,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
end RoomLeakage;
