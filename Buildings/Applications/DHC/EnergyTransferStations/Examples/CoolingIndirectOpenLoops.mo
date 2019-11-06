within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingIndirectOpenLoops
  "Example model for indirect cooling energy transfer station with open loops on the building and district sides"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.5
    "Nominal mass flow rate of primary (district) district cooling side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.5
    "Nominal mass flow rate of secondary (building) district cooling side";

  Modelica.Blocks.Sources.Constant TSet(k=273 + 7)
    "Setpoint temperature for building chilled water supply"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    p=300000,
    T=287.15,
    nPorts=1) "District-side (primary) sink" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,70})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000 + 800,
    use_T_in=true,
    T=278.15,
    nPorts=1) "District (primary) source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,70})));
  Buildings.Fluid.Sources.Boundary_pT sinBui(
    redeclare package Medium = Medium,
    use_T_in=false,
    T=280.15,
    nPorts=1) "Building (secondary) sink (chilled water supply)" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-60,-70})));
  Buildings.Fluid.Sources.Boundary_pT souBui(
    redeclare package Medium = Medium,
    use_T_in=true,
    T=289.15,
    nPorts=1) "Building (secondary) source (chilled water return)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-70})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    T_start=278.15) "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-60,30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TDisRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    T_start=287.15) "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    T_start=289.15) "Building-side (secondary) return temperature sensor"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    T_start=280.15) "Building-side (secondary) supply temperature sensor"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-30})));
  Modelica.Blocks.Sources.RealExpression dTDis(y=TDisRet.T - TDisSup.T)
    "District-side (primary) temperature change"
    annotation (Placement(transformation(extent={{64,80},{114,100}})));
  Modelica.Blocks.Sources.RealExpression dTBui(y=TBuiRet.T - TBuiSup.T)
    "Building-side (secondary) temperature change"
    annotation (Placement(transformation(extent={{64,100},{114,120}})));
  Modelica.Blocks.Sources.RealExpression TApp(y=TBuiSup.T - TDisSup.T)
    "Approach temperature of heat exchanger"
    annotation (Placement(transformation(extent={{64,120},{114,140}})));
  Buildings.Applications.DHC.EnergyTransferStations.CoolingIndirect coo(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal(displayUnit="Pa") = 500,
    dp2_nominal(displayUnit="Pa") = 500,
    Q_flow_nominal=18514,
    T_a1_nominal=278.15,
    T_a2_nominal=289.15,
    dp_nominal(displayUnit="Pa") = 5000,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    Ti=40,
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    yCon_start=0,
    reverseAction=true) "Indirect cooling ETS"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumBui(
    redeclare package Medium = Medium,
    m_flow_nominal=m2_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    dp_nominal=0) "Building-side (secondary) pump"
    annotation (Placement(transformation(extent={{-20,-30},{-40,-10}})));
  Modelica.Blocks.Sources.Trapezoid tra(
    amplitude=1.5,
    rising(displayUnit="h") = 10800,
    width(displayUnit="h") = 10800,
    falling(displayUnit="h") = 10800,
    period(displayUnit="h") = 43200,
    offset=273 + 3.5) "District supply temperature trapezoid signal"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Modelica.Blocks.Sources.RealExpression TBuiRetSig(y=(273 + 16) + 2*sin(time*2
        *3.14/86400))
    "Sinusoidal signal for return temperature on building (secondary) side"
    annotation (Placement(transformation(extent={{-40,-120},{40,-100}})));
equation
  connect(souDis.ports[1], TDisSup.port_a)
    annotation (Line(points={{-60,60},{-60,40}}, color={0,127,255}));
  connect(TDisRet.port_b, sinDis.ports[1])
    annotation (Line(points={{60,40},{60,60}}, color={0,127,255}));
  connect(souBui.ports[1], TBuiRet.port_a)
    annotation (Line(points={{60,-60},{60,-40}}, color={0,127,255}));
  connect(TBuiSup.port_b, sinBui.ports[1])
    annotation (Line(points={{-60,-40},{-60,-60}}, color={0,127,255}));
  connect(TSet.y,coo.TSetCHWS)  annotation (Line(points={{-79,0},{-2,0}},
                         color={0,0,127}));
  connect(coo.port_a1, TDisSup.port_b)
    annotation (Line(points={{0,6},{-60,6},{-60,20}}, color={0,127,255}));
  connect(coo.port_b1, TDisRet.port_a)
    annotation (Line(points={{20,6},{60,6},{60,20}}, color={0,127,255}));
  connect(coo.port_a2, TBuiRet.port_b)
    annotation (Line(points={{20,-6},{60,-6},{60,-20}}, color={0,127,255}));
  connect(coo.port_b2, pumBui.port_a) annotation (Line(points={{0,-6},{-10,-6},
          {-10,-20},{-20,-20}}, color={0,127,255}));
  connect(pumBui.port_b, TBuiSup.port_a)
    annotation (Line(points={{-40,-20},{-60,-20}}, color={0,127,255}));
  connect(tra.y, souDis.T_in)
    annotation (Line(points={{-79,100},{-56,100},{-56,82}}, color={0,0,127}));
  connect(TBuiRetSig.y, souBui.T_in)
    annotation (Line(points={{44,-110},{56,-110},{56,-82}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-140},{120,140}})),
    Documentation(info="<html>
<p>This model provides an example for the indirect cooling energy transfer station model.
Both the district and building chilled water loops are open. The district supply temperature
is modulating, while the modulating building return temperature mimics a theoretically 
variable cooling load at the building. </p>
</html>", revisions="<html>
<ul>
<li>November 1, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingIndirectOpenLoops.mos"
        "Simulate and plot"));
end CoolingIndirectOpenLoops;
