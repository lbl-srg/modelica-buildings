within Buildings.Experimental.DHC.Loads;
block EnergyMassFlow
  extends Modelica.Blocks.Icons.Block;

  parameter Boolean have_masFlo = false
    "Set to true in case of prescribed mass flow rate"
    annotation(Evaluate=true);
  parameter Boolean have_pum
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Design heating heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TLoa_nominal = 20+273.15
    "Load temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Real fra_m_flow_min = if have_pum then 0.1 else 0
    "Minimum flow rate (ratio to nominal)"
    annotation(Dialog(enable=have_pum and not have_masFlo));

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
  Real rat_m_flow_cor
    "Mass flow rate ratio corrected for supply temperature mismatch";
  Real rat_Q_flow_tem
    "Heat flow rate correction factor for supply temperature mismatch";
  Real rat_Q_flow_mas
    "Heat flow rate correction factor for mass flow rate mismatch";
  Modelica.SIunits.MassFlowRate m_flow_internal
    "Mass flow rate for internal use when mPre_flow is removed";

  function characteristics "m_flow -> Q_flow characteristics"
    /* FE: implement exponential characteristics based on OS load data for
    the case where have_masFlo is false.
    */
    extends Modelica.Icons.Function;
    input Real rat_m_flow
      "Fraction mass flow rate";
    input Boolean have_masFlo = false;
    input Real k = 2.5 "Shape factor of typical characteristics";
    output Real rat_Q_flow
      "Fraction heat flow rate";
  algorithm
    rat_Q_flow := (1 - exp(-k * rat_m_flow)) / (1 - exp(-k));
  end characteristics;

  function inverseCharacteristics "Inverse of m_flow -> Q_flow characteristics"
    /* FE: implement exponential characteristics based on OS load data for
    the case where have_masFlo is false.
    */
    extends Modelica.Icons.Function;
    input Real rat_Q_flow
      "Fraction heat flow rate";
    input Boolean have_masFlo = false;
    input Real k = 2.5 "Shape factor of typical characteristics";
    output Real rat_m_flow
      "Fraction mass flow rate";
  algorithm
    rat_m_flow := log(rat_Q_flow * (exp(-k) -1) + 1) / (-k);
  end inverseCharacteristics;

equation
  if have_masFlo then
    connect(mPre_flow, m_flow_internal);
  else
    m_flow_internal = m_flow_nominal;
  end if;
  // Correction for supply temperature mismatch.
  rat_Q_flow_tem = abs((TSupSet - TLoa_nominal) *
    Utilities.Math.Functions.inverseXRegularized(
      TSup_actual - TLoa_nominal,
      0.1));
  // FIX case have_masFlo with ratio of inverseCharacteristics
  rat_m_flow_cor =
    if have_masFlo then
      m_flow_internal / m_flow_nominal
    else
      inverseCharacteristics(QPre_flow / Q_flow_nominal * rat_Q_flow_tem);
  filter.u = rat_m_flow_cor;
  m_flow = if have_masFlo then filter.y else
    Utilities.Math.Functions.smoothLimit(
      x=filter.y,
      l=if uEna then fra_m_flow_min else 0,
      u=1,
      deltaX=1E-4) * m_flow_nominal;
  // Correction for mass flow rate shortage.
  rat_Q_flow_mas = if have_pum then 1 else
    Utilities.Math.Functions.smoothLimit(
      x = characteristics(m_flow_actual / m_flow_nominal, have_masFlo) *
        Utilities.Math.Functions.inverseXRegularized(
          characteristics(filter.y / m_flow_nominal, have_masFlo),
          1E-4),
      l=0,
      u=1,
      deltaX=1E-4);
  Q_flow_actual = -QPre_flow * rat_Q_flow_mas;
  Q_flow_residual = -QPre_flow - Q_flow_actual;

  annotation (
    defaultComponentName="eneMasFlo",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
<p>
TODO:
Criteria for unmet load:
moving average of Q_flow difference AND
supply temperature mismatch (because a permanent temperature mismatch
only leads to a transient mismatch in Q_flow, so the user
can have bad insight on degraded operating conditions.)

Document enable signal for zero flow rate at zero load: is it really needed?
</p>
<p>
This block approximates the relationship between a cumulated load
on a hydronic distribution system and the mass flow rate.
</p>
<ul>
<li>
First, a precomputed characteristics is used to assess the mass flow
rate <i>m&#775;Cha</i> as a function of the load.
TODO: compute the characteristics based on
https://github.com/urbanopt/openstudio-prototype-loads
</li>
<li>
This mass flow rate is then corrected to account for the impact
of a transient mismatch between the supply temperature set point
<i>TSupSet</i> and the actual supply temperature <i>TSup_actual</i>.
<p style=\"font-style:italic;\">
m&#775;Cor = m&#775;Cha * (TSupSet - TLoa) / (TSup_actual - TLoa),
</p>
<p>
where <i>TLoa</i> is the temperature of the load (considered constant).
The equation here above expresses that an infinite mass flow rate
is needed to meet the load when the supply temperature tends towards
the load temperature.
</p>
</li>
<li>
The corrected mass flow rate is then filtered to approximate the
response time of the terminal actuators and the distribution pump.
This also provides a means to break the algebraic loop between the
mass flow rate and the supply temperature.
See
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>
for a description of the filter.
</li>
<li>
Eventually the corrected mass flow rate is bounded by the recirculation
flow rate at minimum pump speed, and the nominal mass flow rate.
<li>
</ul>
<p>
The block also implements the following equations that allow to split
the load between a steady state term—the part of the load that can be met
under the actual operating conditions—and a delayed term—the part of the load
that cannot be met and that will contribute to a variation of the average
temperature of the fluid inside the distribution system.
</p>
<ul>
<li>
The delayed term is computed from the load <i>Q&#775;</i> and the
corrected mass flow rate <i>m&#775;Cor</i> (unbounded) as follows.
TODO: Document the correction based on m_flow_actual, cf. case with an
active ETS and a pressure-independent valve.
<p style=\"font-style:italic;\">
Q&#775;Del = Q&#775; * (1 - exp(-max(0, m&#775;Cor - m&#775;Nom) / m&#775;Nom)).
</p>
</li>
<li>
The steady-state term is then simply computed as
<i>Q&#775;Ste = Q&#775; - Q&#775;Del</i>.
</li>
<li>
According to the above equations, when the corrected mass flow rate is
below the nominal mass flow rate, the delayed term is zero and the
steady-state term is equal to the load.
The delayed term corresponds to the part of the corrected mass flow
rate required to meet the load, which exceeds the nominal mass flow rate.
</li>
</ul>
</html>"));
end EnergyMassFlow;
