within Buildings.Fluid.Humidifiers;
model SprayAirWasher_X
  "Spray air washer with leaving water mass fraction as input"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialPrescribedOutlet(
    redeclare replaceable package Medium =
        Modelica.Media.Interfaces.PartialCondensingGases,
    outCon(
      final T_start=293.15,
      final X_start=X_start,
      final use_TSet = true,
      final use_X_wSet = true,
      final QMax_flow = Modelica.Constants.inf,
      final QMin_flow = -Modelica.Constants.inf,
      final mWatMax_flow = mWatMax_flow,
      final mWatMin_flow = 0));

  parameter Modelica.Units.SI.MassFlowRate mWatMax_flow(min=0) = Modelica.Constants.inf
    "Maximum water mass flow rate addition (positive)"
    annotation (Evaluate=true);

  parameter Modelica.Units.SI.MassFraction X_start[Medium.nX]=Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization"));

  // Set maximum to a high value to avoid users mistakenly entering relative humidity.
  Modelica.Blocks.Interfaces.RealInput X_w(
    unit="1",
    min=0,
    max=0.03)
    "Set point for water vapor mass fraction in kg/kg total air of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Modelica.Blocks.Interfaces.RealOutput mWat_flow(unit="kg/s")
    "Water added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

protected
  constant Modelica.Units.SI.SpecificEnthalpy hSte=Medium.enthalpyOfLiquid(T=
      283.15) "Enthalpy of water at 10 degree Celsius";

  Modelica.Units.SI.SpecificEnthalpy hLea=inStream(port_a.h_outflow) + {hSte}*(
      port_b.Xi_outflow - inStream(port_a.Xi_outflow))
    "Approximation of leaving enthalpy, based on dh/dx=h_fg";

  Modelica.Blocks.Sources.RealExpression TLea(y=
    Medium.temperature_phX(p = port_b.p,
                           h = hLea,
                           X = port_b.Xi_outflow)) "Leaving air temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
equation
  connect(X_w, outCon.X_wSet)
    annotation (Line(points={{-120,60},{-20,60},{-20,4},{19,4}},
                                                             color={0,0,127}));
  connect(outCon.mWat_flow, mWat_flow) annotation (Line(points={{41,4},{80,4},{80,
          60},{110,60}}, color={0,0,127}));

  connect(TLea.y, outCon.TSet)
    annotation (Line(points={{11,20},{14,20},{14,8},{19,8}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,62,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,98},{-64,80}},
          textColor={0,0,127},
          textString="X_w"),
        Text(
          extent={{32,116},{98,62}},
          textColor={0,0,127},
          textString="mWat_flow"),
        Rectangle(
          extent={{-100,62},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,62},{100,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,34},{-34,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-64,34},{-52,44},{-64,54}}, color={0,0,0}),
        Rectangle(
          extent={{58,-54},{54,52}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},
              {42,-28},{42,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{
              42,10}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,
              40},{42,42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="hum",
Documentation(info="<html>
<p>
Model for a spray air washer with a prescribed outlet water vapor mass fraction
in kg/kg total air.
</p>
<p>
This model forces the outlet water mass fraction at <code>port_b</code> to be
no lower than the
input signal <code>X_wSet</code>, subject to optional limits on the
maximum water vapor mass flow rate that is added, as
described by the parameter <code>mWatMax_flow</code>.
By default, the model has unlimited capacity.
</p>
<p>
The output signal <code>mWat_flow &ge; 0</code> is the moisture added
to the medium if the flow rate is from <code>port_a</code> to <code>port_b</code>.
If the flow is reversed, then <code>mWat_flow = 0</code>.
The outlet specific enthalpy at <code>port_b</code> is increased by
the enthalpy of liquid water at <i>10</i>&deg;C times the mass of water that was added.
Therefore, the temperature of the leaving fluid is below the inlet temperature.
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
For a model that uses a control signal <i>u &isin; [0, 1]</i> and multiplies
this with the nominal water mass flow rate, use
<a href=\"modelica://Buildings.Fluid.Humidifiers.Humidifier_u\">
Buildings.Fluid.Humidifiers.Humidifier_u</a>

</p>
<h4>Limitations</h4>
<p>
This model only adds water vapor for the flow from
<code>port_a</code> to <code>port_b</code>.
The water vapor of the reverse flow is not affected by this model.
</p>
<p>
This model does not affect the enthalpy of the air. Therefore,
if water is added, the temperature will decrease, e.g., the humidification
is adiabatic.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 8, 2022, by Michael Wetter:<br/>
Renamed parameter <code>massDynamics</code> to <code>energyDynamics</code> for consistency with other models.
</li>
<li>
December 14, 2018, by Michael Wetter:<br/>
Restricted base class for medium to one that implements
the function <code>enthalpyOfLiquid</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1057\">#1057</a>.
</li>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SprayAirWasher_X;
