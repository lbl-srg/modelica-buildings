within Buildings.Examples.Tutorial.Boiler;
model System3
  "3rd part of the system model, which adds the boiler loop with open loop control"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+50
    "Radiator nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+40
    "Radiator nominal return water temperature";
  parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal=
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";

//-------------------------Step 4: Boiler design values-------------------------//
  parameter Modelica.SIunits.Temperature TBoiSup_nominal = 273.15+70
    "Boiler nominal supply water temperature";
  parameter Modelica.SIunits.Temperature TBoiRet_min = 273.15+60
    "Boiler minimum return water temperature";
  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TBoiRet_min)
    "Boiler nominal mass flow rate";
//------------------------------------------------------------------------------//

//----------------Radiator loop: Three-way valve: mass flow rate----------------//
  parameter Modelica.SIunits.MassFlowRate mRadVal_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";
//------------------------------------------------------------------------------//

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 4000
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(
      extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
      table=[-6, 0;
              8, QRooInt_flow;
             18, 0],
      timeScale=3600) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal) "Radiator"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
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
  Buildings.Fluid.Movers.FlowControlled_m_flow pumRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRad_flow_nominal) "Pump for radiator"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-50,-70})));

//-------------------------Step 3: Splitter and mixers------------------------//
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mRadVal_flow_nominal,-mRad_flow_nominal,mRad_flow_nominal
         - mRadVal_flow_nominal},
    dp_nominal={100,-8000,6750}) "Mixer between valve and radiators"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-110})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mRadVal_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={200,-200,-50}) "Splitter of boiler loop bypass" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-190})));

  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,0,0},
    m_flow_nominal={mRad_flow_nominal,-mRadVal_flow_nominal,-mRad_flow_nominal
         + mRadVal_flow_nominal}) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-110})));
  Buildings.Fluid.FixedResistances.Junction mix2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal={0,-200,0},
    m_flow_nominal={mRadVal_flow_nominal,-mBoi_flow_nominal,mBoi_flow_nominal})
    "Mixer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-190})));
  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal*{1,-1,-1},
    dp_nominal=200*{1,-1,-1}) "Splitter for radiator loop valve bypass"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-150})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Movers.FlowControlled_m_flow pumBoi(
      redeclare package Medium = MediumW,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      m_flow_nominal=mBoi_flow_nominal) "Pump for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-280})));

//-------------------------------Step 3: Boiler-------------------------------//
  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    dp_nominal=2000,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue()) "Boiler"
    annotation (Placement(transformation(extent={{20,-320},{0,-300}})));
//----------------------------------------------------------------------------//

