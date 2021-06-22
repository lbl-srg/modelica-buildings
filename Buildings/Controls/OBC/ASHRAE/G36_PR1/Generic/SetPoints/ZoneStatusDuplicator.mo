within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
model ZoneStatusDuplicator "Duplicate zone status output"

  parameter Integer numZon(final min=1)=1 "Number of zones in input";
  parameter Integer numGro(final min=1)=1 "Number of groups in output";


  CDL.Interfaces.BooleanInput                        zonOcc[numZon]
    "True when the zone is set to be occupied due to the override"
    annotation (Placement(transformation(extent={{-80,60},{-40,100}}),
      iconTransformation(extent={{-80,190},{-40,230}})));
  CDL.Interfaces.BooleanInput                        uOcc[numZon]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{-80,20},{-40,60}}),
        iconTransformation(extent={{-80,170},{-40,210}})));
  CDL.Interfaces.RealInput                        tNexOcc[numZon](final unit=
        fill("s", numZon), final quantity=fill("Time", numZon))
                                         "Time to next occupied period"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
      iconTransformation(extent={{-80,150},{-40,190}})));
  CDL.Interfaces.RealInput                        uCooTim[numZon](final unit=
        fill("s", numZon), final quantity=fill("Time", numZon))
                                         "Cool down time"
    annotation (Placement(transformation(extent={{-80,-60},{-40,-20}}),
      iconTransformation(extent={{-80,110},{-40,150}})));
  CDL.Interfaces.RealInput                        uWarTim[numZon](final unit=
        fill("s", numZon), final quantity=fill("Time", numZon))
                                         "Warm-up time"
    annotation (Placement(transformation(extent={{-80,-100},{-40,-60}}),
      iconTransformation(extent={{-80,90},{-40,130}})));
  CDL.Interfaces.BooleanInput                        uOccHeaHig[numZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-140},{-40,-100}}),
      iconTransformation(extent={{-80,50},{-40,90}})));
  CDL.Interfaces.BooleanInput                        uHigOccCoo[numZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-180},{-40,-140}}),
      iconTransformation(extent={{-80,30},{-40,70}})));
  CDL.Interfaces.BooleanInput                        uUnoHeaHig[numZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-220},{-40,-180}}),
      iconTransformation(extent={{-80,-10},{-40,30}})));
  CDL.Interfaces.RealInput                        THeaSetOff[numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-260},{-40,-220}}),
      iconTransformation(extent={{-80,-30},{-40,10}})));
  CDL.Interfaces.BooleanInput                        uEndSetBac[numZon]
    "True when the zone could end the setback mode"
    annotation (Placement(transformation(extent={{-80,-300},{-40,-260}}),
      iconTransformation(extent={{-80,-50},{-40,-10}})));
  CDL.Interfaces.BooleanInput                        uHigUnoCoo[numZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-330},{-40,-290}}),
      iconTransformation(extent={{-80,-90},{-40,-50}})));
  CDL.Interfaces.RealInput                        TCooSetOff[numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-390},{-40,-350}}),
      iconTransformation(extent={{-80,-110},{-40,-70}})));
  CDL.Interfaces.BooleanInput                        uEndSetUp[numZon]
    "True when the zone could end the setup mode"
    annotation (Placement(transformation(extent={{-80,-420},{-40,-380}}),
      iconTransformation(extent={{-80,-130},{-40,-90}})));
  CDL.Interfaces.RealInput                        TZon[numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{-80,-460},{-40,-420}}),
      iconTransformation(extent={{-80,-170},{-40,-130}})));
  CDL.Interfaces.BooleanInput                        uWin[numZon]
    "True when the window is open, false when the window is close or the zone does not have window status sensor"
    annotation (Placement(transformation(extent={{-80,-540},{-40,-500}}),
      iconTransformation(extent={{-80,-190},{-40,-150}})));


  CDL.Interfaces.BooleanOutput yzonOcc[numGro, numZon]
    "True when the zone is set to be occupied due to the override"
    annotation (Placement(transformation(extent={{40,60},{80,100}}),
      iconTransformation(extent={{40,190},{80,230}})));
  CDL.Interfaces.BooleanOutput yOcc[numGro,numZon]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{40,20},{80,60}}),
        iconTransformation(extent={{40,170},{80,210}})));
  CDL.Interfaces.RealOutput ytNexOcc[numGro, numZon](
    final unit=fill("s", numZon),
    final quantity=fill("Time", numZon)) "Time to next occupied period"
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
      iconTransformation(extent={{40,150},{80,190}})));
  CDL.Interfaces.RealOutput yCooTim[numGro,numZon](final unit=fill("s", numZon),
      final quantity=fill("Time", numZon)) "Cool down time" annotation (
      Placement(transformation(extent={{40,-60},{80,-20}}), iconTransformation(
          extent={{40,110},{80,150}})));
  CDL.Interfaces.RealOutput yWarTim[numGro,numZon](final unit=fill("s", numZon),
      final quantity=fill("Time", numZon)) "Warm-up time" annotation (Placement(
        transformation(extent={{40,-100},{80,-60}}), iconTransformation(extent={
            {40,90},{80,130}})));
  CDL.Interfaces.BooleanOutput yOccHeaHig[numGro,numZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-140},{80,-100}}),
        iconTransformation(extent={{40,50},{80,90}})));
  CDL.Interfaces.BooleanOutput yHigOccCoo[numGro,numZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-180},{80,-140}}),
        iconTransformation(extent={{40,30},{80,70}})));
  CDL.Interfaces.BooleanOutput yUnoHeaHig[numGro,numZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-220},{80,-180}}),
        iconTransformation(extent={{40,-10},{80,30}})));
  CDL.Interfaces.RealOutput yTHeaSetOff[numGro, numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-260},{80,-220}}),
      iconTransformation(extent={{40,-30},{80,10}})));
  CDL.Interfaces.BooleanOutput yEndSetBac[numGro,numZon]
    "True when the zone could end the setback mode" annotation (Placement(
        transformation(extent={{40,-300},{80,-260}}), iconTransformation(extent=
           {{40,-50},{80,-10}})));
  CDL.Interfaces.BooleanOutput yHigUnoCoo[numGro,numZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-330},{80,-290}}),
        iconTransformation(extent={{40,-90},{80,-50}})));
  CDL.Interfaces.RealOutput yTCooSetOff[numGro, numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-390},{80,-350}}),
      iconTransformation(extent={{40,-110},{80,-70}})));
  CDL.Interfaces.BooleanOutput yEndSetUp[numGro,numZon]
    "True when the zone could end the setup mode" annotation (Placement(
        transformation(extent={{40,-420},{80,-380}}), iconTransformation(extent=
           {{40,-130},{80,-90}})));
  CDL.Interfaces.RealOutput yTZon[numGro, numZon](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{40,-460},{80,-420}}),
      iconTransformation(extent={{40,-170},{80,-130}})));
  CDL.Interfaces.BooleanOutput yWin[numGro,numZon]
    "True when the window is open, false when the window is close or the zone does not have window status sensor"
    annotation (Placement(transformation(extent={{40,-540},{80,-500}}),
        iconTransformation(extent={{40,-190},{80,-150}})));


  CDL.Routing.BooleanArrayReplicator zonOccDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  CDL.Routing.BooleanArrayReplicator uOccDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  CDL.Routing.RealArrayReplicator tNexOccDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Routing.RealArrayReplicator uCooTimDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  CDL.Routing.RealArrayReplicator uWarTimDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  CDL.Routing.BooleanArrayReplicator uOccHeaHigDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  CDL.Routing.BooleanArrayReplicator uHigOccCooDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  CDL.Routing.BooleanArrayReplicator uUnoHeaHigDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  CDL.Routing.RealArrayReplicator THeaSetOffDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));
  CDL.Routing.BooleanArrayReplicator uEndSetBacDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-290},{10,-270}})));
  CDL.Routing.BooleanArrayReplicator uHigUnoCooDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-320},{10,-300}})));
  CDL.Routing.RealArrayReplicator TCooSetOffDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-380},{10,-360}})));
  CDL.Routing.BooleanArrayReplicator uEndSetUpDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-410},{10,-390}})));
  CDL.Routing.RealArrayReplicator TZonDup(nin=numZon, nout=numGro) "Duplicator"
    annotation (Placement(transformation(extent={{-10,-450},{10,-430}})));
  CDL.Routing.BooleanArrayReplicator uWinDup(nin=numZon, nout=numGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-530},{10,-510}})));
