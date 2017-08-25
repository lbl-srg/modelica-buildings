within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block HeatingCoolingControlLoops "Generates heating and cooling control signals to maintain zone set temperature"

  parameter Real conSigMin=0 "Lower limit of control signal output";
  parameter Real conSigMax=1 "Upper limit of control signal output";
  parameter Real kPCoo=1 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiCoo=30 "Time constant of damper limit controller integrator block";
  parameter Real kPHea=1 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiHea=30 "Time constant of damper limit controller integrator block";
  parameter Modelica.SIunits.Time disDel=30 "Comparison with respect to threshold";

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

protected
  final parameter Real looDisVal=0 "Output value at loop disable";

  CDL.Continuous.LimPID conCooVal(
    final yMax=conSigMax,
    final yMin=conSigMin,
    final controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPCoo,
    final Ti=TiCoo) "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Continuous.LimPID conHeaVal(
    final yMax=conSigMax,
    final yMin=conSigMin,
    final controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPHea,
    final Ti=TiHea) "Heating coil valve controller"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Continuous.Line conCooInv(
    final limitBelow=true,
    final limitAbove=true) "Inverter of the cooling control signal"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Continuous.Sources.Constant conSigMinSig(final k=conSigMin)
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  CDL.Continuous.Sources.Constant conSigMaxSig(final k=conSigMax)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

