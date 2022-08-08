within Buildings.Fluid.Sensors;
model Velocity "Ideal sensor for flow velocity"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RoundSensor;
  parameter Medium.Density
    d_start=Medium.density(Medium.setState_pTX(p_start, T_start, X_start))
    "Initial or guess value of density"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Temperature used to compute d_start"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Pressure p_start=Medium.p_default
    "Pressure used to compute d_start"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.MassFraction X_start[Medium.nX]=Medium.X_default
    "Mass fraction used to compute d_start"
    annotation (Dialog(group="Initialization"));

  parameter Modelica.Units.SI.Area A "Cross sectional area of flow channel";
  Modelica.Units.SI.VolumeFlowRate V_flow
    "Volume flow rate from port_a to port_b";
  Modelica.Blocks.Interfaces.RealOutput v(final quantity="Velocity",
                                          final unit="m/s")
    "Flow velocity from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));
protected
  Medium.Density dMed(start=d_start)
    "Medium temperature to which the sensor is exposed";

  Medium.Density d_a_inflow(start=d_start)
    "Density of inflowing fluid at port_a";
  Medium.Density d_b_inflow(start=d_start)
    "Density of inflowing fluid at port_b, or rho_a_inflow if uni-directional flow";
  Medium.Density d(start=d_start) "Density of the passing fluid";
initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(d) = 0;
     elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      d = d_start;
    end if;
  end if;
equation
  if allowFlowReversal then
     d_a_inflow = Medium.density(state=
                    Medium.setState_phX(p=port_b.p, h=port_b.h_outflow, X=port_b.Xi_outflow));
     d_b_inflow = Medium.density(state=
                    Medium.setState_phX(p=port_a.p, h=port_a.h_outflow, X=port_a.Xi_outflow));
     dMed = Modelica.Fluid.Utilities.regStep(
              x=port_a.m_flow,
              y1=d_a_inflow,
              y2=d_b_inflow,
              x_small=m_flow_small);
  else
     dMed = Medium.density(state=Medium.setState_phX(
              p=port_b.p,
              h=port_b.h_outflow,
              X=port_b.Xi_outflow));
     d_a_inflow = dMed;
     d_b_inflow = dMed;
  end if;
  // Output signal of density sensor that is used to compute
  // the volume flow rate
  if dynamic then
    der(d) = (dMed-d)*k*tauInv;
  else
    d = dMed;
  end if;
  // Volume flow rate
  V_flow = port_a.m_flow/d;
  // Flow velocity
  v = V_flow / A;
annotation (defaultComponentName="senVel",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Text(
          extent={{48,120},{8,78}},
          textColor={0,0,0},
          textString="v"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Text(
          extent={{180,90},{60,40}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(v, format=".3g")))}),
  Documentation(info="<html>
<p>
This model outputs the flow velocity flowing from
<code>port_a</code> to <code>port_b</code>.
</p>
<p>
The sensor is ideal, i.e., it does not influence the fluid.
If the parameter <code>tau</code> is non-zero, then the measured
density that is used to convert the mass flow rate into
volumetric flow rate is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
<h4>Typical use and important parameters</h4>
<p>
In order to use the flow velocity sensor, the cross sectional area of the flow
channel <code>crossSection</code> must be specified in <code>m<sub>2</sub></code>. For a
circular flow channel (e.g. a round pipe) of diameter <code>diameter</code>, the
cross sectional area can be specified as <code>crossSection = diameter *
diameter / 4 * Modelica.Constants.pi</code>. See
<a href=\"modelica://Buildings.Fluid.Sensors.Examples.Velocity\">
Buildings.Fluid.Sensors.Examples.Velocity</a> for an example implementation
with <code>diameter = 0.1</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
May 20, 2016, by Marcus Fuchs:<br/>
First implementation.
Implementation is based on
<a href=\"modelica://Buildings.Fluid.Sensors.VolumeFlowRate\">
Buildings.Fluid.Sensors.VolumeFlowRate</a>.
</li>
</ul>
</html>"));
end Velocity;
