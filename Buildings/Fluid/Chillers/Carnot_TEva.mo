within Buildings.Fluid.Chillers;
model Carnot_TEva
  "Chiller with prescribed evaporator leaving temperature and performance curve adjusted based on Carnot efficiency"
 extends Buildings.Fluid.Chillers.BaseClasses.PartialCarnot_T(
   final COP_is_for_cooling = true,
   final QCon_flow_nominal = -QEva_flow_nominal*(1 + COP_nominal)/COP_nominal,
   PEle(y=-QEva_flow/COP),
   redeclare HeatExchangers.HeaterCooler_u con(
    final from_dp=from_dp1,
    final dp_nominal=dp1_nominal,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final deltaM=deltaM1,
    final tau=tau1,
    final T_start=T1_start,
    final energyDynamics=energyDynamics,
    final homotopyInitialization=homotopyInitialization,
    final Q_flow_nominal=QCon_flow_nominal),
   redeclare HeatExchangers.SensibleCooler_T eva(
    final from_dp=from_dp2,
    final dp_nominal=dp2_nominal,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final QMin_flow=QEva_flow_min,
    final tau=tau2,
    final T_start=T2_start,
    final energyDynamics=energyDynamics,
    final homotopyInitialization=homotopyInitialization));

  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_min(max=0) = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

protected
  Modelica.Blocks.Math.Gain yCon(final k=1/QCon_flow_nominal)
    "Normalized condenser heat flow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Add QCon_flow_internal(final k1=-1)
    "Heat added to condenser"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
initial equation
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be negative.");

equation
  connect(TSet, eva.TSet) annotation (Line(points={{-120,90},{-66,90},{28,90},{28,
          -52},{12,-52}}, color={0,0,127}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{-11,-52},{-40,-52},{-40,
          -90},{110,-90}}, color={0,0,127}));
  connect(QCon_flow_internal.y, yCon.u)
    annotation (Line(points={{-59,40},{-42,40}},          color={0,0,127}));
  connect(yCon.y, con.u) annotation (Line(points={{-19,40},{-16,40},{-16,42},{-16,
          64},{-16,66},{-12,66}}, color={0,0,127}));
  connect(QCon_flow_internal.y, QCon_flow) annotation (Line(points={{-59,40},{-52,
          40},{-52,80},{80,80},{80,90},{110,90}}, color={0,0,127}));
  connect(QCon_flow_internal.u1, eva.Q_flow) annotation (Line(points={{-82,46},{
          -90,46},{-90,-52},{-11,-52}}, color={0,0,127}));
  connect(QCon_flow_internal.u2, PEle.y) annotation (Line(points={{-82,34},{-88,
          34},{-88,20},{72,20},{72,0},{61,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Text(
          extent={{-148,156},{-92,114}},
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TEva"),
        Line(points={{-100,90},{-80,90},{-80,-56}}, color={0,0,255})}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
This is a model of a chiller whose coefficient of performance COP changes
with temperatures in the same way as the Carnot efficiency changes.
The control input is the setpoint of the evaporator leaving temperature, which
is met exactly at steady state if the chiller has sufficient capacity.
</p>
<p>
The model allows to either specify the Carnot effectivness
<i>&eta;<sub>Carnot,0</sub></i>, or
a <i>COP<sub>0</sub></i>
at the nominal conditions, together with
the evaporator temperature <i>T<sub>eva,0</sub></i> and
the condenser temperature <i>T<sub>con,0</sub></i>, in which
case the model computes the Carnot effectivness as
</p>
<p align=\"center\" style=\"font-style:italic;\">
&eta;<sub>Carnot,0</sub> =
  COP<sub>0</sub>
&frasl;  (T<sub>eva,0</sub> &frasl; (T<sub>con,0</sub>-T<sub>eva,0</sub>)).
</p>
<p>
On the <code>Advanced</code> tab, a user can specify the temperatures that
will be used as the evaporator and condenser temperature.
</p>
<p>
During the simulation, the chiller COP is computed as the product
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP = &eta;<sub>Carnot,0</sub> COP<sub>Carnot</sub> &eta;<sub>PL</sub>,
</p>
<p>
where <i>COP<sub>Carnot</sub></i> is the Carnot efficiency and
<i>&eta;<sub>PL</sub></i> is a polynomial in the cooling part load ratio <i>y<sub>PL</sub></i>
that can be used to take into account a change in <i>COP</i> at part load
conditions.
This polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta;<sub>PL</sub> = a<sub>1</sub> + a<sub>2</sub> y<sub>PL</sub> + a<sub>3</sub> y<sub>PL</sub><sup>2</sup> + ...
</p>
<p>
where the coefficients <i>a<sub>i</sub></i>
are declared by the parameter <code>a</code>.
</p>
<p>
On the <code>Dynamics</code> tag, the model can be parametrized to compute a transient
or steady-state response.
The transient response of the model is computed using a first
order differential equation for the evaporator and condenser fluid volumes.
The chiller outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
<h4>Typical use and important parameters</h4>
<p>
When using this component, make sure that the condenser has sufficient mass flow rate.
Based on the evaporator mass flow rate, temperature difference and the efficiencies,
the model computes how much heat will be added to the condenser.
If the mass flow rate is too small, very high outlet temperatures can result.
</p>
<p>
The evaporator heat flow rate <code>QEva_flow_nominal</code> is used to assign
the default value for the mass flow rates, which are used for the pressure drop
calculations.
It is also used to compute the part load efficiency.
Hence, make sure that <code>QEva_flow_nominal</code> is set to a reasonable value.
</p>
<p>
The maximum cooling capacity is set by the parameter <code>QEva_flow_min</code>,
which is by default set to negative infinity.
</p>
<p>
The coefficient of performance depends on the
evaporator and condenser leaving temperature
since otherwise the second law of thermodynamics may be violated.
</p>
<h4>Notes</h4>
<p>
For a similar model that can be used as a heat pump, see
<a href=\"modelica://Buildings.Fluid.HeatPumps.Examples.Carnot_TCon\">
Buildings.Fluid.HeatPumps.Examples.Carnot_TCon</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 8, 2017, by Michael Wetter:<br/>
Replaced model that interfaces with fluid stream.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>
January 2, 2017, by Filip Jorissen:<br/>
Removed parameters
<code>effInpEva</code> and <code>effInpCon</code>
and updated documentation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">
issue 497</a>.
</li>
<li>
August 8, 2016, by Michael Wetter:<br/>
Changed default temperature to compute COP to be the leaving temperature as
use of the entering temperature can violate the 2nd law if the temperature
lift is small.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">
Annex 60, issue 497</a>.
</li>
<li>
November 25, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TEva;
