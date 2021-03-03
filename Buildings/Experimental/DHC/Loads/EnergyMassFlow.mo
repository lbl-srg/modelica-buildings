within Buildings.Experimental.DHC.Loads;
block EnergyMassFlow
  extends Modelica.Blocks.Icons.Block;
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(
    final unit="kg/s")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,40},{140,80}}), iconTransformation(extent={{100,40},
            {140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flow(
    final unit="W")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup_actual(
    final unit="K",
    displayUnit="degC")
    "Connector of actuator output signal"
    annotation (Placement(transformation(
          extent={{-140,-80},{-100,-40}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow_actual(
    final unit="1")
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
     final order=2,
     f_cut=5/(2*Modelica.Constants.pi*120),
     final init=Modelica.Blocks.Types.Init.InitialOutput,
     final y_start=0,
     final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
     final filterType=Modelica.Blocks.Types.FilterType.LowPass,
     x(each stateSelect=StateSelect.always,
       each start=0))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
protected
  Modelica.SIunits.MassFlowRate m_flow_char
    "Mass flow rate from characteristics";
  Modelica.SIunits.MassFlowRate m_flow_cor
    "Mass flow rate corrected for supply temperature mismatch";
  Modelica.SIunits.MassFlowRate m_flow_residual
    "Residual mass flow rate";
equation
  // TODO: implement exponential characteristics
  m_flow_char = Q_flow / Q_flow_nominal;
  // TODO: regularize
  m_flow_cor = m_flow_char * abs((TSupSet - TLoa) *
    Utilities.Math.Functions.inverseXRegularized(TSup_actual - TLoa, 0.1));
  filter.u = m_flow_cor / m_flow_nominal;
  // TODO: smoothmin/max
  m_flow = max(
    fra_m_flow_min*m_flow_nominal,
    min(filter.y * m_flow_nominal, m_flow_nominal));
  m_flow_residual = max(0, m_flow_cor - m_flow_nominal);
  Q_flow_residual = -Q_flow * (1 - exp(-m_flow_residual / m_flow_nominal));
  Q_flow_actual = -Q_flow - Q_flow_residual;
  annotation (
  defaultComponentName="masFlo",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
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
flow rate corresponding to the minimum pump speed, and the nominal 
mass flow rate.
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
