within Buildings.Fluid.Sensors.BaseClasses;
partial model PartialAbsoluteSensor
  "Partial component to model a sensor that measures a potential variable"

  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium in the sensor"
    annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Boolean warnAboutOnePortConnection = true
   "Set to false to suppress warning about potential numerical issues, see Buildings.Fluid.Sensors.UsersGuide for more information"
   annotation(HideResult=true);
  Modelica.Fluid.Interfaces.FluidPort_a port(redeclare package Medium=Medium, m_flow(min=0))
    annotation (Placement(transformation(
        origin={0,-100},
        extent={{-10,-10},{10,10}},
        rotation=90)));

protected
  parameter String instanceName = getInstanceName() "Name of the instance";
initial equation
  assert(not warnAboutOnePortConnection,
  "Sensor " + instanceName + " can lead to numerical problems if connected to a scalar fluid port.
  Only connect it to a vectorized fluid port, such as used in 'Buildings.Fluid.MixingVolumes`.
  See Buildings.Fluid.Sensors.UsersGuide for more information.
  To disable this warning, set 'warnAboutOnePortConnection = false' in " + instanceName + ".",
  level=AssertionLevel.warning);
equation
  port.m_flow = 0;
  port.h_outflow = 0;
  port.Xi_outflow = zeros(Medium.nXi);
  port.C_outflow = zeros(Medium.nC);
  annotation (Documentation(info="<html>
<p>
Partial component to model an absolute sensor.
The component can be used for pressure sensor models.
Use for other properties such as temperature or density is discouraged, because the enthalpy at the connector can have different meanings, depending on the connection topology. For these properties, use
<a href=\"modelica://Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor\">
Buildings.Fluid.Sensors.BaseClasses.PartialFlowSensor</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 20, 2020, by Michael Wetter:<br/>
Introduced parameter <code>warnAboutOnePortConnection</code> and added assertion with level set to warning.</br>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1399\"> #1399</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
September 7, 2018, by Michael Wetter:<br/>
Changed
<code>port(redeclare package Medium=Medium, m_flow(min=0, max=0))</code>
to
<code>port(redeclare package Medium=Medium, m_flow(min=0))</code>
to avoid in Dymola 2019FD01 beta1 the message
\"port.m_flow has the range [0,0] - which is suspicious since the max-value should be above the min-value\"
which causes an error in pedantic mode.
Note that the MSL also uses only a <code>min</code> value.
</li>
<li>
March 22, 2017, by Filip Jorissen:<br/>
Set <code>m_flow(max=0)</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/687\">#687</a>.
</li>
<li>
February 12, 2011, by Michael Wetter:<br/>
First implementation.
Implementation is based on <code>Modelica.Fluid</code>.
</li>
</ul>
</html>"),
Icon(
  graphics={
    Bitmap(
      visible = warnAboutOnePortConnection,
      extent={{-96,-82},{-64,-50}},
      fileName="modelica://Buildings/Resources/Images/Fluid/Sensors/warningIcon.png")}));
end PartialAbsoluteSensor;
