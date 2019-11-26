within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingIndirectClosedBuildingLoop
  "Example model for indirect cooling energy transfer station that has a closed chilled water loop on the building side"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal = 0.5
    "Nominal mass flow rate on district-side (primary)";
  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal = 0.5
    "Nominal mass flow rate on building-side (secondary)";

  parameter Modelica.SIunits.SpecificHeatCapacity cp=
    Medium.specificHeatCapacityCp(
    Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Specific heat capacity of medium";

  Modelica.Blocks.Sources.Constant TSetCHWS(k=273.15 + 7)
    "Setpoint temperature for building chilled water supply"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000 + 800,
    use_T_in=false,
    T=278.15,
    nPorts=1)
    "District (primary) source"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    T=287.15,
    nPorts=1)
    "District (primary) sink"
    annotation (Placement(transformation(extent={{128,60},{108,80}})));
  Buildings.Applications.DHC.EnergyTransferStations.CoolingIndirect coo(
    redeclare package Medium = Medium,
    m1_flow_nominal=mDis_flow_nominal,
    m2_flow_nominal=mBui_flow_nominal,
    dp1_nominal = 500,
    dp2_nominal = 500,
    Q_flow_nominal=18514,
    T_a1_nominal = 278.15,
    T_a2_nominal = 289.15,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yCon_start=0,
    reverseAction=true)
    "Indirect cooling ETS"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=[0,-10E3; 6,-8E3; 6,-5E3; 12,-2E3; 18,-15E3; 24,-10E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mBui_flow_nominal,
    from_dp=false,
    linearizeFlowResistance=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    Q_flow_nominal=-1,
    dp_nominal=100)
    "Aggregate building cooling load"
    annotation (Placement(transformation(extent={{40,-86},{60,-66}})));
  Modelica.Blocks.Math.Gain gai(k=-1/(cp*(16 - 7)))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumBui(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=mBui_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=6000)
    "Building-side (secondary) pump"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-10})));
  Buildings.Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = Medium,
    V_start=1000)
    "Expansion tank"
    annotation (Placement(transformation(extent={{20,0},{40,-20}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h") = 18000,
    startTime(displayUnit="h") = 3600)
    "Ramp load from zero"
    annotation (Placement(transformation(extent={{-120,-66},{-100,-46}})));
  Modelica.Blocks.Math.Product pro
  "Multiplyer to ramp load from zero"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    T_start=278.15)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mDis_flow_nominal,
    T_start=287.15)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{70,60},{90,80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=289.15)
    "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(extent={{70,-86},{90,-66}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=mBui_flow_nominal,
    T_start=280.15)
    "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-86},{10,-66}})));
  Modelica.Blocks.Math.Add dTBui(k1=-1)
    "Calculate change in building temperature"
    annotation (Placement(transformation(extent={{110,-40},{130,-20}})));
  Modelica.Blocks.Math.Add dTDis(k1=-1)
    "Calculate change in district temperature"
    annotation (Placement(transformation(extent={{90,90},{110,110}})));
  Modelica.Blocks.Math.Add TApp(k2=-1) "Calculate approach temperature"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
equation
  connect(coo.port_b2, pumBui.port_a)
    annotation (Line(points={{40,14},{-20,14},{-20,0}},
                                                    color={0,127,255}));
  connect(gai.y, pumBui.m_flow_in)
    annotation (Line(points={{-39,-10},{-32,-10}}, color={0,0,127}));
  connect(exp.port_a, pumBui.port_a)
    annotation (Line(points={{30,0},{30,14},{-20,14},{-20,0}},
                                                           color={0,127,255}));
  connect(pro.u1, QCoo.y[1]) annotation (Line(points={{-62,-44},{-80,-44},{-80,-20},
          {-99,-20}}, color={0,0,127}));
  connect(pro.u2, ram.y)
    annotation (Line(points={{-62,-56},{-99,-56}}, color={0,0,127}));
  connect(pro.y, loa.u)
    annotation (Line(points={{-39,-50},{30,-50},{30,-70},{38,-70}},
                                                  color={0,0,127}));
  connect(gai.u, QCoo.y[1]) annotation (Line(points={{-62,-10},{-80,-10},{-80,-20},
          {-99,-20}}, color={0,0,127}));
  connect(TSetCHWS.y, coo.TSet)
    annotation (Line(points={{-99,20},{38,20}}, color={0,0,127}));
  connect(loa.port_b, TBuiRet.port_a)
    annotation (Line(points={{60,-76},{70,-76}}, color={0,127,255}));
  connect(TBuiRet.port_b, coo.port_a2) annotation (Line(points={{90,-76},{100,
          -76},{100,14},{60,14}},
                             color={0,127,255}));
  connect(pumBui.port_b, TBuiSup.port_a) annotation (Line(points={{-20,-20},{
          -20,-76},{-10,-76}},
                           color={0,127,255}));
  connect(TBuiSup.port_b, loa.port_a)
    annotation (Line(points={{10,-76},{40,-76}}, color={0,127,255}));
  connect(coo.port_b1, TDisRet.port_a) annotation (Line(points={{60,26},{66,26},
          {66,70},{70,70}}, color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{90,70},{108,70}}, color={0,127,255}));
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-10,70},{10,70}}, color={0,127,255}));
  connect(TDisSup.port_b, coo.port_a1) annotation (Line(points={{30,70},{34,70},
          {34,26},{40,26}}, color={0,127,255}));
  connect(TBuiSup.T, TApp.u1)
    annotation (Line(points={{0,-65},{0,126},{38,126}}, color={0,0,127}));
  connect(TDisSup.T, TApp.u2)
    annotation (Line(points={{20,81},{20,114},{38,114}}, color={0,0,127}));
  connect(TDisRet.T, dTDis.u2)
    annotation (Line(points={{80,81},{80,94},{88,94}}, color={0,0,127}));
  connect(dTDis.u1, TDisSup.T)
    annotation (Line(points={{88,106},{20,106},{20,81}}, color={0,0,127}));
  connect(TBuiRet.T, dTBui.u2)
    annotation (Line(points={{80,-65},{80,-36},{108,-36}}, color={0,0,127}));
  connect(dTBui.u1, TBuiSup.T)
    annotation (Line(points={{108,-24},{0,-24},{0,-65}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-140,-100},{140,140}})),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingIndirectClosedBuildingLoop.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=86400,
    Tolerance=1e-06),
  Documentation(info="<html>
<p>This model provides an example for the indirect cooling energy transfer station model. 
The cooling load ramps up from zero and is modulated according to the QCoo table specification. 
The secondary (building) chilled water is varaible flow, with the mass flow rate being adjusted 
depending on the total building load.</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2019, by Kathryn Hinkelman:<br/>
First implementation. 
</li>
</ul>
</html>"));
end CoolingIndirectClosedBuildingLoop;
