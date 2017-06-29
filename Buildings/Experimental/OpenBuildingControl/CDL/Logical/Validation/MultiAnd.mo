within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model MultiAnd "Model to validate the application of MultiAnd block"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul1(
     width = 0.5, period=1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul2(
     width = 0.5, period=2)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul3(
     width = 0.5, period=3)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul4(
     width = 0.5, period=4)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul5(
     width = 0.5, period=5)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.MultiAnd mulAnd_1(nu=1)
    "Logical 'MultiAnd': 1 input connection y=u"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.MultiAnd mulAnd_2(nu=2)
    "Logical 'MultiAnd': 2 input connection y=and (u1, u2)"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.MultiAnd mulAnd_5(nu=5)
    "Logical 'MultiAnd': 5 input connection y=and(u1,u2, ...,u5)"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(booPul1.y, mulAnd_5.u[1]) annotation (Line(points={{-39,60},{-39,60},{
          20,60},{20,-24.4},{40,-24.4}}, color={255,0,255}));
  connect(booPul2.y, mulAnd_5.u[2]) annotation (Line(points={{-39,30},{14,30},{14,
          -27.2},{40,-27.2}}, color={255,0,255}));
  connect(booPul3.y, mulAnd_5.u[3]) annotation (Line(points={{-39,0},{0,0},{0,-30},
          {40,-30}}, color={255,0,255}));
  connect(booPul4.y, mulAnd_5.u[4]) annotation (Line(points={{-39,-30},{-39,-30},
          {14,-30},{14,-32.8},{40,-32.8}}, color={255,0,255}));
  connect(booPul5.y, mulAnd_5.u[5]) annotation (Line(points={{-39,-60},{-39,-60},
          {20,-60},{20,-35.6},{40,-35.6}}, color={255,0,255}));
  connect(booPul1.y, mulAnd_1.u[1]) annotation (Line(points={{-39,60},{-39,60},{
          20,60},{20,30},{40,30}}, color={255,0,255}));
  connect(booPul1.y, mulAnd_2.u[1]) annotation (Line(points={{-39,60},{-39,60},{
          20,60},{20,3.5},{40,3.5}}, color={255,0,255}));
  connect(booPul2.y, mulAnd_2.u[2]) annotation (Line(points={{-39,30},{-39,30},{
          14,30},{14,-3.5},{40,-3.5}}, color={255,0,255}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/MultiAnd.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.MultiAnd\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.MultiAnd</a>.
</p>
<ul>
<li>input <code>u1</code> is booleanPulse with <code>period=1 Sec</code>, 
<code>width=0.5</code>;</li>
<li>input <code>u2</code> is booleanPulse with <code>period=2 Sec</code>, 
<code>width=0.5</code>;</li>
<li>input <code>u3</code> is booleanPulse with <code>period=3 Sec</code>, 
<code>width=0.5</code>;</li>
<li>input <code>u4</code> is booleanPulse with <code>period=4 Sec</code>, 
<code>width=0.5</code>;</li>
<li>input <code>u5</code> is booleanPulse with <code>period=5 Sec</code>, 
<code>width=0.5</code>;</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
June 28, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end MultiAnd;
