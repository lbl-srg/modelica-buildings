within Buildings.ChillerWSE.Examples;
model IntegratedPrimaryLoadSide
  "Example that show how to use Buildings.ChillerWSE.IntegratedPrimaryLoadSide"

  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // chillers parameters
  parameter Integer nChi=2 "Number of chillers";
  parameter Modelica.SIunits.MassFlowRate mChiller1_flow_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate mChiller2_flow_nominal= 18.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dpChiller1_nominal = 46.2*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpChiller2_nominal = 44.8*1000
    "Nominal pressure";

 // WSE parameters
  parameter Modelica.SIunits.MassFlowRate mWSE1_flow_nominal= 34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.MassFlowRate mWSE2_flow_nominal= 35.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.SIunits.PressureDifference dpWSE1_nominal = 33.1*1000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpWSE2_nominal = 34.5*1000
    "Nominal pressure";


  parameter Buildings.Fluid.Movers.Data.Generic[nChi] perPum(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=mChiller2_flow_nominal/1000*{0.2,0.6,1.0,1.2}, dp=dpChiller2_nominal*{1.2,
          1.1,1.0,0.6}));

  Buildings.ChillerWSE.IntegratedPrimaryLoadSide intWSEPri(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    nChi=nChi,
    addPowerToMedium=false,
    perPum=perPum,
    mChiller1_flow_nominal=mChiller1_flow_nominal,
    mChiller2_flow_nominal=mChiller2_flow_nominal,
    mWSE1_flow_nominal=mWSE1_flow_nominal,
    mWSE2_flow_nominal=mWSE2_flow_nominal,
    dpChiller1_nominal=dpChiller1_nominal,
    dpWSE1_nominal=dpWSE1_nominal,
    dpChiller2_nominal=dpChiller2_nominal,
    dpWSE2_nominal=dpWSE2_nominal,
    redeclare
      Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
      perChi)
    "Integrated waterside economizer on the load side of a primary-only chilled water system"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium =
        MediumW, V_start=1)
    annotation (Placement(transformation(extent={{52,59},{72,79}})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow[nChi](
    redeclare package Medium = MediumW,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=6,
    dp_nominal=14930 + 14930 + 74650,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    m_flow_nominal=mChiller1_flow_nominal) "Cooling tower" annotation (
      Placement(transformation(extent={{10,-10},{-10,10}}, origin={3,51})));
  Fluid.Sources.FixedBoundary           sin2(
    nPorts=1, redeclare package Medium = MediumW)   "Sink on medium 2 side"
                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70})));
  Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller2_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-54},{-60,-34}})));
  redeclare replaceable Fluid.Sources.Boundary_pT                sou2(
    nPorts=1,
    redeclare package Medium = MediumW,
    T=291.15)
  constrainedby Fluid.Sources.Boundary_pT(
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    T=291.15) "Source on medium 2 side"
    annotation (Placement(transformation(extent={{58,-84},{38,-64}})));
  Modelica.Blocks.Sources.Constant
                               TEva_in(k=273.15 + 25.28)
                   "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Sources.Constant TSet(k(unit="K",displayUnit="degC")=273.15+15.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Sources.BooleanStep onChi(startTime(displayUnit="h") = 7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(startTime(displayUnit="h") = 14400,
      startValue=true) "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Blocks.Sources.Constant yVal7(k=0) "Conrol signal for valve 7"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.Constant yPum(k=1) "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  Modelica.Blocks.Sources.RealExpression yVal5(y=if onChi.y and not onWSE.y
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{100,86},{80,106}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if not onChi.y and onWSE.y
         then 1 else 0) "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{100,66},{80,86}})));
  Modelica.Blocks.Sources.Constant yFanCT(k=1) "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{100,120},{80,140}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaData(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-50,112},{-30,132}})));
  Fluid.Sensors.TemperatureTwoPort TSupCW(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller1_flow_nominal)
    annotation (Placement(transformation(extent={{-18,50},{-38,70}})));
  Fluid.Sensors.TemperatureTwoPort TRetCW(redeclare package Medium = MediumW,
      m_flow_nominal=nChi*mChiller1_flow_nominal)
    annotation (Placement(transformation(extent={{20,-4},{40,16}})));
  Fluid.Movers.FlowControlled_m_flow pumCW[2](
    redeclare package Medium = MediumW,
    addPowerToMedium=false,
    m_flow_nominal=mChiller1_flow_nominal) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,26})));
  Modelica.Blocks.Sources.Constant mPumCW(k=mChiller1_flow_nominal)
    "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{-100,-22},{-80,-2}})));
