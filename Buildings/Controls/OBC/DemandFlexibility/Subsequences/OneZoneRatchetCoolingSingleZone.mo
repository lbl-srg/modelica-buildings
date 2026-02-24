within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block OneZoneRatchetCoolingSingleZone "one_zone_ratchet_cooling_single_zone"

      parameter Real samplePeriodRatchet(unit="s")=300
    "Sample period of the demand flexibility control";
          parameter Real samplePeriodRebound(unit="s")=900
    "Sample period of rebound";
     parameter Real TRatThreshold=0.5
    "Threshold of zone air temperature setpoint difference below which ratcheting is triggerd";
    parameter Real TRat=1
    "Ratcheting temperature";
               parameter Real TReb=-1
    "rebound temperature";
     parameter Real reboundDuration(unit="s")=3600;

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput loaShe
    "Load shed event flag" annotation (Placement(transformation(extent={{-240,32},
            {-200,72}}), iconTransformation(extent={{-240,32},{-200,72}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone room air temperature" annotation (Placement(transformation(
          extent={{-240,-44},{-200,-4}}),   iconTransformation(extent={{-240,
            -44},{-200,-4}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{300,-116},{340,-76}}),
                                       iconTransformation(extent={{300,-116},{
            340,-76}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetCur(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-110},{-200,-70}}), iconTransformation(extent={{-240,-110},
            {-200,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "thermal limit zone temperature setpoint" annotation (Placement(
        transformation(extent={{-236,-244},{-196,-204}}), iconTransformation(
          extent={{-238,-182},{-198,-142}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSetNom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "nominal zone temperature setpoint" annotation (Placement(transformation(
          extent={{-236,-284},{-196,-244}}), iconTransformation(extent={{-238,
            -250},{-198,-210}})));
  Buildings.Controls.OBC.DemandFlexibility.Subsequences.OneZoneRatchetCooling
    one_zone_ratchet_cooling1(
    samplePeriodRatchet=samplePeriodRatchet,
    samplePeriodRebound=samplePeriodRebound,
    TRatThreshold=TRatThreshold,
    TRat=TRat,
    TReb=TReb,
    reboundDuration=reboundDuration)
    annotation (Placement(transformation(extent={{-64,-186},{188,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4(k=true)
    annotation (Placement(transformation(extent={{-176,-18},{-154,4}})));
equation
  connect(loaShe, one_zone_ratchet_cooling1.loaShe) annotation (Line(points={{
          -220,52},{-92,52},{-92,-4.72},{-74.08,-4.72}}, color={255,0,255}));
  connect(TZon, one_zone_ratchet_cooling1.TZon) annotation (Line(points={{-220,
          -24},{-92,-24},{-92,-61.37},{-74.08,-61.37}}, color={0,0,127}));
  connect(TZonCooSetCur, one_zone_ratchet_cooling1.TZonCooSetCur) annotation (
      Line(points={{-220,-90},{-92,-90},{-92,-77.85},{-74.08,-77.85}}, color={0,
          0,127}));
  connect(TZonCooSetMax, one_zone_ratchet_cooling1.TZonCooSetMax) annotation (
      Line(points={{-216,-224},{-92,-224},{-92,-131.41},{-74.08,-131.41}},
        color={0,0,127}));
  connect(TZonCooSetNom, one_zone_ratchet_cooling1.TZonCooSetNom) annotation (
      Line(points={{-216,-264},{-92,-264},{-92,-224},{-90,-224},{-90,-216},{-94,
          -216},{-94,-149.95},{-73.072,-149.95}}, color={0,0,127}));
  connect(one_zone_ratchet_cooling1.TZonCooSetCom, TZonCooSetCom) annotation (
      Line(points={{198.08,-9.87},{294,-9.87},{294,-96},{320,-96}}, color={0,0,
          127}));
  connect(con4.y, one_zone_ratchet_cooling1.ratSig) annotation (Line(points={{
          -151.8,-7},{-92,-7},{-92,-20.17},{-74.08,-20.17}}, color={255,0,255}));
  connect(one_zone_ratchet_cooling1.rebSig, con4.y) annotation (Line(points={{
          -74.08,-36.65},{-136,-36.65},{-136,-7},{-151.8,-7}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},
            {300,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{300,100}},
        grid={2,2})));
end OneZoneRatchetCoolingSingleZone;
