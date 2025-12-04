within Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries;
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
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.Boundary_pT ambWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    T=288.15,
    nPorts=2) "Ambient water supply and return" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,42})));
  Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.BaseClasses.BuildingETS bui(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    facTerUniSizHea=1,
    final filNam=filNam,
    allowFlowReversalSer=true,
    have_eleNonHva=true)
    "Building time series with energy transfer station"
    annotation (Placement(transformation(extent={{0,46},{20,66}})));
  Modelica.Blocks.Continuous.Integrator dHHeaWat
    "Cumulative enthalpy difference of heating hot water"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Continuous.Integrator dHChiWat
    "Cumulative enthalpy difference of chilled water"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate senHFlo(
      redeclare final package Medium1 = Medium,
      final m_flow_nominal=bui.ets.hex.m1_flow_nominal)
    "Variation of enthalpy flow rate" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,40})));
  Modelica.Blocks.Continuous.Integrator dHFlo if bui.have_hotWat
    "Cumulative enthalpy difference across the ets hex"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Blocks.Continuous.Integrator EChi
    "Cumulative electricity consumption of the heat recovery chiller"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
equation
  connect(bui.dHHeaWat_flow, dHHeaWat.u) annotation (Line(points={{6,44},{6,0},
          {38,0}},                        color={0,0,127}));
  connect(bui.dHChiWat_flow, dHChiWat.u) annotation (Line(points={{8,44},{8,40},
          {38,40}},                       color={0,0,127}));
  connect(wea.weaBus, bui.weaBus) annotation (Line(
      points={{-60,70},{10,70},{10,66}},
      color={255,204,51},
      thickness=0.5));
  connect(senHFlo.port_b1, bui.port_aSerAmb) annotation (Line(points={{-20,46},
          {-10,46},{-10,56},{0,56}},  color={0,127,255}));
  connect(senHFlo.dH_flow, dHFlo.u) annotation (Line(points={{-18,43},{-10,43},
          {-10,-70},{38,-70}},        color={0,0,127}));
  connect(bui.PCoo, EChi.u) annotation (Line(points={{22,63},{22,64},{28,64},{
          28,80},{38,80}},
                        color={0,0,127}));
  connect(bui.port_bSerAmb, senHFlo.port_a2) annotation (Line(points={{20,56},{
          30,56},{30,34},{-20,34}},
                                 color={0,127,255}));
  connect(ambWat.ports[1], senHFlo.port_b2) annotation (Line(points={{-60,41},{
          -50,41},{-50,34},{-40,34}}, color={0,127,255}));
  connect(ambWat.ports[2], senHFlo.port_a1) annotation (Line(points={{-60,43},{
          -50,43},{-50,46},{-40,46}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Examples/Combined/ETSHeatRecoveryHeatPump_BuildingTimeSeries/WithoutDHW.mos" "Simulate and plot"),
    experiment(
      StartTime=7776000,
      StopTime=8640000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Validation model for a single building load, modeled as time series,
connected to an ETS.
</p>
<p>
Note the following:
</p>
<ul>
<li>
The model does not contain a district loop. Rather, the service line is
connected to a constant pressure boundary, and the example model contains
an energy transfer station connected to a building load.
</li>
<li>
The information that no domestic hot water integration should be modeled
is obtained from the load profile <code>filNam</code>
by reading its entry for the peak domestic hot water load.
As it is zero,
the parameter <code>bui.have_hotWat</code> is set to <code>false</code>.
</li>
</ul>
<p>
This model is identical to
<a href=\"modelica://Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.WithDHW\">
Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.WithDHW</a>,
except that it has no domestic hot water.
</p>
</html>"));
end WithoutDHW;
