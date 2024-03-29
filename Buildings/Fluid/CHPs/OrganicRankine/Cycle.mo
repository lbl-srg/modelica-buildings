within Buildings.Fluid.CHPs.OrganicRankine;
model Cycle "Organic Rankine cycle as a bottoming cycle"

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    final m1_flow_nominal = mHot_flow_nominal,
    final dp1_nominal = dpHot_nominal,
    final m2_flow_nominal = mCol_flow_nominal,
    final dp2_nominal = dpCol_nominal,
    T1_start = max(pro.T)*2/3 + min(pro.T)*1/3,
    T2_start = max(pro.T)*1/10 + min(pro.T)*9/10,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true),
    final vol1(
      final prescribedHeatFlowRate=true));

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.FixedEvaporating cyc(
    final pro=pro,
    final mWor_flow_max=mWor_flow_max,
    final mWor_flow_min=mWor_flow_min,
    final TWorEva =
            if useEvaporatingPressure
            then Buildings.Utilities.Math.Functions.smoothInterpolation(
                   x = pWorEva,
                   xSup = pro.p,
                   ySup = pro.T)
            else TWorEva,
    final dTPinEva_set=dTPinEva_set,
    final TWorCon_min =
            if useCondensingPressure
            then Buildings.Utilities.Math.Functions.smoothInterpolation(
                   x = pWorCon_min,
                   xSup = pro.p,
                   ySup = pro.T)
            else TWorCon_min,
    final dTPinCon_set=dTPinCon_set,
    final cpHot=Medium1.specificHeatCapacityCp(sta1_nominal),
    final cpCol=Medium2.specificHeatCapacityCp(sta2_nominal),
    final etaExp=etaExp)
    "Thermodynamic computations of the organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  replaceable parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property records of the working fluid"
    annotation(choicesAllMatching = true,Dialog(group="Cycle"));
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal
    "Nominal heat flow rate of the evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal
    "Nominal mass flow rate of the evaporator fluid"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.PressureDifference dpHot_nominal = 0
    "Nominal pressure drop of the hot fluid in evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.TemperatureDifference dTPinEva_set(
    final min = 0) = 5
    "Set evaporator pinch point temperature differential"
    annotation(Dialog(group="Evaporator"));
  parameter Boolean useEvaporatingPressure = false
    "Set true to specify working fluid evaporating pressure instead of temperature"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.ThermodynamicTemperature TWorEva =
    max(pro.T)*2/3 + min(pro.T)*1/3
    "Evaporating temperature of the working fluid"
    annotation(Dialog(group="Evaporator", enable = not useEvaporatingPressure));
  parameter Modelica.Units.SI.Pressure pWorEva(displayUnit="kPa") =
    max(pro.p)*2/3 + min(pro.p)*1/3
    "Evaporating pressure of the working fluid"
    annotation(Dialog(group="Evaporator", enable = useEvaporatingPressure));
  parameter Modelica.Units.SI.MassFlowRate mCol_flow_nominal
    "Nominal mass flow rate of the condenser fluid"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.PressureDifference dpCol_nominal = 0
    "Nominal pressure drop of the cold fluid in condenser"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.TemperatureDifference dTPinCon_set(
    final min = 0) = 10
    "Set condenser pinch point temperature differential"
    annotation(Dialog(group="Condenser"));
  parameter Boolean useCondensingPressure = false
    "Set true to specify working fluid condensing pressure instead of temperature"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.ThermodynamicTemperature TWorCon_min =
    min(pro.T) + 1
    "Lower bound of working fluid condensing temperature"
    annotation(Dialog(group="Condenser", enable = not useCondensingPressure));
  parameter Modelica.Units.SI.Pressure pWorCon_min(displayUnit="kPa") =
    min(pro.p) + 100
    "Condensing pressure of the working fluid"
    annotation(Dialog(group="Condenser", enable = useCondensingPressure));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_max(
    final min = 0)
    = QEva_flow_nominal / (
        Buildings.Utilities.Math.Functions.smoothInterpolation(
          x = TWorEva,
          xSup = pro.T,
          ySup = pro.hSatVap) -
        Buildings.Utilities.Math.Functions.smoothInterpolation(
          x = TWorCon_min,
          xSup = pro.T,
          ySup = pro.hSatLiq))
    "Upper bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_min(
    final min = 0)
    = mWor_flow_max / 10
    "Lower bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.Efficiency etaExp
    "Expander efficiency"
    annotation(Dialog(group="Cycle"));

  Modelica.Blocks.Interfaces.RealOutput PEleOut(
    final quantity="Power",
    final unit="W") "Electrical power output"
                              annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{70,-20},{
            110,20}})));
  Modelica.Blocks.Interfaces.BooleanInput ena
    "Enable cycle; set false to force working fluid flow to zero" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Evaporator heat flow rate (positive)" annotation (
      Placement(transformation(extent={{100,20},{140,60}}), iconTransformation(
          extent={{70,10},{110,50}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Condenser heat flow rate (positive)" annotation (
      Placement(transformation(extent={{100,-60},{140,-20}}),
        iconTransformation(extent={{70,-50},{110,-10}})));
  Modelica.Blocks.Interfaces.BooleanOutput on_actual
    "Actual on off status of the cycle" annotation (Placement(transformation(
          extent={{100,80},{140,120}}), iconTransformation(extent={{70,80},{90,100}})));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{39,30},{19,50}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{41,-70},{21,-50}})));
  Modelica.Blocks.Sources.RealExpression expTHotIn(y=Medium1.temperature(
        state=Medium1.setState_phX(
          p=port_a1.p,
          h=inStream(port_a1.h_outflow),
          X=inStream(port_a1.Xi_outflow))))
    "Expression for evaporator hot fluid incoming temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.RealExpression expMHot_flow(y=m1_flow)
    "Expression for evaporator hot fluid flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Sources.RealExpression expTColIn(y=Medium2.temperature(
        state=Medium2.setState_phX(
          p=port_a2.p,
          h=inStream(port_a2.h_outflow),
          X=inStream(port_a2.Xi_outflow))))
    "Expression for condenser cold fluid incoming temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.RealExpression expMCol_flow(y=m2_flow)
    "Expression for condenser cold fluid flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Gain gai(k=-1)
    "Change the sign of evaporator heat flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,30})));
