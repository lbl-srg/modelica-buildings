within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTU_cooling
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Fluid in the pipes";
  package Medium2 = Buildings.Media.Air "Moist air";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = -1000
    "Heat flow rate transferred to the load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.1
    "Load side mass flow rate at nominal conditions";
  parameter Modelica.SIunits.Temperature T_a1_nominal(displayUnit="degC")=
      Modelica.SIunits.Conversions.from_degC(7)
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1_nominal(displayUnit="degC")=
      Modelica.SIunits.Conversions.from_degC(12)
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal(displayUnit="degC")=
      Modelica.SIunits.Conversions.from_degC(20)
    "Load side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b2_nominal(displayUnit="degC")=
    T_a2_nominal + Q_flow_nominal / m2_flow_nominal / cp2_nominal;  // In case of purely sensible heat transfer.
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = abs(
    Q_flow_nominal / cp1_nominal / (T_a1_nominal - T_b1_nominal))
    "Source side mass flow rate at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal = Medium1.specificHeatCapacityCp(
    Medium1.setState_pTX(Medium1.p_default, T_a1_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal = Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(Medium2.p_default, T_a2_nominal))
    "Load side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMin_nominal=
      min(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
    "Minimum capacity flow rate at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMax_nominal=
      max(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
    "Maximum capacity flow rate at nominal conditions";
  parameter Real Z = CMin_nominal / CMax_nominal
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration";
  parameter Modelica.SIunits.ThermalConductance UA_nominal=
     Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
     eps=abs(Q_flow_nominal / (CMin_nominal * (T_a1_nominal - T_a2_nominal))),
     Z=Z,
     flowRegime=Integer(hexCon)) * CMin_nominal
    "Thermal conductance at nominal conditions";
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1, nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={180,-60})));
  Buildings.Fluid.Sources.MassFlowSource_T sup1(
    redeclare package Medium = Medium1,
    use_m_flow_in=true,
    m_flow=hexWetNtu.m1_flow_nominal,
    T=T_a1_nominal,
    nPorts=1) "Supply for heating water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-60})));
  Buildings.Fluid.Sources.MassFlowSource_T sup2(
    redeclare package Medium = Medium2,
    m_flow=m2_flow_nominal,
    T=T_a2_nominal,
    nPorts=1) "Supply"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={178,40})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare final package Medium = Medium2, nPorts=1) "Sink"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ySou(
    amplitude=0.5,
    freqHz=0.001,
    phase=1.5707963267949,
    offset=0.5,
    startTime=1000)
    annotation (Placement(transformation(extent={{-190,-100},{-170,-80}})));
  WetEffectivenessNTU_Fuzzy_V2_2_2
                                 hexWetNtu(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final configuration=hexCon,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final UA_nominal=UA_nominal,
    final allowFlowReversal1=false,
    final allowFlowReversal2=false)
    "Coil"
    annotation (Placement(transformation(extent={{32,4},{52,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=hexWetNtu.m1_flow_nominal)
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-150, -70},{-130,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{-190,-40},{-170,-20}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time < 1000)
    annotation (Placement(transformation(extent={{-190,-70},{-170,-50}})));
  Sensors.TemperatureTwoPort T2Out(
    redeclare final package Medium = Medium2,
    final m_flow_nominal=m2_flow_nominal) "Air outlet temperature"
    annotation (Placement(transformation(extent={{-8,30},{-28,50}})));
  Sensors.MassFlowRate senMasFlo1(
    redeclare final package Medium = Medium1) "Water mass flow rate"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Sensors.TemperatureTwoPort T1Inl(redeclare final package Medium = Medium1,
      final m_flow_nominal=m1_flow_nominal) "Water inlet temperature"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Sensors.TemperatureTwoPort T1Out(redeclare final package Medium = Medium1,
      final m_flow_nominal=m1_flow_nominal) "Water outlet temperature"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Sensors.TemperatureTwoPort T2Inl(redeclare final package Medium = Medium2,
      final m_flow_nominal=m2_flow_nominal) "Air inlet temperature"
    annotation (Placement(transformation(extent={{110,30},{90,50}})));
  Sensors.MassFlowRate senMasFlo2(redeclare final package Medium = Medium2)
                                              "Air mass flow rate"
    annotation (Placement(transformation(extent={{150,30},{130,50}})));
equation
  connect(gai.y, sup1.m_flow_in) annotation (Line(points={{-98,-60},{-92,-60},{-92,
          -52},{-82,-52}}, color={0,0,127}));
  connect(ySou.y, swi.u3) annotation (Line(points={{-168,-90},{-160,-90},{-160,
          -68},{-152,-68}},
                       color={0,0,127}));
  connect(gai.u, swi.y) annotation (Line(points={{-122,-60},{-128,-60}}, color={0,0,127}));
  connect(con.y, swi.u1) annotation (Line(points={{-168,-30},{-160,-30},{-160,
          -52},{-152,-52}},
                       color={0,0,127}));
  connect(swi.u2, booleanExpression.y) annotation (Line(points={{-152,-60},{-169,
          -60}}, color={255,0,255}));
  connect(sup2.ports[1], senMasFlo2.port_a)
    annotation (Line(points={{168,40},{150,40}}, color={0,127,255}));
  connect(senMasFlo2.port_b, T2Inl.port_a)
    annotation (Line(points={{130,40},{110,40}}, color={0,127,255}));
  connect(T2Inl.port_b, hexWetNtu.port_a2) annotation (Line(points={{90,40},{60,
          40},{60,0},{52,0}}, color={0,127,255}));
  connect(hexWetNtu.port_b2, T2Out.port_a)
    annotation (Line(points={{32,0},{0,0},{0,40},{-8,40}}, color={0,127,255}));
  connect(T2Out.port_b, sin2.ports[1])
    annotation (Line(points={{-28,40},{-140,40}}, color={0,127,255}));
  connect(sup1.ports[1], senMasFlo1.port_a)
    annotation (Line(points={{-60,-60},{-50,-60}}, color={0,127,255}));
  connect(senMasFlo1.port_b, T1Inl.port_a)
    annotation (Line(points={{-30,-60},{-10,-60}}, color={0,127,255}));
  connect(T1Inl.port_b, hexWetNtu.port_a1) annotation (Line(points={{10,-60},{20,
          -60},{20,-12},{32,-12}}, color={0,127,255}));
  connect(hexWetNtu.port_b1, T1Out.port_a) annotation (Line(points={{52,-12},{60,
          -12},{60,-60},{90,-60}}, color={0,127,255}));
  connect(T1Out.port_b, sin1.ports[1])
    annotation (Line(points={{110,-60},{170,-60}}, color={0,127,255}));
  annotation (
  experiment(
      StopTime=2000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,
            80}})),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU_cooling.mos"
        "Simulate and plot"));
end WetCoilEffectivenessNTU_cooling;
