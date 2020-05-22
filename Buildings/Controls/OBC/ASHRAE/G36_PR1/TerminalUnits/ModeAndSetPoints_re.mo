within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block ModeAndSetPoints_re
  "Output zone setpoint with operation mode selection"

  parameter Real numZon=6;

  parameter Real TZonHeaOn=293.15
    "Heating setpoint during on";
  parameter Real TZonHeaOff=285.15
    "Heating setpoint during off";
  parameter Real TZonCooOn=297.15
    "Cooling setpoint during on";
  parameter Real TZonCooOff=303.15
    "Cooling setpoint during off";
  parameter Real preWarCooTim(
    final unit="s",
    final quantity="Time")=10800
    "Maximum cool-down/warm-up time"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real bouLim(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Value limit to indicate the end of setback/setup mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real TZonFreProOn=277.55
    "Threshold zone temperature value to activate freeze protection mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real TZonFreProOff=280.35
    "Threshold zone temperature value to finish the freeze protection mode"
    annotation (Dialog(tab="Operation mode", group="Parameters"));
  parameter Real warCooTim(
    final unit="s",
    final quantity="Time")=1800
    "Defined cool-down/warm-up time"
    annotation (Dialog(tab="Operation mode", group="Test setting"));
  parameter Boolean have_occSen=false
    "Check if the zone has occupancy sensor"
    annotation (Dialog(tab="Setpoint adjust", group="Sensors"));
  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor"
    annotation (Dialog(tab="Setpoint adjust", group="Sensors"));
  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean sinAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean ignDemLim=true
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Real TZonCooOnMax=300.15
    "Maximum cooling setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonCooOnMin=295.15
    "Minimum cooling setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaOnMax=295.15
    "Maximum heating setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaOnMin=291.15
    "Minimum heating setpoint during on"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonCooSetWinOpe=322.15
    "Cooling setpoint when window is open"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real TZonHeaSetWinOpe=277.15
    "Heating setpoint when window is open"
    annotation (Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Real incTSetDem_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.56
    "Cooling setpoint increase value when cooling demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real incTSetDem_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Cooling setpoint increase value when cooling demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real incTSetDem_3(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.2
    "Cooling setpoint increase value when cooling demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decTSetDem_1(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.56
    "Heating setpoint decrease value when heating demand limit level 1 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decTSetDem_2(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1.1
    "Heating setpoint decrease value when heating demand limit level 2 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decTSetDem_3(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.2
    "Heating setpoint decrease value when heating demand limit level 3 is imposed"
    annotation (Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Integer cooDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.cooling0
    "Cooling demand limit level"
    annotation (Dialog(tab="Setpoint adjust"));
  parameter Integer heaDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.heating0
    "Heating demand limit level"
    annotation (Dialog(tab="Setpoint adjust"));
  parameter Boolean winStaCon=false
    "Window status, set to true if window is open"
    annotation (Dialog(tab="Setpoint adjust"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc[numZon](final unit=
        "s", quantity="Time") "Time to next occupied period" annotation (
      Placement(transformation(extent={{-200,120},{-160,160}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc[numZon]
    "Current occupancy period, true if it is in occupant period" annotation (
      Placement(transformation(extent={{-200,-10},{-160,30.5}}),
        iconTransformation(extent={{-140,40},{-100,80.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](final unit="K",
      quantity="ThermodynamicTemperature") "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-180,-80}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    final unit="K",
    quantity="ThermodynamicTemperature") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-180,-120}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status (open=true, close=false)"
    annotation (Placement(transformation(extent={{-200,-220},{-160,-180}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{160,90},{200,130}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{160,40},{200,80}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{160,-30},{200,10}}),
      iconTransformation(extent={{100,-90},{140,-50}})));

  Generic.SetPoints.ZoneStatus_re zonSta[numZon]
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  CDL.Integers.MultiSum mulSumInt(nin=6)
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  CDL.Integers.MultiSum mulSumInt1(nin=6)
    annotation (Placement(transformation(extent={{0,-14},{20,6}})));
  CDL.Interfaces.RealInput tCoo[numZon](final unit="s", quantity="Time")
    "Zone cooling time during cool-down mode" annotation (Placement(
        transformation(extent={{-200,190},{-160,230}}), iconTransformation(
          extent={{-140,70},{-100,110}})));
  CDL.Interfaces.RealInput tHea[numZon](final unit="s", quantity="Time")
    "Zone heating time during warm up mode" annotation (Placement(
        transformation(extent={{-200,160},{-160,200}}), iconTransformation(
          extent={{-140,70},{-100,110}})));
  CDL.Continuous.MultiMax mulMax(nin=6)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Continuous.MultiMin mulMin(nin=6)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.MultiMax mulMax1(nin=6)
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  CDL.Continuous.MultiMin mulMin1(nin=6)
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  CDL.Logical.MultiOr mulOr(nu=6)
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  CDL.Logical.MultiOr mulOr1(nu=6)
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  CDL.Logical.MultiOr mulOr2(nu=6)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  CDL.Logical.MultiOr mulOr3(nu=6)
    annotation (Placement(transformation(extent={{0,14},{20,34}})));
protected
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
    TZonSet(
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
    final decTSetDem_3=decTSetDem_3) "Zone set point temperature"
    annotation (Placement(transformation(extent={{80,-100},{120,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    final k=cooDemLimLevCon)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    final k=heaDemLimLevCon) "Heating demand limit level"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn[numZon](
      final k=fill(THeaOn, numZon)) "Heating on setpoint"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOff[numZon](
      final k=fill(THeaOff, numZon)) "Heating off set point"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn[numZon](
      final k=fill(TCooOn, numZon)) "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOff[numZon](
      final k=fill(TCooOff, numZon)) "Cooling off set point"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(
    final have_winSen=have_winSen,
    final numZon=1,
    final preWarCooTim=preWarCooTim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff) "Operation mode selector"
    annotation (Placement(transformation(extent={{44,-40},{64,-20}})));

equation
  connect(TZonSet.uCooDemLimLev,cooDemLimLev. y)
    annotation (Line(points={{78,-94},{36,-94},{36,-140},{22,-140}},
      color={255,127,0}));
  connect(heaDemLimLev.y,TZonSet. uHeaDemLimLev)
    annotation (Line(points={{22,-200},{40,-200},{40,-98},{78,-98}},
      color={255,127,0}));
  connect(TZonSet.TZonCooSet, TZonCooSet)
    annotation (Line(points={{122,-72},{132,-72},{132,110},{180,110}},
      color={0,0,127}));
  connect(TZonSet.TZonHeaSet, TZonHeaSet)
    annotation (Line(points={{122,-80},{140,-80},{140,60},{180,60}},
      color={0,0,127}));
  connect(setAdj, TZonSet.setAdj)
    annotation (Line(points={{-180,-80},{-100,-80},{-100,-83},{78,-83}},
      color={0,0,127}));
  connect(heaSetAdj, TZonSet.heaSetAdj)
    annotation (Line(points={{-180,-120},{-100,-120},{-100,-87},{78,-87}},
      color={0,0,127}));
  connect(TZonSet.uOccSen, uOccSen)
    annotation (Line(points={{94,-102},{94,-160},{-180,-160}},
      color={255,0,255}));
  connect(TZonSet.uWinSta, uWinSta)
    annotation (Line(points={{106,-102},{106,-170},{-72,-170},{-72,-200},{-180,-200}},
      color={255,0,255}));
  connect(uOcc, opeModSel.uOcc) annotation (Line(points={{-180,10.25},{-136,
          10.25},{-136,-18},{42,-18}},
                            color={255,0,255}));
  connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{66,-30},
          {70,-30},{70,-62},{78,-62}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{66,-30},{124,-30},{124,-10},{180,-10}},
                                                  color={255,127,0}));

  connect(uWinSta, opeModSel.uWinSta) annotation (Line(points={{-180,-200},{-72,
          -200},{-72,-30},{42,-30}}, color={255,0,255}));
  connect(tCoo, zonSta.cooDowTim) annotation (Line(points={{-180,210},{-62,210},
          {-62,179},{-42,179}}, color={0,0,127}));
  connect(tHea, zonSta.warUpTim) annotation (Line(points={{-180,180},{-68,180},
          {-68,177},{-42,177}}, color={0,0,127}));
  connect(zonSta.yColZon, mulSumInt.u[1:6]) annotation (Line(points={{-18,167},
          {-12,167},{-12,74.1667},{-2,74.1667}}, color={255,127,0}));
  connect(zonSta.yHotZon, mulSumInt1.u[1:6]) annotation (Line(points={{-18,161},
          {-12,161},{-12,-9.83333},{-2,-9.83333}}, color={255,127,0}));
  connect(TZon, mulMax.u[1:6]) annotation (Line(points={{-180,-50},{-130,-50},{
          -130,-2},{-96,-2},{-96,-1.66667},{-62,-1.66667}}, color={0,0,127}));
  connect(TZon, mulMin.u[1:6]) annotation (Line(points={{-180,-50},{-130,-50},{
          -130,-51.6667},{-62,-51.6667}}, color={0,0,127}));
  connect(mulMax.y, opeModSel.TZonMax) annotation (Line(points={{-38,0},{-28,0},
          {-28,-36},{42,-36}}, color={0,0,127}));
  connect(mulMin.y, opeModSel.TZonMin) annotation (Line(points={{-38,-50},{0,
          -50},{0,-38},{42,-38}}, color={0,0,127}));
  connect(zonSta.yCooTim, mulMax1.u[1:6]) annotation (Line(points={{-18,179},{
          -10,179},{-10,198.333},{-2,198.333}}, color={0,0,127}));
  connect(zonSta.yWarTim, mulMin1.u[1:6]) annotation (Line(points={{-18,177},{
          -14,177},{-14,168.333},{-2,168.333}}, color={0,0,127}));
  connect(mulMax1.y, opeModSel.maxCooDowTim) annotation (Line(points={{22,200},
          {32,200},{32,-22},{42,-22}}, color={0,0,127}));
  connect(mulMin1.y, opeModSel.maxWarUpTim) annotation (Line(points={{22,170},{
          30,170},{30,-24},{42,-24}}, color={0,0,127}));
  connect(mulSumInt.y, opeModSel.totColZon) annotation (Line(points={{22,80},{
          28,80},{28,-32},{42,-32}}, color={255,127,0}));
  connect(mulSumInt1.y, opeModSel.totHotZon)
    annotation (Line(points={{22,-4},{22,-40},{42,-40}}, color={255,127,0}));
  connect(TZon, zonSta.TZon) annotation (Line(points={{-180,-50},{-152,-50},{
          -152,167},{-42,167}}, color={0,0,127}));
  connect(zonSta.yOccHeaHig, mulOr.u[1:6]) annotation (Line(points={{-18,173},{
          -12,173},{-12,172},{-6,172},{-6,134.167},{-2,134.167}}, color={255,0,
          255}));
  connect(zonSta.yHigOccCoo, mulOr1.u[1:6]) annotation (Line(points={{-18,171},
          {-10,171},{-10,104.167},{-2,104.167}}, color={255,0,255}));
  connect(zonSta.yUnoHeaHig, mulOr2.u[1:6]) annotation (Line(points={{-18,165},
          {-14,165},{-14,44.1667},{-2,44.1667}}, color={255,0,255}));
  connect(zonSta.yHigUnoCoo, mulOr3.u[1:6]) annotation (Line(points={{-18,163},
          {-16,163},{-16,18.1667},{-2,18.1667}}, color={255,0,255}));
  connect(mulOr.y, opeModSel.occHeaHigMin) annotation (Line(points={{22,140},{
          38,140},{38,-26},{42,-26}}, color={255,0,255}));
  connect(mulOr1.y, opeModSel.maxHigOccCoo) annotation (Line(points={{22,110},{
          34,110},{34,-28},{42,-28}}, color={255,0,255}));
  connect(mulOr2.y, opeModSel.unoHeaHigMin) annotation (Line(points={{22,50},{
          36,50},{36,-34},{42,-34}}, color={255,0,255}));
  connect(mulOr3.y, opeModSel.maxHigUnoCoo) annotation (Line(points={{22,24},{
          26,24},{26,-42},{42,-42}}, color={255,0,255}));
  connect(TSetRooHeaOn.y, zonSta.TZonHeaSetOcc) annotation (Line(points={{-98,
          150},{-60,150},{-60,173},{-42,173}}, color={0,0,127}));
  connect(TSetRooCooOn.y, zonSta.TZonCooSetOcc) annotation (Line(points={{-98,
          110},{-56,110},{-56,171},{-42,171}}, color={0,0,127}));
  connect(TSetRooHeaOff.y, zonSta.TZonHeaSetUno) annotation (Line(points={{-98,
          70},{-50,70},{-50,163},{-42,163}}, color={0,0,127}));
  connect(TSetRooCooOff.y, zonSta.TZonCooSetUno) annotation (Line(points={{-98,
          30},{-46,30},{-46,161},{-42,161}}, color={0,0,127}));
annotation (defaultComponentName="modSetPoi",
  Diagram(coordinateSystem(extent={{-160,-220},{160,220}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={Text(
        extent={{-100,140},{98,102}},
        textString="%name",
        lineColor={0,0,255}),
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,98},{-48,82}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="tNexOcc"),
        Text(
          extent={{-100,70},{-68,56}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-100,40},{-62,24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=cooAdj or sinAdj,
          extent={{-100,12},{-56,-8}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="setAdj"),
        Text(
          visible=heaAdj,
          extent={{-98,-20},{-34,-40}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="heaSetAdj"),
        Text(
          visible=have_occSen,
          extent={{-98,-50},{-50,-68}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOccSen"),
        Text(
          visible=have_winSen,
          extent={{-98,-80},{-56,-98}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWinSta"),
        Text(
          extent={{34,80},{98,64}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonCooSet"),
        Text(
          extent={{34,10},{98,-6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZonHeaSet"),
        Text(
          extent={{36,-60},{100,-76}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="yOpeMod")}),
Documentation(info="<html>
<p>
Block that outputs the zone setpoint temperature (<code>TZonCooSet</code>, <code>TZonHeaSet</code>)
and system operation mode (<code>yOpeMod</code>). When operation mode is in freeze
protection setback mode, it also outputs a level 3 freeze protection alarm
<code>yFreProSta</code>. The sequences are implemented according to ASHRAE
Guideline 36, Part 5.B.3 and 5.C.6.
</p>
<p>The sequence consists of the following two subsequences.</p>
<h4>Operation mode selector</h4>
<p>
The subsequence outputs one of seven types of system operation mode (occupied, warmup,
cool-down, setback, freeze protection setback, setup, unoccupied) according
to current time, the time to next occupied hours <code>tNexOcc</code> and
current zone temperature <code>TZon</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>.
</p>
<h4>Zone setpoint temperature reset</h4>
<p>
This sequence is implemented according to Part 5.B.3. It sets the zone temperature setpoint
according to the globally specified setpoints, the local setpoint adjustments, the demand
limits adjustment, the window status and the occupancy status.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures</a>.
</p>
<h4>Usage</h4>
<p>
This version is for a single zone only to be used in the Single Zone VAV sequence.
For multizone systems, use
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2020, by Jianjun Hu:<br/>
Reimplemented to avoid vector-valued calculations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1709\">issue 1709</a>.
</li>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModeAndSetPoints_re;
