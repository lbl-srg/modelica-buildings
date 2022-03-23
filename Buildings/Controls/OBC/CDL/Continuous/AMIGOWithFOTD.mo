within Buildings.Controls.OBC.CDL.Continuous;
block AMIGOWithFOTD "AMIGO tuning method with a first order model with time delay"
  parameter Real yUpperLimit = 1 "Upper limit for y";
  parameter Real yLowerLimit = 0 "Lower limit for y";
  parameter Real deadBand = 0.5 "Deadband for holding the output value";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller";
  Real y0 "Initial value of the process output";
  Real u0 "Initial value of the process input";
  Interfaces.RealInput tau "Normalized time delay"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}), iconTransformation(extent={{-140,80},{-100,120}})));
  Interfaces.RealInput dtOFF "Half-period length of a relay tuner"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),iconTransformation(extent={{-140,-120},{-100,-80}})));

  Interfaces.RealInput dtON "Half-period length of a relay tuner"
    annotation (Placement(transformation(extent={{-140,-72},{-100,-32}}),
                                                                        iconTransformation(extent={{-140,-78},{-100,-38}})));
  Real Kp "Static gain";
  Real T "Time constant";
  Real L "Time delay";
  Real k
    "Gain of controller";
  Real Ti
    "Time constant of integrator block";
  Real Td
    "Time constant of derivative block";
  Interfaces.RealInput ProcessOutput "Half-period length of a relay tuner"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}}), iconTransformation(extent={{-140,28},{-100,68}})));
  Interfaces.RealInput RelayOutput "Half-period length of a relay tuner"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  IntegratorWithReset Iy annotation (Placement(transformation(extent={{-2,40},{18,60}})));
  IntegratorWithReset Iu annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Modelica.Blocks.Sources.RealExpression yDiff(y=ProcessOutput - y0) annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.RealExpression uDiff(y=RelayOutput - u0) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Divide kpCalculator "Static gain of the process" annotation (Placement(transformation(extent={{40,30},{60,10}})));
  Modelica.Blocks.Sources.RealExpression checkZero(y=noEvent(if Iy.y > 0 then Iy.y else 1)) annotation (Placement(transformation(extent={{58,44},{38,64}})));
  Interfaces.BooleanInput experimentStart "If the relay experiment startes" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,120}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-56,120})));

  Interfaces.BooleanInput experimentEnd "If the relay experiment ends" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={54,120})));
protected
  Modelica.Blocks.Sources.BooleanExpression
                           noReset(y=experimentStart)
                                                  "Constant false" annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Sources.Constant con(final k=0)  "Constant zero" annotation (Placement(transformation(extent={{-80,-26},{-60,-6}})));

equation
  when experimentStart then
    y0 = RelayOutput;
    u0 = ProcessOutput;
  end when;
  when experimentEnd then
     Kp = kpCalculator.y;
     T = dtON/Modelica.Math.log10((deadBand/abs(Kp)+yLowerLimit+Modelica.Math.exp(tau/(1-tau))*(yUpperLimit -
        yLowerLimit))/(yUpperLimit - deadBand/abs(Kp)));
     L = T*(tau/(1-tau));
     if controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI then
        k = 1/Kp*(0.15+0.35*T/L-T^2/(T+L)^2);
        Ti = (0.35+13*T^2/(T^2+12*T*L+7*L^2))*L;
        Td = 0;
     else
        k = 1/Kp*(0.2+0.45*T/L);
        Ti = (0.4*L+0.8*T)/(L+0.1*T)*L;
        Td = 0.5*T*L/(0.3*L+T);
     end if;
  end when;
  connect(noReset.y, Iy.trigger) annotation (Line(points={{-19,20},{8,20},{8,38}},     color={255,0,255}));
  connect(Iu.trigger, Iy.trigger) annotation (Line(points={{8,-12},{8,-20},{-16,-20},{-16,20},{8,20},{8,38}},         color={255,0,255}));
  connect(uDiff.y, Iu.u) annotation (Line(points={{-19,0},{-4,0}},                      color={0,0,127}));
  connect(yDiff.y, Iy.u) annotation (Line(points={{-19,50},{-4,50}},                    color={0,0,127}));
  connect(con.y, Iy.y_reset_in) annotation (Line(points={{-58,-16},{-46,-16},{-46,36},{-4,36},{-4,42}},
                                                                                       color={0,0,127}));
  connect(Iu.y_reset_in, Iy.y_reset_in) annotation (Line(points={{-4,-8},{-46,-8},{-46,36},{-4,36},{-4,42}},
                                                                                                       color={0,0,127}));
  connect(Iu.y, kpCalculator.u1) annotation (Line(points={{20,0},{32,0},{32,14},{38,14}}, color={0,0,127}));
  connect(checkZero.y, kpCalculator.u2) annotation (Line(points={{37,54},{32,54},{32,26},{38,26}}, color={0,0,127}));
  annotation (
    defaultComponentName="ave",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,16}},
          color={0,0,0}),
        Line(
          points={{-100,60}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>Block that generates the PID parameters with the AMIGO method and a first-order model with time delay.</p>
</html>",
      revisions="<html>
<ul>
<li>
March 3, 2022, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end AMIGOWithFOTD;
