within Buildings.Examples.Tutorial.SpaceCooling;
model System3
  "Third part of the system model with air supply and closed loop control"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    mSenFac=3)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Design air conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=291.15
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal=0.012
    "Nominal air humidity ratio supplied to room [kg/kg] assuming 90% relative humidity";
  parameter Modelica.Units.SI.Temperature TRooSet=297.15
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TOut_nominal=303.15
    "Design outlet air temperature";
  parameter Modelica.Units.SI.Temperature THeaRecLvg=TOut_nominal - eps*(
      TOut_nominal - TRooSet) "Air temperature leaving the heat recovery";
  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg=0.0135
    "Air humidity ratio leaving the heat recovery [kg/kg]";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=-QRooInt_flow -
      10E3/30*(TOut_nominal - TRooSet) "Nominal cooling load of the room";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=1.3*
      QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.Units.SI.TemperatureDifference dTFan=2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal=mA_flow_nominal*(
      TASup_nominal - THeaRecLvg - dTFan)*1006 + mA_flow_nominal*(wASup_nominal
       - wHeaRecLvg)*2458.3e3
    "Cooling load of coil, taking into account outside air sensible and latent heat removal";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.Units.SI.Temperature TWSup_nominal=285.15
    "Water supply temperature";
  parameter Modelica.Units.SI.Temperature TWRet_nominal=289.15
    "Water return temperature";
  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal=-QCoiC_flow_nominal/
      (TWRet_nominal - TWSup_nominal)/4200 "Nominal water mass flow rate";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
        QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Supply air fan"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(redeclare package Medium1 =
        MediumA, redeclare package Medium2 = MediumA,
    m1_flow_nominal=mA_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=200,
    dp2_nominal=200,
    eps=eps) "Heat recovery"
    annotation (Placement(transformation(extent={{-110,-36},{-90,-16}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=200,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QCoiC_flow_nominal,
    T_a1_nominal=TWSup_nominal,
    T_a2_nominal=THeaRecLvg,
    w_a2_nominal=wHeaRecLvg,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling coil"
   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-30,-26})));
  Buildings.Fluid.Sources.Outside out(nPorts=2, redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{-140,-32},{-120,-12}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal) "Source for water flow rate"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts=1, redeclare package Medium =
        MediumW) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXOut(redeclare package Medium =
        MediumA, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-76,-26},{-64,-14}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium =
        MediumA, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{6,-26},{18,-14}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-170,-104},{-150,-84}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mWat_flow(realTrue=0, realFalse=
        mW_flow_nominal) "Conversion from boolean to real for water flow rate"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Inputs different"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis con(
    final uLow=-0.5,
    final uHigh=0.5)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fan.port_b, vol.ports[1]) annotation (Line(
      points={{60,-20},{69,-20},{69,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], hex.port_a2) annotation (Line(
      points={{71,20},{71,-46},{-90,-46},{-90,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[1], hex.port_a1) annotation (Line(
      points={{-120,-23},{-116,-23},{-116,-20},{-110,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2], hex.port_b2) annotation (Line(
      points={{-120,-21},{-110,-21},{-110,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{0,-100},{20,-100},{20,-32},{-20,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1, sinWat.ports[1])    annotation (Line(
      points={{-40,-32},{-48,-32},{-48,-66},{-60,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-140,50},{-128,50},{-128,4},{-148,4},{-148,-21.8},{-140,-21.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-140,50},{-110,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-109.95,50.05},{-66,50.05},{-66,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{50,-8},{50,10},{22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, senTemHXOut.port_a) annotation (Line(
      points={{-90,-20},{-76,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHXOut.port_b, cooCoi.port_a2) annotation (Line(
      points={{-64,-20},{-40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, senTemSupAir.port_a) annotation (Line(
      points={{-20,-20},{6,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b, fan.port_a) annotation (Line(
      points={{18,-20},{40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{5.55112e-16,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, senTemRoo.port) annotation (Line(
      points={{60,30},{50,30},{50,80},{70,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(mWat_flow.y, souWat.m_flow_in) annotation (Line(
      points={{-38,-100},{-30,-100},{-30,-92},{-22,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sub.y, con.u)
    annotation (Line(points={{-108,-100},{-102,-100}}, color={0,0,127}));
  connect(con.y, mWat_flow.u)
    annotation (Line(points={{-78,-100},{-62,-100}}, color={255,0,255}));
  connect(TRooSetPoi.y, sub.u1)
    annotation (Line(points={{-148,-94},{-132,-94}}, color={0,0,127}));
  connect(senTemRoo.T, sub.u2) annotation (Line(points={{91,80},{100,80},{100,-140},
          {-140,-140},{-140,-106},{-132,-106}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This part of the system model modifies
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System2\">
Buildings.Examples.Tutorial.SpaceCooling.System2</a>
to use the actual outside temperature for a summer day,
and it adds closed loop control.
The closed loop control measures the room temperature and switches
the chilled water flow rate on or off.
</p>
<h4>Implementation</h4>
<p>
This section describes how we modified
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System2\">
Buildings.Examples.Tutorial.SpaceCooling.System2</a>
to build this model.
</p>
<ol>
<li>
<p>
The first step was to copy the model
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System2\">
Buildings.Examples.Tutorial.SpaceCooling.System2</a>.
</p>
</li>
<li>
<p>
Next, we changed in <code>weaDat</code> the parameter that determines
whether the outside dry bulb temperature is used from the weather data file
or set to a constant value. This can be accomplished in the GUI of the weather data reader
as follows:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SpaceCooling/System3TOutChange.png\" border=\"1\"/>
</p>
</li>
</ol>
<p>
With this change to using real weather data, we also change the simulation
time to be one day during the summer, where the start time is 4320 h (15552000 s)
and the stop time is 4344 h (15638400 s).
</p>
<p>
If the model is now simulated, the following plot could be generated that shows that the
room is cooled too much due to the open loop control:
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SpaceCooling/System3TemperaturesOpenLoop.png\" border=\"1\"/>
</p>
<p>
To add closed loop control, we proceeded as follows.
</p>
<ol start=\"3\">
<li>
<p>
First, we made an instance of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Subtract\">
Buildings.Controls.OBC.CDL.Reals.Subtract</a> and set its name to <code>sub</code>.
It calculates the difference between the set point and the measured temperature.
</p>
</li>
<li>
<p>
For the set point, we made the instance <code>TRooSetPoi</code> to feed a constant
set point into the instance <code>sub</code>.
</p>
</li>
<li>
<p>
The output of the instance <code>sub</code> was then fed as the input to
<code>con</code>, which is an instance of
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Hysteresis\">
Buildings.Controls.OBC.CDL.Reals.Hysteresis</a>.
For the instance <code>con</code>, we set the parameter for the lower limit to
<i>-0.5</i> and the upper limit to <i>0.5</i>.
</p>
</li>
<li>
<p>
The instance <code>senTemRoo</code> has been added to measure the room air temperature.
Note that we decided to measure directly the room air temperature. If we would have used
a temperature sensor in the return air stream, then its temperature would never change when
the mass flow rate is zero, and hence it would not measure how the room temperature changes
when the fan is off.
</p>
</li>
<li>
<p>
Since the controller output is a boolean signal, but the instance
<code>souWat</code> needs a real signal as an input for the water mass flow rate,
we needed to add a conversion block. We therefore replaced the instance
<code>mWat_flow</code> from a constant block to the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Conversions.BooleanToReal\">
Buildings.Controls.OBC.CDL.Conversions.BooleanToReal</a>.
Because the cooling control has a reverse action, i.e.,
if the measured value exceeds the set point, the system should switch
on instead of off, we configured the parameters of the conversion block
as follow:
</p>
<pre>
  realTrue=0
  realFalse=mW_flow_nominal
</pre>
<p>
This will output <code>mW_flow_nominal</code> when the room temperature
is above the set point, and <i>0</i> otherwise.
</p>
</li>
</ol>
<p>
This completes building the model shown in the figure on
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling\">
Buildings.Examples.Tutorial.SpaceCooling</a>.
When simulating the model, the response shown below should be seen.
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SpaceCooling/System3TemperaturesClosedLoop.png\" border=\"1\"/>
<br/>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SpaceCooling/System3FlowRateClosedLoop.png\" border=\"1\"/>
</p>
<!-- Notes -->
<h4>Notes</h4>
<p>
To add a continuous controller for the coil water flow rate, we could have used the model
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PID\">
Buildings.Controls.OBC.CDL.Reals.PID</a>.
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
December 11, 2023, by Jianjun Hu:<br/>
Reimplemented on-off control to avoid using the obsolete <code>OnOffController</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3595\">#3595</a>.
</li>
<li>
September 20, 2021 by David Blum:<br/>
Correct supply and return water parameterization.<br/>
Use design conditions for UA parameterization in cooling coil.<br/>
Use explicit calculation of sensible and latent load to determine design load
on cooling coil.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2624\">#2624</a>.
</li>
<li>
January 28, 2015 by Michael Wetter:<br/>
Added thermal mass of furniture directly to air volume.
This avoids an index reduction.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
January 11, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-160},{120,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SpaceCooling/System3.mos"
        "Simulate and plot"),
    experiment(StartTime=15552000, Tolerance=1e-6, StopTime=15638400));
end System3;