equation
  connect(preHeaFloEva.port, vol1.heatPort) annotation (Line(points={{19,40},{-16,
          40},{-16,60},{-10,60}}, color={191,0,0}));
  connect(preHeaFloCon.port, vol2.heatPort) annotation (Line(points={{21,-60},{12,
          -60}},                      color={191,0,0}));
  connect(cyc.QCon_flow, preHeaFloCon.Q_flow) annotation (Line(points={{12,-4},
          {50,-4},{50,-60},{41,-60}}, color={0,0,127}));
  connect(expTHotIn.y, cyc.THotIn) annotation (Line(points={{-39,30},{-20,30},{
          -20,8},{-12,8}}, color={0,0,127}));
  connect(expMHot_flow.y, cyc.mHot_flow) annotation (Line(points={{-39,10},{-30,
          10},{-30,4},{-12,4}}, color={0,0,127}));
  connect(expTColIn.y, cyc.TColIn) annotation (Line(points={{-39,-10},{-30,-10},
          {-30,-4},{-12,-4}}, color={0,0,127}));
  connect(expMCol_flow.y, cyc.mCol_flow) annotation (Line(points={{-39,-30},{-20,
          -30},{-20,-8},{-12,-8}}, color={0,0,127}));
  connect(cyc.QEva_flow, gai.u)
    annotation (Line(points={{12,4},{50,4},{50,18}}, color={0,0,127}));
  connect(gai.y, preHeaFloEva.Q_flow) annotation (Line(points={{50,41},{50,40},{
          39,40}},         color={0,0,127}));
  connect(cyc.PEleOut, PEleOut)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  connect(ena, cyc.ena)
    annotation (Line(points={{-120,0},{-11,0}}, color={255,0,255}));
  connect(cyc.QEva_flow, QEva_flow) annotation (Line(points={{12,4},{90,4},{90,
          40},{120,40}}, color={0,0,127}));
  connect(cyc.QCon_flow, QCon_flow) annotation (Line(points={{12,-4},{50,-4},{
          50,-40},{120,-40}}, color={0,0,127}));
  connect(cyc.on_actual, on_actual) annotation (Line(points={{11,8},{80,8},{80,
          100},{120,100}}, color={255,0,255}));
  annotation (defaultComponentName = "orc",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,-60},{-28,-20},{16,32},{40,60},{52,60},{54,30},{48,2},{
              52,-38},{58,-58}},
          color={255,255,255},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{6,20},{52,20},{66,-6},{50,-18},{-26,-18}},
          color={255,255,255},
          thickness=0.5,
          pattern=LinePattern.Dash)}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Implemented in this model is a steady-state organic Rankine cycle
