within Buildings.Examples.VAVCO2;
model VAVSystemCTControl
  "Variable air volume flow system of MIT building with CO2 control and continuous time control for static pressure reset"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"});
 parameter Modelica.SIunits.MassFlowRate mMIT_flow = roo.m0Tot_flow
    "Nominal mass flow rate of MIT system model as in ASHRAE 825-RP";
parameter Modelica.SIunits.PressureDifference dpSuiSup_nominal(displayUnit="Pa") = 95
    "Pressure drop supply air leg with splitters of one suite (obtained from simulation)";
parameter Modelica.SIunits.PressureDifference dpSuiRet_nominal(displayUnit="Pa") = 233
    "Pressure drop return air leg with splitters of one suite (obtained from simulation)";
parameter Modelica.SIunits.PressureDifference dpFanSupMIT_nominal(displayUnit="Pa") = 1050
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";
parameter Modelica.SIunits.PressureDifference dpFanRetMIT_nominal(displayUnit="Pa") = 347
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";
parameter Real scaM_flow = 1 "Scaling factor for mass flow rate";
parameter Real scaDpFanSup_nominal = 1
    "Scaling factor for supply fan pressure lift with NSui number of suites";
parameter Real scaDpFanRet_nominal = 1
    "Scaling factor for supply fan pressure lift with NSui number of suites";
  Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (
    Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant yDam(k=0.5)
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.FixedResistances.PressureDrop res31(
    dp_nominal=0.546,
    m_flow_nominal=scaM_flow*1,
    redeclare package Medium = Medium,
    from_dp=true)
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Fluid.FixedResistances.PressureDrop res33(
    dp_nominal=0.164,
    m_flow_nominal=scaM_flow*1,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  Buildings.Fluid.FixedResistances.PressureDrop res57(
    dp_nominal=0.118000,
    m_flow_nominal=scaM_flow*1,
    redeclare package Medium = Medium,
    from_dp=true)
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
Buildings.Examples.VAVCO2.BaseClasses.Suite roo(redeclare package Medium = Medium, scaM_flow=scaM_flow)
    annotation (Placement(transformation(extent={{206,-92},
            {310,20}})));
  Fluid.Actuators.Dampers.MixingBox mixBox(
    dpOut_nominal=0.467,
    dpRec_nominal=0.665,
    mOut_flow_nominal=scaM_flow*1,
    mRec_flow_nominal=scaM_flow*1,
    mExh_flow_nominal=scaM_flow*1,
    redeclare package Medium = Medium,
    dpExh_nominal=0.467,
    allowFlowReversal=true,
    from_dp=false,
    use_inputFilter=false) "mixing box"
    annotation (Placement(transformation(extent={{6,-76},{30,-52}})));
  Buildings.Fluid.Sources.Boundary_pT bouIn(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=2)
    annotation (Placement(transformation(extent={{-38,-74},{-18,-54}})));
   Buildings.Controls.Continuous.LimPID conSupFan(
    Ti=60,
    yMax=1,
    yMin=0,
    Td=60,
    k=0.1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
    "Controller for supply fan"
            annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Movers.FlowControlled_dp fan32(
    redeclare package Medium = Medium,
    per(pressure(final V_flow={0,11.08,14.9}, dp={1508,743,100})),
    init=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mMIT_flow,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=true)
    annotation (Placement(transformation(extent={{122,-18},{138,-2}})));
  Buildings.Fluid.Movers.FlowControlled_dp fan56(
    redeclare package Medium = Medium,
    per(pressure(final V_flow={2.676,11.05}, dp={600,100})),
    init=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mMIT_flow,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=true)
    annotation (Placement(transformation(extent={{138,-78},{122,-62}})));
  Modelica.Blocks.Sources.Pulse pSet(
    amplitude=120,
    period=86400,
    startTime=6*3600,
    width=50)         "Pressure setpoint (0 during night, 120 during day)"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Gain dp32(k=150) "Gain for fan"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Math.Gain dp56(k=60) "Gain for fan"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Modelica.Blocks.Logical.GreaterThreshold hys(threshold=0.1)
    "Hysteresis to separate the on and off signals"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
    annotation (Placement(transformation(extent={{-60,92},{-40,112}})));
equation
  connect(PAtm.y, bouIn.p_in) annotation (Line(
      points={{-59,-40},{-50,-40},{-50,-56},{-40,-56}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(roo.p_rel, conSupFan.u_m)
                              annotation (Line(
      points={{312.6,-23.0769},{320,-23.0769},{320,40},{10,40},{10,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yDam.y, mixBox.y) annotation (Line(
      points={{-19,-10},{18,-10},{18,-49.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.p, PAtm.y) annotation (Line(
      points={{201.32,11.3846},{-50,11.3846},{-50,-40},{-59,-40}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(mixBox.port_Sup, res31.port_a) annotation (Line(
      points={{30,-56.8},{40,-56.8},{40,-10},{60,-10}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));
  connect(res31.port_b, fan32.port_a) annotation (Line(
      points={{80,-10},{122,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res57.port_b, mixBox.port_Ret) annotation (Line(
      points={{60,-70},{46,-70},{46,-71.2},{30,-71.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res33.port_b, roo.port_aSup) annotation (Line(
      points={{180,-10},{192,-10},{192,-14.4615},{206,-14.4615}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.ports[1], mixBox.port_Out) annotation (Line(
      points={{-18,-62},{-4,-62},{-4,-56.8},{6,-56.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.ports[2], mixBox.port_Exh) annotation (Line(
      points={{-18,-66},{-4,-66},{-4,-71.2},{6,-71.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan56.port_b, res57.port_a) annotation (Line(
      points={{122,-70},{80,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan32.port_b, res33.port_a) annotation (Line(
      points={{138,-10},{160,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan56.port_a, roo.port_bExh) annotation (Line(
      points={{138,-70},{157,-70},{157,-83.3846},{206,-83.3846}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pSet.y, conSupFan.u_s) annotation (Line(
      points={{-19,70},{-2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp32.y, fan32.dp_in) annotation (Line(points={{101,90},{129.84,90},{
          129.84,-0.4}}, color={0,0,127}));
  connect(dp56.y, fan56.dp_in) annotation (Line(points={{101,60},{112,60},{112,
          -40},{130.16,-40},{130.16,-60.4}}, color={0,0,127}));
  connect(hys.u, pSet.y) annotation (Line(points={{-2,130},{-12,130},{-12,70},{
          -19,70}}, color={0,0,127}));
  connect(hys.y, switch1.u2) annotation (Line(points={{21,130},{30,130},{30,110},
          {38,110}}, color={255,0,255}));
  connect(switch1.u1, conSupFan.y) annotation (Line(points={{38,118},{28,118},{
          28,70},{21,70}}, color={0,0,127}));
  connect(off.y, switch1.u3)
    annotation (Line(points={{-39,102},{-20,102},{38,102}}, color={0,0,127}));
  connect(switch1.y, dp32.u) annotation (Line(points={{61,110},{68,110},{68,90},
          {78,90}}, color={0,0,127}));
  connect(switch1.y, dp56.u) annotation (Line(points={{61,110},{68,110},{68,110},
          {68,60},{78,60}}, color={0,0,127}));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{350,150}})),
Documentation(info="<html>
<p>
This examples demonstrates the implementation of CO<sub>2</sub> control
for a variable air volume flow system.
Each room has a CO<sub>2</sub> source. Depending on the CO<sub>2</sub>
concentrations, the air dampers in the room open or close.
The supply and return fans are controlled to provide a constant static
pressure.
</p>
<p>
Note that this example does not control the room temperature and
the heat flow through the building envelope. It only implements the
CO<sub>2</sub> source and the damper and fan control to maintain
a CO<sub>2</sub> concentration in the room below 700 PPM.
</p>
<p>
Because the building envelope is idealized as having no leakage,
the supply and return fan are controlled so that they both receive
the same control signal. If the return fan were controlled so that it
tracks the volume flow rate of the supply fan, then there would be multiple
solutions for the control signal as the split between pressure raise
of the supply fan and pressure raise of the return fan is arbitrary.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 20, 2017, by Michael Wetter:<br/>
Changed the fan control so that they have a control signal of exactly zero if the setpoint for the
duct static pressure is zero. This leads to about a four times faster simulation
as previously, a very small control signal was received by the fan during the night hours.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/628\">#628</a>.
</li>
<li>
March 22, 2016, by Michael Wetter:<br/>
Changed the fan model to use pressure as an input, which makes the
model simulate twenty times faster.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
</ul>
</html>"),
     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/VAVSystemCTControl.mos"
        "Simulate and plot",
      file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/plotFan.mos"
        "Plot fan"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08));
end VAVSystemCTControl;
