within Buildings.Experimental.DHC.Loads.BaseClasses;
block EnergyMassFlow
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_masFlo = false
    "Set to true in case of prescribed mass flow rate"
    annotation(Evaluate=true);
  parameter Boolean have_varFlo = true
    "Set to true in case of variable flow system"
    annotation(Evaluate=true, Dialog(enable=not have_masFlo));
  parameter Boolean have_pum
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Design heating heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TSup_nominal(
    start=if Q_flow_nominal<0 then 280.15 else 333.15)
    "Supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TLoa_nominal(
    start=if Q_flow_nominal<0 then 294.15 else 293.15)
    "Load temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real fra_m_flow_min = if have_pum then 0.1 else 0
    "Minimum flow rate (ratio to nominal)"
    annotation(Dialog(enable=have_pum and not have_masFlo and have_varFlo));
  parameter Real k = 2.5
    "Shape factor of emission/flow rate characteristic";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna "Enable signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QPre_flow(
    final unit="W") "Prescribed load"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
              iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mPre_flow(
    final unit="kg/s") if have_masFlo
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup_actual(
    final unit="K",
    displayUnit="degC")
    "Actual supply temperature"
    annotation (Placement(transformation(
      extent={{-140,-60},{-100,-20}}), iconTransformation(extent={{-140,-60},{-100,
            -20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow_actual(
    final unit="kg/s")
    "Actual mass flow rate"
    annotation (Placement(transformation(
      extent={{-140,-90},{-100,-50}}),  iconTransformation(extent={{-140,-90},{-100,
            -50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(
    final unit="kg/s")
    "Mass flow rate required to meet prescribed load"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40}, {140,80}})));
  // Unit set to "1" to allow GUI connection with HeaterCooler_u.
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow_actual(
    unit="1")
    "Load that can be met under actual operating conditions"
    annotation (Placement(transformation(
      extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{140,
        20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow_residual(
    final unit="W")
    "Residual load that cannot be met under actual operating conditions"
    annotation (Placement(transformation(
      extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80},{140,
        -40}})));
  Modelica.Blocks.Continuous.Filter filter(
    final order=1,
    f_cut=5/(2*Modelica.Constants.pi*120),
    final init=Modelica.Blocks.Types.Init.InitialOutput,
    final y_start=1,
    final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
    final filterType=Modelica.Blocks.Types.FilterType.LowPass,
    x(each stateSelect=StateSelect.always, each start=1))
    "First-order filter";

protected
  parameter Real kReg(final unit="1") = 1E-4
    "Regularization parameter";
  Real fra_m_flow
    "Mass flow rate (ratio to nominal) corrected for supply temperature mismatch";
  Real fra_QCap_flow
    "Heating or cooling capacity (ratio to nominal) at actual supply temperature";
  Real fra_QPre_flow
    "Ratio of prescribed heat flow rate to actual capacity";
  Real fra_QPreBou_flow
    "Bounded ratio of prescribed heat flow rate to actual capacity";
  Real fra_Q_flow(final unit="1")
    "Heat flow rate correction factor for mass flow rate mismatch";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow_internal(
    final unit="kg/s")
    "Mass flow rate for internal use when mPre_flow is removed";


  function characteristic "m_flow -> Q_flow characteristic"
    /* FE: implement exponential characteristic based on OS load data for
    the case where have_masFlo is false.
    */
    extends Modelica.Icons.Function;
    input Real fra_m_flow
      "Fraction mass flow rate";
    input Boolean have_masFlo = false;
    input Real k = 2.5 "Shape factor of typical characteristic";
    output Real fra_Q_flow
      "Fraction heat flow rate";
  algorithm
    fra_Q_flow := (1 - exp(-k * fra_m_flow)) / (1 - exp(-k));
    annotation (
      inverse(
        fra_m_flow=inverseCharacteristic(fra_Q_flow, have_masFlo, k)));
  end characteristic;

  function inverseCharacteristic "Inverse of m_flow -> Q_flow characteristic"
    /* FE: implement exponential characteristic based on OS load data for
    the case where have_masFlo is false.
    */
    extends Modelica.Icons.Function;
    input Real fra_Q_flow
      "Fraction heat flow rate";
    input Boolean have_masFlo = false;
    input Real k = 2.5 "Shape factor of typical characteristic";
    output Real fra_m_flow
      "Fraction mass flow rate";
  algorithm
    fra_m_flow := log(fra_Q_flow * (exp(-k) -1) + 1) / (-k);
    annotation (
      inverse(fra_Q_flow=characteristic(fra_m_flow, have_masFlo, k)));
  end inverseCharacteristic;

equation
  if have_masFlo then
    connect(mPre_flow, m_flow_internal);
  else
    m_flow_internal = m_flow_nominal;
  end if;

  // Correction for supply temperature mismatch.
  fra_QCap_flow = (TSup_actual - TLoa_nominal) / (TSup_nominal - TLoa_nominal);

  fra_QPre_flow = QPre_flow / Q_flow_nominal *
    Utilities.Math.Functions.inverseXRegularized(
      fra_QCap_flow,
      kReg);
  fra_QPreBou_flow = max(0, min(1, fra_QPre_flow));

  // Computation of prescribed mass flow rate.
  fra_m_flow =
    if uEna then (
      if have_masFlo then max(0, min(1,
        m_flow_internal / m_flow_nominal *
        inverseCharacteristic(max(0, min(1,
          fra_QPre_flow * (TSupSet - TLoa_nominal) / TLoa_nominal *
            Utilities.Math.Functions.inverseXRegularized(
              (TSup_actual - TLoa_nominal) / TLoa_nominal,
              kReg))),
          have_masFlo,
          k) *
        Utilities.Math.Functions.inverseXRegularized(
          inverseCharacteristic(fra_QPreBou_flow, have_masFlo, k),
          kReg)))
      elseif not have_varFlo then
        1
      else
        max(fra_m_flow_min, inverseCharacteristic(fra_QPreBou_flow)))
    else 0;
  filter.u = fra_m_flow;
  m_flow = filter.y * m_flow_nominal;

  // Correction for mass flow rate shortage.
  fra_Q_flow = if have_pum then 1 else Utilities.Math.Functions.smoothLimit(
    characteristic(m_flow_actual / m_flow_nominal, have_masFlo, k) *
      Utilities.Math.Functions.inverseXRegularized(
        characteristic(m_flow / m_flow_nominal, have_masFlo, k),
        kReg),
    l=0,
    u=1,
    deltaX=kReg);
  Q_flow_actual = if uEna then
    -Q_flow_nominal * fra_Q_flow * Utilities.Math.Functions.smoothMin(
      x1=QPre_flow / Q_flow_nominal,
      x2=fra_QCap_flow,
      deltaX=kReg)
    else 0;
  Q_flow_residual = if uEna then -QPre_flow - Q_flow_actual else 0;

  annotation (
    defaultComponentName="eneMasFlo",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>
TODO:
Add TSup_nominal parameter and use it to compute QCap_flow
and QSet_flow.
Document enable signal for zero flow rate at zero load.
Effectiveness approximation and plot.
</p>
<p>
This block computes the mass flow rate and heat flow rate variables 
that enable coupling steady-state thermal loads provided as 
time series to a dynamic one-dimensional thermo-fluid flow model,
typically representing the in-building chilled water or hot water
distribution system.
</p>
<ul>
<li>
The block approximates the limit of the system capacity considering the actual
supply temperature and mass flow rate values. 
The part of the load that can be met under the actual operating conditions
is <i>Q&#775;_actual</i>. 
The part of the load that cannot be met under the actual operating conditions
is <i>Q&#775;_residual</i>.
</li>
</li>
<li>
The block approximates the relationship between the cumulated load on the hydronic 
distribution system and the chilled water or hot water mass flow rate.
</li>
</ul>
<h4>Implementation</h4>
<p>
<b>General principles</b>
</p>
<p>
In order to formulate generic relationships between the
heat flow rate and the supply temperature and mass flow rate,
the whole distribution system and the terminal units that it serves are abstracted
as a unique heat exchanger between the heating or cooling medium and the load.
Under that assumption, the total heat flow rate <i>Q&#775;</i> transferred to 
the load may be written as a function of the heat exchanger effectiveness <i>ε</i>, 
which is independent of the heat exchanger inlet temperatures.
</p>
<p>
<i>Q&#775; = ε * CMin * (TSup - TLoa)</i>,
</p>
<p>
where <i>CMin</i> is the minimum capacity flow rate, <i>TSup</i> 
is the supply temperature and <i>TLoa</i> is the load temperature which is 
considered constant here.
Various correlations are available to compute the effectiveness from the ratio
of the capacity flow rates and/or the minimum capacity flow rate.
For instance, in case of a load at uniform temperature, we have the following
equation.
</p>
<p>
<i>Q&#775; = (1 - exp(UA / CMin)) * CMin * (TSup - TLoa)</i>,
</p>
<p>
where <i>U</i> is the overall uniform heat transfer coefficient, and 
<i>A</i> is the area associated with the coefficient <i>U</i>.
Identifying the proper heat exchanger configuration and parameters
is practically challenging and likely irrelevant here, considering the modeling
uncertainty introduced by the heat exchanger approximation.
So we rather adopt the following simplified formulation (which also provides 
a straightforward inverse) using a shape factor <i>k</i> to approximate a typical 
emission/flow rate characteristic for variable flow systems, given a fixed supply 
temperature.
</p>
<p>
<i>Q&#775; / Q&#775;_nominal = (1 - exp(-k * m&#775; / m&#775;_nominal)) / (1 - exp(-k))</i>.
</p>
<p>
The figure hereunder compares that characteristic with the ones 
obtained with the ε-NTU method applied to two different configurations:
a case where the load has a uniform temperature (or infinite capacity flow rate)
and a counterflow heat exchanger.
The default value of the shape factor used for the comparison
provides a characteristic which is typical of (Petitjean, 1994)
</p>
<ul>
<li>
a cooling coil with water entering at a temperature of <code>6</code> degC and 
exhibiting a temperature rise of <code>6</code> K at nominal conditions, with
air entering at <code>24</code> degC, or
</li>
<li>
a heating coil with water entering at a temperature of <code>90</code> degC and
exhibiting a temperature drop of <code>30</code> K at nominal conditions, with
air entering at <code>20</code> degC, or
</li>
<li>
a radiator with water entering at a temperature of <code>90</code> degC and
exhibiting a temperature drop of <code>25</code> K at nominal conditions, with
room air at <code>20</code> degC.
</li>
</ul>
<p>
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/Loads/BaseClasses/EnergyMassFlow.png\"/>
</p>
<p>
Based on those general principles, the calculations are performed as
follows.
</p>
<p>
<b>Correction for supply temperature mismatch</b>
</p>
<p>
First, we compute 
</p>
<ul>
<li>
the system heating or cooling capacity <i>Q&#775;Cap</i> (at nominal mass flow rate)
given the actual supply temperature: 
<i>Q&#775;Cap / Q&#775;_nominal = (TSup_actual - TLoa) / (TSup_nominal - TLoa)</i>,
</li>
<li>
the part load ratio corresponding to the prescribed heat flow rate: 
<i>fra_Q&#775;Pre = Q&#775;Pre / Q&#775;Cap</i>.
</li>
</ul>
<p>
<b>Computation of the prescribed mass flow rate</b>
</p>
<p>
For constant flow systems, the prescribed mass flow rate is set to
the nominal value.
For variable flow systems,
</p>
<ul>
<li>
if the mass flow rate is not provided as an input, it is computed by 
applying the inverse of the emission/flow rate characteristic and 
considering the minimum value given by the recirculation flow rate 
at minimum pump speed:
<i>m&#775; / m&#775;_nominal = min(1, max(m&#775;Min / m&#775;_nominal,
f<sup>-1</sup>(fra_Q&#775;Pre)))</i>,
</li>
<li>
if the mass flow rate is provided as an input (<i>m&#775;Pre</i>), it still needs
to be corrected in case of a supply temperature mismatch:
<i>m&#775; / m&#775;_nominal = min(1, m&#775;Pre / m&#775;_nominal *
f<sup>-1</sup>(fra_Q&#775;Pre * (TSupSet - TLoa) / (TSup_actual - TLoa)) /
f<sup>-1</sup>(fra_Q&#775;Pre))</i>.
</li>
</ul>
<p>
The mass flow rate is then filtered to approximate the
response time of the terminal actuators and the distribution pump 
or main control valve.
This also provides a means to break the algebraic loop between the
mass flow rate and the supply temperature.
See
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>
for a description of the filter.
</p>
<p>
<b>Correction for mass flow rate shortage</b>
</p>
<p>
The corresponding heat flow rate correction factor <i>fra_Q&#775;</i> is computed 
as the ratio between the heat flow rate transferred with the actual mass flow rate 
and the heat flow rate transferred with the prescribed mass flow rate—the
emission/flow rate characteristic being used to assess those terms.
This is for passive systems with a differential pressure at their supply 
and control valves to modulate the flow.
In case of active systems with a pump, an ideal mover is expected to be used 
as in 
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface\">
Buildings.Experimental.DHC.Loads.BaseClasses.EnergyMassFlowInterface</a>
to impose the prescribed mass flow rate (whatever the flow resistance of the system) 
so the correction factor is <code>1</code>.
</p>
<p>
<b>Computation of actual and residual heat flow rates</b>
</p>
<p>
The heat flow rate that can be transferred under the actual
operating conditions is computed as
</p>
<p>
<i>Q&#775;_actual = min(Q&#775;Pre, Q&#775;Cap) * fra_Q&#775;</i>.   
</p> 
<p>
The residual heat flow rate is then simply
</p>
<p>
<i>Q&#775;_residual = Q&#775;Pre - Q&#775;_actual</i>.   
</p>
<p>
<b>Enable signal</b>
</p>
<p>
A Boolean \"enable\" signal forces (when false) the output mass flow rate and 
heat flow rate variables to zero, and may be used to represent a lock out of 
the system during off-hours or after a prolonged period with no load.
</p>
<h4>References</h4>
<p>
R. Petitjean.
<i>Total Hydronic Balancing</i>.
Tour and Andersson AB, Ljung, Sweden, 1994.
</p>
</html>"));
end EnergyMassFlow;
