within Buildings.Fluids.Boilers;
model BoilerPolynomial
  "Boiler with efficiency curve described by a polynomial of the temperature"

  extends Interfaces.PartialDynamicTwoPortTransformer(
    m_flow_nominal=Q_flow_nominal/dT_nominal/cp_nominal, final tau=0,
    vol(final V =   VWat));
  annotation (Diagram(graphics), Icon(graphics={
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
          pattern=LinePattern.None,
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
    Documentation(info="<html>
This is a model of a boiler that computes the heat transferred
to the medium based on an input control signal.
The efficiency of the boiler can be computed using polynomials
in the control signal <tt>y</tt> and
the boiler temperature <tt>T</tt>.
</p>
<p>
The parameter <tt>Q_flow_nominal</tt> is the power transferred to the fluid
for <tt>y=1</tt> and, if the efficiency depends on temperature, 
for <tt>T=T0</tt>.
</p>
<p>
Optionally, the port <tt>heatPort</tt> can be connected to a heat port
outside of this model to impose a boundary condition in order to
model heat losses to the ambient. When using this <tt>heatPort</tt>,
make sure that the efficiency curve <tt>effCur</tt>
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
January 29, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  parameter Modelica.SIunits.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.SIunits.Temperature T_nominal = 353.15
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature)";
  // Assumptions
  parameter Buildings.Fluids.Types.EfficiencyCurves effCur=Buildings.Fluids.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency";
  parameter Real a[:] = {0.9} "Coefficients for efficiency curve";
  parameter Modelica.SIunits.TemperatureDifference dT_nominal(min=0)
    "Temperature difference of water loop at nominal load";
  parameter Modelica.SIunits.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.SIunits.Volume VWat = 1.5E-6*Q_flow_nominal
    "Water volume of boiler" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics", enable = not (energyDynamics == Modelica_Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Mass mDry =   1.5E-3*Q_flow_nominal if 
        not (energyDynamics == Modelica_Fluid.Types.Dynamics.SteadyState)
    "Mass of boiler that will be lumped to water heat capacity" 
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics", enable = not (energyDynamics == Modelica_Fluid.Types.Dynamics.SteadyState)));

  Real eta(min=0) "Boiler efficiency";

  Modelica.SIunits.Power QFue_flow "Sensible heat released by fuel";
  Modelica.SIunits.Power QWat_flow "Heat transfer from gas into water";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio" 
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0)));
protected
  Real eta_nominal "Boiler efficiency at nominal condition";

protected
   parameter Modelica.SIunits.SpecificHeatCapacity cp_nominal=Medium.specificHeatCapacityCp(sta_nominal)
    "Specific heat capacity of fluid in boiler";
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)" 
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port, can be used to connect to ambient" 
                             annotation (Placement(transformation(extent={{-10,62},
            {10,82}},            rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(C=500*mDry,
      T(start=T_start)) if not (energyDynamics == Modelica_Fluid.Types.Dynamics.SteadyState)
    "heat capacity of boiler metal" 
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));
  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0) 
                                          annotation (Placement(
        transformation(extent={{100,70},{120,90}}, rotation=0)));
public
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo 
    annotation (Placement(transformation(extent={{-43,-40},{-23,-20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=QWat_flow) 
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  if effCur ==Buildings.Fluids.Types.EfficiencyCurves.Constant then
    eta  = a[1];
    eta_nominal = a[1];
  elseif effCur ==Buildings.Fluids.Types.EfficiencyCurves.Polynomial then
    eta  = Buildings.Utilities.Math.Functions.polynomial(
                                                   a=a, x=y);
    eta_nominal = Buildings.Utilities.Math.Functions.polynomial(
                                                          a=a, x=1);
  elseif effCur ==Buildings.Fluids.Types.EfficiencyCurves.QuadraticLinear then
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
      points={{25,40},{60,40},{60,80},{110,80}},
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
end BoilerPolynomial;
