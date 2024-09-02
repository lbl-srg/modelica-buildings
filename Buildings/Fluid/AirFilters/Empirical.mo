within Buildings.Fluid.AirFilters;
model Empirical "Empirical air filter model"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Air";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop"
    annotation (Dialog(group="Nominal"));
  parameter Buildings.Fluid.AirFilters.BaseClasses.Data.Generic per
    "Performance dataset"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRep
    "Replacing the filter when trigger becomes true"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eps[size(per.substanceName, 1)](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Filtration efficiency" annotation (Placement(transformation(
          extent={{100,20},{140,60}}), iconTransformation(extent={{100,-80},{140,
            -40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
     h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
     redeclare final package Medium = Medium,
     h_outflow(start = Medium.h_default, nominal = Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  Buildings.Fluid.AirFilters.BaseClasses.PressureDropWithVaryingFlowCoefficient
    res(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal)
    "Pressure resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final substanceName=per.substanceName)
    "Contaminant removal"
    annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency epsCal(
    final per=per)
    "Filter characterization"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassAccumulation masAcc(
    final per=per,
    final mCon_reset=0,
    final nin=size(per.substanceName, 1))
    "Contaminant accumulation"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection coeCor(
    final per=per)
    "Flow coefficient correction"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

equation
  connect(masAcc.mCon, epsCal.mCon)
    annotation (Line(points={{-18,80},{-2,80}}, color={0,0,127}));
  connect(masAcc.uRep, uRep)
    annotation (Line(points={{-42,74},{-42,74},{-70,74},{-70,60},{-120,60}},
      color={255,0,255}));
  connect(epsCal.rat, coeCor.rat) annotation (Line(points={{22,86},{40,86},{40,80},
          {58,80}}, color={0,0,127}));
  connect(coeCor.y, res.kCor) annotation (Line(points={{82,80},{90,80},{90,20},
          {-50,20},{-50,12}},color={0,0,127}));
  connect(masTra.mCon_flow, masAcc.mCon_flow) annotation (Line(points={{58,6},{
          76,6},{76,48},{-48,48},{-48,80},{-42,80}},color={0,0,127}));
  connect(masTra.port_a, res.port_b)
    annotation (Line(points={{36,0},{-40,0}}, color={0,127,255}));
  connect(masTra.port_b, port_b)
    annotation (Line(points={{56,0},{100,0}}, color={0,127,255}));
  connect(res.port_a, port_a)
    annotation (Line(points={{-60,0},{-100,0}}, color={0,127,255}));
  connect(epsCal.y, eps) annotation (Line(points={{22,74},{40,74},{40,40},{120,
          40}}, color={0,0,127}));
  connect(masTra.eps, epsCal.y) annotation (Line(points={{34,6},{20,6},{20,40},
          {40,40},{40,74},{22,74}}, color={0,0,127}));
annotation (defaultComponentName="airFil",
Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-20,90},{22,-80}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          lineThickness=0.5),
        Line(
          points={{8,90},{-20,68}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{22,40},{-20,0}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{22,-38},{-20,-80}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-72,50},{-56,60},{-40,48},{-30,58}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,58},{-40,58}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,58},{-30,50}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-72,0},{-56,10},{-40,-2},{-30,8}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,8},{-40,8}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,8},{-30,0}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-72,-48},{-56,-38},{-40,-50},{-30,-40}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,-40},{-40,-40}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,-40},{-30,-48}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{28,52},{44,62},{60,50},{70,60}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{70,60},{60,60}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{70,60},{70,52}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{28,2},{44,12},{60,0},{70,10}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{70,10},{60,10}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{70,10},{70,2}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{28,-46},{44,-36},{60,-48},{70,-38}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{70,-38},{60,-38}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{70,-38},{70,-46}},
          color={28,108,200},
          thickness=0.5),
        Ellipse(
          extent={{-54,70},{-48,64}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,46},{-56,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,36},{-44,30}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,24},{-58,18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-62,-2},{-56,-8}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,-12},{-40,-18}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,-26},{-58,-32}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,-30},{-42,-36}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-60,-52},{-54,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,38},{44,32}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,-16},{46,-22}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-145,-100},{155,-140}},
          textColor={0,0,255},
          textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
An empirical model of air filters, which considers the impacts of the contaminant
accumulation on the pressure drop and the filtration efficiency.
The dynamic characteristics of the filters are defined by
</p>
<ul>
<li>
The <code>mCon_nominal</code> determines the maximum mass of the contaminants that the
filter can held.
</li>
<li>
A performance dataset <code>per</code> that determines 
<ul>
<li>
how the flow coefficient changes with the contaminant accumulation;
</li>
<li>
the types of contaminants;
</li>
<li>
how the filtration efficiency changes 
with the contaminant accumulation for each contaminant.
</li>
</ul>
</li>
</ul>
<p>
See more detailed descriptions in
<a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection\">
Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection</a>
and <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">
Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>, respectively.
</p>
<p>
The input boolean flag, <code>uRep</code>, triggers the filter replacement.
When <code>uRep</code> changes from <code>false</code> to <code>true</code>, the
mass of the captured contaminants becomes <i>0</i>.
</p>
<b>Note:</b>
A warning will be triggered 
<ul>
<li>
when the captured contaminant mass becomes greater than the
maximum contaminant mass (<code>mCon_nominal</code>).
</li>
<li>
or when the <code>extraPropertiesNames</code> in the medium model don't contain all the contaminants
defined in the <code>per</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Empirical;
