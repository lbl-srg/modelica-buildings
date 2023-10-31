within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.Validation;
model HeatPumpDHWTank
  "Validation of the base subsystem model with domestic hot water tank and heat pump"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPumpDHWTank
    heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    datWatHea=datWatHea,
    COP_nominal=2.3,
    TCon_nominal=datWatHea.TMix_nominal + datWatHea.dTHexApp_nominal + 1,
    TEva_nominal(displayUnit="K") = 273.15 + 15 - 5,
    QHotWat_flow_nominal=datWatHea.QHex_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000)
    annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  Fluid.Sources.Boundary_pT           supAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    use_T_in=true,
    T=280.15,
    nPorts=1) "Ambient water supply"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,-60})));
  Fluid.Sources.Boundary_pT           sinAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={60,10})));
  Fluid.Sensors.MassFlowRate           senMasFlo(redeclare package Medium =
        Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{40,-70},{20,-50}})));
  Modelica.Blocks.Sources.Constant TDisSup(k(
      unit="K",
      displayUnit="degC") = 288.15)
    "District supply temperature"
    annotation (Placement(transformation(extent={{100,-60},{80,-40}})));
  Fluid.Sources.Boundary_pT souDCW(
    redeclare final package Medium = Medium,
    T=283.15,
    nPorts=1) "Source for domestic cold water"
                                 annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-70,-30})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Junction dcwSpl(
      redeclare final package Medium = Medium, final m_flow_nominal=6000*{1,-1,
        -1})                                 "Splitter for domestic cold water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-10})));
  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/DHC/Loads/HotWater/DHW_ApartmentMidRise.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Modelica.Blocks.Sources.Constant conTSetMix(k(
      final unit="K",
      displayUnit="degC") = 308.15)
    "Temperature setpoint for mixed water supply to fixture"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Sources.BooleanConstant booCon "Always on"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Loads.HotWater.ThermostaticMixingValve
                          theMixVal(redeclare package Medium = Medium,
      mMix_flow_nominal=1.2*datWatHea.mDom_flow_nominal)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  parameter Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea(VTan=0.1892706, mDom_flow_nominal=6.52944E-06*1000)
    "Data for heat pump water heater with tank"
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));
equation
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{79,-50},{76,-50},{76,-56},{72,-56}},
                                                 color={0,0,127}));
  connect(supAmbWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{50,-60},{40,-60}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaPum.port_a2) annotation (Line(points={{20,-60},{16,
          -60},{16,-8},{10,-8}}, color={0,127,255}));
  connect(sinAmbWat.ports[1], heaPum.port_b2) annotation (Line(points={{50,10},{
          22,10},{22,4},{10,4}}, color={0,127,255}));
  connect(dcwSpl.port_1, souDCW.ports[1]) annotation (Line(points={{-32,-20},{-32,
          -30},{-60,-30}}, color={0,127,255}));
  connect(dcwSpl.port_3, heaPum.port_a1)
    annotation (Line(points={{-22,-10},{-22,-8},{-10,-8}}, color={0,127,255}));
  connect(booCon.y, heaPum.uEna) annotation (Line(points={{-99,-10},{-80,-10},{-80,
          7},{-12,7}}, color={255,0,255}));
  connect(sch.y[1], theMixVal.yMixSet) annotation (Line(points={{-99,70},{-80,70},
          {-80,78},{-61,78}}, color={0,0,127}));
  connect(conTSetMix.y, theMixVal.TMixSet) annotation (Line(points={{-99,30},{-76,
          30},{-76,72},{-61,72}}, color={0,0,127}));
  connect(dcwSpl.port_2, theMixVal.port_col) annotation (Line(points={{-32,0},{-32,
          38},{-68,38},{-68,62},{-60,62}}, color={0,127,255}));
  connect(theMixVal.port_hot, heaPum.port_b1) annotation (Line(points={{-60,66},
          {-72,66},{-72,4},{-10,4}}, color={0,127,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-100},{100,100}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/EnergyTransferStations/Combined/Subsystems/Validation/HeatPumpDHWTank.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Interval=30,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(
      revisions="<html>
<ul>
<li>
October 31, 2020, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPumpDHWTank\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Subsystems.HeatPumpDHWTank</a>.
</p>
</html>"));
end HeatPumpDHWTank;