equation
  connect(zonOcc, zonOccDup.u)
    annotation (Line(points={{-60,80},{-12,80}}, color={255,0,255}));
  connect(uOcc,uOccDup. u)
    annotation (Line(points={{-60,40},{-12,40}},  color={255,0,255}));
  connect(tNexOcc, tNexOccDup.u)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));
  connect(uCooTim, uCooTimDup.u)
    annotation (Line(points={{-60,-40},{-12,-40}}, color={0,0,127}));
  connect(uWarTim, uWarTimDup.u)
    annotation (Line(points={{-60,-80},{-12,-80}}, color={0,0,127}));
  connect(uOccHeaHig, uOccHeaHigDup.u)
    annotation (Line(points={{-60,-120},{-12,-120}}, color={255,0,255}));
  connect(uHigOccCoo, uHigOccCooDup.u)
    annotation (Line(points={{-60,-160},{-12,-160}}, color={255,0,255}));
  connect(uUnoHeaHig, uUnoHeaHigDup.u)
    annotation (Line(points={{-60,-200},{-12,-200}}, color={255,0,255}));
  connect(THeaSetOff, THeaSetOffDup.u)
    annotation (Line(points={{-60,-240},{-12,-240}}, color={0,0,127}));
  connect(uEndSetBac, uEndSetBacDup.u)
    annotation (Line(points={{-60,-280},{-12,-280}}, color={255,0,255}));
  connect(uHigUnoCoo, uHigUnoCooDup.u)
    annotation (Line(points={{-60,-310},{-12,-310}}, color={255,0,255}));
  connect(TCooSetOff, TCooSetOffDup.u)
    annotation (Line(points={{-60,-370},{-12,-370}}, color={0,0,127}));
  connect(uEndSetUp, uEndSetUpDup.u)
    annotation (Line(points={{-60,-400},{-12,-400}}, color={255,0,255}));
  connect(TZon, TZonDup.u)
    annotation (Line(points={{-60,-440},{-12,-440}}, color={0,0,127}));
  connect(uWin, uWinDup.u)
    annotation (Line(points={{-60,-520},{-12,-520}}, color={255,0,255}));
  connect(zonOccDup.y, yzonOcc)
    annotation (Line(points={{12,80},{60,80}}, color={255,0,255}));
  connect(uOccDup.y, yOcc)
    annotation (Line(points={{12,40},{60,40}}, color={255,0,255}));
  connect(ytNexOcc, tNexOccDup.y)
    annotation (Line(points={{60,0},{12,0}}, color={0,0,127}));
  connect(yCooTim, uCooTimDup.y)
    annotation (Line(points={{60,-40},{12,-40}}, color={0,0,127}));
  connect(uWarTimDup.y, yWarTim)
    annotation (Line(points={{12,-80},{60,-80}}, color={0,0,127}));
  connect(uOccHeaHigDup.y, yOccHeaHig)
    annotation (Line(points={{12,-120},{60,-120}}, color={255,0,255}));
  connect(uHigOccCooDup.y, yHigOccCoo)
    annotation (Line(points={{12,-160},{60,-160}}, color={255,0,255}));
  connect(uUnoHeaHigDup.y, yUnoHeaHig)
    annotation (Line(points={{12,-200},{60,-200}}, color={255,0,255}));
  connect(THeaSetOffDup.y, yTHeaSetOff)
    annotation (Line(points={{12,-240},{60,-240}}, color={0,0,127}));
  connect(uEndSetBacDup.y, yEndSetBac)
    annotation (Line(points={{12,-280},{60,-280}}, color={255,0,255}));
  connect(uHigUnoCooDup.y, yHigUnoCoo)
    annotation (Line(points={{12,-310},{60,-310}}, color={255,0,255}));
  connect(TCooSetOffDup.y, yTCooSetOff)
    annotation (Line(points={{12,-370},{60,-370}}, color={0,0,127}));
  connect(uEndSetUpDup.y, yEndSetUp)
    annotation (Line(points={{12,-400},{60,-400}}, color={255,0,255}));
  connect(TZonDup.y, yTZon)
    annotation (Line(points={{12,-440},{60,-440}}, color={0,0,127}));
  connect(uWinDup.y, yWin)
    annotation (Line(points={{12,-520},{60,-520}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-180},
            {40,220}}), graphics={
        Rectangle(
          extent={{-40,220},{40,-180}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-36,138},{6,124}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooTim"),
        Text(
          extent={{-36,118},{4,106}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWarTim"),
        Text(
          extent={{-34,80},{16,64}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccHeaHig"),
        Text(
          extent={{-34,60},{16,46}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigOccCoo"),
        Text(
          extent={{-34,-60},{18,-76}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigUnoCoo"),
        Text(
          extent={{-34,-20},{16,-34}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetBac"),
        Text(
          extent={{-34,-102},{14,-116}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetUp"),
        Text(
          extent={{-34,18},{16,4}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUnoHeaHig"),
        Text(
          extent={{-34,-142},{-12,-154}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-36,-82},{14,-98}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOff"),
        Text(
          extent={{-36,-2},{12,-16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOff"),
        Text(
          extent={{-36,178},{6,164}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-36,220},{0,208}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ZonOcc"),
        Text(
          extent={{-36,200},{-10,186}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-38,-162},{-8,-174}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          extent={{-40,260},{40,220}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-40,-540},{40,100}})));
end ZoneStatusDuplicator;
