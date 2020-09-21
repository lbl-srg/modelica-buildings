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
  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 "Heat recovery effectiveness";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";
  parameter Modelica.SIunits.Temperature THeaRecLvg=
    TOut_nominal - eps*(TOut_nominal-TRooSet)
    "Air temperature leaving the heat recovery";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.SIunits.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.SIunits.HeatFlowRate QCoiC_flow_nominal=4*
    (QRooC_flow_nominal + mA_flow_nominal*(TASup_nominal-THeaRecLvg-dTFan)*1006)
    "Cooling load of coil, taking into account economizer, and increased due to latent heat removal";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.SIunits.Temperature TWSup_nominal = 273.15+16
    "Water supply temperature";
  parameter Modelica.SIunits.Temperature TWRet_nominal = 273.15+12
    "Water return temperature";
  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal=
    QCoiC_flow_nominal/(TWRet_nominal-TWSup_nominal)/4200
    "Nominal water mass flow rate";

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
        QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
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
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(redeclare package Medium1 =
        MediumW, redeclare package Medium2 = MediumA,
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=6000,
    UA_nominal=-QCoiC_flow_nominal/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=THeaRecLvg,
        T_b1=TASup_nominal,
        T_a2=TWSup_nominal,
        T_b2=TWRet_nominal),
    dp2_nominal=200,
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
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant mAir_flow(k=mA_flow_nominal)
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
  Buildings.Controls.OBC.CDL.Logical.OnOffController con(bandwidth=1)
    "Controller for coil water flow rate"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TRooSetPoi(k=TRooSet)
    "Room temperature set point"
    annotation (Placement(transformation(extent={{-170,-90},{-150,-70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mWat_flow(realTrue=0, realFalse=
        mW_flow_nominal) "Conversion from boolean to real for water flow rate"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
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
      points={{60,-20},{68,-20},{68,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], hex.port_a2) annotation (Line(
      points={{72,20},{72,-46},{-90,-46},{-90,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[1], hex.port_a1) annotation (Line(
      points={{-120,-20},{-110,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[2], hex.port_b2) annotation (Line(
      points={{-120,-24},{-110,-24},{-110,-32}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{-20,-100},{0,-100},{0,-32},{-20,-32}},
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
      points={{-110,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{49.8,-8},{49.8,10},{21,10}},
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
  connect(TRooSetPoi.y, con.reference) annotation (Line(
      points={{-149,-80},{-136,-80},{-136,-94},{-122,-94}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.heatPort, senTemRoo.port) annotation (Line(
      points={{60,30},{50,30},{50,80},{70,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(senTemRoo.T, con.u) annotation (Line(
      points={{90,80},{100,80},{100,-140},{-140,-140},{-140,-106},{-122,-106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, mWat_flow.u) annotation (Line(
      points={{-99,-100},{-82,-100}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(mWat_flow.y, souWat.m_flow_in) annotation (Line(
      points={{-59,-100},{-50,-100},{-50,-92},{-40,-92}},
      color={0,0,127},
      smooth=Smooth.None));
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
First, we made an instance of the on/off controller
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.OnOffController\">
Buildings.Controls.OBC.CDL.Logical.OnOffController</a> and set its name to <code>con</code>.
We set the parameter for the bandwidth to <i>1</i> Kelvin.
This model requires as an input the measured temperature and the set point.
</p>
</li>
<li>
<p>
For the set point, we made the instance <code>TRooSetPoi</code> to feed a constant
set point into the controller.
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
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.PID\">
Buildings.Controls.OBC.CDL.Continuous.PID</a>.
</p>
</html>", revisions="<html>
<ul>
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
