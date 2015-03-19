within Buildings.Examples.VAVCO2;
model VAVSystemCTControl
  "Variable air volume flow system of MIT building with CO2 control and continuous time control for static pressure reset"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air (                      extraPropertiesNames={"CO2"});
 parameter Modelica.SIunits.MassFlowRate mMIT_flow = roo.m0Tot_flow
    "Nominal mass flow rate of MIT system model as in ASHRAE 825-RP";
parameter Modelica.SIunits.Pressure dpSuiSup_nominal = 95
    "Pressure drop supply air leg with splitters of one suite (obtained from simulation)";
parameter Modelica.SIunits.Pressure dpSuiRet_nominal = 233
    "Pressure drop return air leg with splitters of one suite (obtained from simulation)";
parameter Modelica.SIunits.Pressure dpFanSupMIT_nominal = 1050
    "Pressure increase over supply fan in MIT system model as in ASHRAE 825-RP (obtained from simulation)";
parameter Modelica.SIunits.Pressure dpFanRetMIT_nominal = 347
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
Buildings.Fluid.FixedResistances.FixedResistanceDpM res31(
                                               dp_nominal=0.546,
  m_flow_nominal=scaM_flow*1,
  dh=sqrt(scaM_flow)*1,
  redeclare package Medium = Medium)
    annotation (
    Placement(transformation(extent={{60,-20},{80,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res33(
  dp_nominal=0.164,
  dh=sqrt(scaM_flow)*1,
  m_flow_nominal=scaM_flow*1,
  redeclare package Medium = Medium)
    annotation (
    Placement(transformation(extent={{160,-20},{180,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res57(
                                               dp_nominal=0.118000,
  m_flow_nominal=scaM_flow*1,
  dh=sqrt(scaM_flow)*1,
  redeclare package Medium = Medium)
    annotation (
    Placement(transformation(extent={{80,-80},{60,-60}})));
Buildings.Examples.VAVCO2.BaseClasses.Suite roo(redeclare package Medium = Medium, scaM_flow=scaM_flow)
    annotation (Placement(transformation(extent={{206,-92},
            {310,20}})));
Fluid.Actuators.Dampers.MixingBox mixBox(
  dpOut_nominal=0.467,
  dpRec_nominal=0.665,
  AOut=scaM_flow*1.32,
  AExh=scaM_flow*1.05,
  ARec=scaM_flow*1.05,
  mOut_flow_nominal=scaM_flow*1,
  mRec_flow_nominal=scaM_flow*1,
  mExh_flow_nominal=scaM_flow*1,
  redeclare package Medium = Medium,
    dpExh_nominal=0.467,
    allowFlowReversal=true,
    from_dp=false) "mixing box"
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
            annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Fluid.Movers.SpeedControlled_y fan32(
    redeclare package Medium = Medium,
    per(pressure(final V_flow={0,11.08,14.9}, dp={1508,743,100})),
    dynamicBalance=true,
    r_N(start=0),
    init=Modelica.Blocks.Types.Init.InitialState,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{122,-18},{138,-2}})));
  Fluid.Movers.SpeedControlled_y fan56(
    redeclare package Medium = Medium,
    per(pressure(final V_flow={2.676,11.05}, dp={600,100})),
    dynamicBalance=true,
    r_N(start=0),
    init=Modelica.Blocks.Types.Init.InitialState,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{138,-78},{122,-62}})));
  Modelica.Blocks.Sources.Trapezoid
                                pSet(
    amplitude=120,
    period=86400,
    width=86400/2,
    falling=10,
    rising=120,
    startTime=6*3600) "Pressure setpoint (0 during night, 120 during day)"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(PAtm.y, bouIn.p_in) annotation (Line(
      points={{-59,-40},{-50,-40},{-50,-56},{-40,-56}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(roo.p_rel, conSupFan.u_m)
                              annotation (Line(
      points={{312.6,-23.0769},{320,-23.0769},{320,60},{50,60},{50,78}},
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
      points={{-19,90},{38,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSupFan.y, fan32.y) annotation (Line(
      points={{61,90},{110,90},{110,40},{130,40},{130,-0.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSupFan.y, fan56.y) annotation (Line(
      points={{61,90},{110,90},{110,-48},{130,-48},{130,-60.4}},
      color={0,0,127},
      smooth=Smooth.None));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{350,150}}), graphics),
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
</html>"),
     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/VAVSystemCTControl.mos"
        "Simulate and plot",
      file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/plotFan.mos"
        "Plot fan"),
    experiment(
      StopTime=172800,
      Tolerance=1e-006));
end VAVSystemCTControl;