as a bottoming cycle.
The fluid stream 1 (using <code>Medium1</code>, <code>port_a1</code>, etc.)
is the evaporator hot fluid carrying waste heat
and the stream 2 is the condenser cold fluid carrying the cooling fluid.
The working fluid (WF) of the cycle is not based on a medium model.
See the Thermodynamic Properties section of this document.
</p>
<h4>Cycle Architecture and Governing Equations</h4>
<p>
The implemented ORC assumes a simple architecture shown in the figure below.
For any given WF, the cycle is determined by providing
the WF evaporating temperature <i>T<sub>w,Eva</sub></i>,
the WF condensing temperature <i>T<sub>w,Con</sub></i>,
the expander efficiency <i>&eta;<sub>Exp</sub></i>.
The superheating temperature differential <i>&Delta;T<sub>Sup</sub></i>
is minimised, meaning it is zero whenever possible; otherwise it assumes
the smallest value not to cause the expander outlet state to fall
under the dome. The model neglects the property difference between
the pump inlet and outlet or the pressure loss along any pipe of
the cycle components. Subcooling after the condenser is not considered.
The Thermodynamic Properties section of this document details how these
state points are found.
</p>
<p>
An important underlying assumption is that all generated power can
be consumed or otherwise dissipated, i.e. the cycle is not controlled
to satisfy a certain load, electrical or thermal.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/OrganicRankine/CycleArchitecture.png\"
alt=\"CycleArchitecture\" width=\"400\" height=\"300\"/></p>
<p>
As the waste heat stream comes in as the evaporator hot fluid,
the cycle processes the heat at a fixed
<i>T<sub>w,Eva</sub></i> provided by the user.
The evaporator heat exchange is governed by the following equations:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>Eva</sub> = m&#775;<sub>h</sub>&nbsp;c<sub>p,h</sub>&nbsp;(T<sub>h,in</sub> - T<sub>h,out</sub>),<br/>
Q&#775;<sub>Eva</sub> = m&#775;<sub>w</sub>&nbsp;(h<sub>ExpInl</sub> - h<sub>Pum</sub>),
</p>
<p>
where the subscripts are:<br/>
<i>Eva</i> - evaporator;<br/>
<i>h</i> - hot fluid of the evaporator, i.e. the fluid carrying waste heat;<br/>
<i>w</i> - working fluid.
</p>
<p>
The cycle needs to accommodate the varying flow rate and temperature
of the waste heat stream. To do so, the model solves for a
<i>m&#775;<sub>w</sub></i> that would maintain a constant pinch point (PP)
temperature differential at the evaporator <i>&Delta;T<sub>pin,Eva</sub></i>.
This differential is found by the following equations:
</p>
<p align=\"center\" style=\"font-style:italic;\">
(T<sub>pin,Eva</sub> - T<sub>h,out</sub>)&nbsp;(h<sub>ExpInl</sub> - h<sub>Pum</sub>)
= (T<sub>h,in</sub> - T<sub>h,out</sub>)&nbsp;(h<sub>pinE,va</sub> - h<sub>Pum</sub>),<br/>
&Delta;T<sub>pin,Eva</sub> = T<sub>pin,Eva</sub> - T<sub>w,Eva</sub>.
</p>
<p>
The condenser side uses the same equations with the evaporator variables
replaced by their condenser counterparts where appropriate:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>Con</sub> = m&#775;<sub>c</sub>&nbsp;c<sub>p,c</sub>&nbsp;(T<sub>c,in</sub> - T<sub>c,out</sub>),<br/>
Q&#775;<sub>Con</sub> = m&#775;<sub>w</sub>&nbsp;(h<sub>ExpOut</sub> - h<sub>Pum</sub>),<br/>
(T<sub>pin,Con</sub> - T<sub>c,in</sub>)&nbsp;(h<sub>ExpOut</sub> - h<sub>Pum</sub>)
= (T<sub>c,out</sub> - T<sub>c,in</sub>)&nbsp;(h<sub>PinCon</sub> - h<sub>Pum</sub>),<br/>
&Delta;T<sub>pin,Con</sub> = T<sub>w,Con</sub> - T<sub>pin,Con</sub>,
</p>
<p>
where the subscripts are:<br/>
<i>Con</i> - condenser;<br/>
<i>c</i> - cold fluid of the condenser.<br/>
</p>
<p>
On this side, to maintain the PP differential, <i>T<sub>w,Con</sub></i>
is solved for.
</p>
<p>
Finally, the electric power output of the cycle is found by
</p>
<p align=\"center\" style=\"font-style:italic;\">
W&#775; = Q&#775;<sub>Eva</sub> - Q&#775;<sub>Con</sub>.
</p>
<p>
In summary, the model has the following information flow:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>User-specified parameters</th>
<th>Inputs and disturbances</th>
<th>Outputs</th>
</tr>
<tr>
<td>
<i>T<sub>w,Eva</sub></i> - Working fluid evaporating temperature,<br/>
<i>&Delta;T<sub>pin,Eva</sub></i> - Evaporator pinch point temperature differential,<br/>
<i>&Delta;T<sub>pin,Con</sub></i> - Condenser pinch point temperature differential.
</td>
<td>
<i>T<sub>h,in</sub></i> - Evaporator hot fluid incoming temperature,<br/>
<i>m&#775;<sub>h</sub></i> - Evaporator hot fluid flow rate,<br/>
<i>T<sub>c,in</sub></i> - Condenser cold fluid incoming temperature,<br/>
<i>m&#775;<sub>c</sub></i> - Condenser cold fluid flow rate.
</td>
<td>
<i>m&#775;<sub>w</sub></i> - Working fluid flow rate,<br/>
<i>T<sub>w,Con</sub></i> - Working fluid condensing temperature,<br/>
<i>T<sub>h,out</sub></i> - Evaporator hot fluid outgoing temperature,<br/>
<i>T<sub>c,out</sub></i> - Condenser cold fluid outgoing temperature,<br/>
<i>Q&#775;<sub>Eva</sub></i> - Evaporator heat flow rate,<br/>
<i>Q&#775;<sub>Con</sub></i> - Condenser heat flow rate,<br/>
<i>W&#775;</i> - Cycle power output.
</td>
</tr>
</table>
<h4>Constraints</h4>
<p>
This model solves for <i>m&#775;<sub>w</sub></i> to maintain the prescribed
evaporator PP temperature differential set point,
and <i>T<sub>w,Con</sub></i> for the condenser PP.
Some constraints apply.
</p>
<p>
On the evaporator side, an upper limit and a lower limit are imposed on
<i>m&#775;<sub>w</sub></i> to reflect the characteristics of a sized cycle.
</p>
<ul>
<li>
If the flow rate required for <i>&Delta;T<sub>pin,Eva</sub></i> to
be maintained at the set value is higher than the upper limit,
<i>m&#775;<sub>w</sub></i> stays at this upper limit and
<i>&Delta;T<sub>pin,Eva</sub></i> is allowed to go higher than its set point.
This may happen when the incoming waste heat fluid has a high flow rate
or a high incoming temperature, i.e. carries more energy than the system
is sized to process.
</li>
<li>
If the flow rate required for <i>&Delta;T<sub>pin,Eva</sub></i> to
be maintained at the set value is lower than the lower limit,
<i>m&#775;<sub>w</sub></i> is reset to zero and
the <i>&Delta;T<sub>pin,Eva</sub></i> set point is ignored.
This may happen when the incoming waste heat fluid has a low flow rate
or a low incoming temperature, i.e. carries too little energy.
This limit also protects the cycle from losing heat through the evaporator
when the incoming fluid is colder than the set evaporating temperature.
</li>
</ul>
<p>
How these constraints affect the cycle's behaviour reacting to
a varying waste heat fluid stream is demonstrated in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Validation.VariableHot\">
Buildings.Fluid.CHPs.OrganicRankine.Validation.VariableHot</a>
</p>
<p>
On the condenser side, a lower limit is imposed on <i>T<sub>w,Con</sub></i>.
This can prevent the condenser pressure from going too low.
This is demonstrated in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Validation.VariableHot\">
Buildings.Fluid.CHPs.OrganicRankine.Validation.VariableHot</a>
In principle, an upper limit should also exist for <i>T<sub>w,Con</sub></i>.
This is simply implemented as an <code>assert()</code> statement.
The reason is that such a situation should not occur as long as
an appropriate minimum cooling fluid flow is maintained in the condenser
whenever the cycle is running. This is a problem of the control sequence
at a higher level and out of scope of the ORC component.
</p>
<h4>Thermodynamic Properties</h4>
<p>
The thermodynamic properties of the WF are not computed by typical
Modelica medium model, but by interpolating data records in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Data\">
Buildings.Fluid.CHPs.OrganicRankine.Data</a>.
Specific enthalpy and specific entropy values are provided as support points
on the saturated liquid line, the saturated vapour line, and
a superheated vapour line (the reference line).
The values of these support points are found using CoolProp
(<a href=\"https://www.coolprop.org\">https://www.coolprop.org</a>;
Bell et al., 2014) under its Python wrapper.
</p>
<p>
Thermodynamic state points in the cycle are determined by various schemes
of interpolation and extrapolation.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/OrganicRankine/SupportCurves.png\"
alt=\"SupportCurves\" width=\"400\" height=\"300\"/></p>
<ul>
<li>
For any point <i>A</i> on a support curve, its property <i>y<sub>A</sub></i>
(enthalpy or entropy) is found by
<p align=\"center\" style=\"font-style:italic;\">
y<sub>A</sub> = s(u<sub>A</sub>,d),
</p>
where <i>s(&middot;,&middot;)</i> is a cubic Hermite spline,
<i>u<sub>A</sub></i> is the input property,
and <i>d</i> defines the support points.
For the saturation curves, <i>u</i> can be either the saturation pressure
or the saturation temperature;
for the reference line, <i>u</i> is the pressure.
</li>
<li>
<i>B</i> is a point in between the two saturation lines.
The only scenario where it needs to be found is when it is
the isentropic expander outlet (<i>ExpOutIse</i>). In this case,
its enthalpy <i>h<sub>B</sub></i> is found by
<p align=\"center\" style=\"font-style:italic;\">
(h<sub>B</sub> - h<sub>1</sub>) / (s<sub>B</sub> - s<sub>1</sub>)
= (h<sub>2</sub> - h<sub>1</sub>) / (s<sub>2</sub> - s<sub>1</sub>)
</p>
where <i>s<sub>B</sub></i> is known because it is the same as the expander
inlet entropy, and all other points are on saturation lines and
therefore can be found using the method for <i>A</i>.
</li>
<li>
<i>C</i> is a point in the superheated vapour region.
The isobaric lines are not straight in this section, but they are assumed
near linear to apply the same method as B using the saturated vapour line
and the reference line, albeit with less accuracy.
</li>
</ul>
<p>
The cycle can be completely defined by providing the following three variables:
evaporating temperature <i>T<sub>Eva</sub></i> or pressure <i>p<sub>Eva</sub></i>,
condensing temperature <i>T<sub>Con</sub></i> or pressure <i>p<sub>Con</sub></i>,
and expander efficiency <i>&eta;<sub>Exp</sub></i>.
Most of the important state points can be found via the interpolation schemes
described above. The only exceptions are <i>ExpInl</i> and <i>ExpOut</i>
which depend on the type of the fluid and <i>&eta;<sub>Exp</sub></i>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/OrganicRankine/ComputationPaths.png\"
alt=\"ComputationPaths\" width=\"1200\" height=\"300\"/></p>
<ul>
<li>
A dry cycle is a cycle where the expansion starts from
the saturated vapour line and ends in the superheated vapour region.
For either a dry fluid (a) or a wet fluid (b) undergoing such a cycle,
<p align=\"center\" style=\"font-style:italic;\">
h<sub>ExpOut</sub> - h<sub>ExpInl</sub>
= (h<sub>ExpOutIse</sub> - h<sub>ExpInl</sub>) &eta;<sub>Exp</sub>
</p>
where <i>h<sub>ExpOut</sub></i> is solved and <i>h<sub>ExpInl</sub></i> is known.
</li>
<li>
A wet cycle is a cycle where the expansion starts from
the superheated vapour region and ends on the saturated vapour line.
In this scenario,
<p align=\"center\" style=\"font-style:italic;\">
h<sub>ExpOut</sub> - h<sub>ExpInl</sub>
= (h<sub>ExpOut</sub> - h<sub>ExpInlIse</sub>) &eta;<sub>Exp</sub>
</p>
where <i>h<sub>ExpOut</sub></i> is known and <i>h<sub>ExpInl</sub></i> is solved.
For this fluid and this <i>&eta;<sub>Exp</sub></i>,
if the expansion started from the saturated vapour line,
the outlet point would end up under the dome.
</li>
</ul>
<h4>References</h4>
<p>
Bell IH, Wronski J, Quoilin S, Lemort V.
Pure and pseudo-pure fluid thermophysical property evaluation and the open-source thermophysical property library CoolProp.
<i>Industrial &amp; engineering chemistry research.
</i>
2014 Feb 12;53(6):2498-508.
<a href=\"https://doi.org/10.1021/ie4033999\">https://doi.org/10.1021/ie4033999</a>
</p>
</html>", revisions="<html>
<ul>
<li>
January 29, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end Cycle;
