within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block TrimAndRespondContinuousTimeApproximation "Trim and respond logic"
  extends Modelica.Blocks.Interfaces.SISO;

  Buildings.Controls.Continuous.LimPID conPID(
    Td=1,
    yMax=1,
    yMin=0,
    reverseActing=false,
    Ti=120,
    k=0.1)     annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
equation
  connect(const.y, conPID.u_s) annotation (Line(
      points={{-39,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conPID.y, y) annotation (Line(
      points={{1,50},{76,50},{76,4.44089e-16},{110,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, conPID.u_m) annotation (Line(
      points={{-120,0},{-10,0},{-10,38}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="triAndRes",
    Documentation(info="<html>
<p>
   This model implements a continuous time approximation to the trim and respond
   control algorithm.
</p>
   </html>", revisions="<html>
<ul>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrimAndRespondContinuousTimeApproximation;
