within Buildings.Fluid.Boilers;
model BoilerBase "Boiler base class with constant efficiency"
  extends Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol,
    show_T = true,
    final tau=VWat*rho_default/m_flow_nominal);

  parameter Modelica.SIunits.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.SIunits.Temperature T_nominal = 353.15
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature)";
  // Assumptions
  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.SIunits.Volume VWat = 1.5E-6*Q_flow_nominal
    "Water volume of boiler"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry =   1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics", enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Efficiency eta_nominal(fixed=false)
    "Boiler efficiency at nominal condition";

  Modelica.SIunits.Efficiency eta = 0.9 "Boiler efficiency";
  Modelica.SIunits.Power QFue_flow = y * Q_flow_nominal/eta_nominal
    "Heat released by fuel";
  Modelica.SIunits.Power QWat_flow = eta * QFue_flow
    "Heat transfer from gas into water";
  Modelica.SIunits.MassFlowRate mFue_flow = QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.SIunits.VolumeFlowRate VFue_flow = mFue_flow/fue.d
    "Fuel volume flow rate";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0)
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port, can be used to connect to ambient"
    annotation (Placement(transformation(extent={{-10,62}, {10,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(
    C=500*mDry,
    T(start=T_start)) if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));



  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-43,-40},{-23,-20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=QWat_flow)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature of fluid"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));
equation

  assert(eta > 0.001, "Efficiency curve is wrong.");

  connect(UAOve.port_b, vol.heatPort)            annotation (Line(
      points={{-28,20},{-22,20},{-22,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UAOve.port_a, heatPort) annotation (Line(
      points={{-48,20},{-52,20},{-52,60},{0,60},{0,72}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCapDry.port, vol.heatPort) annotation (Line(
      points={{-70,12},{-70,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSen.T, T) annotation (Line(
      points={{20,40},{60,40},{60,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo.port, vol.heatPort) annotation (Line(
      points={{-23,-30},{-15,-30},{-15,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_in.y,preHeaFlo. Q_flow) annotation (Line(
      points={{-59,-30},{-43,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.heatPort, temSen.port) annotation (Line(
      points={{-9,-10},{-16,-10},{-16,40},{0,40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Polygon(
          points={{0,-34},{-12,-52},{14,-52},{0,-34}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-100,80},{-80,80},{-80,-44},{-6,-44}},
          smooth=Smooth.None),
        Line(
          points={{100,80},{80,80},{80,4}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{160,144},{40,94}},
          lineColor={0,0,0},
          textString=DynamicSelect("T", String(T-273.15, format=".1f"))),
        Text(
          extent={{-38,146},{-158,96}},
          lineColor={0,0,0},
          textString=DynamicSelect("y", String(y, format=".2f")))}),
defaultComponentName="boi",
Documentation(info="<html>
<p>This is a base model of a boiler whose efficiency is constant which can be modified in extended models. The heat input into the medium is</p>
<p align=\"center\"><i>Q̇ = y Q̇<sub>0</sub> &eta; &frasl; &eta;<sub>0</sub> </i></p>
<p>where <i>y &isin; [0, 1]</i> is the control signal, <i>Q̇<sub>0</i></sub> is the nominal power, <i>&eta;</i> is the efficiency at the current operating point, and <i>&eta;<sub>0</i></sub> is the efficiency at <i>y=1</i> and nominal temperature <i>T=T<sub>0</i></sub> as specified by the parameter <span style=\"font-family: monospace;\">T_nominal</span>. </p>
<p>The efficiency is defined as </p>
<p align=\"center\"><i>&eta;</i> = <i>Q̇</i> &frasl; <i>Q̇<sub>f</i></sub>, </p>
<p>where <i>Q̇</i> is the heat transferred to the working fluid (typically water or air), and <i>Q̇<sub>f</i></sub> is the heat of combustion released by the fuel. It is a constant in this base model but can be further specified in extended models.</p>
<p>The parameter <span style=\"font-family: monospace;\">Q_flow_nominal</span> is the power transferred to the fluid for <i><span style=\"font-family: monospace;\">y</span></i>=1 and, if the efficiency depends on temperature in the extended polynomial boiler model, for <span style=\"font-family: monospace;\">T=T0</span>. </p>
<p>The fuel mass flow rate and volume flow rate are computed as </p>
<p align=\"center\"><i>ṁ<sub>f</sub> = Q̇<sub>f</sub> &frasl; h<sub>f</sub> </i></p>
<p>and </p>
<p align=\"center\"><i>V̇<sub>f</sub> = ṁ<sub>f</sub> &frasl; &rho;<sub>f</sub>, </i></p>
<p>where the fuel heating value <i>h<sub>f</i></sub> and the fuel mass density <i>&rho;<sub>f</i></sub> are obtained from the parameter <span style=\"font-family: monospace;\">fue</span>. Note that if <i>&eta;</i> is the efficiency relative to the lower heating value, then the fuel properties also need to be used for the lower heating value. </p>
<p>Optionally, the port <span style=\"font-family: monospace;\">heatPort</span> can be connected to a heat port outside of this model to impose a boundary condition in order to model heat losses to the ambient. When using this <span style=\"font-family: monospace;\">heatPort</span>, make sure that the efficiency does not already account for this heat loss. </p>
<p>On the Assumptions tag, the model can be parameterized to compute a transient or steady-state response. The transient response of the boiler is computed using a first order differential equation to compute the boiler&apos;s water and metal temperature, which are lumped into one state. The boiler outlet temperature is equal to this water temperature. </p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2021, by Hongxiang Fu:<br/>
Renamed from 
<code>Buildings.Fluid.Boilers.BoilerPolynomial</code>
. The code for efficiency specification is moved to new 
<a href=\"Modelica://Buildings.Fluid.Boilers.BoilerPolynomial\">
<code>Buildings.Fluid.Boilers.BoilerPolynomial</code></a>
. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>
.
</li>
<li>
May 27, 2016, by Michael Wetter:<br/>
Corrected size of input argument to
<code>Buildings.Utilities.Math.Functions.quadraticLinear</code>
for JModelica compliance check.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
October 9, 2013 by Michael Wetter:<br/>
Removed conditional declaration of <code>mDry</code> as the use of a conditional
parameter in an instance declaration is not correct Modelica syntax.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
December 22, 2011 by Michael Wetter:<br/>
Added computation of fuel usage and improved the documentation.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Removed parameter <code>dT_nominal</code>, and require instead
the parameter <code>m_flow_nominal</code> to be set by the user.
This was needed to avoid a non-literal value for the nominal attribute
of the pressure drop model.
</li>
<li>
Changed assignment of parameters in model instantiation, and updated
model for the new base class that does not have a temperature sensor.
</li>
</ul>
</li>
<li>
January 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerBase;
