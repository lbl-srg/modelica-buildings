within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
model ZoneGroupFilter "Filter zones status to group status"

  parameter Integer numZon(final min=1)=1 "Number of zones in input";
  parameter Integer numZonGro(final min=1)=numZon "Number of zones in zone group";
  parameter Boolean zonGroFil[numZon]=fill(true, numZon)
    "Boolean array of zones included in group";


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

  CDL.Interfaces.BooleanOutput yzonOcc[numZonGro]
    "True when the zone is set to be occupied due to the override" annotation (
      Placement(transformation(extent={{40,60},{80,100}}), iconTransformation(
          extent={{40,190},{80,230}})));
  CDL.Interfaces.BooleanOutput yOcc[numZonGro]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{40,20},{80,60}}),
        iconTransformation(extent={{40,170},{80,210}})));
  CDL.Interfaces.RealOutput ytNexOcc[numZonGro](final unit=fill("s", numZon),
      final quantity=fill("Time", numZon)) "Time to next occupied period"
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
        iconTransformation(extent={{40,150},{80,190}})));
  CDL.Interfaces.RealOutput yCooTim[numZonGro](final unit=fill("s", numZon),
      final quantity=fill("Time", numZon)) "Cool down time" annotation (
      Placement(transformation(extent={{40,-60},{80,-20}}), iconTransformation(
          extent={{40,110},{80,150}})));
  CDL.Interfaces.RealOutput yWarTim[numZonGro](final unit=fill("s", numZon),
      final quantity=fill("Time", numZon)) "Warm-up time" annotation (Placement(
        transformation(extent={{40,-100},{80,-60}}), iconTransformation(extent={
            {40,90},{80,130}})));
  CDL.Interfaces.BooleanOutput yOccHeaHig[numZonGro]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-140},{80,-100}}),
        iconTransformation(extent={{40,50},{80,90}})));
  CDL.Interfaces.BooleanOutput yHigOccCoo[numZonGro]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-180},{80,-140}}),
        iconTransformation(extent={{40,30},{80,70}})));
  CDL.Interfaces.BooleanOutput yUnoHeaHig[numZonGro]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-220},{80,-180}}),
        iconTransformation(extent={{40,-10},{80,30}})));
  CDL.Interfaces.RealOutput yTHeaSetOff[numZonGro](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied heating setpoint" annotation (Placement(transformation(
          extent={{40,-260},{80,-220}}), iconTransformation(extent={{40,-30},{80,
            10}})));
  CDL.Interfaces.BooleanOutput yEndSetBac[numZonGro]
    "True when the zone could end the setback mode" annotation (Placement(
        transformation(extent={{40,-300},{80,-260}}), iconTransformation(extent=
           {{40,-50},{80,-10}})));
  CDL.Interfaces.BooleanOutput yHigUnoCoo[numZonGro]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-330},{80,-290}}),
        iconTransformation(extent={{40,-90},{80,-50}})));
  CDL.Interfaces.RealOutput yTCooSetOff[numZonGro](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon))
    "Zone unoccupied cooling setpoint" annotation (Placement(transformation(
          extent={{40,-390},{80,-350}}), iconTransformation(extent={{40,-110},{80,
            -70}})));
  CDL.Interfaces.BooleanOutput yEndSetUp[numZonGro]
    "True when the zone could end the setup mode" annotation (Placement(
        transformation(extent={{40,-420},{80,-380}}), iconTransformation(extent=
           {{40,-130},{80,-90}})));
  CDL.Interfaces.RealOutput yTZon[numZonGro](
    final unit=fill("K", numZon),
    displayUnit=fill("degC", numZon),
    final quantity=fill("ThermodynamicTemperature", numZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{40,-460},{80,-420}}),
        iconTransformation(extent={{40,-170},{80,-130}})));
  CDL.Interfaces.BooleanOutput yWin[numZonGro]
    "True when the window is open, false when the window is close or the zone does not have window status sensor"
    annotation (Placement(transformation(extent={{40,-540},{80,-500}}),
        iconTransformation(extent={{40,-190},{80,-150}})));

  CDL.Routing.BooleanArrayFilter zonOccFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  CDL.Routing.BooleanArrayFilter uOccFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  CDL.Routing.RealArrayFilter tNexOccFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Routing.RealArrayFilter uCooTimFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  CDL.Routing.RealArrayFilter uWarTimFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  CDL.Routing.BooleanArrayFilter uOccHeaHigFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  CDL.Routing.BooleanArrayFilter uHigOccCooFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  CDL.Routing.BooleanArrayFilter uUnoHeaHigFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  CDL.Routing.RealArrayFilter THeaSetOffFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));
  CDL.Routing.BooleanArrayFilter uEndSetBacFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-290},{10,-270}})));
  CDL.Routing.BooleanArrayFilter uHigUnoCooFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-320},{10,-300}})));
  CDL.Routing.RealArrayFilter TCooSetOffFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-380},{10,-360}})));
  CDL.Routing.BooleanArrayFilter uEndSetUpFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-410},{10,-390}})));
  CDL.Routing.RealArrayFilter TZonFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-450},{10,-430}})));
  CDL.Routing.BooleanArrayFilter uWinFil(
    nin=numZon,
    nout=numZonGro,
    fil=zonGroFil) "Zone group filter"
    annotation (Placement(transformation(extent={{-10,-530},{10,-510}})));
