within Buildings.Fluid.HeatExchangers;
model SensibleCooler_T
  "Sensible cooling device with prescribed outlet temperature"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialPrescribedOutlet(
    outCon(
      final QMin_flow = QMin_flow,
      final QMax_flow = 0,
      final mWatMax_flow = 0,
      final mWatMin_flow = 0,
      final use_TSet = true,
      final use_X_wSet = false,
      final T_start=T_start,
      final X_start=Medium.X_default));

  parameter Modelica.Units.SI.HeatFlowRate QMin_flow(max=0) = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)" annotation (Evaluate=true);

  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Start value of temperature" annotation (Dialog(tab="Initialization"));

  Modelica.Blocks.Interfaces.RealInput TSet(
    unit="K",
    displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,80},
              extent={{20,-20},{-20,20}},rotation=180)));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat flow rate added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

equation
  connect(TSet, outCon.TSet) annotation (Line(points={{-120,80},{10,80},{10,8},
          {19,8}},color={0,0,127}));
  connect(outCon.Q_flow, Q_flow) annotation (Line(points={{41,8},{80,8},{80,80},
          {110,80}}, color={0,0,127}));
    annotation (
    defaultComponentName="coo",
Documentation(info="<html>
<p>
Model for an ideal sensible-only cooler that controls its outlet temperature to
a prescribed outlet temperature.
</p>
<p>
This model forces the outlet temperature at <code>port_b</code> to be
no higher than the temperature of the input signal
<code>TSet</code>, subject to optional limits on the
capacity.
By default, the model has unlimited cooling capacity.
</p>
<p>
The output signal <code>Q_flow &le; 0</code> is the heat added
to the medium if the mass flow rate is from <code>port_a</code> to <code>port_b</code>.
If the flow is reversed, then <code>Q_flow=0</code>.
</p>
<p>
The outlet conditions at <code>port_a</code> are not affected by this model,
other than for a possible pressure difference due to flow friction.
</p>
<p>
If the parameter <code>energyDynamics</code> is different from
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
Set <code>dp_nominal = 0</code> to disable the flow friction calculation.
</p>
<p>
For a similar model that is a heater, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Heater_T\">
Buildings.Fluid.HeatExchangers.Heater_T</a>.
For a model that uses a control signal <i>u &isin; [0, 1]</i> and multiplies
this with the nominal heating or cooling power, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>.
</p>
<h4>Limitations</h4>
<p>
If the flow is from <code>port_b</code> to <code>port_a</code>,
then the enthalpy of the medium is not affected by this model.
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
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet\">
Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet</a>
and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet_dynamic\">
Buildings.Fluid.HeatExchangers.Validation.PrescribedOutlet_dynamic</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 10, 2018, by Michael Wetter:<br/>
Corrected missing propagation of initial conditions.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1016\">
Buildings, #1016</a>.
</li>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
                   Text(
          extent={{20,-10},{64,-56}},
          textColor={255,255,255},
          textString="-"),
        Rectangle(
          extent={{-64,34},{-34,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-64,34},{-52,44},{-64,54}}, color={0,0,0}),
        Text(
          extent={{26,108},{94,84}},
          textColor={0,0,127},
          textString="Q_flow"),
        Rectangle(
          extent={{70,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,60},{70,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,60},{-66,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,82},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,102},{-74,84}},
          textColor={0,0,127},
          textString="T")}));
end SensibleCooler_T;
