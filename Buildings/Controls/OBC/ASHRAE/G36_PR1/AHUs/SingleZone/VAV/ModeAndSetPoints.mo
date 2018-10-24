within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
block ModeAndSetPoints
  "Output zone setpoint with operation mode selection"

  parameter Modelica.SIunits.Temperature TZonHeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature TZonHeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TZonCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TZonCooOff=303.15
    "Cooling setpoint during off";
  parameter Modelica.SIunits.Time preWarCooTim=10800
    "Maximum cool-down/warm-up time"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference bouLim=1.1
    "Value limit to indicate the end of setback/setup mode"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.Temperature TZonFreProOn=277.55
    "Threshold zone temperature value to activate freeze protection mode"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.Temperature TZonFreProOff=280.35
    "Threshold zone temperature value to finish the freeze protection mode"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.Time warCooTim=1800
    "Defined cool-down/warm-up time"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Test setting"));
  parameter Boolean have_occSen=false
    "Check if the zone has occupancy sensor"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Sensors"));
  parameter Boolean have_winSen=false
    "Check if the zone has window status sensor"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Sensors"));
  parameter Boolean cooAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable separately"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean heaAdj=false
    "Flag, set to true if heating setpoint is adjustable"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean sinAdj=false
    "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Boolean ignDemLim=true
    "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
  parameter Modelica.SIunits.Temperature TZonCooOnMax=300.15
    "Maximum cooling setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Modelica.SIunits.Temperature TZonCooOnMin=295.15
    "Minimum cooling setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Modelica.SIunits.Temperature TZonHeaOnMax=295.15
    "Maximum heating setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Modelica.SIunits.Temperature TZonHeaOnMin=291.15
    "Minimum heating setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Modelica.SIunits.Temperature TZonCooSetWinOpe=322.15
    "Cooling setpoint when window is open"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Modelica.SIunits.Temperature TZonHeaSetWinOpe=277.15
    "Heating setpoint when window is open"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
  parameter Modelica.SIunits.TemperatureDifference incTSetDem_1=0.56
    "Cooling setpoint increase value when cooling demand limit level 1 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Modelica.SIunits.TemperatureDifference incTSetDem_2=1.1
    "Cooling setpoint increase value when cooling demand limit level 2 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Modelica.SIunits.TemperatureDifference incTSetDem_3=2.2
    "Cooling setpoint increase value when cooling demand limit level 3 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Modelica.SIunits.TemperatureDifference decTSetDem_1=0.56
    "Heating setpoint decrease value when heating demand limit level 1 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Modelica.SIunits.TemperatureDifference decTSetDem_2=1.1
    "Heating setpoint decrease value when heating demand limit level 2 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Modelica.SIunits.TemperatureDifference decTSetDem_3=2.2
    "Heating setpoint decrease value when heating demand limit level 3 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Integer cooDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.cooling0
    "Cooling demand limit level"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust"));
  parameter Integer heaDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.heating0
    "Heating demand limit level"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust"));
  parameter Boolean winStaCon=false
    "Window status, set to true if window is open"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    each final unit="K",
    each quantity="ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(extent={{-180,60},{-140,100.5}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    quantity="Time")
    "Time to next occupied period"
    annotation (Placement(transformation(extent={{-180,120},{-140,160}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
    each final unit="K",
    each quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-160,-40}),
                        iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
    each final unit="K",
    each quantity="ThermodynamicTemperature") if heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-160,-70}), iconTransformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    "Current occupancy period, true if it is in occupant period"
    annotation (Placement(transformation(extent={{-180,0},{-140,40.5}}),
      iconTransformation(extent={{-120,-50},{-100,-29.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
    "Occupancy sensor (occupied=true, unoccupied=false)"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
    "Window status (open=true, close=false)"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
    each final unit="K",
    each quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{140,90},{160,110}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
    each final unit="K",
    each quantity="ThermodynamicTemperature") "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{140,50},{160,70}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
      iconTransformation(extent={{100,-40},{120,-20}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures TZonSet(
    each final have_occSen=have_occSen,
    each final have_winSen=have_winSen,
    each final cooAdj=cooAdj,
    each final heaAdj=heaAdj,
    each final sinAdj=sinAdj,
    each final ignDemLim=ignDemLim,
    each final TZonCooOnMax=TZonCooOnMax,
    each final TZonCooOnMin=TZonCooOnMin,
    each final TZonHeaOnMax=TZonHeaOnMax,
    each final TZonHeaOnMin=TZonHeaOnMin,
    each final TZonCooSetWinOpe=TZonCooSetWinOpe,
    each final TZonHeaSetWinOpe=TZonHeaSetWinOpe,
    each final incTSetDem_1=incTSetDem_1,
    each final incTSetDem_2=incTSetDem_2,
    each final incTSetDem_3=incTSetDem_3,
    each final decTSetDem_1=decTSetDem_1,
    each final decTSetDem_2=decTSetDem_2,
    each final decTSetDem_3=decTSetDem_3)
    "Zone set point temperature"
    annotation (Placement(transformation(extent={{60,-62},{100,-22}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    each k=cooDemLimLevCon)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    each k=heaDemLimLevCon) "Heating demand limit level"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=TZonHeaOn)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOff(
    final k=TZonHeaOff)
    "Heating off set point"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=TZonCooOn)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOff(
    final k=TZonCooOff)
    "Cooling off set point"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel(
    final numZon=1,
    final preWarCooTim=preWarCooTim,
    final bouLim=bouLim,
    final TZonFreProOn=TZonFreProOn,
    final TZonFreProOff=TZonFreProOff)
    "Operation mode selector"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tCooDowHeaUp(
    each final k=warCooTim)
    "Cool down and heat up time (assumed as constant)"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cloWin(
    each k=false) if not have_winSen
    "Closed window status"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));

equation
  connect(TZonSet.uCooDemLimLev,cooDemLimLev. y)
    annotation (Line(points={{58,-56},{36,-56},{36,-90},{-39,-90}},
      color={255,127,0}));
  connect(heaDemLimLev.y,TZonSet. uHeaDemLimLev)
    annotation (Line(points={{-39,-150},{40,-150},{40,-60},{58,-60}},
      color={255,127,0}));
  connect(TSetRooCooOn.y,opeModSel.TZonCooSetOcc)
    annotation (Line(points={{-79,160},{-52,160},{-52,-4.6},{-31,-4.6}},
      color={0,0,127}));
  connect(opeModSel.TZonHeaSetOcc,TSetRooHeaOn. y)
    annotation (Line(points={{-31,-2.2},{-50,-2.2},{-50,120},{-79,120}},
      color={0,0,127}));
  connect(opeModSel.TZonHeaSetUno,TSetRooHeaOff. y)
    annotation (Line(points={{-31,-6.8},{-54,-6.8},{-54,80},{-79,80}},
      color={0,0,127}));
  connect(opeModSel.TZonCooSetUno,TSetRooCooOff. y)
    annotation (Line(points={{-31,-9},{-56,-9},{-56,40},{-79,40}},
      color={0,0,127}));
  connect(TZonSet.TZonCooSet, TZonCooSet)
    annotation (Line(points={{102,-42},{112,-42},{112,100},{150,100}},
      color={0,0,127}));
  connect(TZonSet.TZonHeaSet, TZonHeaSet)
    annotation (Line(points={{102,-50},{120,-50},{120,60},{150,60}},
      color={0,0,127}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{-9,0},{0,0},{0,-72},{128,-72},{128,0},{150,0}},
      color={255,127,0}));
  connect(setAdj, TZonSet.setAdj)
    annotation (Line(points={{-160,-40},{58,-40}},
      color={0,0,127}));
  connect(heaSetAdj, TZonSet.heaSetAdj)
    annotation (Line(points={{-160,-70},{-52,-70},{-52,-44},{58,-44}},
      color={0,0,127}));
  connect(TZonSet.uOccSen, uOccSen)
    annotation (Line(points={{74,-64},{74,-110},{-160,-110}},
      color={255,0,255}));
  connect(TZonSet.uWinSta, uWinSta)
    annotation (Line(points={{86,-64},{86,-120},{-92,-120},{-92,-150},{-160,-150}},
      color={255,0,255}));
  connect(uOcc, opeModSel.uOcc)
    annotation (Line(points={{-160,20.25},{-120,20.25},{-120,9},{-31,9}},
      color={255,0,255}));
  connect(tNexOcc, opeModSel.tNexOcc)
    annotation (Line(points={{-160,140},{-124,140},{-124,6.6},{-31,6.6}},
      color={0,0,127}));

  connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{-9,0},{
          22,0},{22,-52},{58,-52}}, color={255,127,0}));
  connect(TSetRooCooOn.y, TZonSet.TZonCooSetOcc) annotation (Line(points={{-79,
          160},{52,160},{52,-24},{58,-24}}, color={0,0,127}));
  connect(TSetRooHeaOn.y, TZonSet.TZonHeaSetOcc) annotation (Line(points={{-79,
          120},{48,120},{48,-28},{58,-28}}, color={0,0,127}));
  connect(TSetRooHeaOff.y, TZonSet.TZonHeaSetUno) annotation (Line(points={{-79,
          80},{44,80},{44,-36},{58,-36}}, color={0,0,127}));
  connect(TSetRooCooOff.y, TZonSet.TZonCooSetUno) annotation (Line(points={{-79,
          40},{40,40},{40,-32},{58,-32}}, color={0,0,127}));
  connect(uWinSta, opeModSel.uWinSta[1]) annotation (Line(points={{-160,-150},{
          -92,-150},{-92,-120},{-20,-120},{-20,-11}}, color={255,0,255}));
  connect(cloWin.y, opeModSel.uWinSta[1]) annotation (Line(points={{-99,-90},{
          -80,-90},{-80,-50},{-20,-50},{-20,-11}}, color={255,0,255}));
  connect(opeModSel.TZon[1], TZon) annotation (Line(points={{-31,0},{-128,0},{
          -128,80.25},{-160,80.25}}, color={0,0,127}));
  connect(tCooDowHeaUp.y, opeModSel.cooDowTim[1]) annotation (Line(points={{-79,
          -20},{-60,-20},{-60,4.4},{-31,4.4}}, color={0,0,127}));
  connect(opeModSel.warUpTim[1], tCooDowHeaUp.y) annotation (Line(points={{-31,
          2.2},{-60,2.2},{-60,-20},{-79,-20}}, color={0,0,127}));
