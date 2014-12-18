within Buildings.Fluid.HeatExchangers;
model HeaterCooler_T
  "Ideal heater or cooler with a prescribed outlet temperature"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));
  extends Buildings.Fluid.Interfaces.PrescribedOutletStateParameters(
    T_start=Medium.T_default);

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

protected
  Buildings.Fluid.FixedResistances.FixedResistanceDpM preDro(
    redeclare final package Medium = Medium,
    final use_dh=false,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Pressure drop model"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Interfaces.PrescribedOutletState heaCoo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small,
    final show_T=false,
    final show_V_flow=false,
    final Q_flow_maxHeat=Q_flow_maxHeat,
    final Q_flow_maxCool=Q_flow_maxCool,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau,
    final T_start=T_start,
    final energyDynamics=energyDynamics) "Heater or cooler"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(port_a, preDro.port_a) annotation (Line(
      points={{-100,0},{-50,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro.port_b, heaCoo.port_a) annotation (Line(
      points={{-30,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCoo.port_b, port_b) annotation (Line(
      points={{40,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCoo.TSet, TSet) annotation (Line(
      points={{18,8},{0,8},{0,60},{-120,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCoo.Q_flow, Q_flow) annotation (Line(
      points={{41,8},{72,8},{72,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,60},{60,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,5},{99,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,60},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-106,98},{-62,70}},
          lineColor={0,0,127},
          textString="T"),
        Rectangle(
          extent={{60,60},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{72,96},{116,68}},
          lineColor={0,0,127},
          textString="Q_flow")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with a prescribed outlet temperature.
</p>
<p>
This model forces the outlet temperature at <code>port_b</code> to be equal to the temperature
of the input signal <code>TSet</code>, subject to optional limits on the
heating or cooling capacity <code>Q_flow_max</code> and <code>Q_flow_min</code>.
For unlimited capacity, set <code>Q_flow_maxHeat = Modelica.Constant.inf</code>
and <code>Q_flow_maxCool=-Modelica.Constant.inf</code>.
</p>
<p>
The output signal <code>Q_flow</code> is the heat added (for heating) or subtracted (for cooling)
to the medium if the flow rate is from <code>port_a</code> to <code>port_b</code>.
If the flow is reversed, then <code>Q_flow=0</code>.
The outlet temperature at <code>port_a</code> is not affected by this model.
</p>
<p>
If the parameter <code>energyDynamics</code> is not equal to
<code>Modelica.Fluid.Types.Dynamics.SteadyState</code>,
the component models the dynamic response using a first order differential equation.
The time constant of the component is equal to the parameter <code>tau</code>.
This time constant is adjusted based on the mass flow rate using
</p>
<p align=\"center\" style=\"font-style:italic;\">
&tau;<sub>eff</sub> = &tau; |m&#775;| &frasl; m&#775;<sub>nom</sub>
</p>
<p>
where
<i>&tau;<sub>eff</sub></i> is the effective time constant for the given mass flow rate
<i>m&#775;</i> and
<i>&tau;</i> is the time constant at the nominal mass flow rate
<i>m&#775;<sub>nom</sub></i>.
This type of dynamics is equal to the dynamics that a completely mixed
control volume would have.
</p>
<p>
Optionally, this model can have a flow resistance.
If no flow resistance is requested, set <code>dp_nominal=0</code>.
</p>
<p>
For a model that uses a control signal <i>u &isin; [0, 1]</i> and multiplies
this with the nominal heating or cooling power, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>

</p>
<h4>Limitations</h4>
<p>
This model only adds or removes heat for the flow from
<code>port_a</code> to <code>port_b</code>.
The enthalpy of the reverse flow is not affected by this model.
</p>
<p>
This model does not affect the humidity of the air. Therefore,
if used to cool air below the dew point temperature, the water mass fraction
will not change.
</p>
<h4>Validation</h4>
<p>
The model has been validated against the analytical solution in
the examples
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_T\">
Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_T</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_T_dynamic\">
Buildings.Fluid.HeatExchangers.Validation.HeaterCooler_T_dynamic</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 11, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
March 19, 2014, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeaterCooler_T;
