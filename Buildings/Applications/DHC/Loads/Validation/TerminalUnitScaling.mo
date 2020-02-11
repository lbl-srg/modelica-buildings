within Buildings.Applications.DHC.Loads.Validation;
model TerminalUnitScaling
  "Validation of the scaling factor of the terminal unit model"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter Real facSca=30
    "Scaling factor";
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 40
    "Heating water inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15, displayUnit="degC") = T_aHeaWat_nominal - 5
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bLoaHea_nominal(
    min=273.15, displayUnit="degC") = T_aLoaHea_nominal + 12
    "Load side ourtlet temperature at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHeaUni_flow_nominal(min=0)=
    QHeaUni_flow_nominal / (T_bLoaHea_nominal - T_aLoaHea_nominal) /
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      Medium2.p_default, T_aLoaHea_nominal))
    "Load side mass flow rate at nominal conditions for 1 unit"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(min=0)=
    mLoaHeaUni_flow_nominal * facSca
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate QHeaUni_flow_nominal(min=0) = 1000
    "Design heating heat flow rate (>=0) for 1 unit"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=
    QHeaUni_flow_nominal * facSca
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Fluid.Sources.MassFlowSource_T supHeaWat(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=false,
    T=T_aHeaWat_nominal,
    nPorts=1)
    "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,80})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=2) "Sink for heating water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,0})));
  BaseClasses.FanCoil2PipeHeating terUniNoSca(
    have_speVar=false,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final QHea_flow_nominal=QHea_flow_nominal,
    final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal) "Terminal unit no scaling"
    annotation (Placement(transformation(extent={{-12,78},{12,102}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  BaseClasses.FanCoil2PipeHeating terUniSca(
    have_speVar=false,
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final QHea_flow_nominal=QHeaUni_flow_nominal,
    facSca=facSca,
    final mLoaHea_flow_nominal=mLoaHeaUni_flow_nominal,
    final T_aHeaWat_nominal=T_aHeaWat_nominal,
    final T_bHeaWat_nominal=T_bHeaWat_nominal,
    final T_aLoaHea_nominal=T_aLoaHea_nominal) "Terminal unit with scaling"
    annotation (Placement(transformation(extent={{-14,-82},{10,-58}})));
  Fluid.Sources.MassFlowSource_T supHeaWat1(
    use_m_flow_in=true,
    redeclare package Medium = Medium1,
    use_T_in=false,
    T=T_aHeaWat_nominal,
    nPorts=1)
    "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(height=
        QHea_flow_nominal, duration=500)
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
equation
  connect(terUniNoSca.mReqHeaWat_flow, supHeaWat.m_flow_in) annotation (Line(
        points={{13,86},{20,86},{20,110},{-100,110},{-100,88},{-82,88}}, color={
          0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={0,0,127}));
  connect(from_degC1.y, terUniNoSca.TSetHea) annotation (Line(points={{-58,40},{
          -40,40},{-40,96},{-13,96}}, color={0,0,127}));
  connect(supHeaWat.ports[1], terUniNoSca.port_aHeaWat)
    annotation (Line(points={{-60,80},{-12,80}}, color={0,127,255}));
  connect(terUniNoSca.port_bHeaWat, sinHeaWat.ports[1]) annotation (Line(points={{12,80},
          {40,80},{40,2},{100,2}},         color={0,127,255}));
  connect(terUniSca.port_bHeaWat, sinHeaWat.ports[2]) annotation (Line(points={{10,-80},
          {40,-80},{40,-2},{100,-2}},         color={0,127,255}));
  connect(supHeaWat1.ports[1], terUniSca.port_aHeaWat)
    annotation (Line(points={{-60,-80},{-14,-80}}, color={0,127,255}));
  connect(terUniSca.mReqHeaWat_flow, supHeaWat1.m_flow_in) annotation (Line(
        points={{11,-74},{20,-74},{20,-100},{-100,-100},{-100,-72},{-82,-72}},
        color={0,0,127}));
  connect(from_degC1.y, terUniSca.TSetHea) annotation (Line(points={{-58,40},{-40,
          40},{-40,-64},{-15,-64}}, color={0,0,127}));
  connect(ram.y, terUniNoSca.QReqHea_flow) annotation (Line(points={{-98,0},{-20,
          0},{-20,88},{-13,88}}, color={0,0,127}));
  connect(ram.y, terUniSca.QReqHea_flow) annotation (Line(points={{-98,0},{-20,0},
          {-20,-72},{-15,-72}}, color={0,0,127}));
  annotation (
  experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  Documentation(info="<html>
  <p>
  This example illustrates the use of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>
  to transfer heat from a fluid stream to a simplified building model consisting in two heating loads and one cooling
  load as described in
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.RCBuilding\">
  Buildings.DistrictEnergySystem.Loads.Examples.BaseClasses.RCBuilding</a>.
  </p>
  </html>"),
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
  __Dymola_Commands);
end TerminalUnitScaling;
