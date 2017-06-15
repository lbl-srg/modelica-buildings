within Buildings.ChillerWSE.Examples;
model IntegratedPrimary
  "Integrated waterside economizer on the load side in the primary-only system"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=1000 * 0.01035
    "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=1000 * 0.01035
    "Nominal mass flow rate at condenser";

  parameter Integer nChi=2;

   parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
    per[nChi] "Chiller performance data"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  parameter Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 perPum[nChi]
    annotation (Placement(transformation(extent={{20,78},{40,98}})));

  Buildings.ChillerWSE.IntegratedPrimary intWSEPri(
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    mChiller1_flow_nominal=m1_flow_nominal,
    mChiller2_flow_nominal=m2_flow_nominal,
    mWSE1_flow_nominal=m1_flow_nominal,
    mWSE2_flow_nominal=m2_flow_nominal,
    dpChiller1_nominal=60000,
    dpWSE1_nominal=60000,
    dpChiller2_nominal=60000,
    dpWSE2_nominal=60000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    nChi=nChi,
    per=per,
    perPum=perPum,
    k=0.4,
    Ti=80)
    "Integrated WSE on the load side in a primary-only system"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Fluid.Sources.Boundary_pT      sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    nPorts=1,
    T=291.15)
    annotation (Placement(transformation(extent={{98,-84},{78,-64}})));
  Buildings.Fluid.Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2,
    nPorts=1)                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-112,-82})));
  Buildings.Fluid.FixedResistances.PressureDrop res2(
    dp_nominal=6000,
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal)   "Flow resistance"
    annotation (Placement(transformation(extent={{-70,-90},{-90,-70}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1,
    m_flow=m1_flow_nominal,
    T=298.15)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1,
    nPorts=1)                           annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={124,-18})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium1,
    dp_nominal=6000,
    m_flow_nominal=m1_flow_nominal)
                     "Flow resistance"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    offset=273.15 + 20,
    duration=3600,
    startTime=2*3600) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-140,-38},{-120,-18}})));
  Modelica.Blocks.Sources.Ramp TSet(
    duration=3600,
    startTime=3*3600,
    offset=273.15 + 10,
    height=8) "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Modelica.Blocks.Sources.BooleanStep onChi1(startValue=true)
                                             "On/off signal for chiller 1"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Sources.BooleanStep onChi2(startValue=true)
                                             "On/off signal for chiller 1"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Modelica.Blocks.Sources.BooleanStep onWSE "On/off signal for WSE"
    annotation (Placement(transformation(extent={{0,70},{-20,90}})));
  Modelica.Blocks.Sources.BooleanExpression wseMod(y=onWSE.y and not (onChi1.y
         or onChi2.y)) "=true, activate wse mode; =false, deactivate wse mode"
    annotation (Placement(transformation(extent={{0,30},{-20,50}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    offset=273.15 + 15,
    height=5,
    startTime=3600,
    duration=3600) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{140,-80},{120,-60}})));
  Modelica.Blocks.Sources.Constant yVal3(k=0)
    "Valve position in the common leg" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-2,-90})));
  Modelica.Blocks.Sources.Constant yPum(k=1) "Speed signal for pumps"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,-60})));

  Fluid.Sensors.TemperatureTwoPort senConOut(redeclare package Medium = Medium1,
      m_flow_nominal=m1_flow_nominal) "Temperature sensor at condenser outlet"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Fluid.Sensors.TemperatureTwoPort senEvaOut(redeclare package Medium = Medium2,
      m_flow_nominal=m2_flow_nominal) "Temperature at evaporator outlet"
    annotation (Placement(transformation(extent={{-30,-90},{-50,-70}})));
equation
  connect(TCon_in.y, sou1.T_in)
    annotation (Line(points={{-119,-28},{-112,-28},{-112,-16},{-102,-16}},
                                                   color={0,0,127}));
  connect(onChi1.y, intWSEPri.on[1]) annotation (Line(points={{-119,90},{-40,90},
          {-40,-36},{-12,-36}}, color={255,0,255}));
  connect(onChi2.y, intWSEPri.on[2]) annotation (Line(points={{-119,50},{-40,50},
          {-40,-36},{-12,-36}}, color={255,0,255}));
  connect(onWSE.y, intWSEPri.on[3]) annotation (Line(points={{-21,80},{-34,80},{
          -34,-36},{-12,-36}}, color={255,0,255}));
  connect(wseMod.y, intWSEPri.wseMod) annotation (Line(points={{-21,40},{-28,40},
          {-28,-32},{-12,-32}}, color={255,0,255}));
  connect(sou1.ports[1], intWSEPri.port_a1) annotation (Line(points={{-80,-20},{
          -80,-20},{-48,-20},{-48,-34},{-10,-34}},
                               color={0,127,255}));
  connect(res1.port_b, sin1.ports[1])
    annotation (Line(points={{100,-20},{114,-20},{114,-18}},
                                                       color={0,127,255}));
  connect(TEva_in.y, sou2.T_in) annotation (Line(points={{119,-70},{100,-70}},
                     color={0,0,127}));
  connect(sou2.ports[1], intWSEPri.port_a2) annotation (Line(points={{78,-74},{78,
          -74},{20,-74},{20,-46},{10,-46}}, color={0,127,255}));
  connect(sin2.ports[1], res2.port_b) annotation (Line(points={{-102,-82},{-102,
          -80},{-90,-80}},
                      color={0,127,255}));
  connect(TSet.y, intWSEPri.TSet) annotation (Line(points={{-119,10},{-20,10},{-20,
          -40},{-12,-40}}, color={0,0,127}));
  connect(yPum.y, intWSEPri.yPum[1]) annotation (Line(points={{-119,-60},{-46,-60},
          {-46,-44},{-12,-44}}, color={0,0,127}));
  connect(yPum.y, intWSEPri.yPum[2]) annotation (Line(points={{-119,-60},{-119,-60},
          {-46,-60},{-46,-44},{-12,-44}}, color={0,0,127}));
  connect(intWSEPri.yVal3, yVal3.y)
    annotation (Line(points={{-2.8,-52},{-2,-52},{-2,-79}}, color={0,0,127}));
  connect(intWSEPri.port_b1, senConOut.port_a) annotation (Line(points={{10,-34},
          {20,-34},{20,-20},{40,-20}}, color={0,127,255}));
  connect(senConOut.port_b, res1.port_a)
    annotation (Line(points={{60,-20},{80,-20}}, color={0,127,255}));
  connect(res2.port_a, senEvaOut.port_b)
    annotation (Line(points={{-70,-80},{-50,-80}}, color={0,127,255}));
  connect(senEvaOut.port_a, intWSEPri.port_b2) annotation (Line(points={{-30,-80},
          {-20,-80},{-20,-46},{-10,-46}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-160,-100},{140,100}})), Icon(
        coordinateSystem(extent={{-160,-100},{140,100}})));
end IntegratedPrimary;
