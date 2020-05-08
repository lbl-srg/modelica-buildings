within Buildings.Applications.DHC.CentralPlants.Controls;
model dPControl "Demand side pressure difference control"
  parameter Modelica.SIunits.Pressure dPSetPoi "Pressure difference setpoint";
  Buildings.Controls.Continuous.LimPID conPID(
    reverseAction=false,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=240,
    k=0.000001)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression dPSet(y=if yVal > 0.01 then dPSetPoi
         else 0)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Interfaces.RealInput dP "Measured pressure drop"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput yVal "yValve"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealOutput Spe
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(dPSet.y, conPID.u_s) annotation (Line(
      points={{-29,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conPID.u_m, dP) annotation (Line(
      points={{0,-12},{0,-60},{-120,-60}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conPID.y, Spe) annotation (Line(
      points={{11,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-30,12},{20,-8}},
          lineColor={0,0,255},
          textString="dPCon"),
        Text(
          extent={{-42,-106},{52,-148}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(revisions="<html>
<ul>
<li>
April 14, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>When the poistion of demand side two way valve is lower than 0.1, pressure drop set point is 0. </p>

</html>"));
end dPControl;
