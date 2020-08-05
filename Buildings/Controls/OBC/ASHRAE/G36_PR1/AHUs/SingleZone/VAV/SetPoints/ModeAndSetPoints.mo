within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints;
block ModeAndSetPoints "Output zone setpoint with operation mode selection"

  parameter Boolean have_winSen "Check if the zone has window status sensor";
  parameter Boolean have_occSen "Check if the zone has occupancy sensor";
  parameter Real THeaSetOcc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=293.15
    "Occupied heating setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Real THeaSetUno(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=285.15
    "Unoccupied heating setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Real TCooSetOcc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=297.15
    "Occupied cooling setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Real TCooSetUno(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=303.15
    "Unoccupied cooling setpoint"
    annotation (Dialog(group="Setpoints"));
  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Boolean sinAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings", enable=not (cooAdj or heaAdj)));
  parameter Boolean ignDemLim=false
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Setpoints adjustment", group="Adjustable settings"));
  parameter Real TZonCooOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonCooOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaOnMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaOnMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonCooSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=322.15 "Cooling setpoint when window is open"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real TZonHeaSetWinOpe(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15  "Heating setpoint when window is open"
    annotation (Dialog(tab="Setpoints adjustment", group="Limits"));
  parameter Real incTSetDem_1=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real incTSetDem_2=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real incTSetDem_3=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real decTSetDem_1=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real decTSetDem_2=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real decTSetDem_3=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoints adjustment", group="Demand control adjustment"));
  parameter Real bouLim=1
    "Threshold of temperature difference for indicating the end of setback or setup mode"
    annotation (Dialog(tab="Advanced"));
  parameter Real uLow=-0.1
    "Low limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real uHigh=0.1
    "High limit of the hysteresis for checking temperature difference"
    annotation (Dialog(tab="Advanced"));
  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time")=10800 "Maximum cool-down or warm-up time"
    annotation (Dialog(tab="Advanced", group="Operation mode"));
  parameter Real TZonFreProOn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=277.15
    "Threshold temperature to activate the freeze protection mode"
    annotation (Dialog(tab="Advanced", group="Operation mode"));
  parameter Real TZonFreProOff(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=280.15
    "Threshold temperature to end the freeze protection mode"
    annotation (Dialog(tab="Advanced", group="Operation mode"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput cooDowTim(
    final unit="s",
    final quantity="Time")
    "Cool-down time retrieved from optimal cool-down block"
    annotation (Placement(transformation(extent={{-200,180},{-160,220}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput warUpTim(
    final unit="s",
    final quantity="Time") "Warm-up time retrieved from optimal warm-up block"
    annotation (Placement(transformation(extent={{-200,150},{-160,190}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status: true=open, false=close"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Zone occupancy status according to the schedule: true=occupied, false=unoccupied"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    final quantity="Time") "Time to next occupied period"
    annotation (Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj if cooAdj or sinAdj
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uCooDemLimLev
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uHeaDemLimLev
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-200,-220},{-160,-180}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod "Operation mode"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{160,-180},{200,-140}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(
    final numZon=1,
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff) "Operation mode"
    annotation (Placement(transformation(extent={{60,4},{80,36}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures TZonSet(
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final cooAdj=cooAdj,
    final heaAdj=heaAdj,
    final sinAdj=sinAdj,
    final ignDemLim=ignDemLim,
    final TZonCooOnMax=TZonCooOnMax,
    final TZonCooOnMin=TZonCooOnMin,
    final TZonHeaOnMax=TZonHeaOnMax,
    final TZonHeaOnMin=TZonHeaOnMin,
    final TZonCooSetWinOpe=TZonCooSetWinOpe,
    final TZonHeaSetWinOpe=TZonHeaSetWinOpe,
    final incTSetDem_1=incTSetDem_1,
    final incTSetDem_2=incTSetDem_2,
    final incTSetDem_3=incTSetDem_3,
    final decTSetDem_1=decTSetDem_1,
    final decTSetDem_2=decTSetDem_2,
    final decTSetDem_3=decTSetDem_3) "Adjust setpoint temperature"
    annotation (Placement(transformation(extent={{100,-134},{120,-106}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus zonSta(
    final THeaSetOcc=THeaSetOcc,
    final THeaSetUno=THeaSetUno,
    final TCooSetOcc=TCooSetOcc,
    final TCooSetUno=TCooSetUno,
    final bouLim=bouLim,
    final have_winSen=have_winSen,
    final uLow=uLow,
    final uHigh=uHigh) "Zone temperature status"
    annotation (Placement(transformation(extent={{-80,80},{-60,108}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger colZon
    "Check if the zone is cold"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger hotZon
    "Check if the zone is hot"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta(
    final k=false) if not have_winSen
    "Assume window is closed when there is no windows status sensor"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSta(
    final k=true) if not have_occSen
    "Assume the zone is occupied when there is no occupancy sensor"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Boolean to integer"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

equation
  connect(zonSta.cooDowTim, cooDowTim) annotation (Line(points={{-82,102},{-110,
          102},{-110,200},{-180,200}}, color={0,0,127}));
  connect(zonSta.warUpTim, warUpTim) annotation (Line(points={{-82,98},{-120,98},
          {-120,170},{-180,170}}, color={0,0,127}));
  connect(zonSta.uWin, uWin) annotation (Line(points={{-82,90},{-130,90},{-130,140},
          {-180,140}}, color={255,0,255}));
  connect(zonSta.TZon, TZon) annotation (Line(points={{-82,86},{-140,86},{-140,110},
          {-180,110}}, color={0,0,127}));
  connect(zonSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-58,
          107},{40,107},{40,30},{58,30}}, color={0,0,127}));
  connect(zonSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-58,105},
          {38,105},{38,26},{58,26}}, color={0,0,127}));
  connect(zonSta.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={{-58,
          95},{34,95},{34,28},{58,28}}, color={255,0,255}));
  connect(zonSta.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={{-58,
          100},{36,100},{36,24},{58,24}}, color={255,0,255}));
  connect(zonSta.yUnoHeaHig, colZon.u) annotation (Line(points={{-58,90},{-48,90},
          {-48,-50},{-42,-50}}, color={255,0,255}));
  connect(colZon.y, opeModSel.totColZon) annotation (Line(points={{-18,-50},{26,
          -50},{26,20},{58,20}}, color={255,127,0}));
  connect(zonSta.yHigUnoCoo, hotZon.u) annotation (Line(points={{-58,83},{-52,83},
          {-52,-80},{-42,-80}}, color={255,0,255}));
  connect(hotZon.y, opeModSel.totHotZon) annotation (Line(points={{-18,-80},{28,
          -80},{28,10},{58,10}}, color={255,127,0}));
  connect(zonSta.yUnoHeaHig, opeModSel.uSetBac) annotation (Line(points={{-58,90},
          {-28,90},{-28,18},{58,18}}, color={255,0,255}));
  connect(zonSta.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-58,
          88},{32,88},{32,16},{58,16}}, color={255,0,255}));
  connect(TZon, opeModSel.TZonMax) annotation (Line(points={{-180,110},{-140,110},
          {-140,14},{58,14}}, color={0,0,127}));
  connect(TZon, opeModSel.TZonMin) annotation (Line(points={{-180,110},{-140,110},
          {-140,12},{58,12}}, color={0,0,127}));
  connect(zonSta.yHigUnoCoo, opeModSel.uSetUp) annotation (Line(points={{-58,83},
          {-32,83},{-32,8},{58,8}}, color={255,0,255}));
  connect(zonSta.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-58,81},
          {30,81},{30,6},{58,6}}, color={255,0,255}));
  connect(opeModSel.uOcc, uOcc) annotation (Line(points={{58,34},{-80,34},{-80,60},
          {-180,60}}, color={255,0,255}));
  connect(opeModSel.tNexOcc, tNexOcc) annotation (Line(points={{58,32},{-80,32},
          {-80,20},{-180,20}}, color={0,0,127}));
  connect(zonSta.TCooSetOn, TZonSet.TZonCooSetOcc) annotation (Line(points={{-58,
          97},{14,97},{14,-111},{98,-111}}, color={0,0,127}));
  connect(zonSta.TCooSetOff, TZonSet.TZonCooSetUno) annotation (Line(points={{-58,
          85},{12,85},{12,-113},{98,-113}}, color={0,0,127}));
  connect(zonSta.THeaSetOn, TZonSet.TZonHeaSetOcc) annotation (Line(points={{-58,
          102},{20,102},{20,-116},{98,-116}}, color={0,0,127}));
  connect(zonSta.THeaSetOff, TZonSet.TZonHeaSetUno) annotation (Line(points={{-58,
          92},{18,92},{18,-118},{98,-118}}, color={0,0,127}));
  connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{82,20},{
          92,20},{92,-107},{98,-107}}, color={255,127,0}));
  connect(TZonSet.uCooDemLimLev, uCooDemLimLev) annotation (Line(points={{98,-126},
          {-4,-126},{-4,-160},{-180,-160}}, color={255,127,0}));
  connect(TZonSet.uHeaDemLimLev, uHeaDemLimLev) annotation (Line(points={{98,-128},
          {0,-128},{0,-200},{-180,-200}}, color={255,127,0}));
  connect(uWin, TZonSet.uWinSta) annotation (Line(points={{-180,140},{-130,140},
          {-130,-133},{98,-133}}, color={255,0,255}));
  connect(winSta.y, TZonSet.uWinSta) annotation (Line(points={{-98,-20},{-60,-20},
          {-60,-133},{98,-133}},color={255,0,255}));
  connect(TZonSet.uOccSen, uOccSen) annotation (Line(points={{98,-131},{-80,-131},
          {-80,-120},{-180,-120}},  color={255,0,255}));
  connect(occSta.y, TZonSet.uOccSen) annotation (Line(points={{-98,-180},{-80,-180},
          {-80,-131},{98,-131}},color={255,0,255}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{82,20},{180,20}}, color={255,127,0}));
  connect(TZonSet.TZonCooSet, TZonCooSet) annotation (Line(points={{122,-112},{140,
          -112},{140,-60},{180,-60}}, color={0,0,127}));
  connect(TZonSet.TZonHeaSet, TZonHeaSet) annotation (Line(points={{122,-120},{140,
          -120},{140,-160},{180,-160}}, color={0,0,127}));
  connect(winSta.y, booToInt.u)
    annotation (Line(points={{-98,-20},{-42,-20}}, color={255,0,255}));
  connect(uWin, booToInt.u) annotation (Line(points={{-180,140},{-130,140},{-130,
          40},{-60,40},{-60,-20},{-42,-20}}, color={255,0,255}));
  connect(booToInt.y, opeModSel.uOpeWin) annotation (Line(points={{-18,-20},{24,
          -20},{24,22},{58,22}}, color={255,127,0}));
  connect(TZonSet.setAdj, setAdj) annotation (Line(points={{98,-121},{-64,-121},
          {-64,-40},{-180,-40}}, color={0,0,127}));
  connect(TZonSet.heaSetAdj, heaSetAdj) annotation (Line(points={{98,-123},{-68,
          -123},{-68,-80},{-180,-80}}, color={0,0,127}));

annotation (defaultComponentName="modSetPoi",
  Diagram(coordinateSystem(extent={{-160,-220},{160,220}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Text(
        extent={{-120,140},{100,100}},
        textString="%name",
        lineColor={0,0,255}),
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,8},{-58,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-100,26},{-76,16}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-100,46},{-74,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=cooAdj or sinAdj,
          extent={{-100,-12},{-66,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="setAdj"),
        Text(
          visible=heaAdj,
          extent={{-98,-32},{-52,-46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-98,-52},{-58,-64}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccSen"),
        Text(
          visible=have_winSen,
          extent={{-100,66},{-74,54}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          extent={{46,8},{96,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{44,-72},{96,-88}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{52,88},{100,76}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod"),
        Text(
          extent={{-98,104},{-50,90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="cooDowTim"),
        Text(
          extent={{-98,88},{-50,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="warUpTim"),
        Text(
          extent={{-98,-70},{-30,-84}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uCooDemLimLev"),
        Text(
          extent={{-100,-90},{-30,-100}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uHeaDemLimLev")}),
Documentation(info="<html>
<p>
Block that outputs the zone setpoint temperature (<code>TZonCooSet</code>,
<code>TZonHeaSet</code>) and system operation mode (<code>yOpeMod</code>).
</p>
<p>The sequence consists of the following two subsequences.</p>
<h4>Operation mode selector</h4>
<p>
The subsequence outputs one of seven types of system operation mode (occupied, warm-up,
cooldown, setback, freeze protection setback, setup, unoccupied) according
to current time, the time to next occupied hours <code>tNexOcc</code> and
current zone temperature <code>TZon</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>.
</p>
<h4>Zone setpoint temperature reset</h4>
<p>
It sets the zone temperature setpoint according to the globally specified setpoints,
the local setpoint adjustments, the demand limits adjustment, the window status
and the occupancy status. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures</a>.
</p>
<h4>Usage</h4>
<p>
This version is for a single zone only to be used in the Single Zone VAV sequence.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2020, by Jianjun Hu:<br/>
Moved from TerminalUnits.ModeAndSetPoints,
reimplemented to use the operating mode specified according to ASHRAE G36 official
release and changed the heating and cooling demand limit level to be inputs.
</li>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModeAndSetPoints;
