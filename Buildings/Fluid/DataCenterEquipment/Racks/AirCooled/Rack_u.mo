within Buildings.Fluid.DataCenterEquipment.Racks.AirCooled;
model Rack_u "Model of an air-cooled rack, and utilization is input"
  extends Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.PartialRack(
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data.Generic dat
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.AirCooled.Data.Generic,
    vol(nPorts=2));

  Modelica.Blocks.Interfaces.RealOutput PTot(final unit="W")
    "Electrical power consumed by IT and fan"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
      iconTransformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput PFan(final unit="W")
    "Electrical power consumed by fan"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,40},{120,60}})));

  BaseClasses.ControlledFan fan(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final eta_nominal=dat.eta_nominal,
    final m_flow_nominal=dat.m_flow_nominal,
    final PFan_nominal=dat.PFan_nominal)
    "Fans to cool IT equipment"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

protected
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default = Medium.specificHeatCapacityCp(
    state_default) "Specific heat capacity";

  parameter Modelica.Units.SI.Density rho_default = Medium.density(
    state_default) "Density";

  parameter Medium.ThermodynamicState state_default=
    Medium.setState_phX(
      Medium.p_default,
      Medium.h_default,
      Medium.X_default[1:Medium.nXi])
    "Default medium state";

  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") =
    dat.PFan_nominal * dat.eta_nominal / (dat.m_flow_nominal/rho_default)
    "Fan pressure rise at nominal conditions, used also to parameterize internal flow resistance";

  Controls.OBC.CDL.Reals.Add PTotal "Total power consumption"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Controls.OBC.CDL.Reals.AddParameter TOutSet(p=dat.dTAir_nominal)
    "Setpoint for leaving air temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAirLvg
    "Leaving air temperature"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=dat.m_flow_nominal,
    from_dp=true,
    dp_nominal=dp_nominal)
    "Flow resistance"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Modelica.Blocks.Sources.RealExpression TIn(
    y(final unit="K", displayUnit="degC")=Medium.temperature(
      Medium.setState_phX(
        port_a.p,
        inStream(port_a.h_outflow),
        inStream(port_a.Xi_outflow))))
      "Inlet temperature"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
equation
  connect(PTotal.y, PTot) annotation (Line(points={{42,80},{110,80}},
        color={0,0,127}));
  connect(P, PTotal.u1) annotation (Line(points={{-120,50},{-70,50},{-70,86},{18,
          86}}, color={0,0,127}));
  connect(P, preHea.Q_flow) annotation (Line(points={{-120,50},{-80,50},{-80,20},
          {-40,20}},
                   color={0,0,127}));
  connect(TOutSet.y, fan.TSet) annotation (Line(points={{-38,50},{-22,50},{-22,
          8}},      color={0,0,127}));
  connect(TAirLvg.port, vol.heatPort) annotation (Line(points={{20,-20},{10,-20},
          {10,10},{20,10}},color={191,0,0}));
  connect(TAirLvg.T, fan.TMea) annotation (Line(points={{41,-20},{50,-20},{50,-40},
          {-30,-40},{-30,4},{-22,4}},color={0,0,127}));
  connect(TIn.y, TOutSet.u)
    annotation (Line(points={{-69,30},{-64,30},{-64,42},{-66,42},{-66,50},{-62,
          50}},                                  color={0,0,127}));
  connect(port_a, fan.port_a)
    annotation (Line(points={{-100,0},{-20,0}}, color={0,127,255}));
  connect(fan.port_b, vol.ports[1])
    annotation (Line(points={{0,0},{30,0}}, color={0,127,255}));
  connect(vol.ports[2], res.port_a)
    annotation (Line(points={{30,0},{60,0}}, color={0,127,255}));
  connect(res.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(fan.P, PTotal.u2)
    annotation (Line(points={{1,6},{4,6},{4,74},{18,74}}, color={0,0,127}));
  connect(fan.P, PFan)
    annotation (Line(points={{1,6},{4,6},{4,60},{110,60}}, color={0,0,127}));
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
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>.
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
<p>
Because the pressure drop of the rack is typically no a known design quantity,
the model computes it internally based on the fan power consumption and
the fan efficiency.
</p>
<h4>Fan</h4>
<p>
The model has a built-in fan which uses a constant total efficiency, specified through the
parameter <code>dat.eta_nominal</code>.
The fan has a PI controller that maintains a temperature difference across
the rack equal to the parameter <code>dTSet</code>.
</p>
<h4>Implementation</h4>
<p>
The implementation uses a fan model with prescribed speed, and, as explained above,
it computes a flow resistance which is then used in the simulations.
This implementation is used to allow use of this model with active rear door heat exchangers.
As active rear-door heat exchangers also have a fan, in such a configuration there will
be two fans in series. Prescribing the mass flow rate instead of the fan
may give in this situation an overspecified system of equations.
Thefore, rack model and rear-door heat exchangers use the fan model
<a href=\\\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.ControlledFan\\\">
Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.ControlledFan</a>.
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
          fillPattern=FillPattern.Solid),
        Text(
          extent={{62,66},{92,32}},
          textColor={0,0,127},
          textString="PFan"),
        Text(
          extent={{62,90},{88,68}},
          textColor={0,0,127},
          textString="PTot")}));
end Rack_u;
