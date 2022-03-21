within Buildings.Controls.OBC.CDL.Discrete;
block Relay "Outputs a relay signal for model identification"
  parameter Real yUpperLimit = 1 "Upper limit for y";
  parameter Real yLowerLimit = 0 "Lower limit for y";
  parameter Real deadBand = 0.5 "Deadband for holding the output value";
  Modelica.Blocks.Interfaces.RealInput u1 "Input 2" annotation (Placement(transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-120,30},
            {-100,50}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Input 1" annotation (Placement(transformation(extent={{-120,-54},{-100,-34}}), iconTransformation(extent={{-120,-54},
            {-100,-34}})));
  Modelica.Blocks.Interfaces.RealOutput y(start=yLowerLimit)
    "Relay signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Units.SI.Time tON_start(start=0);
  Modelica.Units.SI.Time tOFF_start(start=0);
  Modelica.Units.SI.Duration dtON(start=0);
  Modelica.Units.SI.Duration dtOFF(start=0);


algorithm
  when u1-u2>deadBand then
    y :=yUpperLimit;
    tON_start:=time;
    if tOFF_start>0 then
    dtOFF:=time - tOFF_start;
    end if;
  end when;
  when u1-u2<-deadBand then
    y :=yLowerLimit;
    tOFF_start:=time;
    if tON_start>0 then
    dtON:=time - tON_start;
    end if;
  end when;

    annotation (Placement(transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,60}})),
                Placement(transformation(extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,60}})),
              Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                        Text(
        extent={{-148,160},{152,120}},
        textString="%name",
        textColor={0,0,255}),           Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={223,211,169},
          lineThickness=5.0,
          borderPattern=BorderPattern.Raised,
          fillPattern=FillPattern.Solid),
        Line(points={{-40,-6},{16,38}}, color={28,108,200}),
        Ellipse(
          extent={{-50,0},{-38,-12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,0},{44,-12}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-48,-6},{-84,-6}}, color={28,108,200}),
        Line(points={{78,-6},{42,-6}}, color={28,108,200})}),    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Relay;
