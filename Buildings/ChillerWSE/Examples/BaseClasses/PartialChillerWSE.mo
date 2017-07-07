within Buildings.ChillerWSE.Examples.BaseClasses;
model PartialChillerWSE
  "Partial examples for chillers and WSE configurations"
  extends Modelica.Icons.Example;

  replaceable package MediumCHW = Buildings.Media.Water "Medium model";
  replaceable package MediumCW = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2567.1*1000/(
      4200*10) "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2567.1*1000/ (
      4200*8.5) "Nominal mass flow rate at condenser water";

  parameter Modelica.SIunits.PressureDifference dpCHW_nominal = 40000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal = 40000
    "Nominal pressure";
  parameter Integer nChi=1 "Number of chillers";
  parameter Buildings.Fluid.Movers.Data.Generic[nChi] perPum(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=mCHW_flow_nominal/1000*{0.2,0.6,1.0,1.2}, dp=dpCHW_nominal*{1.2,
          1.1,1.0,0.6}));

  Fluid.Sources.FixedBoundary           sin1(
    nPorts=1, redeclare package Medium = MediumCW)
                                        annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={90,-4})));
  Fluid.Sources.MassFlowSource_T           sou1(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = MediumCW,
    m_flow=mCW_flow_nominal,
    T=298.15)
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.TimeTable TCon_in(
    table=[0,273.15 + 12.78; 7200,273.15 + 12.78; 7200,273.15 + 18.33; 14400,273.15
         + 18.33; 14400,273.15 + 26.67],
    offset=0,
    startTime=0)      "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Fluid.Sources.FixedBoundary           sin2(
    nPorts=1, redeclare package Medium = MediumCHW)
                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70})));
  Fluid.Sources.Boundary_pT                sou2(
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = MediumCHW,
    T=291.15)
    annotation (Placement(transformation(extent={{58,-84},{38,-64}})));
  Modelica.Blocks.Sources.Constant
                               TEva_in(k=273.15 + 25.28)
                   "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  IntegratedPrimaryLoadSide intWSEPri(
    mChiller1_flow_nominal=mCW_flow_nominal,
    mChiller2_flow_nominal=mCHW_flow_nominal,
    mWSE1_flow_nominal=mCW_flow_nominal,
    mWSE2_flow_nominal=mCHW_flow_nominal,
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    dpChiller1_nominal=dpCW_nominal,
    dpWSE1_nominal=dpCW_nominal,
    dpChiller2_nominal=dpCHW_nominal,
    dpWSE2_nominal=dpCHW_nominal,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    redeclare
      Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Trane_CVHF_2567kW_11_77COP_VSD
      perChi,
    k=0.4,
    Ti=80,
    perPum=perPum,
    nChi=nChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
  Modelica.Blocks.Sources.Constant TSet(k(displayUnit="degC")=273.15+15.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Sources.BooleanStep
                                   onChi(startTime(displayUnit="h") = 7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(startTime(displayUnit="h") = 14400,
      startValue=true) "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Modelica.Blocks.Sources.RealExpression yVal5(y=if onChi.y and not onWSE.y
         then 1 else 0) "On/off signal for valve 5"
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
  Modelica.Blocks.Sources.RealExpression yVal6(y=if not onChi.y and onWSE.y
         then 1 else 0) "On/off signal for valve 6"
    annotation (Placement(transformation(extent={{40,40},{20,60}})));
  Modelica.Blocks.Sources.Constant yVal7(
                                        k=0) "Conrol signal for valve 7"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Constant yPum(k=1) "Conrol signal for pumps"
    annotation (Placement(transformation(extent={{40,20},{20,40}})));
  Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium = MediumCHW,
      m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-54},{-60,-34}})));
equation
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-79,-10},{-72,-10},{-72,0},{-62,0}},
                                                   color={0,0,127}));
  connect(sou2.T_in, TEva_in.y)
    annotation (Line(points={{60,-70},{79,-70}},          color={0,0,127}));
  connect(TSet.y, intWSEPri.TSet) annotation (Line(points={{-79,60},{-79,60},{-20,
          60},{-20,-27.2},{-11.6,-27.2}}, color={0,0,127}));
  connect(onChi.y, intWSEPri.on[1]) annotation (Line(points={{-79,90},{-26,90},{
          -26,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(onWSE.y, intWSEPri.on[2]) annotation (Line(points={{-79,20},{-26,20},{
          -26,-30.4},{-11.6,-30.4}}, color={255,0,255}));
  connect(sou1.ports[1], intWSEPri.port_a1) annotation (Line(points={{-40,-4},{-32,
          -4},{-32,-32},{-10,-32}}, color={0,127,255}));
  connect(intWSEPri.port_b1, sin1.ports[1]) annotation (Line(points={{10,-32},{60,
          -32},{60,-4},{80,-4}}, color={0,127,255}));
  connect(yVal5.y, intWSEPri.yVal5) annotation (Line(points={{19,70},{8,70},{-18,
          70},{-18,-35},{-11.6,-35}}, color={0,0,127}));
  connect(yVal6.y, intWSEPri.yVal6) annotation (Line(points={{19,50},{19,50},{-18,
          50},{-18,-38.2},{-11.6,-38.2}}, color={0,0,127}));
  connect(yVal7.y, intWSEPri.yVal7) annotation (Line(points={{-19,-70},{-3.2,-70},
          {-3.2,-49.6}}, color={0,0,127}));
  connect(yPum.y, intWSEPri.yPum[1]) annotation (Line(points={{19,30},{-18,30},{
          -18,-42.4},{-11.6,-42.4}}, color={0,0,127}));
  connect(sou2.ports[1], intWSEPri.port_a2) annotation (Line(points={{38,-74},{24,
          -74},{24,-44},{10,-44}}, color={0,127,255}));
  connect(sin2.ports[1], TSup.port_b) annotation (Line(points={{-80,-70},{-60,-70},
          {-60,-44}}, color={0,127,255}));
  connect(TSup.port_a, intWSEPri.port_b2)
    annotation (Line(points={{-40,-44},{-10,-44}}, color={0,127,255}));
end PartialChillerWSE;
