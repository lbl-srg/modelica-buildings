within Buildings.Experimental.DHC.EnergyTransferStations.Cooling.Examples;
model DirectUncontrolled "Example model for the direct cooling energy transfer 
  station with uncontrolled fluid transfer between district and building within the ETS"
extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Water medium";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=-18000
    "Nominal cooling load (Negative for cooling)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=-Q_flow_nominal/(cp*(16-7))
    "Nominal mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
  Buildings.Experimental.DHC.EnergyTransferStations.Cooling.DirectUncontrolled
    cooETS(
    m_flow_nominal=m_flow_nominal,
    QChiWat_flow_nominal=Q_flow_nominal,
    dpSup=6000,
    dpRet=6000,
    nPorts_bChiWat=1,
    nPorts_aChiWat=1)
    "Direct cooling energy transfer station"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium=Medium,
    p(displayUnit="Pa")=300000+800,
    use_T_in=true,
    T=280.15,
    nPorts=1)
    "District-side source"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium=Medium,
    p(displayUnit="Pa")=300000,
    T=289.15,
    nPorts=1)
    "District-side sink"
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare package Medium=Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    linearizeFlowResistance=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    Q_flow_nominal=-1,
    dp_nominal=100)
    "Aggregate building cooling load"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium=Medium,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=50,
    riseTime=10)
    "In-building terminal control valve"
    annotation (Placement(transformation(extent={{20,0},{0,20}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo(
    table=[
      0,-10E3;
      6,-8E3;
      6,-5E3;
      12,-2E3;
      18,-15E3;
      24,-10E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling demand"
    annotation (Placement(transformation(extent={{-100,66},{-80,86}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(
      displayUnit="h")=18000,
    startTime(
      displayUnit="h")=3600)
    "Ramp load from zero"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Math.Product pro
    "Multiplier to ramp load from zero"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_max(
    y=Q_flow_nominal)
    "Maximum cooling load"
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
  Modelica.Blocks.Math.Division div
    "Division"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Trapezoid tra(
    amplitude=2,
    rising(
      displayUnit="h")=10800,
    width(
      displayUnit="h")=10800,
    falling(
      displayUnit="h")=10800,
    period(
      displayUnit="h")=43200,
    offset=273.15+6)
    "Trapezoid signal for district supply temperature"
    annotation (Placement(transformation(extent={{-100,-76},{-80,-56}})));
equation
  connect(tra.y, souDis.T_in)
    annotation (Line(points={{-79,-66},{-62,-66}}, color={0,0,127}));
  connect(souDis.ports[1], cooETS.port_aSerCoo)
    annotation (Line(points={{-40,-70},{-20,-70},{-20,-39.3333},{0,-39.3333}}, color={0,127,255}));
  connect(QCoo.y[1], div.u1)
    annotation (Line(points={{-79,76},{-22,76}},color={0,0,127}));
  connect(Q_flow_max.y, div.u2)
    annotation (Line(points={{-39,52},{-32,52},{-32,64},{-22,64}}, color={0,0,127}));
  connect(ram.y, pro.u2)
    annotation (Line(points={{-79,30},{-70,30},{-70,24},{-42,24}}, color={0,0,127}));
  connect(QCoo.y[1], pro.u1)
    annotation (Line(points={{-79,76},{-70,76},{-70,36},{-42,36}}, color={0,0,127}));
  connect(pro.y, loa.u)
    annotation (Line(points={{-19,30},{40,30},{40,16},{62,16}}, color={0,0,127}));
  connect(div.y, val.y)
    annotation (Line(points={{1,70},{10,70},{10,22}}, color={0,0,127}));
  connect(cooETS.port_bSerCoo, sinDis.ports[1])
    annotation (Line(points={{20,-39.3333},{40,-39.3333},{40,-70},{60,-70}},  color={0,127,255}));
  connect(cooETS.ports_bChiWat[1], loa.port_a)
    annotation (Line(points={{20,-24.6667},{80,-24.6667},{80,10},{60,10}},  color={0,127,255}));
  connect(loa.port_b, val.port_a)
    annotation (Line(points={{40,10},{20,10}}, color={0,127,255}));
  connect(val.port_b, cooETS.ports_aChiWat[1])
    annotation (Line(points={{0,10},{-60,10},{-60,-24.6667},{0,-24.6667}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-120},{160,120}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Cooling/Examples/DirectUncontrolled.mos" "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>This model provides an example for the direct cooling energy transfer 
station model, which does not contain in-building pumping or deltaT 
control. The ultimate control lies with the thermostatic control valve 
at the lumped terminal building load. The control valve is modulated 
proportionally to the instantaneous cooling load with respect to the 
maximum load.</p>
</html>",
      revisions="<html>
<ul>
<li>December 10, 2021, by Chengnan Shi:<br/>First implementation. </li>
</ul>
</html>"));
end DirectUncontrolled;
