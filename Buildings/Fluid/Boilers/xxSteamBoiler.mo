within Buildings.Fluid.Boilers;
model xxSteamBoiler "Simple steam boiler model for testing"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium(
    redeclare final package Medium_b = MediumSte,
    redeclare final package Medium_a = MediumWat,
    final show_T = true);

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water(T_max=623.15) "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  BaseClasses.xxBoiling boiling
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Interfaces.RealInput pSte "Prescribed steam pressure"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
  Movers.FlowControlled_dp fan(redeclare package Medium = MediumWat,
      m_flow_nominal=m_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sensors.Pressure senPre
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Math.Add dp(k2=-1) "Change in pressure between two fluids"
    annotation (Placement(transformation(extent={{-60,26},{-40,46}})));
  Modelica.Blocks.Interfaces.RealOutput dhOut(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat input into fluid"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumWat)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Product QMea_flow "Measured heat transfer rate"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
equation
  connect(pSte, dp.u1) annotation (Line(points={{-120,60},{-70,60},{-70,42},{
          -62,42}},
                color={0,0,127}));
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
  connect(senPre.port, port_a)
    annotation (Line(points={{-80,20},{-80,0},{-100,0}}, color={0,127,255}));
  connect(senPre.p, dp.u2)
    annotation (Line(points={{-69,30},{-62,30}}, color={0,0,127}));
  connect(dp.y, fan.dp_in)
    annotation (Line(points={{-39,36},{-30,36},{-30,12}}, color={0,0,127}));
  connect(boiling.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  connect(boiling.dhOut, dhOut) annotation (Line(points={{41,6},{70,6},{70,60},{
          110,60}}, color={0,0,127}));
  connect(fan.port_b, senMasFlo.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, boiling.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(senMasFlo.m_flow, QMea_flow.u1)
    annotation (Line(points={{0,11},{0,86},{58,86}}, color={0,0,127}));
  connect(boiling.dhOut, QMea_flow.u2)
    annotation (Line(points={{41,6},{48,6},{48,74},{58,74}}, color={0,0,127}));
  connect(QMea_flow.y, Q_flow)
    annotation (Line(points={{81,80},{90,80},{90,90},{110,90}},
                                                color={0,0,127}));
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
end xxSteamBoiler;
