within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block HeatingCoolingControlLoops "Generates heating and cooling signals to maintain zone set temperature"



    annotation (Placement(transformation(extent={{-20,110},{0,130}})),
                Placement(transformation(extent={{-20,20},{0,40}})),
                Placement(transformation(extent={{60,90},{80,110}})),
                Placement(transformation(extent={{-140,130},{-120,150}})),
                Placement(transformation(extent={{-140,-30},{-120,-10}})),
                Placement(transformation(extent={{-140,160},{-120,180}})),
                Placement(transformation(extent={{-140,0},{-120,20}})),
    defaultComponentName = "conLoo",
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-124,146},{128,110}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(                           extent={{-160,-220},{160,220}},
        initialScale=0.1)),
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
</html>"));
end HeatingCoolingControlLoops;
