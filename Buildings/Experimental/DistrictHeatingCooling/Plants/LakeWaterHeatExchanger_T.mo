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

  parameter Modelica.SIunits.TemperatureDifference TApp(min=0, displayUnit="K") = 0.5
    "Approach temperature difference";

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
    annotation (Placement(transformation(extent={{-80,216},{-60,236}})));
  Modelica.Blocks.Interfaces.RealInput TSetHea(unit="K")
    "Temperature set point for heating"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(unit="K")
    "Temperature set point for cooling"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
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
    annotation (Placement(transformation(extent={{-40,156},{-20,176}})));
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
    annotation (Placement(transformation(extent={{-40,98},{-20,118}})));
  Utilities.Math.SmoothMax maxHeaLea(deltaX=0.1) "Maximum leaving temperature"
    annotation (Placement(transformation(extent={{8,104},{28,124}})));
  Utilities.Math.SmoothMin minHeaLvg(deltaX=0.1) "Minimum leaving temperature"
    annotation (Placement(transformation(extent={{52,116},{72,136}})));
  Utilities.Math.SmoothMax maxCooLea(deltaX=0.1) "Maximum leaving temperature"
    annotation (Placement(transformation(extent={{52,156},{72,176}})));
  Utilities.Math.SmoothMin minCooLvg(deltaX=0.1) "Minimum leaving temperature"
    annotation (Placement(transformation(extent={{8,150},{28,170}})));
  Modelica.Blocks.Sources.Constant TAppHex(k=TApp)
    "Approach temperature difference"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Modelica.Blocks.Math.Add TWatHea
    "Heat exchanger outlet, taking into account approach"
    annotation (Placement(transformation(extent={{-30,186},{-10,206}})));
  Modelica.Blocks.Math.Add TWatCoo(k2=-1)
    "Heat exchanger outlet, taking into account approach"
    annotation (Placement(transformation(extent={{-30,220},{-10,240}})));
equation
  connect(coo.port_b, port_a1)
    annotation (Line(points={{-10,60},{-100,60}}, color={0,127,255}));
  connect(coo.port_a, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(hea.port_b, port_b2) annotation (Line(points={{-10,-60},{-100,-60}},
                 color={0,127,255}));
  connect(hea.port_a, port_a2) annotation (Line(points={{10,-60},{100,-60}},
                 color={0,127,255}));
  connect(TColIn.y, maxHeaLea.u2) annotation (Line(points={{-19,108},{-19,108},{
          6,108}},             color={0,0,127}));
  connect(maxHeaLea.y, minHeaLvg.u2)
    annotation (Line(points={{29,114},{42,114},{42,120},{44,120},{50,120}},
                                                          color={0,0,127}));
  connect(TSetHea, minHeaLvg.u1) annotation (Line(points={{-120,160},{-60,160},
          {-60,132},{50,132}},                         color={0,0,127}));
  connect(minHeaLvg.y, hea.TSet) annotation (Line(points={{73,126},{86,126},{86,
          -54},{12,-54}}, color={0,0,127}));
  connect(TWarIn.y, minCooLvg.u1) annotation (Line(points={{-19,166},{-19,166},{
          6,166}},       color={0,0,127}));
  connect(minCooLvg.y, maxCooLea.u2)
    annotation (Line(points={{29,160},{29,160},{50,160}},
                                                color={0,0,127}));
  connect(TSetCoo, maxCooLea.u1) annotation (Line(points={{-120,100},{44,100},{
          44,172},{50,172}},                   color={0,0,127}));
  connect(maxCooLea.y, coo.TSet) annotation (Line(points={{73,166},{80,166},{80,
          66},{12,66}},
                    color={0,0,127}));
  connect(watTem.y[1], TWatHea.u1) annotation (Line(points={{-59,226},{-50,226},
          {-50,202},{-40,202},{-32,202}}, color={0,0,127}));
  connect(TAppHex.y, TWatHea.u2)
    annotation (Line(points={{-59,190},{-32,190}}, color={0,0,127}));
  connect(TAppHex.y, TWatCoo.u2) annotation (Line(points={{-59,190},{-40,190},{-40,
          224},{-32,224}}, color={0,0,127}));
  connect(TWatCoo.u1, watTem.y[1]) annotation (Line(points={{-32,236},{-50,236},
          {-50,226},{-59,226}}, color={0,0,127}));
  connect(TWatCoo.y, minCooLvg.u2) annotation (Line(points={{-9,230},{0,230},{0,
          154},{6,154}}, color={0,0,127}));
  connect(TWatHea.y, maxHeaLea.u1) annotation (Line(points={{-9,196},{-4,196},{-4,
          120},{6,120}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,260}})), Icon(coordinateSystem(extent={{-100,-100},{100,
            260}}, preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,260}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),  Rectangle(
          extent={{-64,244},{70,118}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          radius=10),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-62,84},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-136,214},{-82,176}},
          lineColor={0,0,127},
          textString="TSetHea"),
        Text(
          extent={{-134,148},{-80,110}},
          lineColor={0,0,127},
          textString="TSetCoo"),
        Text(
          extent={{-139,-100},{161,-140}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-18,137},{-10,84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,137},{22,84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,218},{42,240},{18,182},{48,144},{30,132},{0,138},{-30,132},
              {-34,162},{-34,202},{-18,208},{12,218}},
          smooth=Smooth.Bezier,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255},
          pattern=LinePattern.None)}));
end LakeWaterHeatExchanger_T;
