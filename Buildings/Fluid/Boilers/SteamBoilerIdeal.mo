within Buildings.Fluid.Boilers;
model SteamBoilerIdeal "Simple steam boiler model for testing"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;

/*  replaceable package Medium_a =
      IBPSA.Media.Steam.Interfaces.PartialPureSubstanceWithSat
    "Medium model for port_a (inlet)";
  replaceable package Medium_b =
      IBPSA.Media.Steam.Interfaces.PartialPureSubstanceWithSat
    "Medium model for port_b (outlet)";
*/
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal
    "Nominal steam pressure";

  BaseClasses.Evaporation eva(
    redeclare package Medium_a = Medium_a,
    redeclare package Medium_b = Medium_b,
    m_flow_nominal=m_flow_nominal,
    pSte_nominal=pSte_nominal,
    final show_T = show_T)
    "Evaporation model"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Interfaces.RealOutput dh(unit="J/kg") "Change in enthalpy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat input into fluid"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium_a)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Product QMea_flow "Measured heat transfer rate"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Movers.FlowControlled_dp pum(
    redeclare package Medium = Medium_a,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    final show_T = show_T)
    "Pump to increase pressure to setpoint"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Sensors.Pressure senPre(redeclare package Medium = Medium_a)
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Math.Add dpAct(k2=-1)
    "Actual pressure change required per measurement and setpoint"
    annotation (Placement(transformation(extent={{-50,36},{-30,56}})));
  Modelica.Blocks.Sources.RealExpression pSteSet(y=pSte_nominal)
    "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{-90,42},{-70,62}})));
equation
  connect(senMasFlo.m_flow, QMea_flow.u1)
    annotation (Line(points={{10,11},{10,86},{58,86}},
                                                     color={0,0,127}));
  connect(QMea_flow.y, Q_flow)
    annotation (Line(points={{81,80},{90,80},{90,90},{110,90}},
                                                color={0,0,127}));
  connect(senMasFlo.port_b,eva. port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(eva.port_b, port_b)
    annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
  connect(eva.dh, dh) annotation (Line(points={{51,6},{54,6},{54,60},{110,60}},
        color={0,0,127}));
  connect(eva.dh, QMea_flow.u2)
    annotation (Line(points={{51,6},{54,6},{54,74},{58,74}}, color={0,0,127}));
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-30,0}}, color={0,127,255}));
  connect(pum.port_b, senMasFlo.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(senPre.p, dpAct.u2) annotation (Line(points={{-69,30},{-60,30},{-60,
          40},{-52,40}}, color={0,0,127}));
  connect(dpAct.y, pum.dp_in)
    annotation (Line(points={{-29,46},{-20,46},{-20,12}}, color={0,0,127}));
  connect(senPre.port, port_a)
    annotation (Line(points={{-80,20},{-80,0},{-100,0}}, color={0,127,255}));
  connect(pSteSet.y, dpAct.u1)
    annotation (Line(points={{-69,52},{-52,52}}, color={0,0,127}));
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
end SteamBoilerIdeal;
