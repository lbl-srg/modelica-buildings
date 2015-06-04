within Buildings.Fluid.Boilers;
model BoilerPolynomial
  "Boiler with efficiency curve described by a polynomial of the temperature"
  extends Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol,
    show_T = true,
    final tau=VWat*rho_default/m_flow_nominal);

  parameter Modelica.SIunits.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.SIunits.Temperature T_nominal = 353.15
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature)";
  // Assumptions
  parameter Buildings.Fluid.Types.EfficiencyCurves effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency";
  parameter Real a[:] = {0.9} "Coefficients for efficiency curve";

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

  Real eta(min=0) "Boiler efficiency";

  Modelica.SIunits.Power QFue_flow "Heat released by fuel";
  Modelica.SIunits.Power QWat_flow "Heat transfer from gas into water";
  Modelica.SIunits.MassFlowRate mFue_flow "Fuel mass flow rate";
  Modelica.SIunits.VolumeFlowRate VFue_flow "Fuel volume flow rate";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
protected
  Real eta_nominal "Boiler efficiency at nominal condition";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port, can be used to connect to ambient"
                             annotation (Placement(transformation(extent={{-10,62},
            {10,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(C=500*mDry,
      T(start=T_start)) if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0)
                                          annotation (Placement(
        transformation(extent={{100,70},{120,90}})));
protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-43,-40},{-23,-20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=QWat_flow)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature of fluid"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation
  if effCur ==Buildings.Fluid.Types.EfficiencyCurves.Constant then
    eta  = a[1];
    eta_nominal = a[1];
  elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.Polynomial then
    eta  = Buildings.Utilities.Math.Functions.polynomial(
                                                   a=a, x=y);
    eta_nominal = Buildings.Utilities.Math.Functions.polynomial(
                                                          a=a, x=1);
  elseif effCur ==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear then
    eta  = Buildings.Utilities.Math.Functions.quadraticLinear(
                                                        a=a, x1=y, x2=T);
    eta_nominal = Buildings.Utilities.Math.Functions.quadraticLinear(
                                                               a=a, x1=1, x2=T_nominal);
  else
    eta  = 0;
    eta_nominal = 999;
  end if;
  assert(eta > 0.001, "Efficiency curve is wrong.");
  // Heat released by fuel
  QFue_flow = y * Q_flow_nominal/eta_nominal;
  // Heat input into water
  QWat_flow = eta * QFue_flow;
  // Fuel mass flow rate and volume flow rate
  mFue_flow = QFue_flow/fue.h;
  VFue_flow = mFue_flow/fue.d;
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
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
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
        Text(
          extent={{-140,138},{-94,100}},
          lineColor={0,0,127},
          textString="y"),
        Text(
          extent={{88,128},{134,90}},
          lineColor={0,0,127},
          textString="T"),
        Line(
          points={{100,80},{80,80},{80,20},{6,20}},
          color={0,0,127},
          smooth=Smooth.None)}),
defaultComponentName="boi",
Documentation(info="<html>
<p>
This is a model of a boiler whose efficiency is described
by a polynomial.
The heat input into the medium is</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q&#775; = y Q&#775;<sub>0</sub> &eta; &frasl; &eta;<sub>0</sub>
</p>
<p>
where
<i>y &isin; [0, 1]</i> is the control signal,
<i>Q&#775;<sub>0</sub></i> is the nominal power,
<i>&eta;</i> is the efficiency at the current operating point, and
<i>&eta;<sub>0</sub></i> is the efficiency at <i>y=1</i> and
nominal temperature <i>T=T<sub>0</sub></i> as specified by the parameter
<code>T_nominal</code>.
</p>
<p>
The parameter <code>effCur</code> determines what polynomial is used
to compute the efficiency, which is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = Q&#775; &frasl; Q&#775;<sub>f</sub>,
</p>
<p>
where
<i>Q&#775;</i> is the heat transferred to the working fluid (typically water or air), and
<i>Q&#775;<sub>f</sub></i> is the heat of combustion released by the fuel.
</p>
<p>
The following polynomials can be selected to compute the efficiency:
</p>
<table summary=\"summary\"  border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Parameter <code>effCur</code></th>
<th>Efficiency curve</th>
</tr>
<tr>
<td>Buildings.Fluid.Types.EfficiencyCurves.Constant</td>
<td><i>&eta; = a<sub>1</sub></i></td>
</tr>
<tr>
<td>Buildings.Fluid.Types.EfficiencyCurves.Polynomial</td>
<td><i>&eta; = a<sub>1</sub> + a<sub>2</sub> y + a<sub>3</sub> y<sup>2</sup> + ...</i></td>
</tr>
<tr>
<td>Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear</td>
<td><i>&eta; = a<sub>1</sub> + a<sub>2</sub>  y
        + a<sub>3</sub> y<sup>2</sup>
        + (a<sub>4</sub> + a<sub>5</sub>  y
        + a<sub>6</sub> y<sup>2</sup>)  T
</i></td>
</tr>
</table>

<p>
where <i>T</i> is the boiler outlet temperature in Kelvin.
For <code>effCur = Buildings.Fluid.Types.EfficiencyCurves.Polynomial</code>,
an arbitrary number of polynomial coefficients can be specified.
</p>
<p>
The parameter <code>Q_flow_nominal</code> is the power transferred to the fluid
for <code>y=1</code> and, if the efficiency depends on temperature,
for <code>T=T0</code>.
</p>
<p>
The fuel mass flow rate and volume flow rate are computed as </p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775;<sub>f</sub> = Q&#775;<sub>f</sub> &frasl; h<sub>f</sub>
</p>
<p> and </p>
<p align=\"center\" style=\"font-style:italic;\">
  V&#775;<sub>f</sub> = m&#775;<sub>f</sub> &frasl; &rho;<sub>f</sub>,
</p>
<p>
where the fuel heating value
<i>h<sub>f</sub></i> and the fuel mass density
<i>&rho;<sub>f</sub></i> are obtained from the
parameter <code>fue</code>.
Note that if <i>&eta;</i> is the efficiency relative to the lower heating value,
then the fuel properties also need to be used for the lower heating value.
</p>

<p>
Optionally, the port <code>heatPort</code> can be connected to a heat port
outside of this model to impose a boundary condition in order to
model heat losses to the ambient. When using this <code>heatPort</code>,
make sure that the efficiency curve <code>effCur</code>
does not already account for this heat loss.
</p>

<p>
On the Assumptions tag, the model can be parameterized to compute a transient
or steady-state response.
The transient response of the boiler is computed using a first
order differential equation to compute the boiler's water and metal temperature,
which are lumped into one state. The boiler outlet temperature is equal to this water temperature.
</p>

</html>", revisions="<html>
<ul>
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
end BoilerPolynomial;
