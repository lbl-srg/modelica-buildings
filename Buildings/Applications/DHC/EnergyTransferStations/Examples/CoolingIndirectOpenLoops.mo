within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingIndirectOpenLoops
  "Example model for indirect cooling energy transfer station with open loops on the building and district sides"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.5
    "Nominal mass flow rate of primary (district) district cooling side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.5
    "Nominal mass flow rate of secondary (building) district cooling side";

  Modelica.Blocks.Sources.Constant TSetCHWS(k=273.15 + 7)
    "Setpoint temperature for building chilled water supply"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    p=300000,
    T=287.15,
    nPorts=1)
    "District-side (primary) sink"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000 + 800,
    use_T_in=true,
    T=278.15,
    nPorts=1)
    "District (primary) source"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Fluid.Sources.Boundary_pT sinBui(
    redeclare package Medium = Medium,
    use_T_in=false,
    T=280.15,
    nPorts=1)
    "Building (secondary) sink (chilled water supply)"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Fluid.Sources.Boundary_pT souBui(
    redeclare package Medium = Medium,
    use_T_in=true,
    T=289.15,
    nPorts=1)
    "Building (secondary) source (chilled water return)"
    annotation (Placement(transformation(extent={{80,-100},{60,-80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    T_start=278.15)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    T_start=287.15)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    T_start=289.15)
    "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(extent={{40,-100},{20,-80}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    T_start=280.15)
    "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-50,-100},{-70,-80}})));
  Buildings.Applications.DHC.EnergyTransferStations.CoolingIndirect coo(
    redeclare package Medium = Medium,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
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
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumBui(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=6000)
    "Building-side (secondary) pump"
    annotation (Placement(transformation(extent={{-20,-100},{-40,-80}})));
  Modelica.Blocks.Sources.Trapezoid tra(
    amplitude=1.5,
    rising(displayUnit="h") = 10800,
    width(displayUnit="h") = 10800,
    falling(displayUnit="h") = 10800,
    period(displayUnit="h") = 43200,
    offset=273 + 3.5)
    "District supply temperature trapezoid signal"
    annotation (Placement(transformation(extent={{-120,44},{-100,64}})));
  Modelica.Blocks.Sources.RealExpression TBuiRetSig(
    y=(273.15 + 16) + 2*sin(time*2*3.14/86400))
    "Sinusoidal signal for return temperature on building (secondary) side"
    annotation (Placement(transformation(extent={{120,-96},{100,-76}})));
  Modelica.Blocks.Math.Add TApp(k2=-1) "Calculate approach temperature"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Modelica.Blocks.Math.Add dTDis(k1=-1)
    "Calculate change in district temperature"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Modelica.Blocks.Math.Add dTBui(k1=-1)
    "Calculate change in building temperature"
    annotation (Placement(transformation(extent={{88,-50},{108,-30}})));
equation
  connect(coo.port_b2, pumBui.port_a) annotation (Line(points={{-10,-26},{-16,-26},
          {-16,-90},{-20,-90}}, color={0,127,255}));
  connect(tra.y, souDis.T_in)
    annotation (Line(points={{-99,54},{-92,54}},            color={0,0,127}));
  connect(TBuiRetSig.y, souBui.T_in)
    annotation (Line(points={{99,-86},{82,-86}},            color={0,0,127}));
  connect(TSetCHWS.y, coo.TSet)
    annotation (Line(points={{-99,-20},{-12,-20}},
                                              color={0,0,127}));
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-70,50},{-40,50}}, color={0,127,255}));
  connect(TDisSup.port_b, coo.port_a1) annotation (Line(points={{-20,50},{-16,50},
          {-16,-14},{-10,-14}}, color={0,127,255}));
  connect(coo.port_b1, TDisRet.port_a) annotation (Line(points={{10,-14},{16,-14},
          {16,50},{20,50}}, color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{40,50},{60,50}},  color={0,127,255}));
  connect(TBuiSup.T, TApp.u1)
    annotation (Line(points={{-60,-79},{-60,106},{-2,106}}, color={0,0,127}));
  connect(TDisSup.T, TApp.u2)
    annotation (Line(points={{-30,61},{-30,94},{-2,94}}, color={0,0,127}));
  connect(TDisRet.T, dTDis.u2)
    annotation (Line(points={{30,61},{30,74},{58,74}}, color={0,0,127}));
  connect(dTDis.u1, TDisSup.T)
    annotation (Line(points={{58,86},{-30,86},{-30,61}}, color={0,0,127}));
  connect(TBuiRet.T, dTBui.u2)
    annotation (Line(points={{30,-79},{30,-46},{86,-46}}, color={0,0,127}));
  connect(TBuiSup.T, dTBui.u1)
    annotation (Line(points={{-60,-79},{-60,-34},{86,-34}}, color={0,0,127}));
  connect(pumBui.port_b, TBuiSup.port_a)
    annotation (Line(points={{-40,-90},{-50,-90}}, color={0,127,255}));
  connect(TBuiSup.port_b, sinBui.ports[1])
    annotation (Line(points={{-70,-90},{-100,-90}}, color={0,127,255}));
  connect(coo.port_a2, TBuiRet.port_b) annotation (Line(points={{10,-26},{16,
          -26},{16,-90},{20,-90}}, color={0,127,255}));
  connect(TBuiRet.port_a, souBui.ports[1])
    annotation (Line(points={{40,-90},{60,-90}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-140,-120},{140,120}})),
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingIndirectOpenLoops.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=86400,
    Tolerance=1e-06),
  Documentation(info="<html>
<p>This model provides an example for the indirect cooling energy transfer station model.
Both the district and building chilled water loops are open. The district supply temperature
is modulating, while the modulating building return temperature mimics a theoretically 
variable cooling load at the building. </p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2019, by Kathryn Hinkelman:<br/>
First implementation. 
</li>
</ul>
</html>"));
end CoolingIndirectOpenLoops;
