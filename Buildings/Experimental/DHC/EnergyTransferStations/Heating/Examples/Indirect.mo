within Buildings.Experimental.DHC.EnergyTransferStations.Heating.Examples;
model Indirect "Example model for indirect heating energy transfer station
  with a closed chilled water loop on the building side"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Water medium";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal = 19000
    "Heating design flow rate";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal = 50-40
    "Design temperature difference";
  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal=QHea_flow_nominal/dT_nominal/cp
    "Nominal mass flow rate of building heating supply"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default))
    "Default specific heat capacity of medium";
  Buildings.Experimental.DHC.EnergyTransferStations.Heating.Indirect heaETS(
    QHeaWat_flow_nominal=QHea_flow_nominal,
    mDis_flow_nominal=mBui_flow_nominal,
    mBui_flow_nominal=mBui_flow_nominal,
    dpConVal_nominal=9000,
    dp1_nominal=9000,
    dp2_nominal=9000,
    Q_flow_nominal=QHea_flow_nominal,
    T_a1_nominal=328.15,
    T_a2_nominal=313.15,
    k=0.1,
    Ti=40,
    yMax=1,
    yMin=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1)
    "Direct heating energy transfer station"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT souDis(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 300000 + 2*9000,
    use_T_in=false,
    T=328.15,
    nPorts=1)
    "District (primary) source"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Fluid.Sources.Boundary_pT sinDis(
    redeclare package Medium = Medium,
    T=314.15,
    nPorts=1)
    "District (primary) sink"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Sources.Constant TSetHWS(k=273.15 + 50)
    "Setpoint temperature for building heating water supply"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u loa(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=mBui_flow_nominal,
    show_T=true,
    from_dp=false,
    dp_nominal=6000,
    linearizeFlowResistance=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    Q_flow_nominal=-1) "Aggregate building heating load"
    annotation (Placement(transformation(extent={{40,40},{20,60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumBui(
    redeclare replaceable package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=mBui_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=6000+9000)
    "Building-side (secondary) pump"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea(
    table=[0,10E3; 6,8E3; 6,5E3; 12,2E3; 18,15E3; 24,10E3],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600) "Heating demand"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Blocks.Math.Product pro
    "Multiplier to ramp load from zero"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=1,
    duration(displayUnit="h")=18000,
    startTime(displayUnit="h")=3600) "Ramp load from zero"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Math.Gain gai(k=1/(cp*dT_nominal))
    "Multiplier gain for calculating m_flow"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Fluid.Sources.Boundary_pT souBui(
    redeclare package Medium = Medium,
    nPorts=1)
    "Building (secondary) source"
    annotation (Placement(transformation(extent={{128,64},{108,84}})));
equation
  connect(pumBui.port_b, loa.port_a)
    annotation (Line(points={{60,50},{40,50}}, color={0,127,255}));
  connect(QHea.y[1], gai.u)
    annotation (Line(points={{-79,110},{-42,110}}, color={0,0,127}));
  connect(gai.y, pumBui.m_flow_in)
    annotation (Line(points={{-19,110},{70,110},{70,62}}, color={0,0,127}));
  connect(ram.y, pro.u2) annotation (Line(points={{-79,70},{-60,70},{-60,64},{-42,
          64}}, color={0,0,127}));
  connect(QHea.y[1], pro.u1) annotation (Line(points={{-79,110},{-60,110},{-60,76},
          {-42,76}}, color={0,0,127}));
  connect(pro.y, loa.u) annotation (Line(points={{-19,70},{50,70},{50,56},{42,56}},
        color={0,0,127}));
  connect(pumBui.port_a, souBui.ports[1]) annotation (Line(points={{80,50},{94,50},
          {94,74},{108,74}}, color={0,127,255}));
  connect(TSetHWS.y,heaETS.TBuiSupSet)
    annotation (Line(points={{-59,-30},{19.3333,-30}}, color={0,0,127}));
  connect(souDis.ports[1], heaETS.port_aSerHea) annotation (Line(points={{-20,-70},
          {14,-70},{14,-38},{20,-38}}, color={0,127,255}));
  connect(sinDis.ports[1], heaETS.port_bSerHea) annotation (Line(points={{80,-70},
          {60,-70},{60,-38},{40,-38}}, color={0,127,255}));
  connect(loa.port_b, heaETS.ports_aHeaWat[1]) annotation (Line(points={{20,50},
          {-20,50},{-20,-21.3333},{20,-21.3333}}, color={0,127,255}));
  connect(heaETS.ports_bHeaWat[1], pumBui.port_a) annotation (Line(points={{40,
          -21.3333},{62,-21.3333},{62,-22},{100,-22},{100,50},{80,50}},
                                                              color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-140},{140,140}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Heating/Examples/Indirect.mos" "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model provides an example for the indirect heating energy transfer station model.
The heating load ramps up from zero and is modulated according to the QHea table specification.
The mass flow rate of heating water in the building side is varied based on the building load/demand.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 7, 2023, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Indirect;
