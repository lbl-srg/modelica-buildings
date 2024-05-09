within Buildings.Examples.Tutorial.SpaceCooling;
model System2
  "Second part of the system model with air supply and open loop control"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
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
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts=1, redeclare package Medium =
        MediumW) "Sink for water circuit"
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k=
        mA_flow_nominal) "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mWat_flow(k=mW_flow_nominal)
    "Water flow rate"
    annotation (Placement(transformation(extent={{-80,-114},{-60,-94}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHXOut(redeclare package Medium =
        MediumA, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for heat recovery outlet on supply side"
    annotation (Placement(transformation(extent={{-76,-26},{-64,-14}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium =
        MediumA, m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{6,-26},{18,-14}})));
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
      points={{50,-8},{50,10},{22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, souWat.m_flow_in) annotation (Line(
      points={{-58,-104},{-52,-104},{-52,-92},{-42,-92}},
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
  annotation (Documentation(info="<html>
<p>
This part of the system model adds a space cooling with
open loop control to the model
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">
Buildings.Examples.Tutorial.SpaceCooling.System1</a>.
The space cooling consist of a model for the ambient conditions
<code>out</code>, a heat recovery <code>hex</code>,
a cooling coil <code>cooCoi</code> and a fan <code>fan</code>.
There is also a return duct that connects the room volume
<code>vol</code> with the heat recovery.
Weather data are obtained from the instance <code>weaDat</code>
which is connected to the model for the ambient air conditions <code>out</code>
and the outside temperature that is used for the heat conductance
<code>TOut</code>.
</p>
<p>
In this model, the duct pressure loss is not modeled
explicitly, but rather lumped into the pressure drops of the
heat exchangers.
</p>
<h4>Implementation</h4>
<p>
This section describes the steps that were required to build the model.
</p>
<ol>
<li>
<p>
The first step was to copy the model
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">
Buildings.Examples.Tutorial.SpaceCooling.System1</a>.
Note that for larger models, it is recommended to extend models instead
of copying them to avoid code duplication, as code duplication
makes it hard to maintain different versions of a model.
But for this model, we copied the old model to
avoid this model to be dependent on
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">
Buildings.Examples.Tutorial.SpaceCooling.System1</a>.
</p>
</li>
<li>
<p>
As this model will also use water as the medium for the water-side
of the cooling coil, we added the medium declaration
</p>
<pre>
  replaceable package MediumW = Buildings.Media.Water \"Medium for water\";
</pre>
</li>
<li>
<p>
Next, we defined system-level parameters for the water and air temperatures
and the water and air mass flow rates.
These declarations are essentially the design calculations which are
then used to size the components and flow rates.
It is good practice to list them at the top-level of the model
to allow easy change of temperatures or loads at a central place,
and automatic propagation of the new results to models that use
these parameters.
</p>
<p>
Note that we use an assignment for the nominal air mass flow rate
<code>mA_flow_nominal</code> that is different from the assignment in
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">
Buildings.Examples.Tutorial.SpaceCooling.System1</a> because
now, the air flow rate is a result of the sizing calculations.
</p>
<p>
The calculations are as follows:
</p>
<pre>
  //////////////////////////////////////////////////////////
  // Heat recovery effectiveness
  parameter Real eps = 0.8 \"Heat recovery effectiveness\";

  /////////////////////////////////////////////////////////
  // Design air conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal = 291.15
    \"Nominal air temperature supplied to room\";
  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
    \"Nominal air humidity ratio supplied to room [kg/kg] assuming 90% relative humidity\";
  parameter Modelica.Units.SI.Temperature TRooSet = 297.15
    \"Nominal room air temperature\";
  parameter Modelica.Units.SI.Temperature TOut_nominal = 303.15
    \"Design outlet air temperature\";
  parameter Modelica.Units.SI.Temperature THeaRecLvg=
    TOut_nominal - eps*(TOut_nominal-TRooSet)
    \"Air temperature leaving the heat recovery\";
  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
    \"Air humidity ratio leaving the heat recovery [kg/kg]\";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=
     1000 \"Internal heat gains of the room\";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    \"Nominal cooling load of the room\";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    \"Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback\";
  parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
    \"Estimated temperature raise across fan that needs to be made up by the cooling coil\";
  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal=
    mA_flow_nominal*(TASup_nominal-THeaRecLvg-dTFan)*1006+mA_flow_nominal*(wASup_nominal-wHeaRecLvg)*2458.3e3
    \"Cooling load of coil, taking into account outside air sensible and latent heat removal\";

  /////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.Units.SI.Temperature TWSup_nominal = 285.15
    \"Water supply temperature\";
  parameter Modelica.Units.SI.Temperature TWRet_nominal = 289.15
    \"Water return temperature\";
  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal=
    -QCoiC_flow_nominal/(TWRet_nominal-TWSup_nominal)/4200
    \"Nominal water mass flow rate\";
</pre>
</li>
</ol>
<p>
Now, we explain the component models that are used to assemble the system model.
</p>
<ol start=\"4\">
<li>
<p>
The weather data are obtained from the instance
<code>weaDat</code> in which we set the location to Chicago, IL.
We also configured the model to use a constant atmospheric pressure,
as opposed to the pressure from the weather file, as we are not interested
in modeling the effect of changes in the atmospheric pressure.
Furthermore, we configured the model to use a constant dry-bulb
temperature of <code>TOut_nominal</code>. This helps in testing the
model at the design conditions, and can easily be changed later to
use weather data from the file.
Thus, although we use a model that reads a weather data file, for
now we want to use constant outside conditions to simplify the testing
of the model.
</p>
</li>
<li>
<p>
To use weather data for the heat conduction, we changed the instance
<code>TOut</code> to a model that allows obtaining the temperature from
the input port.
To connect this input port to weather data, we added the connector
<code>weaBus</code>, as this is needed to pick a single variable, the
dry-bulb temperature, from the weather bus which carries all weather data.
</p>
</li>
<li>
<p>
To model ambient outside <i>air</i> conditions, we use the instance
<code>out</code> which is connected directly to the weather data model
<code>weaDat</code>.
In this model, we also set the medium model to <code>MediumA</code>.
</p>
</li>
<li>
<p>
Next, we set in all new component models the medium model to
<code>MediumA</code> if it is part of the air system, or to
<code>MediumW</code> if it is part of the water system.
From the information section of the cooling coil, we see
that its parameter <code>Medium1</code> needs to be water,
and <code>Medium2</code> needs to be air.
</p>
</li>
</ol>
<p>
Next, we configured the air-side components of the model.
</p>
<ol start=\"8\">
<li>
<p>
For the heat recovery <code>hex</code>, we set the effectiveness
to the parameter <code>eps</code>, which we defined earlier to be
<i>0.8</i>.
We also set the nominal mass flow rates to <code>mA_flow_nominal</code>
and the pressure drops on both sides to <i>200</i> Pascals.
This pressure drop is attained when the air mass flow rate is
equal to <code>mA_flow_nominal</code>, and it is adjusted for
other flow rates using a quadratic law with regularization when
the flow rate is below <i>10%</i> of <code>mA_flow_nominal</code>.
This default value can be changed on the tab <code>Flow resistance</code>
of the model.
</p>
</li>
<li>
<p>
To configure the cooling coil model <code>cooCoi</code>, we set the
water and air side nominal mass flow rates and pressure drops to
</p>
<pre>
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=200,
</pre>
<p>
This model also requires the specification of the <i>UA</i>-value.
We allow the component model to do this based on design conditions by setting
the parameters:
</p>
<pre>
    use_Q_flow_nominal=true,
    Q_flow_nominal= QCoiC_flow_nominal
    T_a1_nominal=TWSup_nominal,
    T_a2_nominal=THeaRecLvg,
    W_a2_nominal= wHeaRecLvg
</pre>
<p>
In order to see the coil inlet and outlet temperatures, we set the parameter
</p>
<pre>
  show_T = true
</pre>
<p>
Its default value is <code>false</code>.
</p>
<p>
To use prescribed initial values for the state variables of the cooling coil, we set
the parameter
</p>
<pre>
  energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
</pre>
</li>
<li>
<p>
For the fan, we set the nominal mass flow rate to <code>mA_flow_nominal</code>
and also connect its input port to the component <code>mAir_flow</code>,
which assigns a constant air flow rate.
We leave the fan efficiency at its default value of <i>0.7</i>.
We set the parameter
</p>
<pre>
  energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
</pre>
<p>
to configure the fan to be a steady-state model. This was done as we
are using a constant fan speed in this example.
</p>
</li>
<li>
<p>
For the two temperature sensors in the supply duct, we also set the nominal mass flow
rate to <code>mA_flow_nominal</code>.
</p>
</li>
</ol>
<p>
Now, what is left is to configure the water-side components.
</p>
<ol start=\"12\">
<li>
We configured the component <code>souWat</code> so that
it obtains its mass flow rate from the input connector,
and we connected this input connector to the constant block
<code>mWat_flow</code>.
To set the water temperature that leaves this component,
we set the parameter <code>T=TWSup_nominal</code>.
Alternatively, we could have used the model
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>
as is used for the fan, but we chose to use the simpler model
<a href=\"modelica://Buildings.Fluid.Sources.MassFlowSource_T\">
Buildings.Fluid.Sources.MassFlowSource_T</a>
as this model allows the direct specification of the
leaving fluid temperature.
</li>
<li>
<p>
To complete the water circuit, we also used the instance <code>sinWat</code>.
This model is required for the water to flow out of the heat exchanger into
an infinite reservoir. It is also required to set a reference for the
pressure of the water loop.
Since in our model, no water flows out of this reservoir, there is no need to set
its temperature.
</p>
</li>
</ol>
<p>
This completes the initial version of the model. When simulating the model, the
response shown below should be seen.
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SpaceCooling/System2Temperatures.png\" border=\"1\"/>
</p>
<!-- Notes -->
<h4>Notes</h4>
<p>
If we were interested in computing electricity use for the pump,
we could have used the same model as for the fan.
</p>
<p>
To explicitly model duct pressure drop, we could have added
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a> to the model.
However, computationally it is cheaper to lump these pressure drops into other component models.
In fact, rather than separately computing the pressure drop of the heat recovery and the air-side
pressure drop of the cooling coil, we could have modeled the cooling coil pressure drop as
<code>dp_nominal = 2*200+200</code> and set for the heat recovery
<code>dp1_nominal = 0</code> and
<code>dp2_nominal = 0</code>. Setting the nominal pressure drop to zero will remove this equation
from the model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2024, by Hongxiang Fu:<br/>
Added nominal curve specification to suppress warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
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
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-140},{100,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SpaceCooling/System2.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=10800));
end System2;
