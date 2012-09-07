within Buildings.Fluid.HeatExchangers.DXCoils;
model VariableSpeed "Variable speed DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil;
  parameter Real minSpeRat( min=0,max=1) "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Logical.Hysteresis deaBan(uLow=minSpeRat - speRatDeaBan/2,
      uHigh=minSpeRat + speRatDeaBan/2) "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-72,80},{-60,92}})));
equation
  connect(speRat, dxCoo.speRat) annotation (Line(
      points={{-110,80},{-80,80},{-80,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, deaBan.u)
                         annotation (Line(
      points={{-110,80},{-80,80},{-80,86},{-73.2,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y, dxCoo.on)
                           annotation (Line(
      points={{-59.4,86},{-32,86},{-32,60},{-21,60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(deaBan.y, eva.on) annotation (Line(
      points={{-59.4,86},{-32,86},{-32,-62},{-10,-62}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (defaultComponentName="mulSpeDX", Documentation(info="<html>
<p>
This DX cooling coil model can be used to simulate continuously variable speed compressors. 
It uses speed ratio as the control signal and should be operated using 
the temperature setpoint in the room. The system will cease operation 
when conditions require a speed ratio below the minimum value. 
For a detailed description of cooling operation please refer to the documentation at 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-96,96},{-38,78}},
          lineColor={0,0,127},
          textString="speRat")}),
    Diagram(graphics));
end VariableSpeed;
