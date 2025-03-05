within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
block SimVFD "Simple VFD maintaing constant V/F ratio"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer f( start=50,fixed) "Nominal Frequency in Hz";
  parameter Integer p(start=4,fixed) " Number of Pole pairs ";
  parameter Real N_s( start=1500,fixed) "Synchronous Speed in RPM";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput N_ref
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_in
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Freq
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput V_out
    annotation (Placement(transformation(extent={{100,-58},{136,-22}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Freq_out
    annotation (Placement(transformation(extent={{100,22},{136,58}})));

  Modelica.Blocks.Math.Gain Equivalent_Freq(k=p/(120))
    annotation (Placement(transformation(extent={{-64,50},{-44,70}})));
  Modelica.Blocks.Math.Division VFD_Ratio
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=N_s*p/120)
    annotation (Placement(transformation(extent={{-60,8},{-40,30}})));

  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Math.Gain gain(k=2*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{60,30},{80,50}})));

equation
  connect(Equivalent_Freq.u, N_ref)
    annotation (Line(points={{-66,60},{-120,60}}, color={0,0,127}));
  connect(Equivalent_Freq.y, VFD_Ratio.u1)
    annotation (Line(points={{-43,60},{-38,60},{-38,56},{-22,56}},
                                               color={0,0,127}));
  connect(product1.u2, VFD_Ratio.y) annotation (Line(points={{18,-46},{6,
          -46},{6,50},{1,50}},
                            color={0,0,127}));
  connect(product1.y, V_out) annotation (Line(points={{41,-40},{118,-40}},
                      color={0,0,127}));
  connect(product2.u1, VFD_Ratio.y)
    annotation (Line(points={{18,46},{6,46},{6,50},{1,50}},
                                               color={0,0,127}));
  connect(product2.u2, Freq) annotation (Line(points={{18,34},{0,34},{0,
          -60},{-120,-60}},
                      color={0,0,127}));
  connect(gain.u, product2.y)
    annotation (Line(points={{58,40},{41,40}}, color={0,0,127}));
  connect(V_in, product1.u1) annotation (Line(points={{-120,0},{12,0},{12,
          -34},{18,-34}}, color={0,0,127}));
  connect(VFD_Ratio.u2, realExpression.y) annotation (Line(points={{-22,
          44},{-34,44},{-34,19},{-39,19}}, color={0,0,127}));
  connect(Freq_out, Freq_out)
    annotation (Line(points={{118,40},{118,40}}, color={0,0,127}));
  connect(gain.y, Freq_out)
    annotation (Line(points={{81,40},{118,40}}, color={0,0,127}));
annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes the VFD by maintaining constant ratio for the models in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>"));
end SimVFD;
