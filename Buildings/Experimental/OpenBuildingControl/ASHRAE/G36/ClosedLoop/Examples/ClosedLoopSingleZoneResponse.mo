within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.ClosedLoop.Examples;
model ClosedLoopSingleZoneResponse
  "Example for SingleZoneVAV with a dry cooling coil, air-cooled chiller, electric heating coil, variable speed fan, and mixing box with G36 economizer."
  extends Modelica.Icons.Example;

  package MediumA = Buildings.Media.Air "Buildings library air media package";
  package MediumW = Buildings.Media.Water "Buildings library air media package";
  parameter Modelica.SIunits.Temperature TOutCutoff=297
    "Outdoor temperature high limit cutoff";
  parameter Modelica.SIunits.SpecificEnergy hOutCutoff=65100
    "Outdoor air enthalpy high limit cutoff";

  parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
    "Design value for chiller leaving water temperature";
  parameter Modelica.SIunits.Density meanAirDensity=1.204
    "Air density at t = 20C";
  parameter Integer numOcupants=10 "Number of occupants";

  Buildings.Air.Systems.SingleZone.VAV.ChillerDXHeatingEconomizer hvac(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    mAir_flow_nominal=0.75,
    etaHea_nominal=0.99,
    QHea_flow_nominal=7000,
    QCoo_flow_nominal=-7000,
    TSupChi_nominal=TSupChi_nominal)   "Single zone VAV system"
    annotation (Placement(transformation(extent={{80,-20},{120,20}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.Room zon(
      mAir_flow_nominal=0.75,
      lat=weaDat.lat) "Thermal envelope of single zone"
    annotation (Placement(transformation(extent={{160,-20},{200,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=false,
      filNam="modelica://Buildings/Resources/weatherdata/DRYCOLD.mos")
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Modelica.Blocks.Continuous.Integrator EFan "Total fan energy"
    annotation (Placement(transformation(extent={{160,-50},{180,-30}})));
  Modelica.Blocks.Continuous.Integrator EHea "Total heating energy"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Modelica.Blocks.Continuous.Integrator ECoo "Total cooling energy"
    annotation (Placement(transformation(extent={{160,-110},{180,-90}})));
  Modelica.Blocks.Math.MultiSum EHVAC(nu=4)  "Total HVAC energy"
    annotation (Placement(transformation(extent={{200,-80},{220,-60}})));
  Modelica.Blocks.Continuous.Integrator EPum "Total pump energy"
    annotation (Placement(transformation(extent={{160,-140},{180,-120}})));

  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(
    table=[
      0,       15 + 273.15;
      8*3600,  20 + 273.15;
      18*3600, 15 + 273.15;
      24*3600, 15 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-220,0},{-200,20}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(
    table=[
      0,       30 + 273.15;
      8*3600,  25 + 273.15;
      18*3600, 30 + 273.15;
      24*3600, 30 + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));

  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{74,70},{94,90}})));

  Atomic.OutdoorAirFlowSetpoint_SingleZone OutAirSetPoi_SinZon
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  CDL.Continuous.Constant numberOcupants(k=numOcupants) "Number of occupants"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  CDL.Continuous.Add mean(k1=0.5, k2=0.5) annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  CDL.Continuous.Constant TOutCut(k=TOutCutoff) "Outdoor air temperature cutoff"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Logical.Constant fanStatus(k=true) annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  CDL.Logical.Constant windowClosed(k=true) annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  CDL.Logical.Constant chillerOn(k=true) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  CDL.Integers.Constant zonSta(k=2) annotation (Placement(transformation(extent={{-42,-84},{-22,-64}})));
  CDL.Integers.Constant opeMod(k=1) annotation (Placement(transformation(extent={{-42,-116},{-22,-96}})));
  CDL.Integers.Constant freProSta(k=0) annotation (Placement(transformation(extent={{-42,-148},{-22,-128}})));
  CDL.Continuous.Constant TChilWat(k=278.15) annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  SingleZoneVAVControl singleZoneAHUController
    annotation (Placement(transformation(rotation=0, extent={{-20,20},{0,40}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{40,140},{72,140},{72,80},{84,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(hvac.supplyAir, zon.supplyAir) annotation (Line(points={{120,8},{130,8},{130,2},{160,2}},
                                   color={0,127,255}));
  connect(hvac.returnAir, zon.returnAir) annotation (Line(points={{120,0},{126,0},{126,-2},{130,-2},{160,-2}},
                                   color={0,127,255}));

  connect(hvac.weaBus, weaBus) annotation (Line(
      points={{84,17.8},{84,80}},
      color={255,204,51},
      thickness=0.5));
  connect(zon.weaBus, weaBus) annotation (Line(
      points={{166,18},{162,18},{162,80},{84,80}},
      color={255,204,51},
      thickness=0.5));

  connect(hvac.PFan, EFan.u) annotation (Line(points={{121,18},{144,18},{144,-40},{158,-40}},
                     color={0,0,127}));
  connect(hvac.QHea_flow, EHea.u) annotation (Line(points={{121,16},{142,16},{142,-70},{158,-70}},
                     color={0,0,127}));
  connect(hvac.PCoo, ECoo.u) annotation (Line(points={{121,14},{140,14},{140,-100},{158,-100}},
                     color={0,0,127}));
  connect(hvac.PPum, EPum.u) annotation (Line(points={{121,12},{138,12},{138,-130},{158,-130}},
                       color={0,0,127}));

  connect(EFan.y, EHVAC.u[1]) annotation (Line(points={{181,-40},{190,-40},{190,-64.75},{200,-64.75}},
                                color={0,0,127}));
  connect(EHea.y, EHVAC.u[2])
    annotation (Line(points={{181,-70},{200,-70},{200,-68.25}},
                                                             color={0,0,127}));
  connect(ECoo.y, EHVAC.u[3]) annotation (Line(points={{181,-100},{190,-100},{190,-71.75},{200,-71.75}},
                                color={0,0,127}));
  connect(EPum.y, EHVAC.u[4]) annotation (Line(points={{181,-130},{194,-130},{194,-75.25},{200,-75.25}},
                                color={0,0,127}));
  connect(mean.y, singleZoneAHUController.TSetZon)
    annotation (Line(points={{-139,0},{-40,0},{-40,40},{-8,40}}, color={0,0,127}));
  connect(TSetRooHea.y[1], singleZoneAHUController.TRooHeaSet)
    annotation (Line(points={{-199,10},{-180,10},{-180,35},{-20,35}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], singleZoneAHUController.TRooCooSet)
    annotation (Line(points={{-199,-20},{-170,-20},{-170,33},{-20,33}}, color={0,0,127}));
  connect(zon.TRooAir, singleZoneAHUController.TRoo)
    annotation (Line(points={{201,0},{220,0},{220,98},{-60,98},{-60,37},{-20,37}}, color={0,0,127}));
  connect(TOutCut.y, singleZoneAHUController.TOutCut)
    annotation (Line(points={{-59,-90},{-9,-90},{-9,20}}, color={0,0,127}));
  connect(weaBus.TDryBul, singleZoneAHUController.TOut) annotation (Line(
      points={{84,80},{20,80},{20,38},{0,38}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(singleZoneAHUController.uVOutMinSet_flow, OutAirSetPoi_SinZon.VOutMinSet_flow)
    annotation (Line(points={{0,22},{16,22},{16,-30},{-79,-30}}, color={0,0,127}));
  connect(numberOcupants.y, OutAirSetPoi_SinZon.nOcc)
    annotation (Line(points={{-139,-30},{-120,-30},{-120,-22},{-101,-22}}, color={0,0,127}));
  connect(zon.TRooAir, OutAirSetPoi_SinZon.TZon) annotation (Line(points={{201,0},{210,0},{210,-24},{40,-24},{40,-10},{
          -110,-10},{-110,-25},{-101,-25}}, color={0,0,127}));
  connect(hvac.TSup, OutAirSetPoi_SinZon.TSup)
    annotation (Line(points={{121,-7},{130,-7},{130,-44},{-110,-44},{-110,-28},{-101,-28}}, color={0,0,127}));
  connect(fanStatus.y, OutAirSetPoi_SinZon.uSupFan)
    annotation (Line(points={{-119,-70},{-110,-70},{-110,-38},{-101,-38}}, color={255,0,255}));
  connect(windowClosed.y, OutAirSetPoi_SinZon.uWindow)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,-34},{-101,-34}}, color={255,0,255}));
  connect(fanStatus.y, singleZoneAHUController.uSupFan)
    annotation (Line(points={{-119,-70},{-60,-70},{-60,-50},{-1,-50},{-1,20},{-11,20}}, color={255,0,255}));
  connect(singleZoneAHUController.y, hvac.uFan)
    annotation (Line(points={{0,35},{40,35},{40,28},{40,18},{78,18}}, color={0,0,127}));
  connect(singleZoneAHUController.yHea, hvac.uHea)
    annotation (Line(points={{0,26},{20,26},{20,12},{78,12}}, color={0,0,127}));
  connect(singleZoneAHUController.yCoo, hvac.uCooVal)
    annotation (Line(points={{0,24},{0,5},{20,5},{78,5}}, color={0,0,127}));
  connect(chillerOn.y, hvac.chiOn) annotation (Line(points={{61,-90},{70,-90},{70,-10},{78,-10}}, color={255,0,255}));
  connect(hvac.TSup, singleZoneAHUController.TSup)
    annotation (Line(points={{121,-7},{122,-7},{126,-7},{126,-42},{-6,-42},{-6,20}}, color={0,0,127}));
  connect(zonSta.y, singleZoneAHUController.uZonSta)
    annotation (Line(points={{-21,-74},{0,-74},{0,20}}, color={255,127,0}));
  connect(opeMod.y, singleZoneAHUController.uOpeMod)
    annotation (Line(points={{-21,-106},{-2,-106},{-2,20}}, color={255,127,0}));
  connect(freProSta.y, singleZoneAHUController.uFreProSta)
    annotation (Line(points={{-21,-138},{-4,-138},{-4,20}}, color={255,127,0}));
  connect(singleZoneAHUController.yOutDamPos, hvac.uEco)
    annotation (Line(points={{0,24},{50,24},{50,-2},{78,-2}}, color={0,0,127}));
  connect(TSetRooHea.y[1], mean.u1) annotation (Line(points={{-199,10},{-180,10},{-180,6},{-162,6}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], mean.u2)
    annotation (Line(points={{-199,-20},{-180,-20},{-180,-6},{-162,-6}}, color={0,0,127}));
  connect(TChilWat.y, hvac.TSetChi) annotation (Line(points={{61,-130},{70,-130},{70,-15},{78,-15}}, color={0,0,127}));
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
</html>", revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-220,-160},{240,160}})));
end ClosedLoopSingleZoneResponse;