equation
  connect(sou2.T_in,TEva_in. y)
    annotation (Line(points={{60,-70},{79,-70}},          color={0,0,127}));
  connect(intWSEPri.port_b2, TSup.port_a) annotation (Line(points={{-10,-6},{-36,
          -6},{-36,-44},{-40,-44}}, color={0,127,255}));
  connect(TSup.port_b, sin2.ports[1]) annotation (Line(points={{-60,-44},{-70,-44},
          {-70,-70},{-80,-70}}, color={0,127,255}));
  connect(intWSEPri.port_a2, sou2.ports[1]) annotation (Line(points={{10,-6},{24,
          -6},{24,-74},{38,-74}}, color={0,127,255}));
  connect(onChi.y, intWSEPri.on[1]) annotation (Line(points={{-79,90},{-64,90},{
          -64,8},{-64,7.6},{-11.6,7.6}}, color={255,0,255}));
  connect(TSet.y, intWSEPri.TSet) annotation (Line(points={{-79,60},{-79,60},{-60,
          60},{-60,10.8},{-11.6,10.8}}, color={0,0,127}));
  connect(yVal5.y, intWSEPri.yVal5) annotation (Line(points={{79,96},{-58,96},{-58,
          3},{-11.6,3}},          color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6) annotation (Line(points={{79,76},{72,76},{72,
          88},{-58,88},{-58,-0.2},{-11.6,-0.2}}, color={0,0,127}));
  connect(yPum.y, intWSEPri.yPum[1]) annotation (Line(points={{79,50},{72,50},{72,
          88},{-58,88},{-58,-4.4},{-11.6,-4.4}}, color={0,0,127}));
  connect(yVal7.y, intWSEPri.yVal7) annotation (Line(points={{79,20},{70,20},{70,
          -20},{-3.2,-20},{-3.2,-11.6}}, color={0,0,127}));
  connect(weaData.weaBus, weaBus.TWetBul) annotation (Line(
      points={{-80,130},{-54,130},{-40,130},{-40,122}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(intWSEPri.port_b1, TRetCW.port_a)
    annotation (Line(points={{10,6},{20,6}}, color={0,127,255}));
  connect(TRetCW.port_b, expVesChi.port_a)
    annotation (Line(points={{40,6},{62,6},{62,59}}, color={0,127,255}));
  connect(mPumCW.y, pumCW[1].m_flow_in) annotation (Line(points={{-79,-12},{-68,
          -12},{-68,26.2},{-52,26.2}}, color={0,0,127}));
  connect(mPumCW.y, pumCW[2].m_flow_in) annotation (Line(points={{-79,-12},{-68,
          -12},{-68,26.2},{-52,26.2}}, color={0,0,127}));
  connect(onChi.y, intWSEPri.on[2]) annotation (Line(points={{-79,90},{-64,90},{
          -64,7.6},{-11.6,7.6}}, color={255,0,255}));
  connect(onWSE.y, intWSEPri.on[3]) annotation (Line(points={{-79,20},{-74,20},{
          -74,7.6},{-11.6,7.6}}, color={255,0,255}));
  connect(yPum.y, intWSEPri.yPum[2]) annotation (Line(points={{79,50},{74,50},{74,
          52},{74,92},{-54,92},{-54,-4},{-54,-4.4},{-11.6,-4.4}}, color={0,0,127}));


   for i in 1:nChi loop
     connect(cooTow[i].TAir, weaBus.TWetBul.TWetBul) annotation (Line(points={{15,55},
          {24,55},{24,122},{-40,122}}, color={0,0,127}));

     connect(cooTow[i].y, yFanCT.y) annotation (Line(points={{15,59},{40,59},{40,130},
          {79,130}}, color={0,0,127}));
     connect(cooTow[i].port_a, expVesChi.port_a)
       annotation (Line(points={{13,51},{62,51},{62,59}}, color={0,127,255}));
     connect(TSupCW.port_a, cooTow[i].port_b) annotation (Line(points={{-18,60},{-14,
          60},{-14,51},{-7,51}}, color={0,127,255}));
     connect(pumCW[i].port_b, intWSEPri.port_a1)
      annotation (Line(points={{-40,16},{-40,6},{-10,6}}, color={0,127,255}));
  connect(pumCW[i].port_a, TSupCW.port_b)
    annotation (Line(points={{-40,36},{-40,60},{-38,60}}, color={0,127,255}));
   end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end IntegratedPrimaryLoadSide;
