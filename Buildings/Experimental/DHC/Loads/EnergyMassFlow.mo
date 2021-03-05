within Buildings.Experimental.DHC.Loads;
block EnergyMassFlow
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean have_pum
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Design heating heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Temperature TLoa = 20+273.15
    "Load temperature";
  parameter Real fra_m_flow_min = 0.1
    "Minimum flow rate (ratio to nominal)";
  parameter Modelica.SIunits.Time tau = 60
    "Time constant for mass dynamics"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow(
    final unit="W") "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup_actual(
    final unit="K",
    displayUnit="degC")
    "Connector of actuator output signal"
    annotation (Placement(transformation(
          extent={{-140,-50},{-100,-10}}), iconTransformation(extent={{-140,-50},
            {-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow_actual(
    final unit="kg/s")
    "Connector of actuator output signal"
    annotation (Placement(transformation(
          extent={{-140,-108},{-100,-68}}), iconTransformation(extent={{-140,-108},
            {-100,-68}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(
    final unit="kg/s")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40}, {140,80}})));
  // Unit set to "1" to allow GUI connection with HeaterCooler_u.
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow_actual(
    unit="1")
    "Connector of actuator output signal"
    annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{140,
            20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow_residual(
    final unit="W")
    "Connector of actuator output signal"
    annotation (Placement(transformation(
          extent={{100,-80},{140,-40}}), iconTransformation(extent={{100,-80},{140,
            -40}})));
  Modelica.Blocks.Continuous.Filter filter(
     final order=1,
     f_cut=5/(2*Modelica.Constants.pi*120),
     final init=Modelica.Blocks.Types.Init.InitialOutput,
     final y_start=0,
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass,
     x(each stateSelect=StateSelect.always,
       each start=0))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Real rat_m_flow_cha
    "Mass flow rate ratio based on characteristics";
  Real rat_m_flow_cor
    "Mass flow rate ratio corrected for supply temperature mismatch";
  Real rat2_m_flow_cor
    "Correction factor in case of low mass flow rate";
equation
  // TODO: implement exponential characteristics
  rat_m_flow_cha = Q_flow / Q_flow_nominal;
  // TODO: regularize
  rat_m_flow_cor = rat_m_flow_cha * abs((TSupSet - TLoa) *
    Utilities.Math.Functions.inverseXRegularized(TSup_actual - TLoa, 0.1));
  filter.u = rat_m_flow_cor;
  // TODO: smoothmin/max
  // TODO:
  m_flow = homotopy(
    actual=max(
      fra_m_flow_min,
      min(filter.y, 1)) * m_flow_nominal,
    simplified=rat_m_flow_cha * m_flow_nominal);
  rat2_m_flow_cor = if have_pum then 1 else
    Buildings.Utilities.Math.Functions.smoothLimit(
      x=m_flow_actual * Utilities.Math.Functions.inverseXRegularized(
        m_flow,
        1E-4 * m_flow_nominal),
      l=0,
      u=1,
      deltaX=1E-4);
  Q_flow_actual = -Q_flow * exp(-max(0, rat_m_flow_cor - 1)) * rat2_m_flow_cor;
  Q_flow_residual = -Q_flow - Q_flow_actual;
  annotation (
  defaultComponentName="masFlo",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
TODO: test first-order filter.
Criteria for unmet load: 
moving average of Q_flow difference AND 
supply temperature mismatch (because a permanent temperature mismatch
only leads to a transient mismatch in Q_flow, so the user
can have bad insight on degraded operating conditions.)
Include On/Off signal or Boolean for zero flow rate at zero load.
Currently Q_flow_actual computed with unfiltered flow rate: validate
that this will not create issues when mass flow transitions from 0.
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
TODO: Add a correction based on m_flow_actual, cf. case with an
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
