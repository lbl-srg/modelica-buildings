within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model LeadLag_DevSta "Validate lead/lag switching"

  parameter Integer num = 2
    "Total number of chillers, the same number applied to isolation valves, CW pumps, CHW pumps";

  parameter Boolean initRoles[num] = {true, false}
    "Sets initial roles: true = lead, false = lag. There should be only one lead device";

  LeadLag leaLag(num=num)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  CDL.Logical.Sources.Pulse booPul[num](width=0.8, period=2*60*60)
    "Lead device on/off status"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Logical.Sources.Pulse booPul1[num](width=0.2, period=1*60*60)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  CDL.Logical.LogicalSwitch logSwi[num]
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  CDL.Logical.Pre pre[num](pre_u_start=initRoles)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation

  connect(booPul.y, logSwi.u1) annotation (Line(points={{-59,30},{-40,30},{-40,
          8},{-22,8}},
                    color={255,0,255}));
  connect(booPul1.y, logSwi.u3) annotation (Line(points={{-59,-30},{-40,-30},{
          -40,-8},{-22,-8}},
                         color={255,0,255}));
  connect(logSwi.y, leaLag.uDevSta)
    annotation (Line(points={{1,0},{18,0}},   color={255,0,255}));
// experiment(StopTime=3600.0, Tolerance=1e-06),
//  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/fixme.mos"
//    "Simulate and plot"),
  connect(leaLag.DevRol, pre.u)
    annotation (Line(points={{41,0},{58,0}}, color={255,0,255}));
  connect(pre.y, logSwi.u2) annotation (Line(points={{81,0},{90,0},{90,-30},{
          -30,-30},{-30,0},{-22,0}}, color={255,0,255}));
annotation (
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.LeadLag\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.LeadLag</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
fixme<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LeadLag_DevSta;
