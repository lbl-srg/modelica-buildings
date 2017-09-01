within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block HeatingCoolingControlLoops "Generates heating and cooling control signals to maintain zone set temperature"

  parameter Real kPCoo=1 "Gain of damper limit controller"
    annotation(Evaluate=true, Dialog(tab="Controller", group="Cooling Loop"));
  parameter Modelica.SIunits.Time TiCoo=30 "Time constant of damper limit controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Controller", group="Cooling Loop"));
  parameter Real kPHea=1 "Gain of damper limit controller"
    annotation(Evaluate=true, Dialog(tab="Controller", group="Heating Loop"));
  parameter Modelica.SIunits.Time TiHea=30 "Time constant of damper limit controller integrator block"
    annotation(Evaluate=true, Dialog(tab="Controller", group="Heating Loop"));
  parameter Modelica.SIunits.Time disDel=30 "Loop disable delay after controller output became zero"
    annotation(Dialog(group="Disable"));
  parameter Boolean intWin=false "Provisions to minimize integral windup implemented"
    annotation(Dialog(group="Disable"));

  Modelica.Blocks.Interfaces.RealInput TRooHeaSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Zone heating setpoint temperature"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0, origin={-160,140}),iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Zone cooling setpoint temperature"
    annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0,origin={-160,90}), iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,20})));
  Modelica.Blocks.Interfaces.RealInput TRoo(
    final unit="K",
    final quantity = "ThermodynamicTemperature") "Zone temperature measurement"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-160,30}),
      iconTransformation(extent={{-10,-10},{10,10}}, origin={-110,-40})));

  CDL.Interfaces.RealOutput yHea(
    final min=conSigMin,
    final max=conSigMin,
    final unit="1") "Heating control signal"
    annotation (Placement(transformation(extent={{140,110},{160,130}}),
      iconTransformation(extent={{100,30},{120,50}})));
  CDL.Interfaces.RealOutput yCoo(
    final min=conSigMin,
    final max=conSigMin,
    final unit="1") "Cooling control signal"
    annotation (Placement(transformation(extent={{140,50},{160,70}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  CDL.Logical.Switch heaLooDisSwi "Enable-disable switch for the heating loop signal"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  CDL.Logical.Switch cooLooDisSwi "Enable-disable switch for the cooling loop signal"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  CDL.Logical.Not notIntWin
    "Logical not that prevents disable in case integral windup minimization in implemented"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  CDL.Logical.GreaterEqualThreshold heaConIdle(threshold=disDel)
    "Determine whether the provided time delay for heating loop disable has expired"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  CDL.Logical.GreaterEqualThreshold cooConIdle(threshold=disDel)
    "Determine whether the provided time delay for cooling loop disable has expired"
    annotation (Placement(transformation(extent={{30,-140},{50,-120}})));

protected
  final parameter Real conSigMin=0 "Lower limit of control signal output";
  final parameter Real conSigMax=1 "Upper limit of control signal output";

  CDL.Continuous.LimPID conCooVal(
    final yMax=conSigMax,
    final yMin=conSigMin,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=kPCoo,
    final Ti=TiCoo) "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Continuous.LimPID conHeaVal(
    final yMax=conSigMax,
    final yMin=conSigMin,
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=kPHea,
    final Ti=TiHea) "Heating coil valve controller"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Logical.Timer timNoCoo "Measure time since cooling signal became zero."
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  CDL.Logical.Timer timNoHea "Measure time since heating signal became zero."
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  CDL.Continuous.Line conCooInv(
    final limitBelow=true,
    final limitAbove=true) "Inverter of the cooling control signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  CDL.Continuous.Sources.Constant conSigMinSig(final k=conSigMin)
    "Minimum controller output signal"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  CDL.Continuous.Sources.Constant conSigMaxSig(final k=conSigMax)
   "Maximum controller output signal"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  CDL.Logical.Sources.Constant intWinSig(final k=intWin)
    "Provisions to minimize integral windup implemented"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  CDL.Continuous.Sources.Constant looDisValSig(final k=conSigMin)
    "Output value at loop disable"
    annotation (Placement(transformation(extent={{100,-38},{120,-18}})));
  CDL.Logical.And3 andDisHea "Logical and that disables heating loop"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  CDL.Logical.And3 andDisCoo "Logical and that disables cooling loop"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  CDL.Logical.Greater disHea "Determine whether the room temperature is above the heating setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  CDL.Logical.Less disCoo "Determine whether the room temperature is below the cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Logical.GreaterThreshold greThrHea(threshold=conSigMin + CDL.Constants.eps)
    "Determine whether heating signal is active"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  CDL.Logical.GreaterThreshold greThrCoo(threshold=conSigMin + CDL.Constants.eps)
    "Determine whether cooling signal is active"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  CDL.Logical.Not notHea "Logical not block"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  CDL.Logical.Not notCoo "Logical not block"
    annotation (Placement(transformation(extent={{-30,-140},{-10,-120}})));

equation
  connect(TRooHeaSet, conHeaVal.u_s)
    annotation (Line(points={{-160,140},{-160,140},{-102,140}},color={0,0,127}));
  connect(TRoo, conHeaVal.u_m)
    annotation (Line(points={{-160,30},{-112,30},{-112,120},{-90,120},{-90,128}},
    color={0,0,127}));
  connect(TRoo, conCooVal.u_m)
    annotation (Line(points={{-160,30},{-90,30},{-90,58}},   color={0,0,127}));
  connect(conCooVal.u_s,TRooCooSet)
    annotation (Line(points={{-102,70},{-102,70},{-110,70},{-110,90},{-160,90}},
    color={0,0,127}));
  connect(conCooVal.y, conCooInv.u)
    annotation (Line(points={{-79,70},{-79,70},{18,70}},color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.x1)
    annotation (Line(points={{1,90},{10,90},{10,78},{18,78}},color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.f1)
    annotation (Line(points={{1,50},{10,50},{10,74},{18,74}},color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.x2)
    annotation (Line(points={{1,50},{10,50},{10,66},{18,66}},color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.f2)
    annotation (Line(points={{1,90},{10,90},{10,62},{18,62}},  color={0,0,127}));
  connect(timNoHea.y, heaConIdle.u)
    annotation (Line(points={{21,-30},{21,-30},{28,-30}}, color={0,0,127}));
  connect(timNoCoo.y, cooConIdle.u)
    annotation (Line(points={{21,-130},{21,-130},{28,-130}}, color={0,0,127}));
  connect(heaLooDisSwi.y, yHea)
    annotation (Line(points={{121,120},{120,120},{150,120}},color={0,0,127}));
  connect(cooLooDisSwi.y, yCoo)
    annotation (Line(points={{121,60},{120,60},{150,60}},color={0,0,127}));
  connect(TRoo,disHea. u1)
    annotation (Line(points={{-160,30},{-120,30},{-120,-50},{-102,-50}},color={0,0,127}));
  connect(TRooHeaSet,disHea. u2)
    annotation (Line(points={{-160,140},{-130,140},{-130,-58},{-102,-58}}, color={0,0,127}));
  connect(notCoo.y, timNoCoo.u)
    annotation (Line(points={{-9,-130},{-9,-130},{-2,-130}}, color={255,0,255}));
  connect(TRoo,disCoo. u1)
    annotation (Line(points={{-160,30},{-120,30},{-120,-110},{-102,-110}},color={0,0,127}));
  connect(TRooCooSet,disCoo. u2)
    annotation (Line(points={{-160,90},{-130,90},{-130,-118},{-102,-118}}, color={0,0,127}));
  connect(intWinSig.y, notIntWin.u)
    annotation (Line(points={{-39,-80},{-30,-80},{-22,-80}}, color={255,0,255}));
  connect(heaConIdle.y, andDisHea.u1)
    annotation (Line(points={{51,-30},{54,-30},{54,-42},{58,-42}}, color={255,0,255}));
  connect(disHea.y, andDisHea.u2)
    annotation (Line(points={{-79,-50},{-10,-50},{58,-50}}, color={255,0,255}));
  connect(notIntWin.y, andDisHea.u3)
    annotation (Line(points={{1,-80},{30,-80},{30,-58},{58,-58}}, color={255,0,255}));
  connect(heaLooDisSwi.u2, andDisHea.y)
    annotation (Line(points={{98,120},{90,120},{90,-50},{81,-50}}, color={255,0,255}));
  connect(notIntWin.y, andDisCoo.u1)
    annotation (Line(points={{1,-80},{30,-80},{30,-92},{58,-92}}, color={255,0,255}));
  connect(disCoo.y, andDisCoo.u2)
    annotation (Line(points={{-79,-110},{-10,-110},{-10,-100},{58,-100}}, color={255,0,255}));
  connect(cooConIdle.y, andDisCoo.u3)
    annotation (Line(points={{51,-130},{54,-130},{54,-108},{58,-108}}, color={255,0,255}));
  connect(andDisCoo.y, cooLooDisSwi.u2)
    annotation (Line(points={{81,-100},{90,-100},{90,60},{98,60}}, color={255,0,255}));
  connect(looDisValSig.y, heaLooDisSwi.u1)
    annotation (Line(points={{121,-28},{130,-28},{130,0},{70,0},{70,128},{98,128}}, color={0,0,127}));
  connect(conHeaVal.y, heaLooDisSwi.u3)
    annotation (Line(points={{-79,140},{60,140},{60,112},{98,112}}, color={0,0,127}));
  connect(conCooInv.y, cooLooDisSwi.u3)
    annotation (Line(points={{41,70},{60,70},{60,52},{98,52}}, color={0,0,127}));
  connect(looDisValSig.y, cooLooDisSwi.u1)
    annotation (Line(points={{121,-28},{130,-28},{130,2},{80,2},{80,68},{98,68}}, color={0,0,127}));
  connect(notCoo.u, greThrCoo.y)
    annotation (Line(points={{-32,-130},{-36,-130},{-39,-130}}, color={255,0,255}));
  connect(conCooInv.y, greThrCoo.u)
    annotation (Line(points={{41,70},{50,70},{50,-8},{-66,-8},{-66,-130},{-62,-130}}, color={0,0,127}));
  connect(conHeaVal.y, greThrHea.u)
    annotation (Line(points={{-79,140},{-70,140},{-70,-30},{-62,-30}}, color={0,0,127}));
  connect(greThrHea.y, notHea.u) annotation (Line(points={{-39,-30},{-36,-30},{-32,-30}}, color={255,0,255}));
  connect(timNoHea.u, notHea.y) annotation (Line(points={{-2,-30},{-9,-30}}, color={255,0,255}));
    annotation (Placement(transformation(extent={{-20,110},{0,130}})),
                Placement(transformation(extent={{-20,20},{0,40}})),
                Placement(transformation(extent={{60,90},{80,110}})),
                Placement(transformation(extent={{-140,130},{-120,150}})),
                Placement(transformation(extent={{-140,-30},{-120,-10}})),
                Placement(transformation(extent={{-140,160},{-120,180}})),
                Placement(transformation(extent={{-140,0},{-120,20}})),
    defaultComponentName = "conLoo",
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-124,144},{128,108}},
          lineColor={0,0,127},
          textString="%name"),
        Line(
          points={{-80,28},{-46,28},{-38,28},{-22,-26},{24,-26},{32,-26},{46,-26},{82,-26}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-80,-26},{-80,-26},{-52,-26},{-30,-26},{16,-26},{24,-26},{38,28},{82,28}},
          color={0,0,127},
          pattern=LinePattern.Dot,
          thickness=0.5)}),
    Documentation(info="<html>
    <p>
    This block models the control loops that modulate the position of heating and cooling coil valves
    in order to maintain the zone temperature setpoint. ASHRAE Guidline 36 (G36), PART5.B.5, refers to them 
    as the cooling loop and the heating loop.
</p>
<p>
Cooling valve controller is enabled whenever the room temperature (<code>TRoo<\code>) exceeds the cooling temperature 
setpoint (<code>TRooCooSet<\code>). Heating valve controller is enabled whenever the room temperature 
(<code>TRoo<\code>) is below the heating temperature setpoint (<code>TRooHeaSet<\code>). Both loops can remain 
enabled at all times if provisions are made for the integral windup. Otherwise any of the loops get disabled
after remaining at the minimum controller output for longer than <code>disDel<\code> time period. State machine chart
illustrates these conditions:
</p>
</p>
<p align=\"center\">
<img alt=\"Image of control loop state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Atomic/HeatingAndCoolingCoilValvesStateMachine.png\"/>
</p>
<p>
The cooling loop shall maintain the space temperature at the active zone cooling setpoint. The heating loop shall
maintain the space temperature at the active zone heating setpoint. This diagram illustrates the control loops:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of heating and cooling loop control chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Atomic/HeatingAndCoolingCoilValvesControlDiagram.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
September 1, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}}),
                                                          graphics={
        Rectangle(
          extent={{-136,156},{-44,0}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,156},{136,0}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{94,22},{124,2}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Signal
assignments"),
        Text(
          extent={{-118,14},{-82,2}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controllers"),
        Rectangle(
          extent={{-136,-4},{136,-156}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{92,-140},{128,-152}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Loop disable"),
        Rectangle(
          extent={{-40,156},{52,0}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{2,18},{38,6}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controller 
signal reverse")}));
end HeatingCoolingControlLoops;
