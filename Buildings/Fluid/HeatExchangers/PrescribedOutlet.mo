within Buildings.Fluid.HeatExchangers;
model PrescribedOutlet
  "Ideal heater, cooler, humidifier or dehumidifier with prescribed outlet conditions"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialPrescribedOutlet(
    outCon(
      final T_start=T_start,
      final X_start=X_start,
      final use_TSet = use_TSet,
      final use_X_wSet = use_X_wSet,
      final QMax_flow = QMax_flow,
      final QMin_flow = QMin_flow,
      final mWatMax_flow = mWatMax_flow,
      final mWatMin_flow = mWatMin_flow,
      final energyDynamics = energyDynamics,
      final massDynamics = massDynamics));

  parameter Modelica.SIunits.HeatFlowRate QMax_flow(min=0) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)"
    annotation (Evaluate=true, Dialog(enable=use_TSet));
  parameter Modelica.SIunits.HeatFlowRate QMin_flow(max=0) = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)"
    annotation (Evaluate=true, Dialog(enable=use_TSet));

  parameter Modelica.SIunits.MassFlowRate mWatMax_flow(min=0) = Modelica.Constants.inf
    "Maximum water mass flow rate addition (positive)"
    annotation (Evaluate=true, Dialog(enable=use_X_wSet));
  parameter Modelica.SIunits.MassFlowRate mWatMin_flow(max=0) = -Modelica.Constants.inf
    "Maximum water mass flow rate removal (negative)"
    annotation (Evaluate=true, Dialog(enable=use_X_wSet));

  parameter Modelica.SIunits.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable=use_TSet));
  parameter Modelica.SIunits.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=use_X_wSet and Medium.nXi > 0));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations", enable=use_TSet));

  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations", enable=use_X_wSet));

  parameter Boolean use_TSet = true
    "Set to false to disable temperature set point"
    annotation(Evaluate=true);

  parameter Boolean use_X_wSet = true
    "Set to false to disable water vapor set point"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput TSet(
    unit="K",
    displayUnit="degC") if use_TSet
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,80},
              extent={{20,-20},{-20,20}},rotation=180)));

  Modelica.Blocks.Interfaces.RealInput X_wSet(unit="1") if use_X_wSet
    "Set point for water vapor mass fraction of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,40},
              extent={{20,-20},{-20,20}},rotation=180)));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat flow rate added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput mWat_flow(unit="kg/s")
    "Water vapor mass flow rate added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

equation
  connect(outCon.X_wSet, X_wSet) annotation (Line(points={{19,4},{-20,4},{-20,
          40},{-120,40}},
                      color={0,0,127}));
  connect(outCon.mWat_flow, mWat_flow) annotation (Line(points={{41,4},{80,4},{80,
          40},{110,40}}, color={0,0,127}));
  connect(outCon.TSet, TSet) annotation (Line(points={{19,8},{-16,8},{-16,80},{
          -120,80}},
                color={0,0,127}));
  connect(outCon.Q_flow, Q_flow) annotation (Line(points={{41,8},{76,8},{76,80},
          {110,80}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-64,34},{-34,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-64,34},{-52,44},{-64,54}}, color={0,0,0}),
        Text(
          extent={{-98,64},{-76,42}},
          lineColor={0,0,127},
          visible=use_X_wSet,
          textString="X_w"),
        Text(
          extent={{-106,102},{-74,88}},
          lineColor={0,0,127},
          visible=use_TSet,
          textString="T"),
        Rectangle(
          extent={{-100,82},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          visible=use_TSet,
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          visible=use_X_wSet,
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,60},{-66,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          visible=use_TSet,
          fillPattern=FillPattern.Solid),
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
        Text(
          extent={{74,72},{120,44}},
          lineColor={0,0,127},
          textString="mWat_flow"),
        Rectangle(
          extent={{70,41},{100,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{72,108},{120,92}},
          lineColor={0,0,127},
          textString="Q_flow")}),
defaultComponentName="preOut",
Documentation(info="<html>
<p>
Model that allows specifying the temperature and mass fraction of the fluid
that leaves the model from <code>port_b</code>.
</p>
<p>
This model forces the outlet temperature at <code>port_b</code> to be equal to the temperature
of the input signal <code>TSet</code>, subject to optional limits on the
heating or cooling capacity <code>QMax_flow &ge; 0</code> and <code>QMin_flow &le; 0</code>.
Similarly than for the temperature,
this model also forces the outlet water mass fraction at <code>port_b</code> to be
no lower than the
input signal <code>X_wSet</code>, subject to optional limits on the
maximum water vapor mass flow rate that is added, as
described by the parameter <code>mWatMax_flow</code>.
By default, the model has unlimited capacity, but control of temperature
and humidity can be subject to capacity limits, or be disabled.
</p>
<p>
The output signal <code>Q_flow</code> is the heat added (for heating) or subtracted (for cooling)
to the medium if the flow rate is from <code>port_a</code> to <code>port_b</code>.
If the flow is reversed, then <code>Q_flow=0</code>.
</p>
<p>
The outlet conditions at <code>port_a</code> are not affected by this model.
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
This model only adds or removes heat or water vapor for the flow from
<code>port_a</code> to <code>port_b</code>.
The enthalpy of the reverse flow is not affected by this model.
</p>
<p>
If this model is used to cool air below the dew point temperature, the water mass fraction
will not change.
</p>
<p>
Note that for <code>use_TSet = false</code>, the enthalpy of the leaving fluid
will not be changed, even if moisture is added. The enthalpy added (or removed)
by the change in humidity is neglected. To properly account for change in enthalpy
due to humidification, use instead
<a href=\"Buildings.Fluid.Humidifiers.SprayAirWasher_X\">
Buildings.Fluid.Humidifiers.SprayAirWasher_X</a>.
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
May 3, 2017, by Michael Wetter:<br/>
Updated protected model for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">#763</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
Updated model as <code>use_dh</code> is no longer a parameter in the pressure drop model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
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
end PrescribedOutlet;
