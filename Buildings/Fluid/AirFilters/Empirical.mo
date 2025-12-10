within Buildings.Fluid.AirFilters;
model Empirical "Empirical air filter model"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Buildings.Fluid.AirFilters.Data.Generic per
    "Performance dataset"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uRep
    "True: replace the filter and reset the accumulation"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yRep
    "True if the filter is full and should be replaced"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eps[nConSub](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Filtration efficiency"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
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

  Buildings.Fluid.AirFilters.BaseClasses.MassAccumulation masAcc(
    final mCon_max=per.mCon_max,
    final mCon_start=per.mCon_start,
    final nConSub=nConSub) "Contaminant accumulation"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

protected
  parameter Integer nConSub = size(per.namCon,1)
    "Total types of contaminant substances";
  Buildings.Fluid.AirFilters.BaseClasses.PressureDropWithVaryingFlowCoefficient res(
    redeclare package Medium = Medium,
    final m_flow_nominal=per.m_flow_nominal,
    final dp_nominal=per.dp_nominal)
    "Pressure resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(
    redeclare package Medium = Medium,
    final m_flow_nominal=per.m_flow_nominal,
    final namCon=per.namCon)
    "Contaminant removal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency filEff(
    final mCon_max=per.mCon_max,
    final namCon=per.namCon,
    final filEffPar=per.filEffPar) "Filtration efficiency"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection floCor(
    final b=per.b)
    "Flow coefficient correction"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));

equation
  connect(masAcc.mCon,filEff. mCon)
    annotation (Line(points={{-38,60},{-22,60}},color={0,0,127}));
  connect(masAcc.uRep,uRep)
    annotation (Line(points={{-62,54},{-80,54},{-80,80},{-120,80}},
      color={255,0,255}));
  connect(filEff.rat,floCor. rat) annotation (Line(points={{2,66},{20,66},{20,60},
          {38,60}}, color={0,0,127}));
  connect(floCor.y, res.dpCor) annotation (Line(points={{62,60},{70,60},{70,20},{
          -50,20},{-50,12}}, color={0,0,127}));
  connect(masTra.mCon_flow, masAcc.mCon_flow) annotation (Line(points={{62,6},{80,
          6},{80,30},{-70,30},{-70,60},{-62,60}},   color={0,0,127}));
  connect(masTra.port_a, res.port_b)
    annotation (Line(points={{40,0},{-40,0}}, color={0,127,255}));
  connect(masTra.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(res.port_a, port_a)
    annotation (Line(points={{-60,0},{-100,0}}, color={0,127,255}));
  connect(filEff.y, eps) annotation (Line(points={{2,54},{20,54},{20,40},{120,40}},
                color={0,0,127}));
  connect(masTra.eps,filEff. y) annotation (Line(points={{38,6},{20,6},{20,54},{
          2,54}}, color={0,0,127}));
  connect(masAcc.yRep, yRep) annotation (Line(points={{-38,68},{-30,68},{-30,80},
          {120,80}}, color={255,0,255}));
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
This model empirically simulates the performance of air filters,
focusing on key factors such as contamination and pressure drop,
without requiring geometric data. 
It provides a set of parameters and performance characteristics 
that describe how the filter works under various conditions.
The performance of the air filter is characterized by a performance dataset <code>per</code>
(see <a href=\"modelica://Buildings.Fluid.AirFilters.Data.Generic\">
Buildings.Fluid.AirFilters.Data.Generic</a>), which contains key parameters that
define the filter:
</p>
<ul>
<li>
<b>Contaminant Name</b>: The array <code>per.namCon</code> defines the type of
contaminants that can be captured by the filter.
</li>
<li>
<b>Nominal Conditions</b>: They include the nominal pressure drop <code>dp_nominal</code> and
the nominal mass flow rate <code>m_flow_nominal</code> of the clean filter.
They also include the maximum total mass
of contaminants <code>mCon_max</code> that the filter can hold.
</li>
<li>
<b>Resistance Coefficient</b>: The parameter <code>per.b</code> describes how the
pressure drop of the filter increases as the contaminants accumulate over time.
See <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection\">
Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection</a>
for more information.
</li>
<li>
<b>Filtration Efficiency Curves</b>: The array <code>per.filEffPar</code> contains
the filtration efficiency curves. Each curve defines the efficiencies for capturing
each contaminant that is defined in <code>per.namCon</code>.
See <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency\">
Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency</a>
for more information.
</li>
</ul>
<p>
The input boolean flag, <code>uRep</code>, indicates that the filter has been replaced
and thus reset the mass accumulation to the initial status, i.e.,
when <code>uRep</code> changes from <code>false</code> to <code>true</code>, the
mass of the captured contaminants is reset to <code>per.mCon_start</code>.
</p>
<b>Note:</b>
<p>
Warnings will be written when,
</p>
<ul>
<li>
the captured contaminant mass exceeds the <code>mCon_max</code>, or
</li>
<li>
the <code>extraPropertiesNames</code> in the medium model does not contain all the
contaminants specified in the <code>per.namCon</code>.
</li>
</ul>

<h4>References</h4>
<ul>
<li>
<a href=\"https://nvlpubs.nist.gov/nistpubs/TechnicalNotes/NIST.TN.1887r1.pdf\">
CONTAM User Guide and Program Documentation Version 3.4</a>
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