public
  CDL.Logical.Sources.Constant intWinSig(k=intWin) "Provisions to minimize integral windup implemented"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  parameter Boolean intWin = false "Provisions to minimize integral windup implemented";
  CDL.Logical.GreaterEqualThreshold greEquThrHea(threshold=disDel)
    "Determine whether the provided time delay for heating loop disable has expired"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  CDL.Logical.GreaterEqualThreshold greEquThrCoo(threshold=disDel)
    "Determine whether the provided time delay for cooling loop disable has expired"
    annotation (Placement(transformation(extent={{30,-140},{50,-120}})));
  CDL.Logical.Timer timHea "Measure time since heating signal became zero."
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  CDL.Continuous.Sources.Constant looDisValSig(k=looDisVal)
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  CDL.Logical.Timer timCoo "Measure time since cooling signal became zero."
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  CDL.Logical.Not notHea "Logical not block" annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  CDL.Logical.Not notCoo "Logical not block" annotation (Placement(transformation(extent={{-30,-140},{-10,-120}})));
  CDL.Logical.Switch heaLooDisSwi "Enable-disable switch for the heating loop signal"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  CDL.Logical.Switch cooLooDisSwi "Enable-disable switch for the cooling loop signal"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  CDL.Logical.Greater greHea "Determine whether the room temperature is above the heating setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  CDL.Logical.Less greCoo "Determine whether the room temperature is below the cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  CDL.Conversions.RealToBoolean reaToBooHea(threshold=looDisVal)
    "Real to boolean converter, false if the output is zero"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  CDL.Conversions.RealToBoolean reaToBooCoo(threshold=looDisVal)
    "Real to boolean converter, false if the output is zero"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  CDL.Logical.Not notIntWin "Logical not that prevents disable in case integral windup minimization in implemented"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  CDL.Logical.And3 andDis "Logical and that disables cooling loop"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  CDL.Logical.And3 andDisHea "Logical and that disables heating loop"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(TRooHeaSet, conHeaVal.u_s)
    annotation (Line(points={{-160,140},{-160,140},{-102,140}},
                                                  color={0,0,127}));
  connect(TRoo, conHeaVal.u_m)
    annotation (Line(points={{-160,30},{-112,30},{-112,120},{-90,120},{-90,128}},
                                                                              color={0,0,127}));
  connect(TRoo, conCooVal.u_m)
    annotation (Line(points={{-160,30},{-90,30},{-90,58}},   color={0,0,127}));
  connect(conCooVal.u_s,TRooCooSet)
    annotation (Line(points={{-102,70},{-102,70},{-110,70},{-110,90},{-160,90}},
                                                                              color={0,0,127}));
  connect(conCooVal.y, conCooInv.u)
    annotation (Line(points={{-79,70},{-79,70},{-22,70}},  color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.x1)
    annotation (Line(points={{-39,90},{-30,90},{-30,78},{-22,78}},
                                                               color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.f1)
    annotation (Line(points={{-39,50},{-30,50},{-30,74},{-22,74}}, color={0,0,127}));
  connect(conSigMaxSig.y, conCooInv.x2)
    annotation (Line(points={{-39,50},{-30,50},{-30,66},{-22,66}}, color={0,0,127}));
  connect(conSigMinSig.y, conCooInv.f2)
    annotation (Line(points={{-39,90},{-30,90},{-30,62},{-22,62}},
                                                               color={0,0,127}));
  connect(timHea.y, greEquThrHea.u) annotation (Line(points={{21,-30},{21,-30},{28,-30}}, color={0,0,127}));
  connect(timCoo.y, greEquThrCoo.u) annotation (Line(points={{21,-130},{21,-130},{28,-130}},
                                                                                          color={0,0,127}));
  connect(heaLooDisSwi.y, yHea) annotation (Line(points={{121,120},{120,120},{150,120}},           color={0,0,127}));
  connect(cooLooDisSwi.y, yCoo) annotation (Line(points={{121,60},{120,60},{150,60}},          color={0,0,127}));
  connect(TRoo, greHea.u1) annotation (Line(points={{-160,30},{-120,30},{-120,-50},{-102,-50}}, color={0,0,127}));
  connect(TRooHeaSet, greHea.u2)
    annotation (Line(points={{-160,140},{-130,140},{-130,-58},{-102,-58}}, color={0,0,127}));
  connect(conHeaVal.y, reaToBooHea.u)
    annotation (Line(points={{-79,140},{-70,140},{-70,-30},{-62,-30}}, color={0,0,127}));
  connect(reaToBooHea.y, notHea.u) annotation (Line(points={{-39,-30},{-39,-30},{-32,-30}}, color={255,0,255}));
  connect(conCooVal.y, reaToBooCoo.u)
    annotation (Line(points={{-79,70},{-70,70},{-70,-130},{-62,-130}},
                                                                     color={0,0,127}));
  connect(reaToBooCoo.y, notCoo.u) annotation (Line(points={{-39,-130},{-32,-130}},
                                                                                  color={255,0,255}));
  connect(notHea.y, timHea.u) annotation (Line(points={{-9,-30},{-9,-30},{-2,-30}}, color={255,0,255}));
  connect(notCoo.y, timCoo.u) annotation (Line(points={{-9,-130},{-9,-130},{-2,-130}},
                                                                                    color={255,0,255}));
  connect(TRoo, greCoo.u1) annotation (Line(points={{-160,30},{-120,30},{-120,-110},{-102,-110}},
                                                                                                color={0,0,127}));
  connect(TRooCooSet, greCoo.u2)
    annotation (Line(points={{-160,90},{-130,90},{-130,-118},{-102,-118}}, color={0,0,127}));
  connect(intWinSig.y, notIntWin.u) annotation (Line(points={{-39,-80},{-30,-80},{-22,-80}}, color={255,0,255}));
  connect(greEquThrHea.y, andDisHea.u1)
    annotation (Line(points={{51,-30},{54,-30},{54,-42},{58,-42}}, color={255,0,255}));
  connect(greHea.y, andDisHea.u2) annotation (Line(points={{-79,-50},{-10,-50},{58,-50}}, color={255,0,255}));
  connect(notIntWin.y, andDisHea.u3) annotation (Line(points={{1,-80},{30,-80},{30,-58},{58,-58}}, color={255,0,255}));
  connect(heaLooDisSwi.u2, andDisHea.y)
    annotation (Line(points={{98,120},{90,120},{90,-50},{81,-50}}, color={255,0,255}));
  connect(notIntWin.y, andDis.u1) annotation (Line(points={{1,-80},{30,-80},{30,-92},{58,-92}}, color={255,0,255}));
  connect(greCoo.y, andDis.u2)
    annotation (Line(points={{-79,-110},{-10,-110},{-10,-100},{58,-100}}, color={255,0,255}));
  connect(greEquThrCoo.y, andDis.u3)
    annotation (Line(points={{51,-130},{54,-130},{54,-108},{58,-108}}, color={255,0,255}));
  connect(andDis.y, cooLooDisSwi.u2) annotation (Line(points={{81,-100},{90,-100},{90,60},{98,60}}, color={255,0,255}));
  connect(looDisValSig.y, heaLooDisSwi.u1)
    annotation (Line(points={{41,100},{70,100},{70,128},{98,128}}, color={0,0,127}));
  connect(conHeaVal.y, heaLooDisSwi.u3)
    annotation (Line(points={{-79,140},{60,140},{60,112},{98,112}}, color={0,0,127}));
  connect(conCooInv.y, cooLooDisSwi.u3) annotation (Line(points={{1,70},{50,70},{50,52},{98,52}}, color={0,0,127}));
  connect(looDisValSig.y, cooLooDisSwi.u1)
    annotation (Line(points={{41,100},{69.5,100},{69.5,68},{98,68}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-140,-160},{140,160}}),
                                                          graphics={
        Rectangle(
          extent={{-284,134},{-210,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{-286,58},{-256,38}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controller signal inverter"),
        Rectangle(
          extent={{-362,194},{-288,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-318,54},{-282,42}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Controllers"),
        Rectangle(
          extent={{-356,22},{-236,-128}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-262,-118},{-226,-130}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontSize=14,
          textString="Loop disable")}));
end HeatingCoolingControlLoops;
