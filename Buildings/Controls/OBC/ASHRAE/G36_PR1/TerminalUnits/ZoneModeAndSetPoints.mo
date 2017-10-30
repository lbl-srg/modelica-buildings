within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits;
block ZoneModeAndSetPoints "Output zone setpoint with operation mode selection"

  parameter Integer numZon(min=2)
    "Total number of served zones/VAV boxes";
  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  parameter Modelica.SIunits.Time preWarCooTim=10800
    "Maximum cool-down/warm-up time"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.TemperatureDifference bouLim=1.1
    "Value limit to indicate the end of setback/setup mode"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.Temperature freProThrVal=277.55
    "Threshold zone temperature value to activate freeze protection mode"
    annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
  parameter Modelica.SIunits.Temperature freProEndVal=280.35
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
  parameter Modelica.SIunits.Temperature TCooOnMax=300.15
    "Maximum cooling setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits settings"));
  parameter Modelica.SIunits.Temperature TCooOnMin=295.15
    "Minimum cooling setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits settings"));
  parameter Modelica.SIunits.Temperature THeaOnMax=295.15
    "Maximum heating setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits settings"));
  parameter Modelica.SIunits.Temperature THeaOnMin=291.15
    "Minimum heating setpoint during on"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits settings"));
  parameter Modelica.SIunits.Temperature TCooWinOpe=322.15
    "Cooling setpoint when window is open"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits settings"));
  parameter Modelica.SIunits.Temperature THeaWinOpe=277.15
    "Heating setpoint when window is open"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits settings"));
  parameter Real incSetDem_1=0.56
    "Cooling setpoint increase value (degC) when cooling demand limit level 1 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real incSetDem_2=1.1
    "Cooling setpoint increase value (degC) when cooling demand limit level 2 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real incSetDem_3=2.2
    "Cooling setpoint increase value (degC) when cooling demand limit level 3 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decSetDem_1=0.56
    "Heating setpoint decrease value (degC) when heating demand limit level 1 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decSetDem_2=1.1
    "Heating setpoint decrease value (degC) when heating demand limit level 2 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Real decSetDem_3=2.2
    "Heating setpoint decrease value (degC) when heating demand limit level 3 is imposed"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
  parameter Integer cooDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.DemandLimitLevels.cooling0
    "Cooling demand limit level"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Test settings"));
  parameter Integer heaDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants.DemandLimitLevels.heating0
    "Heating demand limit level"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Test settings"));
  parameter Boolean winStaCon=false
    "Window status, set to true if window is open"
    annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Test settings"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    each final unit="K",
    each quantity="ThermodynamicTemperature")
    "Measured zone temperatures"
    annotation (Placement(transformation(rotation=0, extent={{-140,-20},{-100,20.5}}),
      iconTransformation(extent={{-140,20},{-100,60.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
    final unit="s",
    quantity="Time")
    annotation (Placement(transformation(rotation=0, extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
    annotation (Placement(transformation(rotation=0, extent={{-140,-100},{-100,-59.5}}),
      iconTransformation(extent={{-140,-100},{-100,-59.5}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TCooSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{100,90},{120,110}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput THeaSet(
    final unit="K",
    quantity="ThermodynamicTemperature")
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
    "Operation mode"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yFreProSta
    "Freeze protection stage"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
      iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures TSetZon(
    final have_occSen=have_occSen,
    final have_winSen=have_winSen,
    final cooAdj=cooAdj,
    final heaAdj=heaAdj,
    final sinAdj=sinAdj,
    final ignDemLim=ignDemLim,
    final TCooOnMax=TCooOnMax,
    final TCooOnMin=TCooOnMin,
    final THeaOnMax=THeaOnMax,
    final THeaOnMin=THeaOnMin,
    final TCooWinOpe=TCooWinOpe,
    final THeaWinOpe=THeaWinOpe,
    final incSetDem_1=incSetDem_1,
    final incSetDem_2=incSetDem_2,
    final incSetDem_3=incSetDem_3,
    final decSetDem_1=decSetDem_1,
    final decSetDem_2=decSetDem_2,
    final decSetDem_3=decSetDem_3)
    "Zone set point temperature"
    annotation (Placement(transformation(extent={{20,-40},{60,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
    k=cooDemLimLevCon)
    "Cooling demand limit level"
    annotation (Placement(transformation(extent={{-80,-71},{-60,-51}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
    k=heaDemLimLevCon)
    "Heating demand limit level"
    annotation (Placement(transformation(extent={{-80,-101},{-60,-81}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
    final k=THeaOn)
    "Heating on setpoint"
    annotation (Placement(transformation(extent={{-80,81},{-60,101}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOff(
    final k=THeaOff)
    "Heating off set point"
    annotation (Placement(transformation(extent={{-80,51},{-60,71}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
    final k=TCooOn)
    "Cooling on setpoint"
    annotation (Placement(transformation(extent={{-80,111},{-60,132}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOff(
    final k=TCooOff)
    "Cooling off set point"
    annotation (Placement(transformation(extent={{-80,21},{-60,41}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel(
    final numZon=numZon,
    final preWarCooTim=preWarCooTim,
    final bouLim=bouLim,
    final freProThrVal=freProThrVal,
    final freProEndVal=freProEndVal)
    "Operation mode selector"
    annotation (Placement(transformation(extent={{-34,-40},{-14,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tCooDowHeaUp[numZon](
    each final k=warCooTim)
    "Cool down and heat up time (assumed as constant)"
    annotation (Placement(transformation(extent={{-80,-9},{-60,11}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta[numZon](
    each final k=winStaCon)
    "Window status"
    annotation (Placement(transformation(extent={{-32,-90},{-12,-70}})));

  CDL.Interfaces.RealInput                        setAdj(final unit="K",
      quantity="ThermodynamicTemperature") if
                                            (cooAdj or sinAdj)
    "Setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-14,160}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealInput                        heaSetAdj(final unit="K",
      quantity="ThermodynamicTemperature") if
                                            heaAdj
    "Heating setpoint adjustment value"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={20,160}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(TSetZon.uCooDemLimLev,cooDemLimLev. y)
    annotation (Line(points={{18,-34},{0,-34},{0,-60},{-30,-60},{-30,-61},{-59,-61}},
      color={255,127,0}));
  connect(heaDemLimLev.y,TSetZon. uHeaDemLimLev)
    annotation (Line(points={{-59,-91},{6,-91},{6,-38},{18,-38}},
      color={255,127,0}));
  connect(TSetZon.occCooSet,TSetRooCooOn. y)
    annotation (Line(points={{18,-2},{2,-2},{2,121.5},{-59,121.5}},
      color={0,0,127}));
  connect(TSetZon.occHeaSet,TSetRooHeaOn. y)
    annotation (Line(points={{18,-6},{-2,-6},{-2,91},{-59,91}},
      color={0,0,127}));
  connect(TSetZon.unoCooSet,TSetRooCooOff. y)
    annotation (Line(points={{18,-10},{-10,-10},{-10,31},{-59,31}},
      color={0,0,127}));
  connect(TSetZon.unoHeaSet,TSetRooHeaOff. y)
    annotation (Line(points={{18,-14},{-6,-14},{-6,61},{-59,61}},
      color={0,0,127}));
  connect(opeModSel.yOpeMod, TSetZon.uOpeMod)
    annotation (Line(points={{-13,-30},{18,-30}},color={255,127,0}));
  connect(tCooDowHeaUp.y,opeModSel. cooDowTim)
    annotation (Line(points={{-59,1},{-52,1},{-52,-25.6},{-35,-25.6}},
      color={0,0,127}));
  connect(tCooDowHeaUp.y,opeModSel. warUpTim)
    annotation (Line(points={{-59,1},{-52,1},{-52,-27.8},{-35,-27.8}},
      color={0,0,127}));
  connect(TSetRooCooOn.y,opeModSel. TCooSet)
    annotation (Line(points={{-59,121.5},{-44,121.5},{-44,-34.6},{-35,-34.6}},
      color={0,0,127}));
  connect(opeModSel.THeaSet,TSetRooHeaOn. y)
    annotation (Line(points={{-35,-32.2},{-42,-32.2},{-42,91},{-59,91}},
      color={0,0,127}));
  connect(opeModSel.TUnoHeaSet,TSetRooHeaOff. y)
    annotation (Line(points={{-35,-36.8},{-46,-36.8},{-46,61},{-59,61}},
      color={0,0,127}));
  connect(opeModSel.TUnoCooSet,TSetRooCooOff. y)
    annotation (Line(points={{-35,-39},{-48,-39},{-48,31},{-59,31}},
      color={0,0,127}));
  connect(tNexOcc, opeModSel.tNexOcc)
    annotation (Line(points={{-120,60},{-92,60},{-92,-18},{-52,-18},{-52,-23.4},
          {-35,-23.4}},
      color={0,0,127}));
  connect(uOcc, opeModSel.uOcc)
    annotation (Line(points={{-120,-79.75},{-82,-79.75},{-82,-80},{-40,-80},{
          -40,-21},{-35,-21}},
                  color={255,0,255}));
  connect(TSetZon.TCooSet, TCooSet)
    annotation (Line(points={{62,-20},{70,-20},{70,100},{110,100}},
      color={0,0,127}));
  connect(TSetZon.THeaSet, THeaSet)
    annotation (Line(points={{62,-28},{74,-28},{74,60},{110,60}},
      color={0,0,127}));
  connect(opeModSel.yOpeMod, yOpeMod)
    annotation (Line(points={{-13,-30},{10,-30},{10,-60},{88,-60},{88,0},{110,0}},
      color={255,127,0}));
  connect(opeModSel.yFreProSta, yFreProSta)
    annotation (Line(points={{-13,-35},{-4,-35},{-4,-64},{92,-64},{92,-40},{110,
          -40}},
      color={255,127,0}));
  connect(winSta.y, opeModSel.uWinSta)
    annotation (Line(points={{-11,-80},{-8,-80},{-8,-52},{-24,-52},{-24,-41}},
      color={255,0,255}));
  connect(opeModSel.TZon, TZon)
    annotation (Line(points={{-35,-30},{-94,-30},{-94,0.25},{-120,0.25}},
      color={0,0,127}));

  connect(setAdj, TSetZon.setAdj)
    annotation (Line(points={{-14,160},{-14,-18},{18,-18}}, color={0,0,127}));
  connect(heaSetAdj, TSetZon.heaSetAdj) annotation (Line(points={{20,160},{20,
          20},{6,20},{6,-22},{18,-22}}, color={0,0,127}));
annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,140}})),
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
Block outputs zone setpoint temperature (<code>TCooSet</code>, <code>THeaSet</code>) 
and system operation mode (<code>yOpeMod</code>). When operation mode is in freeze
protection setback mode, it also outputs a level 3 freeze protection alarm 
<code>yFreProSta</code>. The sequences are implemented according to ASHRAE
Guideline 36, Part 5.B.3 and 5.C.6.
</p>
<p>The sequence consists of two subsequences. </p>
<h4>a. Operation mode selector</h4>
<p>
The subsequence outputs 7 types system operation mode (occupied, warmup,
cool-down, setback, freeze protection setback, setup, unoccupied) according 
to current time, the time to next occupied hours <code>tNexOcc</code>, 
current zone temperature <code>TZon</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>.
</p>
<h4>b. Zone setpoint temperature reset</h4>
<p>
This sequence is implemented according to Part 5.B.3. It sets zone setpoint 
according to the global giving setpoint, local setpoint adjustments, demand 
limits adjustment, window status and occupancy stataus. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
Moved it from example package.
</li>
<li>
September 25, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneModeAndSetPoints;
