within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups;
block ZoneStatusDuplicator "Duplicate zone status output"

  parameter Integer nZon(final min=1)=1
    "Number of zones in input"
    annotation (__cdl(ValueInReference=False));
  parameter Integer nZonGro(final min=1)=1
    "Number of groups in output"
    annotation (__cdl(ValueInReference=False));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput zonOcc[nZon]
    "True when the zone is set to be occupied due to the override"
    annotation (Placement(transformation(extent={{-80,60},{-40,100}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ[nZon]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{-80,20},{-40,60}}),
        iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc[nZon](
    final unit=fill("s", nZon),
    final quantity=fill("Time", nZon))
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCooTim[nZon](
    final unit=fill("s", nZon),
    final quantity=fill("Time", nZon))
    "Cool down time"
    annotation (Placement(transformation(extent={{-80,-60},{-40,-20}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uWarTim[nZon](
    final unit=fill("s", nZon),
    final quantity=fill("Time", nZon))
    "Warm-up time"
    annotation (Placement(transformation(extent={{-80,-100},{-40,-60}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1OccHeaHig[nZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-140},{-40,-100}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HigOccCoo[nZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-180},{-40,-140}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1UnoHeaHig[nZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-220},{-40,-180}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSetOff[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,-260},{-40,-220}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EndSetBac[nZon]
    "True when the zone could end the setback mode"
    annotation (Placement(transformation(extent={{-80,-300},{-40,-260}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HigUnoCoo[nZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-330},{-40,-290}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSetOff[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,-390},{-40,-350}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EndSetUp[nZon]
    "True when the zone could end the setup mode"
    annotation (Placement(transformation(extent={{-80,-420},{-40,-380}}),
        iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{-80,-460},{-40,-420}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win[nZon]
    "Window status, normally closed (true), when windows open, it becomes false. For zone without sensor, it is true"
    annotation (Placement(transformation(extent={{-80,-540},{-40,-500}}),
        iconTransformation(extent={{-140,-210},{-100,-170}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ZonOcc[nZonGro,nZon]
    "True when the zone is set to be occupied due to the override"
    annotation (Placement(transformation(extent={{40,60},{80,100}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Occ[nZonGro,nZon]
    "True when the zone is occupied according to the occupancy schedule"
    annotation (Placement(transformation(extent={{40,20},{80,60}}),
        iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ytNexOcc[nZonGro, nZon](
    final unit=fill("s", nZonGro, nZon),
    final quantity=fill("Time", nZonGro, nZon)) "Time to next occupied period"
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
      iconTransformation(extent={{100,130},{140,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooTim[nZonGro,nZon](
    final unit=fill("s", nZonGro, nZon),
    final quantity=fill("Time", nZonGro, nZon)) "Cool down time"
    annotation (Placement(transformation(extent={{40,-60},{80,-20}}),
      iconTransformation(extent={{100,90},{140,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yWarTim[nZonGro,nZon](
    final unit=fill("s", nZonGro, nZon),
    final quantity=fill("Time", nZonGro, nZon)) "Warm-up time"
    annotation (Placement(transformation(extent={{40,-100},{80,-60}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1OccHeaHig[nZonGro,nZon]
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-140},{80,-100}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HigOccCoo[nZonGro,nZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-180},{80,-140}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1UnoHeaHig[nZonGro,nZon]
    "True when the zone temperature is lower than the unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-220},{80,-180}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTHeaSetOff[nZonGro, nZon](
    final unit=fill("K", nZonGro, nZon),
    displayUnit=fill("degC", nZonGro, nZon),
    final quantity=fill("ThermodynamicTemperature", nZonGro, nZon))
    "Zone unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-260},{80,-220}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EndSetBac[nZonGro,nZon]
    "True when the zone could end the setback mode"
    annotation (Placement(transformation(extent={{40,-300},{80,-260}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HigUnoCoo[nZonGro,nZon]
    "True when the zone temperature is higher than its unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-330},{80,-290}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTCooSetOff[nZonGro, nZon](
    final unit=fill("K", nZonGro, nZon),
    displayUnit=fill("degC", nZonGro, nZon),
    final quantity=fill("ThermodynamicTemperature", nZonGro, nZon))
    "Zone unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{40,-390},{80,-350}}),
      iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1EndSetUp[nZonGro,nZon]
    "True when the zone could end the setup mode"
    annotation (Placement(transformation(extent={{40,-420},{80,-380}}),
        iconTransformation(extent={{100,-150},{140,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTZon[nZonGro, nZon](
    final unit=fill("K", nZonGro, nZon),
    displayUnit=fill("degC", nZonGro, nZon),
    final quantity=fill("ThermodynamicTemperature", nZonGro, nZon)) "Zone temperature"
    annotation (Placement(transformation(extent={{40,-460},{80,-420}}),
      iconTransformation(extent={{100,-190},{140,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Win[nZonGro,nZon]
    "True when the window is open, false when the window is close or the zone does not have window status sensor"
    annotation (Placement(transformation(extent={{40,-540},{80,-500}}),
        iconTransformation(extent={{100,-210},{140,-170}})));

protected
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator zonOccDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uOccDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator tNexOccDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator uCooTimDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator uWarTimDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uOccHeaHigDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uHigOccCooDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uUnoHeaHigDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator THeaSetOffDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uEndSetBacDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-290},{10,-270}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uHigUnoCooDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-320},{10,-300}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator TCooSetOffDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-380},{10,-360}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uEndSetUpDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-410},{10,-390}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator TZonDup(
    final nin=nZon,
    final nout=nZonGro) "Duplicator"
    annotation (Placement(transformation(extent={{-10,-450},{10,-430}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator uWinDup(
    final nin=nZon,
    final nout=nZonGro)
    "Duplicator"
    annotation (Placement(transformation(extent={{-10,-530},{10,-510}})));

equation
  connect(zonOcc, zonOccDup.u)
    annotation (Line(points={{-60,80},{-12,80}}, color={255,0,255}));
  connect(u1Occ, uOccDup.u)
    annotation (Line(points={{-60,40},{-12,40}}, color={255,0,255}));
  connect(tNexOcc, tNexOccDup.u)
    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));
  connect(uCooTim, uCooTimDup.u)
    annotation (Line(points={{-60,-40},{-12,-40}}, color={0,0,127}));
  connect(uWarTim, uWarTimDup.u)
    annotation (Line(points={{-60,-80},{-12,-80}}, color={0,0,127}));
  connect(u1OccHeaHig, uOccHeaHigDup.u)
    annotation (Line(points={{-60,-120},{-12,-120}}, color={255,0,255}));
  connect(u1HigOccCoo, uHigOccCooDup.u)
    annotation (Line(points={{-60,-160},{-12,-160}}, color={255,0,255}));
  connect(u1UnoHeaHig, uUnoHeaHigDup.u)
    annotation (Line(points={{-60,-200},{-12,-200}}, color={255,0,255}));
  connect(THeaSetOff, THeaSetOffDup.u)
    annotation (Line(points={{-60,-240},{-12,-240}}, color={0,0,127}));
  connect(u1EndSetBac, uEndSetBacDup.u)
    annotation (Line(points={{-60,-280},{-12,-280}}, color={255,0,255}));
  connect(u1HigUnoCoo, uHigUnoCooDup.u)
    annotation (Line(points={{-60,-310},{-12,-310}}, color={255,0,255}));
  connect(TCooSetOff, TCooSetOffDup.u)
    annotation (Line(points={{-60,-370},{-12,-370}}, color={0,0,127}));
  connect(u1EndSetUp, uEndSetUpDup.u)
    annotation (Line(points={{-60,-400},{-12,-400}}, color={255,0,255}));
  connect(TZon, TZonDup.u)
    annotation (Line(points={{-60,-440},{-12,-440}}, color={0,0,127}));
  connect(u1Win, uWinDup.u)
    annotation (Line(points={{-60,-520},{-12,-520}}, color={255,0,255}));
  connect(zonOccDup.y, y1ZonOcc)
    annotation (Line(points={{12,80},{60,80}}, color={255,0,255}));
  connect(uOccDup.y, y1Occ)
    annotation (Line(points={{12,40},{60,40}}, color={255,0,255}));
  connect(ytNexOcc, tNexOccDup.y)
    annotation (Line(points={{60,0},{12,0}}, color={0,0,127}));
  connect(yCooTim, uCooTimDup.y)
    annotation (Line(points={{60,-40},{12,-40}}, color={0,0,127}));
  connect(uWarTimDup.y, yWarTim)
    annotation (Line(points={{12,-80},{60,-80}}, color={0,0,127}));
  connect(uOccHeaHigDup.y, y1OccHeaHig)
    annotation (Line(points={{12,-120},{60,-120}}, color={255,0,255}));
  connect(uHigOccCooDup.y, y1HigOccCoo)
    annotation (Line(points={{12,-160},{60,-160}}, color={255,0,255}));
  connect(uUnoHeaHigDup.y, y1UnoHeaHig)
    annotation (Line(points={{12,-200},{60,-200}}, color={255,0,255}));
  connect(THeaSetOffDup.y, yTHeaSetOff)
    annotation (Line(points={{12,-240},{60,-240}}, color={0,0,127}));
  connect(uEndSetBacDup.y, y1EndSetBac)
    annotation (Line(points={{12,-280},{60,-280}}, color={255,0,255}));
  connect(uHigUnoCooDup.y, y1HigUnoCoo)
    annotation (Line(points={{12,-310},{60,-310}}, color={255,0,255}));
  connect(TCooSetOffDup.y, yTCooSetOff)
    annotation (Line(points={{12,-370},{60,-370}}, color={0,0,127}));
  connect(uEndSetUpDup.y, y1EndSetUp)
    annotation (Line(points={{12,-400},{60,-400}}, color={255,0,255}));
  connect(TZonDup.y, yTZon)
    annotation (Line(points={{12,-440},{60,-440}}, color={0,0,127}));
  connect(uWinDup.y, y1Win)
    annotation (Line(points={{12,-520},{60,-520}}, color={255,0,255}));

  annotation (defaultComponentName="zonStaDup",
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},
            {100,200}}), graphics={
        Rectangle(
          extent={{-100,200},{100,-200}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,118},{-54,104}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCooTim"),
        Text(
          extent={{-96,98},{-56,86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uWarTim"),
        Text(
          extent={{-94,60},{-44,44}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1OccHeaHig"),
        Text(
          extent={{-94,40},{-44,26}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HigOccCoo"),
        Text(
          extent={{-94,-80},{-42,-96}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1HigUnoCoo"),
        Text(
          extent={{-94,-40},{-44,-54}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1EndSetBac"),
        Text(
          extent={{-94,-122},{-46,-136}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1EndSetUp"),
        Text(
          extent={{-94,-2},{-44,-16}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1UnoHeaHig"),
        Text(
          extent={{-94,-162},{-72,-174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-96,-102},{-46,-118}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TCooSetOff"),
        Text(
          extent={{-96,-22},{-48,-36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSetOff"),
        Text(
          extent={{-96,158},{-54,144}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-96,200},{-60,188}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="ZonOcc"),
        Text(
          extent={{-96,180},{-70,166}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Occ"),
        Text(
          extent={{-98,-182},{-68,-194}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Win"),
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-40,-540},{40,100}})),
    Documentation(revisions="<html>
<ul>
<li>
June 23, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block duplicates the signals of <code>nZon</code> by converting the
input vector-valued signals of dimension <code>nZon</code> to a matrix-valued
output of dimension <code>[nZonGro, nZon]</code>.
</p>
<p>
This block prevent the use of <code>for</code> loops in the connectors between
zones and zone groups by connecting all the zones to each 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus</a>.
</p>
</html>"));
end ZoneStatusDuplicator;