annotation (defaultComponentName="modSetPoi",
  Diagram(coordinateSystem(extent={{-140,-180},{140,180}})),
  Icon(graphics={Text(
        extent={{-100,140},{98,102}},
        textString="%name",
        lineColor={0,0,255}),
      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Block that outputs zone setpoint temperature (<code>TZonCooSet</code>, <code>TZonHeaSet</code>)
and system operation mode (<code>yOpeMod</code>). When operation mode is in freeze
protection setback mode, it also outputs a level 3 freeze protection alarm
<code>yFreProSta</code>. The sequences are implemented according to ASHRAE
Guideline 36, Part 5.B.3 and 5.C.6.
</p>
<p>The sequence consists of two subsequences.</p>
<h4>Operation mode selector</h4>
<p>
The subsequence outputs 7 types system operation mode (occupied, warmup,
cool-down, setback, freeze protection setback, setup, unoccupied) according
to current time, the time to next occupied hours <code>tNexOcc</code>,
current zone temperature <code>TZon</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>.
</p>
<h4>Zone setpoint temperature reset</h4>
<p>
This sequence is implemented according to Part 5.B.3. It sets zone setpoint
according to the global giving setpoint, local setpoint adjustments, demand
limits adjustment, window status and occupancy stataus. See
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
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end ModeAndSetPoints;
