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

  parameter Modelica.SIunits.Temperature TLooMax "Maximum loop temperature";
  parameter Modelica.SIunits.Temperature TLooMin "Minimum loop temperature";

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
  Modelica.Blocks.Interfaces.RealInput TSetHea(unit="K")
    "Temperature set point for heating"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Interfaces.RealInput TSetCoo(unit="K")
    "Temperature set point for cooling"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealOutput TWat(unit="K")
    "Temperature of water reservoir"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Modelica.Blocks.Interfaces.RealOutput QWat_flow(unit="W")
    "Heat exchanged with water reservoir (positive if added to reservoir)"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Fluid.Actuators.Valves.ThreeWayLinear valCoo(
    redeclare final package Medium =  Medium,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    filteredOpening=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final dpFixed_nominal={if disableHeatExchanger then 0 else dp_nominal,0})
    "Switching valve for cooling"                                       annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,60})));
  Fluid.Actuators.Valves.ThreeWayLinear valHea(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    filteredOpening=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    final dpFixed_nominal={0,0}) "Switching valve for heating"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-60})));

protected
  Modelica.Blocks.Sources.CombiTimeTable watTem(
    tableOnFile=true,
    tableName="tab1",
    fileName=Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    y(unit="K"))
    "Temperature of the water reservoir (such as a river, lake or ocean)"
    annotation (Placement(transformation(extent={{-80,216},{-60,236}})));

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
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
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
    annotation (Placement(transformation(extent={{40,190},{60,210}})));
  Modelica.Blocks.Math.Add TWatCoo(k2=-1)
    "Heat exchanger outlet, taking into account approach"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Modelica.Blocks.Math.Add QExc_flow(k1=-1) "Heat added to water reservoir"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
public
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-100,238},{-60,278}}),
                                                     iconTransformation(extent=
            {{-10,224},{10,244}})));
  Utilities.Math.SmoothMax smoothMax(deltaX=0.1)
    annotation (Placement(transformation(extent={{-10,198},{10,218}})));
  Utilities.Math.SmoothMin smoothMin(deltaX=0.1)
    annotation (Placement(transformation(extent={{-10,230},{10,250}})));
