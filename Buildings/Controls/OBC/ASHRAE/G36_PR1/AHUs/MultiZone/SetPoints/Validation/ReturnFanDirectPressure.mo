within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Validation;
model ReturnFanDirectPressure
  "Validate model for calculating return fan control with direct building pressure 
  of multi zone VAV AHU"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.ReturnFanDirectPressure
    retFanPre(kP=0.1) "Return fan control with direct building pressure"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFanSta(k=true)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Sine buiPre(
    freqHz=1/7200,
    offset=5,
    amplitude=10) "Building static presure"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.ReturnFanDirectPressure
    retFanPre1(kP=0.5)
    "Return fan control with direct building pressure"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.ReturnFanDirectPressure
    retFanPre2
    "Return fan control with direct building pressure"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(supFanSta.y, retFanPre.uFan)
    annotation (Line(points={{-39,70},{-20,70},{-20,76},{18,76}},
      color={255,0,255}));
  connect(buiPre.y, retFanPre.uBuiPre)
    annotation (Line(points={{-39,20},{0,20},{0,70},{18,70}},
      color={0,0,127}));
  connect(supFanSta.y, retFanPre1.uFan)
    annotation (Line(points={{-39,70},{-20,70},{-20,26},{18,26}},
      color={255,0,255}));
  connect(supFanSta.y, retFanPre2.uFan)
    annotation (Line(points={{-39,70},{-20,70},{-20,-24},{18,-24}},
      color={255,0,255}));
  connect(buiPre.y, retFanPre1.uBuiPre)
    annotation (Line(points={{-39,20},{18,20}}, color={0,0,127}));
  connect(buiPre.y, retFanPre2.uBuiPre)
    annotation (Line(points={{-39,20},{0,20},{0,-30},{18,-30}},
      color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/SetPoints/Validation/ReturnFanDirectPressure.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.ReturnFanDirectPressure\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.ReturnFanDirectPressure</a>
for exhaust air damper and return fan control with direct building pressure measurement 
for systems with multiple
zones.
</p>
</html>", revisions="<html>
<ul>
<li>
October 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFanDirectPressure;