//--------------------------Step 3: Three-way Valve---------------------------//
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRadVal_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) "Three-way valve for radiator loop"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-150})));
//----------------------------------------------------------------------------//

  Buildings.Fluid.Sources.Boundary_pT preSou(redeclare package Medium = MediumW,
      nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{92,-320},{72,-300}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valBoi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) "Three-way valve for boiler"
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-250})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium =
        MediumW, m_flow_nominal=mBoi_flow_nominal) "Return water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-280})));
  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mBoi_flow_nominal,-mBoi_flow_nominal,-mBoi_flow_nominal},
    dp_nominal={0,0,-200}) "Splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-250})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(k=1)
    "Constant control signal for valves"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conBoi(k=mBoi_flow_nominal)
    "Constant mass flow rate for boiler pump"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(k=0.5)
    "Constant control signal for valves"
    annotation (Placement(transformation(extent={{0,-290},{20,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysPum(
    uLow=273.15 + 19,
    uHigh=273.15 + 21)
    "Pump hysteresis"
    annotation (Placement(transformation(extent={{-220,-80},{-200,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaRad(realTrue=mRad_flow_nominal)
    "Radiator pump signal"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
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
  connect(pumRad.port_b, temSup.port_a) annotation (Line(
      points={{-50,-60},{-50,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b, pumBoi.port_a) annotation (Line(
      points={{-5.55112e-16,-310},{-50,-310},{-50,-290}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, spl1.port_1) annotation (Line(
      points={{-50,-270},{-50,-260}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_2, spl.port_1) annotation (Line(
      points={{-50,-240},{-50,-200}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, valRad.port_1)
                                  annotation (Line(
      points={{-50,-180},{-50,-160}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_2, mix.port_1)
                                  annotation (Line(
      points={{-50,-140},{-50,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl1.port_3, valBoi.port_3)
                                    annotation (Line(
      points={{-40,-250},{50,-250}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valBoi.port_2, temRet.port_a)
                                      annotation (Line(
      points={{60,-260},{60,-270}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_b, boi.port_a) annotation (Line(
      points={{60,-290},{60,-310},{20,-310}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_a, preSou.ports[1]) annotation (Line(
      points={{20,-310},{72,-310}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix2.port_2, valBoi.port_1)
                                    annotation (Line(
      points={{60,-200},{60,-240}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl4.port_2, mix2.port_1) annotation (Line(
      points={{60,-160},{60,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl2.port_2, spl4.port_1) annotation (Line(
      points={{60,-120},{60,-140}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valRad.port_3, spl4.port_3)
                                   annotation (Line(
      points={{-40,-150},{50,-150}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_3, mix2.port_3) annotation (Line(
      points={{-40,-190},{50,-190}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_3, spl2.port_3) annotation (Line(
      points={{-40,-110},{50,-110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mix.port_2, pumRad.port_a) annotation (Line(
      points={{-50,-100},{-50,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad.port_b, spl2.port_1) annotation (Line(
      points={{20,-10},{60,-10},{60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, valRad.y)
                          annotation (Line(
      points={{-98,-150},{-62,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conBoi.y, pumBoi.m_flow_in) annotation (Line(
      points={{-78,-280},{-70.5,-280},{-70.5,-280},{-62,-280}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, valBoi.y)
                           annotation (Line(
      points={{-98,-150},{-80,-150},{-80,-220},{80,-220},{80,-250},{72,-250}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(const1.y, boi.y) annotation (Line(
      points={{22,-280},{32,-280},{32,-302},{22,-302}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temRoo.T,hysPum. u) annotation (Line(
      points={{-50,30},{-234,30},{-234,-70},{-222,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y,not1. u) annotation (Line(
      points={{-198,-70},{-182,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(not1.y,booToReaRad. u) annotation (Line(
      points={{-158,-70},{-142,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaRad.y, pumRad.m_flow_in) annotation (Line(
      points={{-118,-70},{-90.5,-70},{-90.5,-70},{-62,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This part of the system model adds the boiler loop with
open loop control to the model that is implemented in
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System2\">
Buildings.Examples.Tutorial.Boiler.System2</a>.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the model
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System2\">
Buildings.Examples.Tutorial.Boiler.System2</a>
and called it
<code>Buildings.Examples.Tutorial.Boiler.System3</code>.
</p>
</li>
<li>
<p>
Next, we deleted the sink and source models <code>sin</code> and <code>sou</code>,
as these will be replaced by the boiler loop.
</p>
</li>
<li>
<p>
We made various instances of
<a href=\"modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a>
to model flow splitter and mixers.
We also made an instance of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear\">
Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear</a>
to model the three-way valves, and
an instance of
<a href=\"modelica://Buildings.Fluid.Boilers.BoilerPolynomial\">
Buildings.Fluid.Boilers.BoilerPolynomial</a>
to model the boiler.
</p>
<p>
Note that we also made an instance of
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>,
which we called <code>preSou</code>.
This is required to set a pressure reference in the water loop, which is a closed system.
For medium models that expand with increasing temperature,
this is also required to accumulate, and to feed back into the system,
the difference in mass due to the thermal expansion of water.
</p>
</li>
<li>
<p>
Next, we parameterized the medium of all these components by
setting it to <code>MediumW</code>.
</p>
<p>
Since the nominal mass flow rate for the
boiler loop is required by several models, we introduced
the following system-level parameters, where
<code>TBoiRet_min</code> will be used to avoid
condensation in the boiler:
</p>
<pre>
  parameter Modelica.SIunits.Temperature TBoiSup_nominal = 273.15+80
    \"Boiler nominal supply water temperature\";
  parameter Modelica.SIunits.Temperature TBoiRet_min = 273.15+60
    \"Boiler minimum return water temperature\";
  parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TBoiRet_min)
    \"Boiler nominal mass flow rate\";
</pre>
</li>
</ol>
<p>
Next, we set the parameters of the individual component models.
</p>
<ol>
<li>
<p>
We lumped the pressure drop of the boiler loop into the boiler model
and hence set
</p>
<pre>
  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mBoi_flow_nominal,
    dp_nominal=2000,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue()) \"Boiler\";
</pre>
</li>
<li>
<p>
For the three-way valve in the radiator loop, we used the default pressure drop of
<i>6000</i> Pa.
For its mass flow rate, we introduced the parameter
</p>
<pre>
  parameter Modelica.SIunits.MassFlowRate mRadVal_flow_nominal=
    Q_flow_nominal/4200/(TBoiSup_nominal-TRadRet_nominal)
    \"Radiator nominal mass flow rate\";
</pre>
<p>
This allowed us to configure the valve as
</p>
<pre>
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRad(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRadVal_flow_nominal,
    l={0.01,0.01},
    dpValve_nominal=6000) \"Three-way valve for radiator loop\"
</pre>
<p>
where <code>l={0.01,0.01}</code> is a valve leakage of 1%
and <code>dpValve_nominal=6000</code> is the pressure drop of the valve
if it is fully open
and if the mass flow rate is equal to <code>m_flow_nominal</code>.
It is recommended to set the valve leakage to a non-zero value to avoid numerical problems.
A non-zero value also represent a more realistic situation, as most valves have some leakage.
</p>
</li>
<li>
<p>
For the bypass between the valve and the radiator, we note that the
mass flow rate is equal to <code>mRad_flow_nominal - mRadVal_flow_nominal</code>.
This is a fixed bypass that is used to allow the valve to work across
its full range.
We decided to lump the pressure drop of this bypass, and the pressure drop of the
radiator loop, into the instance <code>mix</code>.
Hence, its parameters are
</p>
<pre>
  Buildings.Fluid.FixedResistances.Junction mix(
    redeclare package Medium =MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={mRadVal_flow_nominal,
                   -mRad_flow_nominal,
                   mRad_flow_nominal-mRadVal_flow_nominal},
    dp_nominal={100,-8000,6750}) \"Mixer between valve and radiators\";
</pre>
<p>
Note the negative values, which are used for the ports where the medium is
outflowing at nominal conditions.
See also the documentation of the model
<a href=\"modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a>.
</p>
<p>
We also set the pressure drop of
port 3 of <code>mix</code>
to the same value as the pressure drop of the valve in order
to balance the flows. In practice, this can be done by using a
balance valve, whose pressure drop we lumped into the component
<code>mix</code>.
</p>
</li>
<li>
<p>
Next, we set the pressure drops and flow rates of all flow splitters and mixers.
For the flow splitters and mixers that are connected to another flow splitter or mixer which
already computes the pressure drop of the connecting flow leg, we set the nominal pressure drop
to zero. This will remove the equation for the pressure drop calculation.
However, we chose to still use the mixer and splitters to make sure that
we properly defined the mixing points in the system.
</p>
</li>
<li>
<p>
Next, we connected all fluid ports, and we set open-loop control signals
for the valves, pumps and boilers.
This is implemented using the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.Constant\">
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant</a>.
Using open-loop signals allows testing the model prior to
adding the complexity of closed loop control.
To avoid that the boiler overheats, we set its control input to
<code>0.5</code>. Otherwise, the boiler temperature would raise quickly
when the radiator pump is off, and the simulation would stop
with an error message that says that its medium temperature is
outside the allowed range.
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/System3Temperatures.png\" border=\"1\"/>
</p>
<p>
The figure shows that the room temperature is around
<i>5</i>&deg;C when the internal heat gain is zero,
i.e., it is at the average of the outside temperature
and the room design temperature.
Since the boiler control signal is <i>0.5</i>,
this indicates that the model is correct.
</p>
</html>", revisions="<html>
<ul>
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
March 1, 2013, by Michael Wetter:<br/>
Added nominal pressure drop for valves as
this parameter no longer has a default value.
</li>
<li>
January 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-240,-360},{100,100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System3.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800));
end System3;
