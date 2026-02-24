within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block OneZoneRatchetHeatingSingleZone "one_zone_ratchet_heating_single_zone"

      parameter Real samplePeriodRatchet(unit="s")=300
    "Sample period of the demand flexibility control";
          parameter Real samplePeriodRebound(unit="s")=900
    "Sample period of rebound";
     parameter Real TRatThreshold=0.5
    "Threshold of zone air temperature setpoint difference below which ratcheting is triggerd";

           parameter Real TRat=-1
    "Ratcheting temperature";
           parameter Real TReb=1
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
          extent={{-240,-42},{-200,-2}}),   iconTransformation(extent={{-240,
            -42},{-200,-2}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonSetHeaCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint command" annotation (Placement(transformation(
          extent={{300,-122},{340,-82}}),
                                       iconTransformation(extent={{300,-122},{
            340,-82}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetCur(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-116},{-200,-76}}), iconTransformation(extent={{-240,
            -116},{-200,-76}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "thermal limit zone temperature setpoint" annotation (Placement(
        transformation(extent={{-240,-184},{-200,-144}}), iconTransformation(
          extent={{-240,-188},{-200,-148}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSetNom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "nominal zone temperature setpoint" annotation (Placement(transformation(
          extent={{-240,-256},{-200,-216}}), iconTransformation(extent={{-240,
            -256},{-200,-216}})));
  Buildings.Controls.OBC.DemandFlexibility.Subsequences.OneZoneRatchetHeating
    one_zone_ratchet_heating1(
    samplePeriodRatchet=samplePeriodRatchet,
    samplePeriodRebound=samplePeriodRebound,
    TRatThreshold=TRatThreshold,
    TRat=TRat,
    TReb=TReb,
    reboundDuration=reboundDuration)
    annotation (Placement(transformation(extent={{-64,-182},{242,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con4(k=true)
    annotation (Placement(transformation(extent={{-178,0},{-158,20}})));
equation
  connect(loaShe, one_zone_ratchet_heating1.loaShe) annotation (Line(points={{
          -220,52},{-96,52},{-96,30.96},{-76.24,30.96}}, color={255,0,255}));
  connect(TZon, one_zone_ratchet_heating1.TZon) annotation (Line(points={{-220,
          -22},{-94,-22},{-94,-35.59},{-76.24,-35.59}}, color={0,0,127}));
  connect(TZonHeaSetCur, one_zone_ratchet_heating1.TZonHeaSetCur) annotation (
      Line(points={{-220,-96},{-194,-96},{-194,-54.95},{-76.24,-54.95}}, color=
          {0,0,127}));
  connect(TZonHeaSetMin, one_zone_ratchet_heating1.TZonHeaSetMin) annotation (
      Line(points={{-220,-164},{-190,-164},{-190,-75.52},{-76.24,-75.52}},
        color={0,0,127}));
  connect(TZonHeaSetNom, one_zone_ratchet_heating1.TZonHeaSetNom) annotation (
      Line(points={{-220,-236},{-194,-236},{-194,-97.3},{-76.24,-97.3}}, color=
          {0,0,127}));
  connect(one_zone_ratchet_heating1.TZonSetHeaCom, TZonSetHeaCom) annotation (
      Line(points={{254.24,24.91},{254.24,-102},{320,-102}}, color={0,0,127}));
  connect(con4.y, one_zone_ratchet_heating1.ratSig) annotation (Line(points={{
          -156,10},{-94,10},{-94,12.81},{-76.24,12.81}}, color={255,0,255}));
  connect(con4.y, one_zone_ratchet_heating1.rebSig) annotation (Line(points={{
          -156,10},{-94,10},{-94,-6.55},{-76.24,-6.55}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},
            {300,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-300},{300,100}},
        grid={2,2})));
end OneZoneRatchetHeatingSingleZone;
