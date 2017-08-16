within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block HeatingCoolingControlLoops "Generates heating and cooling control signals to maintain zone set temperature"

  parameter Real conSigMin=0 "Lower limit of control signal output";
  parameter Real conSigMax=1 "Upper limit of control signal output";
  parameter Real kPCoo=1 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiCoo=30 "Time constant of damper limit controller integrator block";
  parameter Real kPHea=1 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiHea=30 "Time constant of damper limit controller integrator block";

  Modelica.Blocks.Interfaces.RealInput TRooHeaSet(unit="K")
    "Zone heating setpoint temperature" annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0, origin={-100,50}), iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet(unit="K")
    "Zone cooling setpoint temperature" annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0,origin={-100,0}),  iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,20})));
  Modelica.Blocks.Interfaces.RealInput TRoo(unit="K") "Zone temperature measurement"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-100,-60}),
      iconTransformation(extent={{-10,-10},{10,10}}, origin={-110,-40})));

  CDL.Interfaces.RealOutput yHea(min=conSigMin, max=conSigMin, unit="1") "Heating control signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}}),
      iconTransformation(extent={{100,30},{120,50}})));
  CDL.Interfaces.RealOutput yCoo(min=conSigMin, max=conSigMin, unit="1") "Cooling control signal"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  CDL.Continuous.Line conCooInv(limitBelow=true, limitAbove=true) "Inverter of the cooling control signal"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  CDL.Continuous.Sources.Constant conSigMinSig(k=conSigMin)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  CDL.Continuous.Sources.Constant conSigMaxSig(k=conSigMax)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));

protected
  CDL.Continuous.LimPID conCooVal(
    Td=0.1,
    final yMax=conSigMax,
    final yMin=conSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPCoo,
    final Ti=TiCoo) "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  CDL.Continuous.LimPID conHeaVal(
    Td=0.1,
    final yMax=conSigMax,
    final yMin=conSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPHea,
    final Ti=TiHea) "Heating coil valve controller"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

equation
  connect(TRooHeaSet, conHeaVal.u_s) annotation (Line(points={{-100,50},{-42,50}}, color={0,0,127}));
  connect(TRoo, conHeaVal.u_m)
    annotation (Line(points={{-100,-60},{-60,-60},{-60,30},{-30,30},{-30,38}},color={0,0,127}));
  connect(TRoo, conCooVal.u_m) annotation (Line(points={{-100,-60},{-30,-60},{-30,-32}},color={0,0,127}));
  connect(conCooVal.u_s,TRooCooSet)
    annotation (Line(points={{-42,-20},{-42,-20},{-50,-20},{-50,0},{-100,0}}, color={0,0,127}));
  connect(conHeaVal.y, yHea)
    annotation (Line(points={{-19,50},{-19,50},{70,50},{80,50},{90,50}}, color={0,0,127}));
  connect(conCooInv.y, yCoo) annotation (Line(points={{71,-20},{90,-20}}, color={0,0,127}));
  connect(conCooVal.y, conCooInv.u) annotation (Line(points={{-19,-20},{20,-20},{48,-20}}, color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.x1) annotation (Line(points={{31,0},{40,0},{40,-12},{48,-12}}, color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.f1)
    annotation (Line(points={{31,-40},{40,-40},{40,-16},{48,-16}}, color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.x2)
    annotation (Line(points={{31,-40},{40,-40},{40,-24},{48,-24}}, color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.f2) annotation (Line(points={{31,0},{40,0},{40,-28},{48,-28}}, color={0,0,127}));
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
          textString="%name")}),
    Documentation(info="<html>
    <p>
This block models the control loops that operate to maintain zone temperature setpoint, the Cooling Loop and 
the Heating Loop, as described in ASHRAE Guidline 36 (G36), PART5.B.5.
</p>
<p>
fixme add description of disable conditions and state machine chart
</p>
</p>
<p align=\"center\">
<img alt=\"Image of control loop state machine chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/fixme.png\"/>
</p>
<p>
The Cooling Loop shall maintain the space temperature at the active zone cooling setpoint. The Heating Loop shall 
maintain the space temperature at the active zone heating setpoint.

<p>
This chart illustrates the control loops:
<br>
</br>
</p>
<p align=\"center\">
<img alt=\"Image of heating and cooling loop control chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/fixmeAddImage.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 13, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-80,-80},{80,80}}), graphics={
        Rectangle(
          extent={{2,16},{76,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{40,-62},{76,-74}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controller signal inverter"),
        Rectangle(
          extent={{-76,76},{-2,-76}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{-20,-62},{16,-74}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controllers")}));
end HeatingCoolingControlLoops;
