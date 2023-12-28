within Buildings.Fluid.AirFilters;
model Generic
  replaceable package Medium =
    Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Air"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}) "Moist air with CO2")),
      Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
  parameter Real mCon_nominal
  "Contaminant held capacity of the filter";
  parameter Real epsFun[:]
  "Filter efficiency curve";
  parameter Real b( final min = 1 + 1E-3)
  "Resistance coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop";
  Modelica.Blocks.Interfaces.BooleanInput triRep
    "replacing the filter when trigger becomes true"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Fluid.AirFilters.BaseClasses.PressureDropInputFlowCoefficient res(
     redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    "pressure resistance"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal) "contaminant removal"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.SimpleCharacterization simCha(
    final mCon_nominal=mCon_nominal,
    final epsFun=epsFun,
    final b=b) "filter characterization"
    annotation (Placement(transformation(extent={{22,50},{42,70}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassAccumulation masAcc(
    final mCon_nominal=mCon_nominal,
    final mCon_reset=0)
    "contaminant accumulation"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
     redeclare package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
     redeclare package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Sources.RealExpression traceSubstancesFlow(
     y=inStream(port_a.C_outflow[1]))
    "trace substances flow rate"
    annotation (Placement(transformation(extent={{-72,70},{-52,90}})));
equation
  connect(masAcc.mCon, simCha.mCon)
    annotation (Line(points={{2,60},{20,60}}, color={0,0,127}));
  connect(simCha.kCor, res.kCor) annotation (Line(points={{44,53.8},{50,53.8},{50,
          54},{56,54},{56,38},{-18,38},{-18,12}}, color={0,0,127}));
  connect(res.port_a, port_a)
    annotation (Line(points={{-28,0},{-100,0}}, color={0,127,255}));
  connect(res.port_b, masTra.port_a)
    annotation (Line(points={{-8,0},{40,0}}, color={0,127,255}));
  connect(masTra.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(masAcc.triRep, triRep) annotation (Line(points={{-22,53.8},{-22,54},{-94,
          54},{-94,60},{-120,60}}, color={255,0,255}));
  connect(traceSubstancesFlow.y, masAcc.mCon_flow) annotation (Line(points={{-51,
          80},{-40,80},{-40,66},{-22,66}}, color={0,0,127}));
  connect(simCha.eps, masTra.eps) annotation (Line(points={{44,65.8},{52,65.8},{
          52,66},{60,66},{60,28},{26,28},{26,6},{38,6}}, color={0,0,127}));
  connect(masTra.m_flow_in[1], traceSubstancesFlow.y) annotation (Line(points={{
          50,12},{50,20},{-40,20},{-40,80},{-51,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          defaultComponentName="genFilter",
          Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model of a generic air filter, which captures the impacts of the contamination accumulation on
the pressure drop and the filter efficiency. 
</p>
<p>
This model does not require detailed information of filters, such as filter type or geometric data.
Instead, its dynamic characteristics are defined by three parameters, <code>mCon_nominal</code>,<code>epsFun</code>,
and <code>b</code>.
</p>
<ul>
<li> 
<code>mCon_nominal</code> determines the maximum mass of the contaminants that the filter can hold;
</li> 
<li> 
<code>epsFun</code> is a vector of coefficients that determines how the filter efficiency changes by the accumulation 
of contaminants;
</li> 
<li> 
<code>b</code> is a constant that determines how the flow coefficient changes by the accumulation 
of contaminants.
</li>
</ul>
See more detailed descriptions in <a href=\"modelica://Buildings.Fluid.AirFilters.BaseClasses.SimpleCharacterization\">
Buildings.Fluid.AirFilters.BaseClasses.SimpleCharacterization</a>.
<p>
The input boolean flag, <code>triRep</code>, triggers the filter replacement.
Specifically, when <code>triRep</code> changes from <i>false</i> to <i>true</i>, the mass 
of the contaminants that the filter holds, <code>mCon = 0</code>.
</p>
<b>Note:</b> 
A warning will be triggered when <code>mCon > mCon_nominal</code>. 
</html>"));
end Generic;
