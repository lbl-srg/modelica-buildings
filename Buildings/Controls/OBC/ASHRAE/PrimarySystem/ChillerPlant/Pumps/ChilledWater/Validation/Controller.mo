within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Validation;
model Controller "Validate chiller water pump control sequence"


  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller
    controller(nPum=3, nPum_nominal=3)
    "Pump speed control for plant with headered primary chilled water pump and without local DP sensor"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](k={2,1,3})
    "Chilled water pump operating priority"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[2](
    each final k=true) "Constant true"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(each final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=0.25,
    final freqHz=1/3600,
    final offset=0.25) "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen1(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final amplitude=1.5*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine remPreSen2(
    final offset=8.5*6894.75,
    final freqHz=1/3600,
    final startTime=2,
    final amplitude=1*6894.75) "Remote pressure difference sensor reading"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant difPreSet(
    final k=8.5*6894.75)
    "Pressure difference setpoint"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));

equation
  connect(conInt.y, controller.uPumPri) annotation (Line(points={{-159,160},{-140,
          160},{-140,129},{-101,129}}, color={255,127,0}));
  connect(con[1].y, controller.uChiWatPum[1]) annotation (Line(points={{-159,
          120},{-132,120},{-132,126.333},{-101,126.333}},
                                                   color={255,0,255}));
  connect(con[2].y, controller.uChiWatPum[2]) annotation (Line(points={{-159,
          120},{-132,120},{-132,127},{-101,127}},  color={255,0,255}));
  connect(sin.y, controller.VChiWat_flow) annotation (Line(points={{-159,40},{
          -128,40},{-128,117},{-101,117}},
                                      color={0,0,127}));
  connect(con[1].y, controller.uChiIsoVal[1]) annotation (Line(points={{-159,
          120},{-132,120},{-132,119},{-101,119}},
                                             color={255,0,255}));
  connect(remPreSen1.y, controller.dpChiWat_remote[1]) annotation (Line(points={{-159,0},
          {-124,0},{-124,113},{-101,113}},          color={0,0,127}));
  connect(remPreSen2.y, controller.dpChiWat_remote[2]) annotation (Line(points={{-159,
          -40},{-124,-40},{-124,113},{-101,113}},       color={0,0,127}));
  connect(difPreSet.y, controller.dpChiWatSet) annotation (Line(points={{-159,-80},
          {-120,-80},{-120,111},{-101,111}}, color={0,0,127}));
  connect(con1.y, controller.uChiWatPum[3]) annotation (Line(points={{-159,80},
          {-136,80},{-136,127.667},{-101,127.667}}, color={255,0,255}));
  connect(con1.y, controller.uChiIsoVal[2]) annotation (Line(points={{-159,80},
          {-136,80},{-136,119},{-101,119}}, color={255,0,255}));
annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Pumps/ChilledWater/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Arpil 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-280},{240,280}})));
end Controller;