protected
  Modelica.Blocks.Sources.Constant TMaxDes(k=TLooMax)
    "Maximum desired outlet temperature"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Modelica.Blocks.Sources.Constant TMinDes(k=TLooMin)
    "Minimum desired outlet temperature"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));

  Controller conCoo(final m_flow_nominal=m_flow_nominal)
    "Controller for hex for cooling" annotation (Placement(transformation(
          rotation=0, extent={{-40,20},{-20,40}})));
  Fluid.Sensors.MassFlowRate senMasFloCoo(redeclare package Medium = Medium)
    "Mass flow sensor used for cooling control"
    annotation (Placement(transformation(extent={{-52,50},{-72,70}})));
  Fluid.Sensors.MassFlowRate senMasFloHea(redeclare package Medium = Medium)
    "Mass flow sensor used for heating control"
    annotation (Placement(transformation(extent={{-42,-50},{-62,-30}})));
  Controller conHea(final m_flow_nominal=m_flow_nominal)
    "Controller for hex for heating" annotation (Placement(transformation(
          rotation=0, extent={{-60,-90},{-40,-70}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splHea(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Flow splitter for heating"
    annotation (Placement(transformation(extent={{-34,-50},{-14,-30}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splCoo(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal={0,0,0}) "Flow splitter for cooling"
    annotation (Placement(transformation(extent={{-40,52},{-20,72}})));
equation
  connect(TColIn.y, maxHeaLea.u2) annotation (Line(points={{-19,108},{-19,108},{
          6,108}},             color={0,0,127}));
  connect(maxHeaLea.y, minHeaLvg.u2)
    annotation (Line(points={{29,114},{42,114},{42,120},{44,120},{50,120}},
                                                          color={0,0,127}));
  connect(minHeaLvg.y, hea.TSet) annotation (Line(points={{73,126},{86,126},{86,
          -34},{12,-34}}, color={0,0,127}));
  connect(TWarIn.y, minCooLvg.u1) annotation (Line(points={{-19,166},{-19,166},{
          6,166}},       color={0,0,127}));
  connect(minCooLvg.y, maxCooLea.u2)
    annotation (Line(points={{29,160},{29,160},{50,160}},
                                                color={0,0,127}));
  connect(maxCooLea.y, coo.TSet) annotation (Line(points={{73,166},{80,166},{80,
          80},{20,80},{20,66},{12,66}},
                    color={0,0,127}));
  connect(TAppHex.y, TWatHea.u2)
    annotation (Line(points={{-59,190},{-40,190},{-40,194},{38,194}},
                                                   color={0,0,127}));
  connect(TAppHex.y, TWatCoo.u2) annotation (Line(points={{-59,190},{-40,190},{-40,
          224},{38,224}},  color={0,0,127}));
  connect(TWatCoo.y, minCooLvg.u2) annotation (Line(points={{61,230},{80,230},{80,
          182},{0,182},{0,154},{6,154}},
                         color={0,0,127}));
  connect(TWatHea.y, maxHeaLea.u1) annotation (Line(points={{61,200},{68,200},{68,
          186},{-6,186},{-6,120},{6,120}},
                         color={0,0,127}));
  connect(watTem.y[1], TWat) annotation (Line(points={{-59,226},{-50,226},{-50,280},
          {88,280},{88,180},{110,180}},      color={0,0,127}));
  connect(coo.Q_flow, QExc_flow.u1) annotation (Line(points={{-11,66},{-16,66},{
          -16,6},{18,6}}, color={0,0,127}));
  connect(hea.Q_flow, QExc_flow.u2) annotation (Line(points={{-11,-34},{-11,-34},
          {-14,-34},{-14,-6},{18,-6}}, color={0,0,127}));
  connect(QExc_flow.y, QWat_flow) annotation (Line(points={{41,0},{66,0},{90,0},
          {90,120},{110,120}}, color={0,0,127}));
  connect(watTem.y[1], smoothMin.u2) annotation (Line(points={{-59,226},{-50,226},
          {-50,234},{-12,234}}, color={0,0,127}));
  connect(smoothMin.u1, weaBus.TWetBul) annotation (Line(points={{-12,246},{-44,
          246},{-44,258},{-80,258}}, color={0,0,127}));
  connect(smoothMax.y, TWatHea.u1) annotation (Line(points={{11,208},{24,208},{24,
          206},{38,206}}, color={0,0,127}));
  connect(smoothMax.u2, watTem.y[1]) annotation (Line(points={{-12,202},{-50,202},
          {-50,226},{-59,226}}, color={0,0,127}));
  connect(smoothMax.u1, weaBus.TDryBul) annotation (Line(points={{-12,214},{-44,
          214},{-44,258},{-80,258}}, color={0,0,127}));
  connect(smoothMin.y, TWatCoo.u1) annotation (Line(points={{11,240},{20,240},{20,
          236},{38,236}}, color={0,0,127}));
  connect(TSetCoo, maxCooLea.u1) annotation (Line(points={{-120,100},{40,100},{
          40,172},{50,172}}, color={0,0,127}));
  connect(TMaxDes.y, minHeaLvg.u1) annotation (Line(points={{-59,150},{-50,150},
          {-50,132},{50,132}}, color={0,0,127}));
  connect(valCoo.port_2, port_b1)
    annotation (Line(points={{60,60},{76,60},{100,60}}, color={0,127,255}));
  connect(conCoo.y, valCoo.y) annotation (Line(points={{-19,30},{30,30},{30,76},
          {50,76},{50,72}}, color={0,0,127}));
protected
  model Controller "Controller for bay water heat exchanger"
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
      "Nominal mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    Modelica.Blocks.Nonlinear.Limiter limTem(        uMax=1, uMin=0)
      "Signal limiter for switching valve"
      annotation (Placement(transformation(extent={{20,60},{40,80}})));
    Modelica.Blocks.Math.Gain gaiTem(k=4) "Control gain for dT"
      annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
    Modelica.Blocks.Math.Feedback feeBac "Control error"
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Interfaces.RealInput u1 annotation (Placement(transformation(
            rotation=0, extent={{-120,60},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput u2 annotation (Placement(transformation(
          rotation=90,
          extent={{-10,-10},{10,10}},
          origin={0,-10})));
    Modelica.Blocks.Interfaces.RealOutput y
      "Control signal (0: bypass hex, 1: use hex)"
                                            annotation (Placement(transformation(
            rotation=0, extent={{100,90},{120,110}})));
    Modelica.Blocks.Interfaces.RealInput m_flow "Mass flow rate" annotation (
        Placement(transformation(rotation=0, extent={{-120,120},{-100,140}})));
    Modelica.Blocks.Math.Gain norFlo(final k=1/m_flow_nominal)
      "Normalized flow rate"
      annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
    Modelica.Blocks.Nonlinear.Limiter limFlo(        uMax=1, uMin=0)
      "Signal limiter for switching valve"
      annotation (Placement(transformation(extent={{20,120},{40,140}})));
    Modelica.Blocks.Math.Gain gaiFlo(k=100) "Control gain for flow rate"
      annotation (Placement(transformation(extent={{-30,120},{-10,140}})));
    Modelica.Blocks.Math.Product product
      annotation (Placement(transformation(extent={{60,90},{80,110}})));
  equation
    connect(feeBac.y, gaiTem.u)
      annotation (Line(points={{-41,70},{-32,70}}, color={0,0,127}));
    connect(gaiTem.y, limTem.u)
      annotation (Line(points={{-9,70},{22,70},{18,70}}, color={0,0,127}));
    connect(u1, feeBac.u1) annotation (Line(points={{-110,70},{-110,70},{-58,70}},
          color={0,0,127}));
    connect(u2, feeBac.u2) annotation (Line(points={{0,-10},{0,20},{-50,20},{-50,
            62}},
          color={0,0,127}));
    connect(m_flow, norFlo.u)
      annotation (Line(points={{-110,130},{-82,130}}, color={0,0,127}));
    connect(norFlo.y, gaiFlo.u) annotation (Line(points={{-59,130},{-46,130},{-32,
            130}}, color={0,0,127}));
    connect(gaiFlo.y, limFlo.u)
      annotation (Line(points={{-9,130},{18,130}}, color={0,0,127}));
    connect(limFlo.y, product.u1) annotation (Line(points={{41,130},{48,130},{48,
            106},{58,106}}, color={0,0,127}));
    connect(limTem.y, product.u2) annotation (Line(points={{41,70},{46,70},{48,70},
            {48,94},{58,94}}, color={0,0,127}));
    connect(product.y, y) annotation (Line(points={{81,100},{88,100},{88,100},{88,
            100},{110,100}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-100,0},{100,200}},
            preserveAspectRatio=false)), Icon(coordinateSystem(extent={{-100,0},{100,
              200}})));
  end Controller;
equation
  connect(valCoo.port_1, coo.port_a)
    annotation (Line(points={{40,60},{26,60},{10,60}}, color={0,127,255}));
  connect(senMasFloCoo.m_flow, conCoo.m_flow) annotation (Line(points={{-62,71},
          {-62,74},{-48,74},{-48,33},{-41,33}}, color={0,0,127}));
  connect(senMasFloCoo.port_b, port_a1) annotation (Line(points={{-72,60},{-100,
          60}},           color={0,127,255}));
  connect(port_b2, senMasFloHea.port_b) annotation (Line(points={{-100,-60},{-80,
          -60},{-80,-40},{-62,-40}}, color={0,127,255}));
  connect(conHea.m_flow, senMasFloHea.m_flow) annotation (Line(points={{-61,-77},
          {-72,-77},{-72,-24},{-52,-24},{-52,-29}}, color={0,0,127}));
  connect(valHea.port_2, port_a2)
    annotation (Line(points={{60,-60},{80,-60},{100,-60}}, color={0,127,255}));
  connect(valHea.port_1, hea.port_a) annotation (Line(points={{40,-60},{30,-60},
          {30,-40},{10,-40}}, color={0,127,255}));
  connect(conHea.y, valHea.y) annotation (Line(points={{-39,-80},{-20,-80},{36,-80},
          {36,-40},{50,-40},{50,-48}}, color={0,0,127}));
  connect(TColIn.y, conHea.u2) annotation (Line(points={{-19,108},{-10,108},{-10,
          90},{-86,90},{-86,-96},{-50,-96},{-50,-91}}, color={0,0,127}));
  connect(conHea.u1, minHeaLvg.y) annotation (Line(points={{-61,-83},{-70,-83},{
          -70,-94},{86,-94},{86,126},{73,126}}, color={0,0,127}));
  connect(senMasFloHea.port_a, splHea.port_1) annotation (Line(points={{-42,-40},
          {-38,-40},{-34,-40}}, color={0,127,255}));
  connect(splHea.port_3, valHea.port_3) annotation (Line(points={{-24,-50},{-24,
          -76},{50,-76},{50,-70}}, color={0,127,255}));
  connect(splHea.port_2, hea.port_b) annotation (Line(points={{-14,-40},{-12,-40},
          {-10,-40}}, color={0,127,255}));
  connect(senMasFloCoo.port_a, splCoo.port_1)
    annotation (Line(points={{-52,60},{-40,60},{-40,62}}, color={0,127,255}));
  connect(splCoo.port_2, coo.port_b)
    annotation (Line(points={{-20,62},{-15,60},{-10,60}}, color={0,127,255}));
  connect(splCoo.port_3, valCoo.port_3) annotation (Line(points={{-30,52},{-30,
          42},{50,42},{50,50}},
                            color={0,127,255}));
  connect(TWarIn.y, conCoo.u1) annotation (Line(points={{-19,166},{-14,166},{
          -14,128},{-50,128},{-50,27},{-41,27}}, color={0,0,127}));
  connect(maxCooLea.y, conCoo.u2) annotation (Line(points={{73,166},{80,166},{
          80,16},{-30,16},{-30,19}}, color={0,0,127}));
  annotation (
  defaultComponentName="hex",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            300}})),            Icon(coordinateSystem(extent={{-100,-100},{100,300}},
                   preserveAspectRatio=false), graphics={
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
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>
Model for a lake water heat exchanger that either provides heating or cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
February 16, 2016, by Michael Wetter:<br/>
Improved controls.
</li>
<li>
December 23, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LakeWaterHeatExchanger_T;
