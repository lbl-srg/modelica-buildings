within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses;
model Convector
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  Sensors.MassFlowRate senFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  HeaterCooler_u hex(
    redeclare package Medium = Medium,
    Q_flow_nominal=1092,
    m_flow_nominal=0.094,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealInput airFlo
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput rooTem
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  ModificationFactor mod
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.RealExpression senTem(y=Medium.temperature(state_a))
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

   Medium.ThermodynamicState state_a=
    Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow))
    "state for medium inflowing through port_a1";
equation
  connect(hex.Q_flow, y) annotation (Line(points={{61,6},{70,6},{70,70},{110,70}},
        color={0,0,127}));
  connect(port_a, senFlo.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(hex.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(mod.y, hex.u)
    annotation (Line(points={{11,60},{20,60},{20,6},{38,6}}, color={0,0,127}));
  connect(airFlo, mod.airFlo) annotation (Line(points={{-120,90},{-70,90},{-20,
          90},{-20,69},{-12,69}}, color={0,0,127}));
  connect(rooTem, mod.rooTem) annotation (Line(points={{-120,48},{-72,48},{-20,
          48},{-20,51.2},{-12,51.2}}, color={0,0,127}));
  connect(senFlo.m_flow, mod.watFlo) annotation (Line(points={{-70,11},{-70,11},
          {-70,63},{-12,63}}, color={0,0,127}));
  connect(senFlo.port_b, hex.port_a)
    annotation (Line(points={{-60,0},{-10,0},{40,0}}, color={0,127,255}));
  connect(senTem.y, mod.watTem) annotation (Line(points={{-39,30},{-30,30},{-30,
          57},{-12,57}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,100},{-50,-100}},
          lineColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-10,100},{10,-100}},
          lineColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95}),
        Rectangle(
          extent={{50,100},{70,-100}},
          lineColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={95,95,95})}), defaultComponentName="con",
           Documentation(info="<html>
<p>
In cooling mode, this model adds heat to the water stream. The heat added is equal to:

<p align=\"center\" style=\"font-style:italic;\">
  Q<sub>Beam</sub> = Q<sub>rated</sub> f<sub><code>&#916;</code>T</sub>( ) f<sub>SA</sub>( ) f<sub>W</sub>( ) 
  <p>

In heating mode, the heat is removed from the water stream.

 <p>

</html>"));
end Convector;
