within Buildings.Examples.Tutorial.Boiler;
model System2
  "2nd part of the system model, consisting of the room with heat transfer and a radiator"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;

//-------------------------Step 2: Water as medium-------------------------//
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";
//-------------------------------------------------------------------------//

//------------------------Step 4: Design conditions------------------------//
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.Units.SI.Temperature TRadSup_nominal=273.15 + 50
    "Radiator nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TRadRet_nominal=273.15 + 40
    "Radiator nominal return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=Q_flow_nominal/
      4200/(TRadSup_nominal - TRadRet_nominal)
    "Radiator nominal mass flow rate";
//------------------------------------------------------------------------//

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=4000
    "Internal heat gains of the room";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut(T=263.15)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTab(
      extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
      table=[-6, 0;
              8, QRooInt_flow;
             18, 0],
      timeScale=3600) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

//-------------------------Step 5: Radiator Model-------------------------//
 Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal) "Radiator"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
//------------------------------------------------------------------------//

  Buildings.Fluid.Sources.Boundary_pT sin(nPorts=1, redeclare package Medium = MediumW)
    "Sink for mass flow rate"           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "Supply water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-40,30})));

//------------------------Step 5: Pump for radiator-----------------------//
Buildings.Fluid.Movers.FlowControlled_m_flow pumRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mRad_flow_nominal) "Pump for radiator"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-70})));

//------------------------------------------------------------------------//

  Buildings.Fluid.Sources.Boundary_pT sou(
    nPorts=1,
    redeclare package Medium = MediumW,
    T=TRadSup_nominal) "Sink for mass flow rate"
                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-110})));

//--------------------------Step 6: Pump control--------------------------//
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysPum(
    uLow=273.15 + 19,
    uHigh=273.15 + 21)
    "Pump hysteresis"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
//------------------------------------------------------------------------//

