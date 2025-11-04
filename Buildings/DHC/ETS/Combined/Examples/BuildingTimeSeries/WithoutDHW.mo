within Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries;
model WithoutDHW "ETS connected to building loads without DHW"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";

  parameter String filNam =
    "modelica://Buildings/Resources/Data/DHC/Loads/Examples/JBA_ClusterA_futu_tendays.mos"
    "Load profile";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 wea(
    computeWetBulbTemperature=false,
    filNam = Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/DHC/Loads/Examples/fTMY_Maryland_Prince_George's_NORESM2_2020_2039.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-60,-6},{-40,14}})));
  Buildings.Fluid.Sources.Boundary_pT supAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    use_T_in=true,
    T=280.15,
    nPorts=1) "Ambient water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-24})));
  Buildings.Fluid.Sources.Boundary_pT sinAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-60})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-40})));
  Modelica.Blocks.Sources.Constant TDisSup(k(
      unit="K",
      displayUnit="degC") = 288.15)
    "District supply temperature"
    annotation (Placement(transformation(extent={{-92,-30},{-72,-10}})));
  Buildings.DHC.ETS.Combined.Examples.BuildingTimeSeries.BaseClasses.BuildingETS bui(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    facTerUniSizHea=1,
    final filNam=filNam,
    allowFlowReversalSer=true,
    have_eleNonHva=true)
    "Building time series with energy transfer station"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Continuous.Integrator dHHeaWat
    "Cumulative enthalpy difference of heating hot water"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Continuous.Integrator dHChiWat
    "Cumulative enthalpy difference of chilled water"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Continuous.Integrator dHHotWat if bui.have_hotWat
    "Cumulative enthalpy difference of domestic hot water"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senHFlo(
      redeclare final package Medium1 = Medium,
      final m_flow_nominal=bui.ets.hex.m1_flow_nominal)
    "Variation of enthalpy flow rate" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-30})));
  Modelica.Blocks.Continuous.Integrator dHFlo if bui.have_hotWat
    "Cumulative enthalpy difference across the ets hex"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum ENet(
    nin=if bui.have_hotWat
        then 3
        else 2)
    "Cumulative net energy consumption, heating + dhw (if present) - cooling"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Modelica.Blocks.Continuous.Integrator EChi
    "Cumulative electricity consumption of the heat recovery chiller"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
equation
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{-71,-20},{-62,-20}},
                                                 color={0,0,127}));
  connect(bui.dHHeaWat_flow, dHHeaWat.u) annotation (Line(points={{46,-22},{46,
          -38},{22,-38},{22,50},{38,50}}, color={0,0,127}));
  connect(bui.dHChiWat_flow, dHChiWat.u) annotation (Line(points={{48,-22},{48,
          -40},{20,-40},{20,80},{38,80}}, color={0,0,127}));
  connect(bui.dHHotWat_flow, dHHotWat.u) annotation (Line(points={{44,-22},{44,-36},
          {24,-36},{24,20},{38,20}}, color={0,0,127}));
  connect(dHChiWat.y, ENet.u[1]) annotation (Line(points={{61,80},{68,80},{68,50},
          {78,50}},                  color={0,0,127}));
  connect(dHHeaWat.y, ENet.u[2]) annotation (Line(points={{61,50},{78,50}},
                                     color={0,0,127}));
  connect(dHHotWat.y, ENet.u[3]) annotation (Line(points={{61,20},{68,20},{68,
          50},{78,50}},              color={0,0,127}));
  connect(wea.weaBus, bui.weaBus) annotation (Line(
      points={{-40,4},{50,4},{50,0}},
      color={255,204,51},
      thickness=0.5));
  connect(senMasFlo.port_a, bui.port_bSerAmb)
    annotation (Line(points={{70,-30},{70,-10},{60,-10}}, color={0,127,255}));
  connect(sinAmbWat.ports[1], senHFlo.port_b2) annotation (Line(points={{-40,
          -60},{-30,-60},{-30,-36},{-20,-36}}, color={0,127,255}));
  connect(senHFlo.port_a2, senMasFlo.port_b) annotation (Line(points={{0,-36},{
          14,-36},{14,-60},{70,-60},{70,-50}}, color={0,127,255}));
  connect(senHFlo.port_b1, bui.port_aSerAmb) annotation (Line(points={{0,-24},{
          12,-24},{12,-10},{40,-10}}, color={0,127,255}));
  connect(supAmbWat.ports[1], senHFlo.port_a1) annotation (Line(points={{-40,-24},
          {-20,-24}},                          color={0,127,255}));
  connect(senHFlo.dH_flow, dHFlo.u) annotation (Line(points={{2,-27},{2,-28},{
          10,-28},{10,-80},{38,-80}}, color={0,0,127}));
  connect(bui.PCoo, EChi.u) annotation (Line(points={{62,-3},{62,-4},{70,-4},{
          70,10},{78,10}},
                        color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Examples/BuildingTimeSeries/WithoutDHW.mos" "Simulate and plot"),
    experiment(
      StartTime=7776000,
      StopTime=8640000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Validation model for a single building without DHW integration in the ETS.
Note that the information that a domestic hot water integration is present
is obtained from the load profile <code>filNam</code>.
</p>
</html>"));
end WithoutDHW;
