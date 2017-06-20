within Buildings.Air.Systems.SingleZone.VAV.Examples;
model ChillerDXHeatingEconomizer
  "Example for SingleZoneVAV with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with economizer."
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    designAirFlow=0.75,
    minAirFlow=0.2*0.75,
    designHeatingEfficiency=0.99,
    designHeatingCapacity=7000,
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    designCoolingCapacity=-7000,
    sensitivityGainHeat=0.25,
    sensitivityGainCool=0.25,
    minOAFra=0.2,
    sensitivityGainEco=0.25,
    supplyAirTempSet=286.15,
    chwsTempSet=279.15) "Single zone VAV system"
    annotation (Placement(transformation(extent={{-40,-10},{0,22}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.Room zon(
      designAirFlow=0.75, lat=weaDat.lat) "Thermal envelope of single zone"
    annotation (Placement(transformation(extent={{32,-4},{52,16}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam=
        "modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Continuous.Integrator EFan "Total fan energy"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Continuous.Integrator EHea "Total heating energy"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Continuous.Integrator ECoo "Total cooling energy"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Math.Sum EHVAC(nin=4) "Total HVAC energy"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Continuous.Integrator EPum "Total pump energy"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
equation
  connect(weaDat.weaBus, zon.weaBus) annotation (Line(
      points={{-80,90},{-26,90},{33,90},{33,16.4}},
      color={255,204,51},
      thickness=0.5));
  connect(hvac.supplyAir, zon.supplyAir) annotation (Line(points={{0,8},{4,8},{
          14,8},{14,26},{38,26},{38,17}}, color={0,127,255}));
  connect(zon.zoneMeanAirTemperature, hvac.TRoo) annotation (Line(points={{53,6},
          {60,6},{70,6},{70,-16},{-64,-16},{-64,6},{-42,6}}, color={0,0,127}));
  connect(zon.TcoolSetpoint, hvac.TSetRooCoo) annotation (Line(points={{53,-2},
          {62,-2},{62,-14},{-60,-14},{-60,14},{-42,14}}, color={0,0,127}));
  connect(zon.TheatSetpoint, hvac.TSetRooHea) annotation (Line(points={{53,0},{
          64,0},{64,-12},{-54,-12},{-54,20},{-42,20}}, color={0,0,127}));
  connect(zon.returnAir, hvac.returnAir[1]) annotation (Line(points={{44,17},{
          44,24},{18,24},{18,-4},{0,-4}}, color={0,127,255}));
  connect(weaDat.weaBus,hvac. weaBus) annotation (Line(
      points={{-80,90},{-37,90},{-37,23}},
      color={255,204,51},
      thickness=0.5));
  connect(hvac.fanPower, EFan.u) annotation (Line(points={{1,20},{10,20},{10,-30},
          {18,-30}}, color={0,0,127}));
  connect(hvac.heatPower, EHea.u) annotation (Line(points={{1,18},{8,18},{8,-50},
          {18,-50}}, color={0,0,127}));
  connect(hvac.coolPower, ECoo.u) annotation (Line(points={{1,16},{6,16},{6,-70},
          {18,-70}}, color={0,0,127}));
  connect(EFan.y, EHVAC.u[1]) annotation (Line(points={{41,-30},{48,-30},{48,-71.5},
          {58,-71.5}}, color={0,0,127}));
  connect(EHea.y, EHVAC.u[2]) annotation (Line(points={{41,-50},{41,-70.5},{58,
          -70.5}}, color={0,0,127}));
  connect(ECoo.y, EHVAC.u[3]) annotation (Line(points={{41,-70},{50,-70},{50,-69.5},
          {58,-69.5}}, color={0,0,127}));
  connect(EPum.y, EHVAC.u[4]) annotation (Line(points={{41,-90},{48,-90},{48,-68.5},
          {58,-68.5}}, color={0,0,127}));
  connect(EPum.u, hvac.pumpPower) annotation (Line(points={{18,-90},{4,-90},{4,
          14},{1,14}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=504800,
      Interval=3600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/ChillerDXHeatingEconomizer.mos"
        "Simulate and plot"),
     Documentation(info="<html>
<p>
The thermal zone is based on the BESTEST Case 600 envelope, while the HVAC
system is based on a conventional VAV system with air cooled chiller and
economizer.  See documentation for the specific models for more information.
</p>
</html>"));
end ChillerDXHeatingEconomizer;
