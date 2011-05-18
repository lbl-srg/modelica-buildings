within Buildings.Examples.VAVCO2;
model VAVSystemCTControl
  "VAV system model of MIT building with continuous time control for static pressure reset"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});

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
      annotation (extent=[-86,-50; -66,-30],
                                           style(thickness=2),
    Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant yDam(k=0.5)
      annotation (extent=[-40,20; -20,40], style(thickness=2),
    Placement(transformation(extent={{-40,-20},{-20,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res31(
                                               dp_nominal=0.546,
  m_flow_nominal=scaM_flow*1,
  dh=sqrt(scaM_flow)*1,
  redeclare package Medium = Medium,
    allowFlowReversal=false)
    annotation (extent=[50,-20; 70,0],style(thickness=2),
    Placement(transformation(extent={{50,-20},{70,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res33(
  dp_nominal=0.164,
  dh=sqrt(scaM_flow)*1,
  m_flow_nominal=scaM_flow*1,
  redeclare package Medium = Medium,
    allowFlowReversal=false)
    annotation (extent=[144,-20; 164,0],style(thickness=2),
    Placement(transformation(extent={{170,-20},{190,0}})));
Buildings.Fluid.FixedResistances.FixedResistanceDpM res57(
                                               dp_nominal=0.118000,
  m_flow_nominal=scaM_flow*1,
  dh=sqrt(scaM_flow)*1,
  redeclare package Medium = Medium,
    allowFlowReversal=false)
    annotation (extent=[54,-80; 74,-60], style(thickness=2),
    Placement(transformation(extent={{68,-80},{48,-60}})));
Buildings.Examples.VAVCO2.BaseClasses.Suite roo(redeclare package Medium = Medium, scaM_flow=scaM_flow)
    annotation (extent=[198,-92; 302,20], Placement(transformation(extent={{206,-92},
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
    allowFlowReversal=true) "mixing box"
                            annotation (extent=[8,-72; 28,-52],  style(
        thickness=2),
    Placement(transformation(extent={{10,-72},{30,-52}})));
  Buildings.Fluid.Sources.Boundary_pT bouIn(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=2)                                           annotation (extent=[-38,-18;
        -18,2],  style(thickness=2),
    Placement(transformation(extent={{-38,-74},{-18,-54}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

   Buildings.Controls.Continuous.LimPID conSupFan(
    Ti=60,
    yMax=1,
    yMin=0,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.1,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    y_start=0.5) "Controller for supply fan"
            annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.Constant const(k=120)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Fluid.Movers.FlowMachine_y fan32(
    redeclare package Medium = Medium,
    m_flow_nominal=mMIT_flow,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,11.08,14.9}, dp_nominal={1508,743,100}),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    dynamicBalance=true,
    homotopyInitialization=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{92,-18},{108,-2}})));
  Fluid.Movers.FlowMachine_y fan56(
    redeclare package Medium = Medium,
    m_flow_nominal=mMIT_flow,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          V_flow_nominal={2.676,11.05}, dp_nominal={600,100}),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    dynamicBalance=true,
    homotopyInitialization=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{108,-78},{92,-62}})));
  Fluid.Sensors.VolumeFlowRate senVolFloSup(redeclare package Medium = Medium,
      m_flow_nominal=mMIT_flow,
    allowFlowReversal=false) "Volume flow rate of supply fan"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Fluid.Sensors.VolumeFlowRate senVolFloSup1(redeclare package Medium = Medium,
      m_flow_nominal=mMIT_flow,
    allowFlowReversal=false) "Volume flow rate of supply fan"
    annotation (Placement(transformation(extent={{156,-80},{136,-60}})));
   Buildings.Controls.Continuous.LimPID conRetFan(
    Ti=60,
    yMax=1,
    yMin=0,
    Td=60,
    k=0.1/mMIT_flow,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    y_start=0.5,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
    "Controller for return fan"
            annotation (Placement(transformation(extent={{120,80},{140,100}})));
equation
  connect(PAtm.y, bouIn.p_in) annotation (Line(
      points={{-59,-40},{-50,-40},{-50,-56},{-40,-56}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(const.y, conSupFan.u_s)
                            annotation (Line(
      points={{21,90},{38,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.p_rel, conSupFan.u_m)
                              annotation (Line(
      points={{312.6,-17.3333},{320,-17.3333},{320,60},{50,60},{50,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yDam.y, mixBox.y) annotation (Line(
      points={{-19,-10},{20,-10},{20,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo.p, PAtm.y) annotation (Line(
      points={{201.32,12.5333},{72,12},{-50,12},{-50,-40},{-59,-40}},
      color={255,0,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(mixBox.port_Sup, res31.port_a) annotation (Line(
      points={{30,-56},{40,-56},{40,-10},{50,-10}},
      color={0,127,255},
      thickness=0.5,
      smooth=Smooth.None));

  connect(res31.port_b, fan32.port_a) annotation (Line(
      points={{70,-10},{92,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res57.port_b, mixBox.port_Ret) annotation (Line(
      points={{48,-70},{42,-70},{42,-68},{30,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res33.port_b, roo.port_aSup) annotation (Line(
      points={{190,-10},{192,-10},{192,-9.86667},{206,-9.86667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conSupFan.y, fan32.y)
                          annotation (Line(
      points={{61,90},{80,90},{80,30},{100,30},{100,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bouIn.ports[1], mixBox.port_Out) annotation (Line(
      points={{-18,-62},{-4,-62},{-4,-56},{10,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.ports[2], mixBox.port_Exh) annotation (Line(
      points={{-18,-66},{-4,-66},{-4,-68},{10,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan32.port_b, senVolFloSup.port_a) annotation (Line(
      points={{108,-10},{120,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senVolFloSup.port_b, res33.port_a) annotation (Line(
      points={{140,-10},{170,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senVolFloSup.V_flow, conRetFan.u_s) annotation (Line(
      points={{130,1},{130,48},{100,48},{100,90},{118,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senVolFloSup1.V_flow, conRetFan.u_m) annotation (Line(
      points={{146,-59},{146,66},{130,66},{130,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan56.port_b, res57.port_a) annotation (Line(
      points={{92,-70},{68,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan56.port_a, senVolFloSup1.port_b) annotation (Line(
      points={{108,-70},{136,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senVolFloSup1.port_a, roo.port_bExh) annotation (Line(
      points={{156,-70},{184,-70},{184,-69.6},{206,-69.6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conRetFan.y, fan56.y) annotation (Line(
      points={{141,90},{160,90},{160,-40},{100,-40},{100,-62}},
      color={0,0,127},
      smooth=Smooth.None));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{350,150}}), graphics),
Documentation(info="<html>
<p>
This examples demonstrates the implementation of CO<sub>2</sub> control
for a variable air volume flow system.
Each room has a CO<sub>2</sub> source. Depending on the CO<sub>2</sub>
concentrations, the air damper in the room open or close.
The supply and return fans are controlled to provide a constant static
pressure.
</p>
<p>
Note that this example does not control the room temperature and 
the heat flow through the building envelope. It only implements the 
CO<sub>2</sub> transfer.
</p>
<h4>Information for Windows users:</h4>
<p>
This example uses the Radau solver. 
For Dymola 7.4, Microsoft Visual C++ Express 2010 does
not work with the Radau solver.
Microsoft Visual C++ Express is not officialy supported by Dymola 7.4 and it can not link
the model to the Radau solver. 
To avoid this problem, use another compiler, such as Visual C++ 2008. 
</p>
</html>"),            
     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/run1DayCTControl.mos" "Run",
      file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/plotRooACH.mos" "Plot room air change per hour",
      file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/plotFan.mos" "Plot fan",
      file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVCO2/plotCO2.mos" "Plot CO2"),
    experiment(
      StopTime=86400,
      Tolerance=1e-005,
      Algorithm="Radau"));
end VAVSystemCTControl;