equation
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{5.55112e-16,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{2,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-50,-30},{-50,-10},{-5.55112e-16,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad.port_b, sin.ports[1]) annotation (Line(
      points={{20,-10},{50,-10},{50,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort) annotation (Line(
      points={{-30,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{8,-2.8},{8,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{12,-2.8},{12,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], pumRad.port_a) annotation (Line(
      points={{-50,-100},{-50,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port_a) annotation (Line(
      points={{-50,-60},{-50,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.T, hysPum.u) annotation (Line(
      points={{-50,30},{-234,30},{-234,-70},{-222,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y, not1.u) annotation (Line(
      points={{-198,-70},{-182,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y, booToReaRad.u) annotation (Line(
      points={{-158,-70},{-142,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in) annotation (Line(
      points={{-118,-70},{-90.5,-70},{-90.5,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This part of the system model adds a radiator with a prescribed mass flow
rate to the system that is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System1\">
Buildings.Examples.Tutorial.Boiler.System1</a>.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System1\">
Buildings.Examples.Tutorial.Boiler.System1</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System2</code>.
</p>
</li>
<li>
<p>
Since this model uses water as the medium, we declared the water medium model
at the top-level of the model by adding the lines
</p>
<pre>
  replaceable package MediumW =
      Buildings.Media.Water \"Medium model\";
</pre>
</li>
<li>
<p>
To model the pump, a temperature sensor which we will need later
for the control, and a flow sink, we made instances of the models
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
(instance <code>pumRad</code> for the pump that serves the radiators),
<a href=\"modelica://Buildings.Fluid.Sensors.TemperatureTwoPort\">
Buildings.Fluid.Sensors.TemperatureTwoPort</a>
(instance <code>temSup</code>),
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2\">
Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2</a>
(instance <code>rad</code>), and
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>
(instance <code>sou</code> and <code>sin</code> for the sink and source
reservoirs, which will later be replace by the boiler loop).
</p>
<p>
In all of these instances, we set the medium model to <code>MediumW</code>.
We also made an instance of the model
Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor
(instance <code>temRoo</code>) to measure the room temperature.
We connected the model as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System2Connections.png\" border=\"1\"/>
</p>
<p>
Note that there are two connections from the
radiator to the room volume:
One connection is for the convective heat flow rate, and the other is for the
radiative heat flow rate. For simplicity, we assumed that the air and radiative
temperature of the room are equal.
Furthermore, we simplified the model by using only one radiator instead of multiple
radiators, although this radiator will be quite large as it needs to provide a
heat flow rate of <i>20</i> kW.
</p>
</li>
<li>
<p>
Next, we computed the design mass flow rate for the radiator.
According to the schematic drawing, the radiator should have at
the design conditions a supply water temperature of
<i>50</i>&deg;C and a return water temperature of
<i>40</i>&deg;C.
Thus, we define the radiator mass flow rate as
</p>
<pre>
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = 20000
    \"Nominal heat flow rate of radiator\";
  parameter Modelica.Units.SI.Temperature TRadSup_nominal = 273.15+50
    \"Radiator nominal supply water temperature\";
  parameter Modelica.Units.SI.Temperature TRadRet_nominal = 273.15+40
    \"Radiator nominal return water temperature\";
  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal =
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    \"Radiator nominal mass flow rate\";
</pre>
</li>
<li>
<p>
Now, we set the mass flow rate of <code>pumRad</code> and <code>temSup</code> to
<code>mRad_flow_nominal</code>.
We also set the temperature of the fluid that flows out of <code>sou</code>
to <code>TRadSup_nominal</code>.
We configured the parameters of the radiator model as
</p>
<pre>
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal) \"Radiator\";
</pre>
<p>
We configured the parameters of the pump model as
</p>
<pre>
  Buildings.Fluid.Movers.FlowControlled_m_flow pumRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRad_flow_nominal)
    \"Pump for radiator\";
</pre>
</li>
<li>
<p>
To enable the pump when the room temperature is below
<i>19</i>&deg;C and to switch it off when the room temperature
is below
<i>21</i>&deg;C,
we implemented the control blocks as shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System2PumpControl.png\" border=\"1\"/>
</p>
<p>
In this control sequence, the first block is a hysteresis element,
which is modeled by
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Hysteresis\">
Buildings.Controls.OBC.CDL.Reals.Hysteresis</a>.
It is configured as
</p>
<pre>
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysPum(
    uLow=273.15 + 19,
    uHigh=273.15 + 21)
    \"Pump hysteresis\";
</pre>
<p>
to output <code>false</code> when the input signal falls below <i>19</i>&deg;C, and
<code>true</code> when the input signal raises above <i>21</i>&deg;C.
Next, we send the output to the instance <code>not1</code>, which outputs
</p>
<pre>
  y= not u
</pre>
<p>
to negate the signal.
The output of this signal is a boolean value, but the pump
input signal is the required mass flow rate.
Thus, we used the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.BooleanToReal\">
Buildings.Controls.OBC.CDL.Conversions.BooleanToReal</a> to convert the signal.
We set the parameters of the boolean to real converter as
</p>
<pre>
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad(
        realTrue=mRad_flow_nominal,
        realFalse=0) \"Radiator pump signal\";
</pre>
<p>
For numerical reasons, in particular in large system models, it is recommended to
continuously change the mass flow rate, as opposed to having a step change.
Therefore,
in the instance <code>pumRad</code>, we leave the parameter
<code>use_inputFilter</code> at its default value <code>true</code>.
This will approximate a continuous change in mass flow rate when the
pump is switched on or off.
Finally, we closed the control loop between the room temperature sensor and the
pump input signal.
</p>
</li>
</ol>
<!-- ============================== -->
<p>
This completes the initial version of the model. When simulating the model
for <i>2</i> days, or <i>172800</i> seconds, the
response shown below should be seen.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System2Temperatures.png\" border=\"1\"/>
</p>
<p>
The figure shows that the room temperature is maintained at
<i>20</i>&deg;C when the internal heat gain is zero, and controlled around
<i>19</i>&deg;C to <i>21</i>&deg;C when there is an internal heat gain.
The temperature is slightly outside this temperature range because of the
time lag that is caused by the thermal capacity of the radiator.
</p>
<!-- Notes -->
<h4>Notes</h4>
<p>
For a more realistic model of a room, the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a>
could have been used.
For transient heat conduction, models from the
package
<a href=\"modelica://Buildings.HeatTransfer.Conduction\">
Buildings.HeatTransfer.Conduction</a>
could have been used.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2024, by Hongxiang Fu:<br/>
Specified <code>nominalValuesDefineDefaultPressureCurve=true</code>
in the mover component to suppress a warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
<li>
March 6, 2017, by Michael Wetter:<br/>
Added missing density to computation of air mass flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/673\">#673</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
January 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,
            extent={{-240,-160},{100,100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System2.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800));
end System2;
