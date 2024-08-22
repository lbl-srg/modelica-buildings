within Buildings.DHC.ETS.Combined.Subsystems.Validation;
model HeatPumpDHWTank
  "Validation of the base subsystem model with domestic hot water tank and heat pump"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  parameter Modelica.Units.SI.TemperatureDifference dT_nominal = 5
    "Nominal temperature difference across heat pump condensor and district supply/return water";
  parameter Modelica.Units.SI.Temperature TDisSup_nominal = 273.15 + 15
    "Nominal district supply water temperature";
  Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank
    heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    datWatHea=datWatHea,
    COP_nominal=2.3,
    TCon_nominal=datWatHea.TDom_nominal + datWatHea.dTHexApp_nominal +
        dT_nominal,
    TEva_nominal(displayUnit="K") = TDisSup_nominal - dT_nominal,
    QHotWat_flow_nominal=datWatHea.QHex_flow_nominal,
    dT_nominal=dT_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000)
    annotation (Placement(transformation(extent={{-20,-12},{0,8}})));
  Fluid.Sources.Boundary_pT           supAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    use_T_in=true,
    T=280.15,
    nPorts=1) "Ambient water supply"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={50,-60})));
  Fluid.Sources.Boundary_pT           sinAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=180,
                                                                               origin={-50,-60})));
  Fluid.Sensors.MassFlowRate           senMasFlo(redeclare package Medium =
        Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{30,-70},{10,-50}})));
  Modelica.Blocks.Sources.Constant TDisSup(k = TDisSup_nominal)
    "District supply temperature"
    annotation (Placement(transformation(extent={{90,-66},{70,-46}})));
  Fluid.Sources.Boundary_pT souDCW(
    redeclare final package Medium = Medium,
    T=283.15,
    nPorts=1) "Source for domestic cold water"
                                 annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-100,-42})));
  Buildings.DHC.ETS.BaseClasses.Junction dcwSpl(
      redeclare final package Medium = Medium, final m_flow_nominal=6000*{1,-1,
        -1})                                 "Splitter for domestic cold water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-68,4})));
  Modelica.Blocks.Sources.CombiTimeTable sch(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/DHC/Loads/HotWater/DHW_ApartmentMidRise.mos"),
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Domestic hot water fixture draw fraction schedule"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));

  Modelica.Blocks.Sources.Constant conTSetMix(k(
      final unit="K",
      displayUnit="degC") = 308.15)
    "Temperature setpoint for mixed water supply to fixture"
    annotation (Placement(transformation(extent={{-110,20},{-90,40}})));
  Loads.HotWater.ThermostaticMixingValve
                          theMixVal(redeclare package Medium = Medium,
      mMix_flow_nominal=1.2*datWatHea.mDom_flow_nominal)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  parameter Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger
    datWatHea(VTan=0.1892706, mDom_flow_nominal=6.52944E-06*1000)
    "Data for heat pump water heater with tank"
    annotation (Placement(transformation(extent={{-20,22},{0,42}})));
  Modelica.Blocks.Sources.BooleanConstant on "Enable"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
equation
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{69,-56},{62,-56}}, color={0,0,127}));
  connect(supAmbWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{40,-60},{30,-60}}, color={0,127,255}));
  connect(senMasFlo.port_b, heaPum.port_a2) annotation (Line(points={{10,-60},{
          4,-60},{4,-8},{0,-8}}, color={0,127,255}));
  connect(sinAmbWat.ports[1], heaPum.port_b2) annotation (Line(points={{-40,-60},
          {-30,-60},{-30,-8},{-20,-8}},
                                 color={0,127,255}));
  connect(dcwSpl.port_1, souDCW.ports[1]) annotation (Line(points={{-68,-6},{
          -68,-42},{-90,-42}},
                           color={0,127,255}));
  connect(dcwSpl.port_3, heaPum.port_a1)
    annotation (Line(points={{-58,4},{-20,4}},             color={0,127,255}));
  connect(sch.y[1], theMixVal.yMixSet) annotation (Line(points={{-89,70},{-80,
          70},{-80,78},{-61,78}},
                              color={0,0,127}));
  connect(conTSetMix.y, theMixVal.TMixSet) annotation (Line(points={{-89,30},{
          -76,30},{-76,72},{-61,72}},
                                  color={0,0,127}));
  connect(dcwSpl.port_2, theMixVal.port_col) annotation (Line(points={{-68,14},
          {-68,62},{-60,62}},              color={0,127,255}));
  connect(theMixVal.port_hot, heaPum.port_b1) annotation (Line(points={{-60,66},
          {-64,66},{-64,50},{20,50},{20,4},{0,4}},
                                     color={0,127,255}));
  connect(on.y, heaPum.uEna) annotation (Line(points={{-29,20},{-26,20},{-26,7},
          {-22,7}},    color={255,0,255}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-100},{100,100}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Subsystems/Validation/HeatPumpDHWTank.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
November 28, 2023, by David Blum:<br/>
Update for new heat pump with storage tank subsystem model.
</li>
<li>
October 31, 2020, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank\">
Buildings.DHC.ETS.Combined.Subsystems.HeatPumpDHWTank</a>.
</p>
</html>"));
end HeatPumpDHWTank;
