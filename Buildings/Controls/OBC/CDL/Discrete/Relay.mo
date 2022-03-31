within Buildings.Controls.OBC.CDL.Discrete;
block Relay "Outputs a relay signal for PID tuning experiment"
  parameter Buildings.Controls.OBC.CDL.Types.PIDAutoTuner tuningMethodType=Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau "Type of autotuner";
  parameter Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel tuningModeType=Buildings.Controls.OBC.CDL.Types.PIDAutoTuneModel.FOTD "Type of the tune model"
      annotation (Dialog(enable=tuningMethodType == Buildings.Controls.OBC.CDL.Types.PIDAutoTuner.tau));
  parameter Real yUpperLimit = 1 "Upper limit of the output";
  parameter Real yLowerLimit = -0.5 "Lower limit of the output";
  parameter Real deadBand = 0.5 "Deadband for holding the output value";
  Interfaces.RealInput u1 "Input 1" annotation (Placement(transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-120,30},
            {-100,50}})));
  Interfaces.RealInput u2 "Input 2" annotation (Placement(transformation(extent={{-120,-54},{-100,-34}}), iconTransformation(extent={{-120,-54},
            {-100,-34}})));
  Interfaces.RealOutput y "Ouput" annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Interfaces.RealOutput dtON "Half-period length for the upper limit" annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Interfaces.RealOutput dtOFF "Half-period length for the lower limit" annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Interfaces.RealOutput uDiff "Difference between u1 and u2" annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
  Interfaces.BooleanOutput experimentStart(start=false) "Set to true when the relay experiment starts" annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Interfaces.BooleanOutput experimentEnd(start=false) "Set to true when the relay experiment ends" annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Modelica.Units.SI.Time tON_start(start=0) "Time when the output is the upper limit";
  Modelica.Units.SI.Time tOFF_start(start=0) "Time when the output is the lower limit";

equation
  uDiff=u1-u2;
  when uDiff>+deadBand then
    tON_start = time;
    if tOFF_start>0 then
      dtOFF = time - tOFF_start;
    else
      dtOFF = 0;
    end if;
  end when;
  when uDiff<-deadBand then
    tOFF_start = time;
    if tON_start>0 then
      dtON = time - tON_start;
    else
      dtON = 0;
    end if;
  end when;
  when tON_start>0 or tOFF_start>0 then
    experimentStart = true;
  end when;
  when dtON>0 and dtOFF>0 then
    experimentEnd = true;
  end when;
  if uDiff>deadBand then
    y = yUpperLimit;
  elseif uDiff<-deadBand then
    y = yLowerLimit;
  elseif tOFF_start>tON_start then
    y = yLowerLimit;
  elseif tON_start>tOFF_start then
    y = yUpperLimit;
  else
    y = yLowerLimit;
  end if;

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
        Line(points={{78,-6},{42,-6}}, color={28,108,200})}),    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 30, 2022, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Block that outputs a relay signal which switches between two discrete values every time the process output leaves the hysteresis band. </p>
</html>"));
end Relay;
