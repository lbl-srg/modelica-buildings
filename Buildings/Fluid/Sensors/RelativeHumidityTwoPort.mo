within Buildings.Fluid.Sensors;
model RelativeHumidityTwoPort "Ideal two port relative humidity sensor"
  extends Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor;
  extends Modelica.Icons.RoundSensor;
  Modelica.Blocks.Interfaces.RealOutput phi(final unit="1",
                                            min=0,
                                            start=phi_start)
    "Relative humidity of the passing fluid"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
        origin={1,110})));
  parameter Real phi_start(final unit="1", min=0, max=1)=0.5
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

protected
  Real phiMed(final unit="1", min=0, start=phi_start)
    "Relative humidity to which the sensor is exposed to";

protected
  Modelica.Units.SI.Temperature T_a
    "Temperature of the medium flowing from port_a to port_b";
  Medium.MassFraction Xi_a[Medium.nXi](
    quantity=Medium.substanceNames[1:Medium.nXi])
    "Mass fraction of the medium flowing from port_a to port_b";
  Real phi_a(final unit="1")
    "Relative humidity of the medium flowing from port_a to port_b";
  Modelica.Units.SI.Temperature T_b
    "Temperature of the medium flowing from port_b to port_a";
  Medium.MassFraction Xi_b[Medium.nXi](
    quantity=Medium.substanceNames[1:Medium.nXi])
    "Mass fraction of the medium flowing from port_b to port_a";
  Real phi_b(final unit="1")
    "Relative humidity of the medium flowing from port_b to port_a";

initial equation
  if dynamic then
    if initType == Modelica.Blocks.Types.Init.SteadyState then
      der(phi) = 0;
    elseif initType == Modelica.Blocks.Types.Init.InitialState or
           initType == Modelica.Blocks.Types.Init.InitialOutput then
      phi = phi_start;
    end if;
  end if;
equation

  // Since the sensor does not affect the medium, we can use
  // port_b.Xi_outflow = inStream(port_a.Xi_outflow).
  Xi_a = port_b.Xi_outflow;

  T_a=Medium.temperature_phX(
      p=port_a.p,
      h=port_b.h_outflow,
      X=Xi_a);

  phi_a = Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
    p=port_a.p,
    T=T_a,
    X_w=Xi_a[1]);

  if allowFlowReversal then
    phi_b = Buildings.Utilities.Psychrometrics.Functions.phi_pTX(
      p=port_b.p,
      T=T_b,
      X_w=Xi_b[1]);
    T_b=Medium.temperature_phX(
      p=port_b.p,
      h=port_a.h_outflow,
      X=Xi_b);
    Xi_b = port_a.Xi_outflow;
    phiMed = Modelica.Fluid.Utilities.regStep(
               x=port_a.m_flow,
               y1=phi_a,
               y2=phi_b,
               x_small=m_flow_small);
  else
    phi_b = 0;
    T_b = 273.15;
    Xi_b = zeros(Medium.nXi);
    phiMed = phi_a;
  end if;
  // Output signal of sensor
  if dynamic then
    der(phi) = (phiMed-phi)*k*tauInv;
  else
    phi = phiMed;
  end if;
annotation (defaultComponentName="senRelHum",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Text(
          extent={{102,124},{6,95}},
          textColor={0,0,0},
          textString="phi"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255}),
        Text(
          extent={{-20,120},{-140,70}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(phi, leftJustified=false, significantDigits=2)))}),
  Documentation(info="<html>
<p>
This model outputs the relative humidity of the fluid flowing from
<code>port_a</code> to <code>port_b</code>.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
Note that this sensor can only be used with media that contain the variable <code>phi</code>,
which is typically the case for moist air models.
</p>
<p>
If the parameter <code>tau</code> is non-zero, then its output
is computed using a first order differential equation.
Setting <code>tau=0</code> is <i>not</i> recommend. See
<a href=\"modelica://Buildings.Fluid.Sensors.UsersGuide\">
Buildings.Fluid.Sensors.UsersGuide</a> for an explanation.
</p>
</html>", revisions="<html>
<ul>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
January 26, 2016 by Michael Wetter:<br/>
Added <code>quantity</code> attribute for mass fraction variables.<br/>
Made unit assignment of output signal final.
</li>
<li>
January 18, 2016 by Filip Jorissen:<br/>
Using parameter <code>tauInv</code>
since this now exists in
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor\">Buildings.Fluid.Sensors.BaseClasses.PartialDynamicFlowSensor</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/372\">#372</a>.
</li>
<li>
June 3, 2011 by Michael Wetter:<br/>
Revised implementation to add dynamics in such a way that
the time constant increases as the mass flow rate tends to zero.
This significantly improves the numerics.
</li>
<li>
Feb. 5, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidityTwoPort;
