within Buildings.Fluid.CHPs.OrganicRankine;
model Cycle "Organic Rankine cycle as a bottoming cycle"

  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    final m1_flow_nominal = mHot_flow_nominal,
    final dp1_nominal = dpHot_nominal,
    final m2_flow_nominal = mCol_flow_nominal,
    final dp2_nominal = dpCol_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T1_start = max(pro.T)*2/3 + min(pro.T)*1/3,
    T2_start = max(pro.T)*1/10 + min(pro.T)*9/10,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      nPorts=2,
      final prescribedHeatFlowRate=true),
    final vol1(
      final prescribedHeatFlowRate=true));

  replaceable parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    constrainedby Buildings.Fluid.CHPs.OrganicRankine.Data.Generic
    "Property records of the working fluid"
    annotation(choicesAllMatching = true,Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal
    "Nominal mass flow rate of the evaporator fluid"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.PressureDifference dpHot_nominal = 0
    "Nominal pressure drop of the hot fluid in evaporator"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.TemperatureDifference dTPinEva_set(
    final min = 0) = 5
    "Set evaporator pinch point temperature difference"
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
  parameter Modelica.Units.SI.TemperatureDifference dTPinCon(
    final min = 0) = 10
    "Condenser pinch point temperature difference"
    annotation(Dialog(group="Condenser"));
  parameter Boolean useLowCondenserPressureWarning = true
    "If true, issues warning if pCon < 101325 Pa"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_max(
    final min = 0)
    "Upper bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_min(
    final min = 0)
    "Lower bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_hysteresis
    = mWor_flow_min + (mWor_flow_max - mWor_flow_min) * 0.1
    "Hysteresis for turning off the cycle when flow too low"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.Efficiency etaExp
    "Expander efficiency"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.Efficiency etaPum
    "Pump efficiency"
    annotation(Dialog(group="Cycle"));

  Modelica.Blocks.Interfaces.BooleanInput ena
    "Enable cycle; set false to force working fluid flow to zero" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-90,-10},{-70,10}})));

  Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity="Power",
    final unit="W") "Electrical power output from the expander"
    annotation (Placement(
        transformation(extent={{100,10},{140,50}}), iconTransformation(extent={{
            70,20},{90,40}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Evaporator heat flow rate (positive)" annotation (
      Placement(transformation(extent={{100,70},{140,110}}),iconTransformation(
          extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,90})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Condenser heat flow rate (positive)" annotation (
      Placement(transformation(extent={{100,-110},{140,-70}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-90})));
  Modelica.Blocks.Interfaces.BooleanOutput on_actual
    "Actual on off status of the cycle" annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{70,-10},{90,
            10}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power",
    final unit="W")
    "Electrical power consumption of the pump" annotation (Placement(
        transformation(extent={{100,-50},{140,-10}}),iconTransformation(extent={{70,-40},
            {90,-20}})));

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.FixedEvaporating cyc(
    final pro=pro,
    final mWor_flow_max=mWor_flow_max,
    final mWor_flow_min=mWor_flow_min,
    final mWor_flow_hysteresis=mWor_flow_hysteresis,
    final TWorEva =
            if useEvaporatingPressure
            then Buildings.Utilities.Math.Functions.smoothInterpolation(
                   x = pWorEva,
                   xSup = pro.p,
                   ySup = pro.T)
            else TWorEva,
    final dTPinEva_set=dTPinEva_set,
    final dTPinCon=dTPinCon,
    final cpHot=Medium1.specificHeatCapacityCp(sta1_nominal),
    final cpCol=Medium2.specificHeatCapacityCp(sta2_nominal),
    final etaExp=etaExp,
    final etaPum=etaPum,
    final useLowCondenserPressureWarning=useLowCondenserPressureWarning)
    "Thermodynamic computations of the organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

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
        rotation=180,
        origin={60,40})));
