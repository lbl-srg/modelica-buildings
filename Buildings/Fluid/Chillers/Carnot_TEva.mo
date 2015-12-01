within Buildings.Fluid.Chillers;
model Carnot_TEva
  "Chiller with prescribed evaporator leaving temperature and performance curve adjusted based on Carnot efficiency"
 extends Buildings.Fluid.Chillers.BaseClasses.PartialCarnot_T(
   QCon_flow_nominal = -QEva_flow_nominal*(1 + COP_nominal)/COP_nominal,
   PEle(y=-QEva_flow/COP),
   TCon_nominal = 303.15,
   TEva_nominal = 278.15,
   yPL = eva.Q_flow/QEva_flow_nominal,
   effInpEva=Buildings.Fluid.Types.EfficiencyInput.volume,
   effInpCon=Buildings.Fluid.Types.EfficiencyInput.port_a,
   redeclare HeatExchangers.HeaterCooler_u con(
    final from_dp=from_dp1,
    final dp_nominal=dp1_nominal,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final deltaM=deltaM1,
    final tau=tau1,
    final T_start=T1_start,
    final energyDynamics=energyDynamics1,
    final homotopyInitialization=homotopyInitialization,
    final Q_flow_nominal=QCon_flow_nominal),
   redeclare HeatExchangers.HeaterCooler_T eva(
    final from_dp=from_dp2,
    final dp_nominal=dp2_nominal,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final Q_flow_maxHeat=0,
    final Q_flow_maxCool=QEva_flow_min,
    final tau=tau2,
    final T_start=T2_start,
    final energyDynamics=energyDynamics2,
    final homotopyInitialization=homotopyInitialization));

  // Efficiency
  parameter Real COP_nominal(fixed=not use_eta_Carnot)
    "Coefficient of performance"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Modelica.SIunits.HeatFlowRate QEva_flow_min(max=0)=-Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)";

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Evaporator leaving water temperature"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

  Real COP(min=0, unit="1") = etaCar * COPCar * etaPL
    "Coefficient of performance";
  Real COPCar(min=0, unit="1") = TEva /
    Buildings.Utilities.Math.Functions.smoothMax(
      x1=1,
      x2=TCon-TEva,
      deltaX=0.25) "Carnot efficiency";

  Modelica.SIunits.HeatFlowRate QCon_flow = P - QEva_flow
    "Condenser heat input";

protected
  Modelica.Blocks.Sources.RealExpression yCon(final y=QCon_flow/
        QCon_flow_nominal) "Normalized condenser heat flow rate"
    annotation (Placement(transformation(extent={{-60,62},{-40,82}})));
initial equation
  assert(QEva_flow_nominal < 0, "Parameter QEva_flow_nominal must be negative.");
  COP_nominal = etaCar * TEva_nominal/(TCon_nominal-TEva_nominal);

equation
  connect(TSet, eva.TSet) annotation (Line(points={{-120,90},{-66,90},{40,90},{40,
          -54},{12,-54}}, color={0,0,127}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{-11,-54},{-40,-54},{-40,
          -90},{110,-90}}, color={0,0,127}));
  connect(yCon.y, con.u) annotation (Line(points={{-39,72},{-28,72},{-28,66},{-12,
          66}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),       graphics={
        Text(
          extent={{-148,156},{-92,114}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TEva"),
        Line(points={{-100,90},{-82,90},{-82,-56}}, color={0,0,255}),
        Line(points={{0,-70},{0,-90},{100,-90}}, color={0,0,255})}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
This is a model of a chiller whose coefficient of performance COP changes
with temperatures in the same way as the Carnot efficiency changes.
The control input is the setpoint of the evaporator leaving temperature, which
is met exactly at steady state if the chiller has sufficient capacity.
</p>
<p>
The COP at the nominal conditions can be specified by a parameter, or
it can be computed by the model based on the Carnot effectiveness, in which
case
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP<sub>0</sub> = &eta;<sub>car</sub> COP<sub>car</sub>
= &eta;<sub>car</sub> T<sub>eva</sub> &frasl; (T<sub>con</sub>-T<sub>eva</sub>),
</p>
<p>
where <i>T<sub>eva</sub></i> is the evaporator temperature
and <i>T<sub>con</sub></i> is the condenser temperature.
On the <code>Advanced</code> tab, a user can specify the temperature that
will be used as the evaporator (or condenser) temperature. The options
are the temperature of the fluid volume, of <code>port_a</code>, of
<code>port_b</code>, or the average temperature of <code>port_a</code> and
<code>port_b</code>.
</p>
<p>
The chiller COP is computed as the product
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP = &eta;<sub>car</sub> COP<sub>car</sub> &eta;<sub>PL</sub>,
</p>
<p>
where <i>&eta;<sub>car</sub></i> is the Carnot effectiveness,
<i>COP<sub>car</sub></i> is the Carnot efficiency and
<i>&eta;<sub>PL</sub></i> is a polynomial in the control signal <i>y</i>
that can be used to take into account a change in <i>COP</i> at part load
conditions.
This polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta;<sub>PL</sub> = a<sub>1</sub> + a<sub>2</sub> y + a<sub>3</sub> y<sup>2</sup> + ...
</p>
<p>
where <i>y &isin; [0, 1]</i> is the control input and the coefficients <i>a<sub>i</sub></i>
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
By default, the coefficient of performance depends on the
evaporator leaving temperature and the condenser entering
temperature.
This can be changed with the parameters
<code>effInpEva</code> and
<code>effInpCon</code>.
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
November 25, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Carnot_TEva;
