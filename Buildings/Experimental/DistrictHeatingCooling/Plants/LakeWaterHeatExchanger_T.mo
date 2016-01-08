within Buildings.Experimental.DistrictHeatingCooling.Plants;
model LakeWaterHeatExchanger_T "Heat exchanger with lake"
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters;
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final allowFlowReversal1 = true,
    final allowFlowReversal2 = true,
    final m1_flow_nominal = m_flow_nominal,
    final m2_flow_nominal = m_flow_nominal);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);
  parameter Boolean disableHeatExchanger = false
    "Set to true to disable the heat exchanger";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter String filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/Plants/AlamedaOceanT.mos"
    "Name of data file with water temperatures"
    annotation (Dialog(
        loadSelector(filter="Temperature file (*.mos)", caption=
            "Select temperature file")));

  Modelica.Blocks.Sources.CombiTimeTable watTem(
    tableOnFile=true,
    tableName="tab1",
    fileName=Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    y(unit="K"))
    "Temperature of the water reservoir (such as a river, lake or ocean)"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Interfaces.RealInput TSetHea(unit="K")
    "Temperature set point for heating"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(unit="K")
    "Temperature set point for cooling"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Fluid.HeatExchangers.HeaterCooler_T coo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0,
    final Q_flow_maxHeat=0,
    final allowFlowReversal=true,
    final show_T=false,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_maxCool=if disableHeatExchanger then 0 else -Modelica.Constants.inf)
    "Heat exchanger effect for mode in which water is cooled"
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Modelica.Blocks.Sources.RealExpression TWarIn(y=Medium.temperature_phX(
        p=port_b1.p,
        h=inStream(port_b1.h_outflow),
        X=inStream(port_b1.Xi_outflow))) "Warm water inlet temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Fluid.HeatExchangers.HeaterCooler_T hea(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0,
    final allowFlowReversal=true,
    final show_T=false,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    Q_flow_maxCool=0,
    Q_flow_maxHeat=if disableHeatExchanger then 0 else Modelica.Constants.inf)
    "Heat exchanger effect for mode in which water is heated"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Blocks.Sources.RealExpression TColIn(y=Medium.temperature_phX(
        p=port_a2.p,
        h=inStream(port_a2.h_outflow),
        X=inStream(port_a2.Xi_outflow))) "Cold water inlet temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Utilities.Math.SmoothMax maxHeaLea(deltaX=0.1) "Maximum leaving temperature"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Utilities.Math.SmoothMin minHeaLvg(deltaX=0.1) "Minimum leaving temperature"
    annotation (Placement(transformation(extent={{20,-24},{40,-4}})));
  Utilities.Math.SmoothMax maxCooLea(deltaX=0.1) "Maximum leaving temperature"
    annotation (Placement(transformation(extent={{20,16},{40,36}})));
  Utilities.Math.SmoothMin minCooLvg(deltaX=0.1) "Minimum leaving temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
equation
  connect(coo.port_b, port_a1)
    annotation (Line(points={{-10,60},{-100,60}}, color={0,127,255}));
  connect(coo.port_a, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(hea.port_b, port_b2) annotation (Line(points={{-10,-60},{-100,-60}},
                 color={0,127,255}));
  connect(hea.port_a, port_a2) annotation (Line(points={{10,-60},{100,-60}},
                 color={0,127,255}));
  connect(TColIn.y, maxHeaLea.u2) annotation (Line(points={{-59,-30},{-52,-30},{
          -52,-26},{-42,-26}}, color={0,0,127}));
  connect(watTem.y[1], maxHeaLea.u1) annotation (Line(points={{-59,0},{-50,0},{-50,
          -14},{-42,-14}}, color={0,0,127}));
  connect(maxHeaLea.y, minHeaLvg.u2)
    annotation (Line(points={{-19,-20},{0,-20},{18,-20}}, color={0,0,127}));
  connect(TSetHea, minHeaLvg.u1) annotation (Line(points={{-120,120},{-100,120},
          {-46,120},{-46,-4},{10,-4},{10,-8},{18,-8}}, color={0,0,127}));
  connect(minHeaLvg.y, hea.TSet) annotation (Line(points={{41,-14},{50,-14},{50,
          -54},{12,-54}}, color={0,0,127}));
  connect(watTem.y[1], minCooLvg.u2) annotation (Line(points={{-59,0},{-52,0},{-52,
          14},{-42,14}}, color={0,0,127}));
  connect(TWarIn.y, minCooLvg.u1) annotation (Line(points={{-59,30},{-50,30},{-50,
          26},{-42,26}}, color={0,0,127}));
  connect(minCooLvg.y, maxCooLea.u2)
    annotation (Line(points={{-19,20},{18,20}}, color={0,0,127}));
  connect(TSetCoo, maxCooLea.u1) annotation (Line(points={{-120,80},{-76,80},{-30,
          80},{-30,40},{0,40},{0,32},{18,32}}, color={0,0,127}));
  connect(maxCooLea.y, coo.TSet) annotation (Line(points={{41,26},{50,26},{50,66},
          {12,66}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end LakeWaterHeatExchanger_T;