equation
  connect(preHeaFloEva.port, vol1.heatPort) annotation (Line(points={{19,40},{-16,
          40},{-16,60},{-10,60}}, color={191,0,0}));
  connect(preHeaFloCon.port, vol2.heatPort) annotation (Line(points={{21,-60},{12,
          -60}},                      color={191,0,0}));
  connect(cyc.QCon_flow, preHeaFloCon.Q_flow) annotation (Line(points={{11,-8},{
          50,-8},{50,-60},{41,-60}},  color={0,0,127}));
  connect(expTHotIn.y, cyc.THotIn) annotation (Line(points={{-39,30},{-20,30},{-20,
          8},{-11,8}},     color={0,0,127}));
  connect(expMHot_flow.y, cyc.mHot_flow) annotation (Line(points={{-39,10},{-30,
          10},{-30,4},{-11,4}}, color={0,0,127}));
  connect(expTColIn.y, cyc.TColIn) annotation (Line(points={{-39,-10},{-30,-10},
          {-30,-4},{-11,-4}}, color={0,0,127}));
  connect(expMCol_flow.y, cyc.mCol_flow) annotation (Line(points={{-39,-30},{-20,
          -30},{-20,-8},{-11,-8}}, color={0,0,127}));
  connect(cyc.QEva_flow, gai.u)
    annotation (Line(points={{11,8},{80,8},{80,40},{72,40}},
                                                     color={0,0,127}));
  connect(gai.y, preHeaFloEva.Q_flow) annotation (Line(points={{49,40},{39,40}},
                           color={0,0,127}));
  connect(cyc.PEle, PEle) annotation (Line(points={{11,4},{84,4},{84,30},{120,30}},
        color={0,0,127}));
  connect(ena, cyc.ena)
    annotation (Line(points={{-120,0},{-11,0}}, color={255,0,255}));
  connect(cyc.QEva_flow, QEva_flow) annotation (Line(points={{11,8},{80,8},{80,90},
          {120,90}},     color={0,0,127}));
  connect(cyc.QCon_flow, QCon_flow) annotation (Line(points={{11,-8},{50,-8},{50,
          -90},{120,-90}},    color={0,0,127}));
  connect(cyc.on_actual, on_actual) annotation (Line(points={{11,0},{120,0}},
                           color={255,0,255}));
  connect(cyc.PPum, PPum) annotation (Line(points={{11,-4},{84,-4},{84,-30},{120,
          -30}}, color={0,0,127}));
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
Model of an organic Rankine cycle (ORC) as a bottoming cycle.
</p>
<p>
The thermodynamic cycle is steady-state while the evaporator and the condenser
can be configured to have first order dynamics.
The fluid stream 1 (using <code>Medium1</code>, <code>port_a1</code>, etc.)
is the evaporator hot fluid carrying waste heat
and the stream 2 is the condenser cold fluid carrying the cooling fluid.
The working fluid of the cycle is not based on a typical Modelica medium model.
See the Thermodynamic Properties section of this document for the rational.
</p>
<h4>Cycle Architecture and Governing Equations</h4>
<p>
The implemented ORC is modeled based on the simplified cycle shown in the figure below.
The cycle has two variants depending on the shape of the saturation lines of
the working fluid and <i>&eta;<sub>exp</sub></i>.
For any given working fluid, the cycle is fully determined by providing
the working fluid evaporating temperature <i>T<sub>w,eva</sub></i>,
the working fluid condensing temperature <i>T<sub>w,con</sub></i>,
the expander efficiency <i>&eta;<sub>exp</sub></i>, and
the pump efficiency <i>&eta;<sub>pum</sub></i>.
The superheating temperature difference <i>&Delta;T<sub>sup</sub></i>
is minimized, meaning it is zero whenever possible; otherwise it assumes
the smallest value not to cause the expander outlet state to fall
under the dome. Subcooling after the condenser is not considered.
The Thermodynamic Properties section of this document details how these
state points are found.
</p>
<p>
An important assumption is that all heat is dissipated, i.e.,
the cycle is not controlled thermal load.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/OrganicRankine/CycleArchitecture.png\"
alt=\"CycleArchitecture\" width=\"800\" height=\"300\"/></p>
<p>
The cycle processes the heat at a fixed
<i>T<sub>w,eva</sub></i> provided by the user.
The evaporator heat exchange is governed by
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>eva</sub> = m&#775;<sub>h</sub>&nbsp;c<sub>p,h</sub>&nbsp;(T<sub>h,in</sub> - T<sub>h,out</sub>),<br/>
Q&#775;<sub>eva</sub> = m&#775;<sub>w</sub>&nbsp;(h<sub>exp,in</sub> - h<sub>pum,out</sub>),
</p>
<p>
where the subscripts are
<i>eva</i> for evaporator,
<i>exp</i> for expander,
<i>h</i> for hot fluid of the evaporator, i.e. the fluid carrying heat,
<i>pum</i> for pump, and
<i>w</i> for working fluid.
</p>
<p>
The cycle accommodates the variable flow rate and temperature
of the waste heat stream by changing the working fluid mass flow rate <i>m&#775;<sub>w</sub></i>
to maintain a constant pinch point (PP) temperature difference
at the evaporator <i>&Delta;T<sub>pin,eva</sub></i>.
This difference is found from
</p>
<p align=\"center\" style=\"font-style:italic;\">
(T<sub>pin,eva</sub> - T<sub>h,out</sub>)&nbsp;(h<sub>exp,in</sub> - h<sub>pum,out</sub>)
= (T<sub>h,in</sub> - T<sub>h,out</sub>)&nbsp;(h<sub>eva,pin</sub> - h<sub>pum,out</sub>),<br/>
&Delta;T<sub>pin,eva</sub> = T<sub>pin,eva</sub> - T<sub>w,eva</sub>.
</p>
<p>
The condenser side uses the same equations with the evaporator variables
replaced by their condenser counterparts where appropriate. Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>con</sub> = m&#775;<sub>c</sub>&nbsp;c<sub>p,c</sub>&nbsp;(T<sub>c,in</sub> - T<sub>c,out</sub>),<br/>
Q&#775;<sub>con</sub> = m&#775;<sub>w</sub>&nbsp;(h<sub>exp,out</sub> - h<sub>pum,in</sub>),<br/>
(T<sub>c,pin</sub> - T<sub>c,in</sub>)&nbsp;(h<sub>exp,out</sub> - h<sub>pum,in</sub>)
= (T<sub>c,out</sub> - T<sub>c,in</sub>)&nbsp;(h<sub>con,pin</sub> - h<sub>pum,in</sub>),<br/>
&Delta;T<sub>con,pin</sub> = T<sub>w,con</sub> - T<sub>c,pin</sub>,
</p>
<p>
where the subscripts are
<i>con</i> for condenser, and
<i>c</i> for cold fluid in the condenser.<br/>
</p>
<p>
The electric power output of the expander is
</p>
<p align=\"center\" style=\"font-style:italic;\">
P<sub>exp</sub> = m&#775;<sub>w</sub>&nbsp;(h<sub>exp,in</sub> - h<sub>exp,out</sub>).
</p>
<p>
The electric power consumption of the pump is
</p>
<p align=\"center\" style=\"font-style:italic;\">
P<sub>pum</sub> = m&#775;<sub>w</sub>&nbsp;(h<sub>pum,out</sub> - h<sub>pum,in</sub>).
</p>
<p>
The pump work is
</p>
<p align=\"center\" style=\"font-style:italic;\">
P<sub>pum</sub> = m&#775;<sub>w</sub>&nbsp;
(p<sub>eva</sub> - p<sub>con</sub>) / (&rho;<sub>pum,in</sub>&nbsp;&eta;<sub>pum</sub>).
</p>
<p>
This takes advantage of the negligible density change of the liquid
to avoid a property search in the subcooled liquid region.
</p>
<p>
In summary, the model has the following information flow:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>User-specified parameters</th>
<th>Inputs</th>
<th>Outputs</th>
</tr>
<tr>
<td>
<i>T<sub>w,eva</sub></i> - Working fluid evaporating temperature,<br/>
<i>&Delta;T<sub>pin,eva</sub></i> - Evaporator pinch point temperature difference,<br/>
<i>&Delta;T<sub>pin,con</sub></i> - Condenser pinch point temperature difference,<br/>
<i>&eta;<sub>exp</sub></i> - Expander efficiency,<br/>
<i>&eta;<sub>pum</sub></i> - Pump efficiency.
</td>
<td>
<i>T<sub>h,in</sub></i> - Evaporator hot fluid incoming temperature,<br/>
<i>m&#775;<sub>h</sub></i> - Evaporator hot fluid flow rate,<br/>
<i>T<sub>c,in</sub></i> - Condenser cold fluid incoming temperature,<br/>
<i>m&#775;<sub>c</sub></i> - Condenser cold fluid flow rate.
</td>
<td>
<i>m&#775;<sub>w</sub></i> - Working fluid flow rate,<br/>
<i>T<sub>w,con</sub></i> - Working fluid condensing temperature,<br/>
<i>T<sub>h,out</sub></i> - Evaporator hot fluid outgoing temperature,<br/>
<i>T<sub>c,out</sub></i> - Condenser cold fluid outgoing temperature,<br/>
<i>Q&#775;<sub>eva</sub></i> - Evaporator heat flow rate,<br/>
<i>Q&#775;<sub>con</sub></i> - Condenser heat flow rate,<br/>
<i>P<sub>exp</sub></i> - Expander power output,<br/>
<i>P<sub>pum</sub></i> - Pump power consumption.
</td>
</tr>
</table>
<h4>Constraints</h4>
<p>
The ORC system controls <i>m&#775;<sub>w</sub></i> to maintain the prescribed
evaporator PP temperature difference set point.
Although the model does not implement this as a control loop,
an upper limit and a lower limit are imposed on
<i>m&#775;<sub>w</sub></i> to reflect the characteristics of a sized cycle.
</p>
<ul>
<li>
The working fluid mass flow rate <i>m&#775;<sub>w</sub></i> will not go higher than a prescribed
upper limit. Rather, <i>m&#775;<sub>w</sub></i> stays at the
user-specified upper limit and <i>&Delta;T<sub>pin,eva</sub></i>
increases beyond its set point.
This may happen when the incoming hot fluid has a
high flow rate or a high incoming temperature, i.e., it
carries more energy than the cycle is sized to process.
</li>
<li>
When the working fluid mass flow rate <i>m&#775;<sub>w</sub></i> needs to go below a prescribed lower limit,
<i>m&#775;<sub>w</sub></i> is set to zero and the cycle is switched off. This
may happen when the incoming waste heat fluid has
a low flow rate or a low incoming temperature, i.e., it
carries too little energy.
</li>
</ul>
<p>
How these constraints affect the cycle's behavior reacting to
a variable waste heat fluid stream is demonstrated in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Validation.VariableSource\">
Buildings.Fluid.CHPs.OrganicRankine.Validation.VariableSource</a>.
</p>
<h4>Thermodynamic Properties</h4>
<p>
The thermodynamic properties of the working fluid are not computed by a typical
Modelica medium model, but by interpolating data records in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Data\">
Buildings.Fluid.CHPs.OrganicRankine.Data</a>.
Specific enthalpy and specific entropy values are provided as support points
on the saturated liquid line, the saturated vapor line, and
a superheated vapor line (called the reference line).
The values of these support points were obtained using CoolProp
(<a href=\"https://www.coolprop.org\">https://www.coolprop.org</a>;
Bell et al., 2014) through its Python wrapper and stored as Modelica records.
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
On the saturation line, the specific enthalpy, specific
entropy or density, here labeled as <i>y<sub>A</sub></i>, are obtained
using cubic Hermite spline interpolation as
<p align=\"center\" style=\"font-style:italic;\">
y<sub>A</sub> = s(u<sub>A</sub>,d)
</p>
where <i>s(&middot;,&middot;)</i> is a cubic Hermite spline,
<i>u<sub>A</sub></i> is the input property, and
<i>d</i> are the support points.
For the saturation curves, the user can configure the model
to use either the saturation pressure or the saturation
temperature for <i>u<sub>A</sub></i>.
For the reference line <i>u<sub>A</sub></i> is the pressure.
</li>
<li>
If the fluid is wet, the isentropic expander outlet point is in between
the saturation lines. In this case, its enthalpy <i>h<sub>B</sub></i>
is obtained from
<p align=\"center\" style=\"font-style:italic;\">
(h<sub>B</sub> - h<sub>1</sub>) / (s<sub>B</sub> - s<sub>1</sub>)
= (h<sub>2</sub> - h<sub>1</sub>) / (s<sub>2</sub> - s<sub>1</sub>)
</p>
where <i>s<sub>B</sub></i> is known because it equals the expander inlet
entropy, and all other points are on the saturation
line and therefore can be found as point <i>A</i>.
</li>
<li>
<i>C</i> is a point in the superheated vapor region. This is the case for
the expander inlet or outlet depending on the shape of the cycle.
The isobaric lines are not straight in this section, but they are
assumed linear so that the method for <i>B</i> can be applied using the
saturated vapour line and the reference line, albeit with less accuracy.
</li>
</ul>
<p>
The cycle can be completely defined by providing the following quantities:
evaporating temperature <i>T<sub>eva</sub></i> or pressure <i>p<sub>eva</sub></i>,
condensing temperature <i>T<sub>con</sub></i> or pressure <i>p<sub>con</sub></i>,
expander efficiency <i>&eta;<sub>exp</sub></i>, and
pump efficiency <i>&eta;<sub>pum</sub></i>.
Most of the important state points can be found via the interpolation schemes
described above. The only exceptions are the expander inlet, expander outlet,
and the pump outlet.
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
h<sub>exp,out</sub> - h<sub>exp,in</sub>
= (h<sub>exp,out,ise</sub> - h<sub>exp,in</sub>) &eta;<sub>exp</sub>
</p>
where <i>h<sub>exp,out</sub></i> is solved and <i>h<sub>exp,in</sub></i> is known.
</li>
<li>
A wet cycle is a cycle where the expansion starts from
the superheated vapour region and ends on the saturated vapour line.
In this scenario,
<p align=\"center\" style=\"font-style:italic;\">
h<sub>exp,out</sub> - h<sub>exp,in</sub>
= (h<sub>exp,out</sub> - h<sub>exp,inl,ise</sub>) &eta;<sub>exp</sub>
</p>
where <i>h<sub>exp,out</sub></i> is known and <i>h<sub>exp,in</sub></i> is solved.
For this fluid and this <i>&eta;<sub>exp</sub></i>,
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
