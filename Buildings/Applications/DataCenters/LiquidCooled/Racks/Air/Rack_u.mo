within Buildings.Applications.DataCenters.LiquidCooled.Racks.Air;
model Rack_u "Model of an air-cooled rack, and utilization is input"
  extends Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.PartialRack(
    m_flow_nominal = P_nominal/(dTSet*cp_default),
    dp_nominal=200,
    n=2,
    vol(nPorts=2)
    );
  parameter Modelica.Units.SI.TemperatureDifference dTSet(min=1) = 10
    "Set point for temperature raise across rack";


  Fluid.Movers.Preconfigured.FlowControlled_m_flow mov(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=true,
    use_riseTime=false,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    "Fan"
    annotation (Placement(transformation(extent={{-40,10},{-20,-10}})));

protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default = Medium.specificHeatCapacityCp(
    state_default) "Specific heat capacity";
  Modelica.Units.SI.SpecificHeatCapacity cp = Medium.specificHeatCapacityCp(
    state_in) "Specific heat capacity";

  Controls.OBC.CDL.Reals.Add PTot "Total power consumption"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.RealExpression mSet_flow(
    y(final unit="kg/s")=Q_flow.y/(cp*dTSet))
    "Set point for fan mass flow rate"
    annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
protected
  parameter Medium.ThermodynamicState state_default=
    Medium.setState_phX(
      Medium.p_default,
      Medium.h_default,
      Medium.X_default[1:Medium.nXi])
    "Default medium state";
  Medium.ThermodynamicState state_in=
    Medium.setState_phX(
      port_a.p,
      inStream(port_a.h_outflow),
      inStream(port_a.Xi_outflow))
      "State of inflowing medium";
equation
  connect(mSet_flow.y, mov.m_flow_in)
    annotation (Line(points={{-59,-32},{-30,-32},{-30,-12}},
                                                       color={0,0,127}));
  connect(preDro.port_b, mov.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(mov.port_b, vol.ports[2])
    annotation (Line(points={{-20,0},{60,0}}, color={0,127,255}));
  connect(Q_flow.y, PTot.u1) annotation (Line(points={{-59,50},{-30,50},{-30,36},
          {-22,36}}, color={0,0,127}));
  connect(mov.P, PTot.u2) annotation (Line(points={{-19,-9},{-10,-9},{-10,16},{-28,
          16},{-28,24},{-22,24}}, color={0,0,127}));
  connect(PTot.y, P) annotation (Line(points={{2,30},{80,30},{80,90},{110,90}},
        color={0,0,127}));
  connect(PTot.y, preHea.Q_flow) annotation (Line(points={{2,30},{10,30},{10,10},
          {20,10}}, color={0,0,127}));
annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of an air-cooled IT rack.
</p>
<h4>Electrical and fluid characterization</h4>
<p>
The model takes as a parameter the thermal design power (TDB) <code>P_nominal</code>
and as an input the utilization <code>u</code>.
The heat added to the coolant fluid is then calculated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q_flow = u P_nominal.
</p>
<p>
The fluid outlet temperature is computed using a first order delay to mimic
the transient effect. This first order delay is characterized by the user-configurable
time constant <code>tau</code>, set by default to <code>tau=2</code> seconds.
For exact transient response, this value should be identified based on measurements.
</p>
<p>
To compute the pressure drop, the model uses
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent\">
Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent</a>.
Therefore, the mass flow rate and pressure drop are related as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m_flow &frasl; m_flow_nominal = (dp &frasl; dp_nominal)<sup>m</sup>,
</p>
<p>
where 
<code>m_flow_nominal</code> is a parameter for the design flow rate,
<code>dp</code> is the pressure difference between inlet and outlet,
<code>dp_nominal</code> is a parameter for the design pressure difference, and
<code>m</code> is a parameter for the flow exponent.
</p>
<h4>Fan mass flow rate</h4>
<p>
The model has a built-in fan, configured to have zero back pressure.
The fan has an ideal controller that maintains a temperature difference across
the rack equal to the parameter <code>dTSet</code>, before adding the fan
energy to that air stream.
Note that therefore, the actual rack outlet temperature is slightly higher because the
fan energy is not included in the calculation of the mass flow rate.
If it were included, the model would have a nonlinear system of equations,
or would require a PI controller.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 26, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{40,4},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-106,4},{-40,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid)}));
end Rack_u;
