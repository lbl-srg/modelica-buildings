within Buildings.DHC.ETS.Combined.Controls;
model Supervisory
  "Supervisory controller"
  extends Buildings.DHC.ETS.Combined.Controls.BaseClasses.PartialSupervisory;

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (choices(choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real kHot(
    min=0)=0.05
    "Gain of controller on hot side";
  parameter Real kCol(
    min=0)=0.1
    "Gain of controller on cold side";
  parameter Real TiHot(
    final min=Buildings.Controls.OBC.CDL.Constants.small,
    final quantity="Time",
    final unit="s") = 300
    "Time constant of integrator block on hot side"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                              or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real TiCol(
    final min=Buildings.Controls.OBC.CDL.Constants.small,
    final quantity="Time",
    final unit="s") = 120
    "Time constant of integrator block on cold side"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                             or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real THeaWatSupSetMin(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Minimum value of heating water supply temperature set point";
  parameter Real TChiWatSupSetMin(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Minimum value of chilled water supply temperature set point";
  parameter Real TChiWatSupSetMax(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set point";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoCon_actual(
    final unit="1")
    "Return position of condenser to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValIsoEva_actual(
    final unit="1")
    "Return position of evaporator to ambient loop isolation valve"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.DHC.ETS.Combined.Controls.SideHot conHot(
    final k=kHot,
    final Ti=TiHot,
    final nSouAmb=nSouAmb,
    final controllerType=controllerType)
    "Hot side controller"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.DHC.ETS.Combined.Controls.SideCold conCol(
    final k=kCol,
    final Ti=TiCol,
    final nSouAmb=nSouAmb,
    final controllerType=controllerType,
    final TChiWatSupSetMin=TChiWatSupSetMin)
    "Cold side controller"
    annotation (Placement(transformation(extent={{0,-42},{20,-22}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1[nSouAmb]
    "Maximum of output control signals"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.DHC.ETS.Combined.Controls.Reset resTHeaSup(
    final TWatSupSetMinMax=THeaWatSupSetMin)
    "Heating water supply temperature reset"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.DHC.ETS.Combined.Controls.Reset resTCooSup(
    final TWatSupSetMinMax=TChiWatSupSetMax)
    "Chilled water supply temperature reset"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
equation
  connect(conHot.yAmb,max1.u1)
    annotation (Line(points={{22,34},{40,34},{40,6},{48,6}},color={0,0,127}));
  connect(conCol.yAmb,max1.u2)
    annotation (Line(points={{22,-28},{40,-28},{40,-6},{48,-6}},color={0,0,127}));
  connect(conHot.yCol,conCol.uCol)
    annotation (Line(points={{22,26},{30,26},{30,0},{-14,0},{-14,-32.2},{-2,-32.2}},color={0,0,127}));
  connect(resTHeaSup.TWatSupSet, conHot.TSet) annotation (Line(points={{-48,20},
          {-30,20},{-30,32},{-2,32}}, color={0,0,127}));
  connect(THeaWatTop,conHot.TTop)
    annotation (Line(points={{-140,0},{-26,0},{-26,28},{-2,28}},color={0,0,127}));
  connect(max1.y,yAmb)
    annotation (Line(points={{72,0},{90,0},{90,-20},{140,-20}},color={0,0,127}));
  connect(TChiWatBot,conCol.TBot)
    annotation (Line(points={{-140,-60},{-40,-60},{-40,-40.4},{-2,-40.4}},color={0,0,127}));
  connect(THeaWatSupPreSet, resTHeaSup.TWatSupPreSet) annotation (Line(points={{
          -140,20},{-80,20},{-80,14},{-72,14}}, color={0,0,127}));
  connect(conHot.yValIso,yValIsoCon)
    annotation (Line(points={{22,30},{60,30},{60,20},{140,20}},color={0,0,127}));
  connect(conCol.yValIso,yValIsoEva)
    annotation (Line(points={{22,-32},{100,-32},{100,0},{140,0}},color={0,0,127}));
  connect(resTHeaSup.TWatSupSet, THeaWatSupSet) annotation (Line(points={{-48,20},
          {-30,20},{-30,-60},{140,-60}}, color={0,0,127}));
  connect(conCol.TChiWatSupSet,TChiWatSupSet)
    annotation (Line(points={{22,-36},{100,-36},{100,-80},{140,-80}},color={0,0,127}));
  connect(uHeaHol.y, conHot.uHea) annotation (Line(points={{-88,100},{-20,100},
          {-20,40},{-2,40}}, color={255,0,255}));
  connect(uCooHol.y,conCol.uHeaCoo)
    annotation (Line(points={{-88,60},{-40,60},{-40,-24},{-2,-24}},color={255,0,255}));
  connect(uHeaHol.y, resTHeaSup.u) annotation (Line(points={{-88,100},{-80,100},
          {-80,26},{-72,26}}, color={255,0,255}));
  connect(uHeaHol.y,yHea)
    annotation (Line(points={{-88,100},{140,100}},color={255,0,255}));
  connect(uCooHol.y,yCoo)
    annotation (Line(points={{-88,60},{140,60}},color={255,0,255}));
  connect(yValIsoCon_actual,conHot.yValIsoCon_actual)
    annotation (Line(points={{-140,-80},{-22,-80},{-22,24},{-2,24}},color={0,0,127}));
  connect(yValIsoEva_actual,conHot.yValIsoEva_actual)
    annotation (Line(points={{-140,-100},{-18,-100},{-18,20},{-2,20}},color={0,0,127}));
  connect(conHot.uCoo, uCooHol.y) annotation (Line(points={{-2,36},{-40,36},{
          -40,60},{-88,60}}, color={255,0,255}));
  connect(TChiWatSupPreSet, resTCooSup.TWatSupPreSet) annotation (Line(points={{-140,
          -40},{-80,-40},{-80,-36},{-72,-36}},                color={0,0,127}));
  connect(uCooHol.y, resTCooSup.u) annotation (Line(points={{-88,60},{-40,60},{-40,
          -10},{-80,-10},{-80,-24},{-72,-24}}, color={255,0,255}));
  connect(resTCooSup.TWatSupSet, conCol.TSet) annotation (Line(points={{-48,-30},
          {-40,-30},{-40,-36},{-22,-36},{-22,-36.2},{-2,-36.2}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}})),
    defaultComponentName="conSup",
    Documentation(
      revisions="<html>
<ul>
<li>
March 6, 2025, by Hongxiang Fu:<br/>
<ul>
<li>
Added reset to the chilled water set point.
</li>
<li>
Added <code>uCoo</code> as an additional input
to <code>conHot</code>.
</li>
</ul>
These are for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4133\">#4133</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This block implements the supervisory control functions of the ETS model
<a href=\"modelica://Buildings.DHC.ETS.Combined.ChillerBorefield\">
Buildings.DHC.ETS.Combined.ChillerBorefield</a>.
</p>
<ul>
<li>
Heating (resp. cooling) is enabled based on the input signal <code>uHea</code>
(resp. <code>uCoo</code>) which is held for 15', meaning that,
when enabled, the mode remains active for at least <i>15</i> minutes and,
when disabled, the mode cannot be enabled again for at least <i>15</i> minutes.
The heating and cooling enable signals should be computed externally based on a schedule
(to lock out the system during off-hours), ideally in conjunction with the number
of requests yielded by the terminal unit controllers, or any
other signal representative of the load.
Indeed, the heating water supply set point is allowed to be reset down
only when heating is disabled, in which
case the system performance is improved due to a lower chiller lift.
</li>
<li>
The controller resets the heating water supply temperature based on the logic described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.Reset\">
Buildings.DHC.ETS.Combined.Controls.Reset</a>.
Note that this resetting logic is meant to operate the chiller at low lift.
The chilled water supply temperature may be also reset down by
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.SideCold\">
Buildings.DHC.ETS.Combined.Controls.SideCold</a>
to maintain the heating water supply temperature set point.
This second resetting logic is required for the heating function of the unit,
but it has a negative impact on the lift.
</li>
<li>
Eventually the systems serving as ambient sources are controlled based on the
maximum of the control signals <code>yAmb</code> yielded by
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.SideHot\">
Buildings.DHC.ETS.Combined.Controls.SideHot</a>
and
<a href=\"modelica://Buildings.DHC.ETS.Combined.Controls.SideCold\">
Buildings.DHC.ETS.Combined.Controls.SideCold</a>.
</li>
</ul>
</html>"));
end Supervisory;
