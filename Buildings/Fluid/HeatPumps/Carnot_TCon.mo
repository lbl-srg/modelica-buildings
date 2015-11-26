within Buildings.Fluid.HeatPumps;
model Carnot_TCon
  "Heat pump with prescribed condenser leaving temperature and performance curve adjusted based on Carnot efficiency"
 extends Buildings.Fluid.Chillers.BaseClasses.PartialCarnot_T(
   QEva_flow_nominal = -QCon_flow_nominal*COP_nominal/(COP_nominal-1),
   PEle(y=QCon_flow/COP),
   final COPc_nominal = COP_nominal-1,
   TCon_nominal = 273.15+35,
   TEva_nominal = 273.15+5,
   yPL = con.Q_flow/QCon_flow_nominal,
   effInpEva=Buildings.Fluid.Types.EfficiencyInput.port_a,
   effInpCon=Buildings.Fluid.Types.EfficiencyInput.volume,
   redeclare HeatExchangers.HeaterCooler_T con(
    final from_dp=from_dp1,
    final dp_nominal=dp1_nominal,
    final linearizeFlowResistance=linearizeFlowResistance1,
    final deltaM=deltaM1,
    final Q_flow_maxHeat=QCon_flow_max,
    final Q_flow_maxCool=0,
    final tau=tau1,
    final T_start=T1_start,
    final energyDynamics=energyDynamics1,
    final homotopyInitialization=homotopyInitialization),
   redeclare HeatExchangers.HeaterCooler_u eva(
    final from_dp=from_dp2,
    final dp_nominal=dp2_nominal,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final tau=tau2,
    final T_start=T2_start,
    final energyDynamics=energyDynamics2,
    final homotopyInitialization=homotopyInitialization,
    final Q_flow_nominal=QEva_flow_nominal));

  // Efficiency
  parameter Real COP_nominal(fixed=not use_eta_Carnot)
    "Coefficient of performance"
    annotation (Dialog(group="Efficiency", enable=not use_eta_Carnot));

  parameter Modelica.SIunits.HeatFlowRate QCon_flow_max(
    min=0)=Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)";

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K")
    "Condenser leaving water temperature"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Actual heating heat flow rate added to fluid 1"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  Real COP(min=0) = COPc + 1 "Coefficient of performance";
  Real COPCar(min=0)= COPcCar + 1 "Carnot efficiency";

  Modelica.SIunits.HeatFlowRate QEva_flow = P - QCon_flow
    "Evaporator heat input";

protected
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(
    final y=QEva_flow/QEva_flow_nominal) "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
initial equation
  assert(QCon_flow_nominal > 0, "Parameter QCon_flow_nominal must be positive.");

  COP_nominal = etaCar * TCon_nominal/(TCon_nominal-TEva_nominal);

equation
  connect(TSet, con.TSet) annotation (Line(points={{-120,90},{-80,90},{-80,90},{
          -80,66},{-12,66}}, color={0,0,127}));
  connect(con.Q_flow, QCon_flow) annotation (Line(points={{11,66},{80,66},{80,90},
          {110,90}}, color={0,0,127}));
  connect(QEva_flow_in.y, eva.u) annotation (Line(points={{41,-40},{52,-40},{52,
          -54},{12,-54}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),
            graphics={
        Text(
          extent={{-148,156},{-92,114}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TCon"),
        Line(points={{-100,90},{-82,90},{79.8418,90},{80,64}},
                                                    color={0,0,255}),
        Line(points={{0,80},{0,84},{90,84},{90,90},{100,90}},
                                                 color={0,0,255})}),
defaultComponentName="heaPum",
Documentation(info="<html>
<p>
This is a model of a heat pump whose coefficient of performance COP changes
with temperatures in the same way as the Carnot efficiency changes.
The control input is the setpoint of the condenser leaving temperature, which
is met exactly at steady state if the heat pump has sufficient capacity.
</p>
<p>
The COP at the nominal conditions can be specified by a parameter, or
it can be computed by the model based on the Carnot effectiveness, in which
case
</p>
<p align=\"center\" style=\"font-style:italic;\">
  COP<sub>0</sub> = &eta;<sub>car</sub> COP<sub>car</sub>
= &eta;<sub>car</sub> T<sub>con</sub> &frasl; (T<sub>con</sub>-T<sub>eva</sub>),
</p>
<p>
where <i>T<sub>eva</sub></i> is the evaporator temperature
and <i>T<sub>con</sub></i> is the condenser temperature.
On the <code>Advanced</code> tab, a user can specify the temperature that
will be used as the evaporator and condenser temperatures. The options
are the temperature of the fluid volume, of <code>port_a</code>, of
<code>port_b</code>, or the average temperature of <code>port_a</code> and
<code>port_b</code>.
</p>
<p>
The heat pump COP is computed as the product
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
The heat pump outlet temperatures are equal to the temperatures of these lumped volumes.
</p>
<h4>Typical use and important parameters</h4>
<p>
When using this component, make sure that the evaporater has sufficient mass flow rate.
Based on the condenser mass flow rate, temperature difference and the efficiencies,
the model computes how much heat will be removed from the evaporator.
If the mass flow rate is too small, very low outlet temperatures can result, possibly below freezing.
</p>
<p>
The condenser heat flow rate <code>QCon_flow_nominal</code> is used to assign
the default value for the mass flow rates, which are used for the pressure drop
calculations.
It is also used to compute the part load efficiency.
Hence, make sure that <code>QCon_flow_nominal</code> is set to a reasonable value.
</p>
<p>
The maximum heating capacity is set by the parameter <code>QCon_flow_max</code>,
which is by default set to infinity.
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
For a similar model that can be used as a chiller, see
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.Carnot_TEva\">
Buildings.Fluid.Chillers.Examples.Carnot_TEva</a>.
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
end Carnot_TCon;