equation
  connect(zonOcc, zonOccFil.u)
    annotation (Line(points={{-60,80},{-12,80}}, color={255,0,255}));
  connect(uOcc, uOccFil.u)
    annotation (Line(points={{-60,40},{-12,40}}, color={255,0,255}));
  connect(yzonOcc, zonOccFil.y)
    annotation (Line(points={{60,80},{12,80}}, color={255,0,255}));
  connect(yOcc, uOccFil.y)
    annotation (Line(points={{60,40},{12,40}}, color={255,0,255}));
  connect(tNexOcc, tNexOccFil.u)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));
  connect(ytNexOcc, tNexOccFil.y)
    annotation (Line(points={{60,0},{12,0}}, color={0,0,127}));
  connect(uCooTim, uCooTimFil.u)
    annotation (Line(points={{-60,-40},{-12,-40}}, color={0,0,127}));
  connect(yCooTim, uCooTimFil.y)
    annotation (Line(points={{60,-40},{12,-40}}, color={0,0,127}));
  connect(uWarTim, uWarTimFil.u)
    annotation (Line(points={{-60,-80},{-12,-80}}, color={0,0,127}));
  connect(yWarTim, uWarTimFil.y)
    annotation (Line(points={{60,-80},{12,-80}}, color={0,0,127}));
  connect(uOccHeaHig, uOccHeaHigFil.u)
    annotation (Line(points={{-60,-120},{-12,-120}}, color={255,0,255}));
  connect(yOccHeaHig, uOccHeaHigFil.y)
    annotation (Line(points={{60,-120},{12,-120}}, color={255,0,255}));
  connect(uHigOccCoo, uHigOccCooFil.u)
    annotation (Line(points={{-60,-160},{-12,-160}}, color={255,0,255}));
  connect(yHigOccCoo, uHigOccCooFil.y)
    annotation (Line(points={{60,-160},{12,-160}}, color={255,0,255}));
  connect(uUnoHeaHig, uUnoHeaHigFil.u)
    annotation (Line(points={{-60,-200},{-12,-200}}, color={255,0,255}));
  connect(yUnoHeaHig, uUnoHeaHigFil.y)
    annotation (Line(points={{60,-200},{12,-200}}, color={255,0,255}));
  connect(THeaSetOff, THeaSetOffFil.u)
    annotation (Line(points={{-60,-240},{-12,-240}}, color={0,0,127}));
  connect(yTHeaSetOff, THeaSetOffFil.y)
    annotation (Line(points={{60,-240},{12,-240}}, color={0,0,127}));
  connect(uEndSetBac, uEndSetBacFil.u) annotation (Line(points={{-60,-280},{-36,
          -280},{-36,-280},{-12,-280}}, color={255,0,255}));
  connect(yEndSetBac, uEndSetBacFil.y)
    annotation (Line(points={{60,-280},{12,-280}}, color={255,0,255}));
  connect(uHigUnoCoo, uHigUnoCooFil.u)
    annotation (Line(points={{-60,-310},{-12,-310}}, color={255,0,255}));
  connect(yHigUnoCoo, uHigUnoCooFil.y)
    annotation (Line(points={{60,-310},{12,-310}}, color={255,0,255}));
  connect(TCooSetOff, TCooSetOffFil.u)
    annotation (Line(points={{-60,-370},{-12,-370}}, color={0,0,127}));
  connect(yTCooSetOff, TCooSetOffFil.y)
    annotation (Line(points={{60,-370},{12,-370}}, color={0,0,127}));
  connect(uEndSetUp, uEndSetUpFil.u) annotation (Line(points={{-60,-400},{-36,-400},
          {-36,-400},{-12,-400}}, color={255,0,255}));
  connect(yEndSetUp, uEndSetUpFil.y)
    annotation (Line(points={{60,-400},{12,-400}}, color={255,0,255}));
  connect(TZon, TZonFil.u) annotation (Line(points={{-60,-440},{-36,-440},{-36,
          -440},{-12,-440}}, color={0,0,127}));
  connect(yTZon, TZonFil.y)
    annotation (Line(points={{60,-440},{12,-440}}, color={0,0,127}));
  connect(uWin, uWinFil.u) annotation (Line(points={{-60,-520},{-36,-520},{-36,
          -520},{-12,-520}}, color={255,0,255}));
  connect(yWin, uWinFil.y)
    annotation (Line(points={{60,-520},{12,-520}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-40,-180},
            {40,220}}), graphics={
        Rectangle(
          extent={{-40,220},{40,-182}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-36,128},{6,114}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooTim"),
        Text(
          extent={{-36,108},{4,96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWarTim"),
        Text(
          extent={{-34,70},{16,54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccHeaHig"),
        Text(
          extent={{-34,50},{16,36}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigOccCoo"),
        Text(
          extent={{-34,-70},{18,-86}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uHigUnoCoo"),
        Text(
          extent={{-34,-30},{16,-44}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetBac"),
        Text(
          extent={{-34,-112},{14,-126}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uEndSetUp"),
        Text(
          extent={{-34,8},{16,-6}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uUnoHeaHig"),
        Text(
          extent={{-34,-152},{-12,-164}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-36,-92},{14,-108}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOff"),
        Text(
          extent={{-36,-12},{12,-26}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOff"),
        Text(
          extent={{-36,168},{6,154}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-36,210},{0,198}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ZonOcc"),
        Text(
          extent={{-36,190},{-10,176}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-38,-172},{-8,-184}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          extent={{-40,260},{40,220}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-40,-540},{40,100}})));
end ZoneGroupFilter;
