within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block HeatingCoolingControlLoops "Generates heating and cooling control signals to maintain zone set temperature"

  parameter Real conSigMin=0 "Lower limit of control signal output";
  parameter Real conSigMax=1 "Upper limit of control signal output";
  parameter Real kPCoo=30 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiCoo=0.9 "Time constant of damper limit controller integrator block";
  parameter Real kPHea=30 "Gain of damper limit controller";
  parameter Modelica.SIunits.Time TiHea=0.9 "Time constant of damper limit controller integrator block";

  Modelica.Blocks.Interfaces.RealInput TRooHeaSet(unit="K")
    "Zone heating setpoint temperature" annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0, origin={-80,40}),  iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput TRooCooSet(unit="K")
    "Zone cooling setpoint temperature" annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},rotation=0,origin={-80,0}),   iconTransformation(
      extent={{-10,-10},{10,10}},origin={-110,20})));
  Modelica.Blocks.Interfaces.RealInput TRoo(unit="K") "Zone temperature measurement"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-80,-40}),
      iconTransformation(extent={{-10,-10},{10,10}}, origin={-110,-40})));

  CDL.Interfaces.RealOutput yHea(min=conSigMin, max=conSigMin, unit="1") "Heating control signal"
    annotation (Placement(transformation(extent={{60,30},{80,50}}),
      iconTransformation(extent={{100,30},{120,50}})));
  CDL.Interfaces.RealOutput yCoo(min=conSigMin, max=conSigMin, unit="1") "Cooling control signal"
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

protected
  CDL.Continuous.LimPID conCooVal(
    Td=0.1,
    final yMax=conSigMax,
    final yMin=conSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPCoo,
    final Ti=TiCoo) "Cooling coil valve controller"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Continuous.LimPID conHeaVal(
    Td=0.1,
    final yMax=conSigMax,
    final yMin=conSigMin,
    controllerType=Buildings.Experimental.OpenBuildingControl.CDL.Types.SimpleController.PI,
    final k=kPHea,
    final Ti=TiHea) "Heating coil valve controller"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

equation
  connect(TRooHeaSet, conHeaVal.u_s) annotation (Line(points={{-80,40},{-34,40},{-22,40}}, color={0,0,127}));
  connect(TRoo, conHeaVal.u_m)
    annotation (Line(points={{-80,-40},{-40,-40},{-40,20},{-10,20},{-10,28}}, color={0,0,127}));
  connect(TRoo, conCooVal.u_m) annotation (Line(points={{-80,-40},{-10,-40},{-10,-12}}, color={0,0,127}));
  connect(conCooVal.u_s,TRooCooSet)  annotation (Line(points={{-22,0},{-22,0},{-80,0}}, color={0,0,127}));
  connect(conHeaVal.y, yHea) annotation (Line(points={{1,40},{1,40},{70,40}}, color={0,0,127}));
  connect(yCoo, conCooVal.y) annotation (Line(points={{70,0},{50,0},{50,0},{50,0},{1,0}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-60,-60},{60,60}})));
end HeatingCoolingControlLoops;
