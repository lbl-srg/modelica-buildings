within Buildings.Fluid.Boilers;
model SteamBoiler2 "Simple steam boiler model for testing"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_b = MediumSte,
    redeclare final package Medium_a = MediumWat,
    final show_T = true);

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water(T_max=623.15) "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  BaseClasses.Boiling2 boi
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Interfaces.RealInput pSte "Prescribed steam pressure"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealOutput dh(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat input into fluid"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumWat)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Product QMea_flow "Measured heat transfer rate"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
equation
  connect(senMasFlo.m_flow, QMea_flow.u1)
    annotation (Line(points={{-50,11},{-50,86},{58,86}},
                                                     color={0,0,127}));
  connect(QMea_flow.y, Q_flow)
    annotation (Line(points={{81,80},{90,80},{90,90},{110,90}},
                                                color={0,0,127}));
  connect(pSte, boi.pOut) annotation (Line(points={{-120,60},{-12,60},{-12,6},{
          -2,6}}, color={0,0,127}));
  connect(port_a, senMasFlo.port_a)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, boi.port_a)
    annotation (Line(points={{-40,0},{0,0}}, color={0,127,255}));
  connect(boi.port_b, port_b)
    annotation (Line(points={{20,0},{100,0}}, color={0,127,255}));
  connect(boi.dh, dh) annotation (Line(points={{21,6},{40,6},{40,60},{110,60}},
        color={0,0,127}));
  connect(boi.dh, QMea_flow.u2)
    annotation (Line(points={{21,6},{40,6},{40,74},{58,74}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-147,-114},{153,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,6},{101,-7}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{70,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,-14},{54,-74}},
          lineColor={255,255,255},
          textString="Q=%Q_flow_nominal"),
      Line(
        points={{44,54},{24,44},{44,24},{24,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{64,54},{44,44},{64,24},{44,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,127},
          lineThickness=0.5),
        Text(
          extent={{78,76},{92,62}},
          lineColor={0,0,127},
          textString="dh"),
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Line(
        points={{-42,54},{-62,44},{-42,24},{-62,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
      Line(
        points={{-22,54},{-42,44},{-22,24},{-42,14}},
        color={0,0,0},
        smooth=Smooth.Bezier,
          extent={{-60,-22},{-36,2}}),
        Rectangle(
          extent={{-100,60},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-94,82},{-46,62}},
          lineColor={0,0,127},
          textString="p_steam"),
        Text(
          extent={{18,98},{56,72}},
          lineColor={0,0,127},
          textString="Q_flow"),
        Rectangle(
          extent={{60,90},{100,88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,90},{62,60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SteamBoiler2;
