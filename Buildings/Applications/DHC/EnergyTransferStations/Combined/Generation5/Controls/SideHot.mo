within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block SideHot "Control block for hot side"
  extends BaseClasses.SideHotCold(
    final reverseActing=false);
  Buildings.Controls.OBC.CDL.Continuous.Min min
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
equation
  connect(min.u1, TTop) annotation (Line(points={{-92,-74},{-120,-74},{-120,-80},
          {-200,-80}},color={0,0,127}));
  connect(min.u2, TBot) annotation (Line(points={{-92,-86},{-120,-86},{-120,
          -140},{-200,-140}},
                       color={0,0,127}));

  connect(min.y, errDis.u2) annotation (Line(points={{-68,-80},{-60,-80},{-60,
          -12}}, color={0,0,127}));
  connect(TTop, errEna.u2) annotation (Line(points={{-200,-80},{-120,-80},{-120,
          20},{-88,20},{-88,28}},   color={0,0,127}));
  connect(TBot, conPlaSeq.u_m) annotation (Line(points={{-200,-140},{-90,-140},
          {-90,-132}},
                  color={0,0,127}));
   annotation (
   defaultComponentName="conHot",
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
This block serves as the controller for the hot side of the ETS.
See 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.SideHotCold</a>
for the description of the control logic.
</p>
</html>"));
end SideHot;
