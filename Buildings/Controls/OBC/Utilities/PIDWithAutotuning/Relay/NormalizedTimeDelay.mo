within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay;
block NormalizedTimeDelay
  "Calculates the normalized time delay of a response from a relay controller"
  parameter Real gamma(min=1+1E-6) = 4
    "Asymmetry level of the relay controller";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rho
    "Connector for the half period ratio signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau
    "Connector for a output signal of the normalized time delay"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant asymmetryLevel(k=gamma)
    "Asymmetry level of the relay"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract subGammaRho "gamma-rho"
    annotation (Placement(transformation(extent={{0,12},{20,32}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=0.35)
    "gain for rho"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "(r-1)*(0.35*roh+0.65)"
    annotation (Placement(transformation(extent={{0,-48},{20,-28}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "calculates tau"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(p=0.65)
    "rho*0.35+0.65"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(p=-1)
    "gamma-1"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
equation
  assert(
    gamma-rho>1E-6,
    "the asymmetry level should be larger than the half period ratio. Check parameters.");
  connect(subGammaRho.u1, asymmetryLevel.y) annotation (Line(points={{-2,28},{-20,
          28},{-20,50},{-58,50}}, color={0,0,127}));
  connect(subGammaRho.u2, rho) annotation (Line(points={{-2,16},{-42,16},{-42,
          20},{-94,20},{-94,0},{-120,0}}, color={0,0,127}));
  connect(gai.u, rho) annotation (Line(points={{-82,-60},{-94,-60},{-94,0},{-120,
          0}}, color={0,0,127}));
  connect(div.u1, subGammaRho.y)
    annotation (Line(points={{38,6},{30,6},{30,22},{22,22}}, color={0,0,127}));
  connect(div.u2, mul.y) annotation (Line(points={{38,-6},{30,-6},{30,-38},{22,-38}},
        color={0,0,127}));
  connect(div.y, tau)
    annotation (Line(points={{62,0},{110,0}}, color={0,0,127}));
  connect(gai.y, addPar2.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(addPar2.y, mul.u2) annotation (Line(points={{-18,-60},{-10,-60},{-10,-44},
          {-2,-44}}, color={0,0,127}));
  connect(addPar1.u, asymmetryLevel.y) annotation (Line(points={{-42,-10},{-52,-10},
          {-52,50},{-58,50}}, color={0,0,127}));
  connect(addPar1.y, mul.u1) annotation (Line(points={{-18,-10},{-10,-10},{-10,-32},
          {-2,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,148},{146,108}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the normalized time delay of the responses from a relay controller, <i>&tau;</i>, by</p>
<p>&tau; = (&gamma; - &rho;)/(&gamma; - 1)/(&rho;*0.35+0.65) </p>
<p>where <i>&gamma;</i> and <i>&rho;</i>  are the asymmetry level of the relay controller and the half-period ratio, respectively.</p>
<h4>References</h4>
<p>
Josefin Berner (2017).
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.
</p>
</html>"));
end NormalizedTimeDelay;
