within Buildings.Controls.OBC.RooftopUnits.DXCoil.Validation;
model Controller "Validation model for DX coil controller"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiCon(
    final nCoi=3,
    final conCooCoiLow=0.2,
    final conCooCoiHig=0.8,
    final uThrCooCoi=0.8,
    final uThrCooCoi1=0.2,
    final uThrCooCoi2=0.8,
    final uThrCooCoi3=0.1,
    final dUHys=0.01,
    final timPer=480,
    final timPer1=180,
    final timPer2=300,
    final timPer3=300,
    final minComSpe=0.1,
    final maxComSpe=1)
    "DX coil staging and compressor speed control"
    annotation (Placement(transformation(extent={{-10,-14},{10,14}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre[3](
    final pre_u_start=fill(false, 3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=0.5,
    final duration=3600,
    final offset=0.5)
    "Ramp signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(DXCoiCon.yDXCoi, pre.u) annotation (Line(points={{12,7},{22,7},{22,0},
          {28,0}},    color={255,0,255}));
  connect(pre.y, DXCoiCon.uDXCoi) annotation (Line(points={{52,0},{60,0},{60,30},
          {-20,30},{-20,4.2},{-12,4.2}}, color={255,0,255}));
  connect(ram.y, DXCoiCon.uCooCoi) annotation (Line(points={{-38,-40},{-20,-40},
          {-20,-11.2},{-12,-11.2}}, color={0,0,127}));
  connect(con1.y, DXCoiCon.uDXCoiAva) annotation (Line(points={{-38,0},{-30,0},
          {-30,-4.2},{-12,-4.2}}, color={255,0,255}));
  connect(conInt.y, DXCoiCon.uCoiSeq) annotation (Line(points={{-38,40},{-30,40},
          {-30,11.2},{-12,11.2}},                   color={255,127,0}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.Controls.DXCoil.Validation.Controller\">
    Buildings.Controls.OBC.RooftopUnits.Controls.DXCoil.Validation.Controller</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    July 13, 2022, by Junke Wang and Karthik Devaprasad:<br/>
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
              points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Controller;
