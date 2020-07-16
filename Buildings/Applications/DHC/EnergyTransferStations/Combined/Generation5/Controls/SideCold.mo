within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model SideCold "Control block for cold side"
  extends BaseClasses.SideHotCold(
    final reverseActing=true);
  Buildings.Controls.OBC.CDL.Continuous.Max max "Max"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
equation
  connect(max.u2, TBot) annotation (Line(points={{-92,-86},{-120,-86},{-120,
          -140},{-200,-140}},
                            color={0,0,127}));
  connect(max.y, errDis.u2) annotation (Line(points={{-68,-80},{-60,-80},{-60,
          -12}}, color={0,0,127}));
  connect(TBot, errEna.u2) annotation (Line(points={{-200,-140},{-120,-140},{
          -120,20},{-88,20},{-88,28}},   color={0,0,127}));
  connect(TTop, max.u1) annotation (Line(points={{-200,-80},{-100,-80},{-100,
          -74},{-92,-74}},  color={0,0,127}));
  connect(TTop, conPlaSeq.u_m) annotation (Line(points={{-200,-80},{-100,-80},{-100,
          -140},{-80,-140},{-80,-132}}, color={0,0,127}));
  annotation (
  defaultComponentName="conCol",
Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This block serves as the controller for the cold side of the ETS.
See 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>
for the description of the control logic.
</p>
</html>"));
end SideCold;
