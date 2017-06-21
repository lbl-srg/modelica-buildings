within Buildings.Air.Systems.SingleZone.VAV.Examples;
model ChillerDXHeatingEconomizer
  "Example for SingleZoneVAV with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with economizer."
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";
  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    mAir_flow_nominal=0.75,
    etaHea_nominal=0.99,
    QHea_flow_nominal=7000,
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    QCoo_flow_nominal=-7000,
    minOAFra=0.2,
    kPFan=4,
    kPEco=4,
    kPHea=4,
    TSetSupAir=286.15,
    TSetSupChi=279.15)           "Single zone VAV system"
    annotation (Placement(transformation(extent={{-40,-10},{0,22}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.Room zon(
      mAir_flow_nominal=0.75, lat=weaDat.lat) "Thermal envelope of single zone"
    annotation (Placement(transformation(extent={{32,-4},{52,16}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false, filNam=
        "modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Continuous.Integrator EFan "Total fan energy"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Continuous.Integrator EHea "Total heating energy"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Continuous.Integrator ECoo "Total cooling energy"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Modelica.Blocks.Math.Sum EHVAC(nin=4) "Total HVAC energy"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Modelica.Blocks.Continuous.Integrator EPum "Total pump energy"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));

  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15
         + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[0,30 + 273.15; 8*3600,25 + 273.15; 18*3600,30 + 273.15; 24*3600,30
         + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));
equation
  connect(weaDat.weaBus, zon.weaBus) annotation (Line(
      points={{-60,70},{-60,70},{-38,70},{-38,70},{35.3333,70},{35.3333,14}},
      color={255,204,51},
      thickness=0.5));
  connect(zon.TRooAir, hvac.TRoo) annotation (Line(points={{52.8333,6},{52.8333,
          6},{70,6},{70,-16},{-54,-16},{-54,8.52632},{-42,8.52632}}, color={0,0,
          127}));
  connect(weaDat.weaBus,hvac. weaBus) annotation (Line(
      points={{-60,70},{-37,70},{-37,22.8421}},
      color={255,204,51},
      thickness=0.5));
  connect(hvac.PFan, EFan.u) annotation (Line(points={{1,20.3158},{10,20.3158},
          {10,-40},{18,-40}},
                     color={0,0,127}));
  connect(hvac.QHea_flow, EHea.u) annotation (Line(points={{1,18.6316},{8,
          18.6316},{8,-70},{18,-70}},
                     color={0,0,127}));
  connect(hvac.PCoo, ECoo.u) annotation (Line(points={{1,16.9474},{6,16.9474},{
          6,-100},{18,-100}},
                     color={0,0,127}));
  connect(EFan.y, EHVAC.u[1]) annotation (Line(points={{41,-40},{48,-40},{48,
          -71.5},{58,-71.5}},
                       color={0,0,127}));
  connect(EHea.y, EHVAC.u[2]) annotation (Line(points={{41,-70},{41,-70.5},{58,
          -70.5}}, color={0,0,127}));
  connect(ECoo.y, EHVAC.u[3]) annotation (Line(points={{41,-100},{50,-100},{50,
          -69.5},{58,-69.5}},
                       color={0,0,127}));
  connect(EPum.y, EHVAC.u[4]) annotation (Line(points={{41,-130},{48,-130},{48,
          -68.5},{58,-68.5}},
                       color={0,0,127}));
  connect(EPum.u, hvac.PPum) annotation (Line(points={{18,-130},{4,-130},{4,
          15.2632},{1,15.2632}},
                       color={0,0,127}));
  connect(hvac.supplyAir, zon.supplyAir) annotation (Line(points={{0,11.8947},{
          20,11.8947},{20,8},{32,8}},
                                   color={0,127,255}));
  connect(hvac.returnAir, zon.returnAir) annotation (Line(points={{0,5.15789},{18,
          5.15789},{18,4},{32,4}}, color={0,127,255}));
  connect(hvac.TSetRooHea, TSetRooCoo.y[1]) annotation (Line(points={{-42,
          20.3158},{-56,20.3158},{-56,40},{-69,40}}, color={0,0,127}));
  connect(TSetRooHea.y[1], hvac.TSetRooCoo) annotation (Line(points={{-69,12},{
          -56,12},{-56,15.2632},{-42,15.2632}}, color={0,0,127}));
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
</html>"),
    Diagram(coordinateSystem(extent={{-100,-140},{100,120}})),
    Icon(coordinateSystem(extent={{-100,-140},{100,120}})));
end ChillerDXHeatingEconomizer;
