within Buildings.Controls.OBC.RooftopUnits.DXCoil.Validation;
model Controller "Validation model for DX coil controller"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiCon(
    nCoi=3,
    conCooCoiLow=0.2,
    conCooCoiHig=0.8,
    uThrCooCoi=0.8,
    uThrCooCoi1=0.2,
    uThrCooCoi2=0.8,
    uThrCooCoi3=0.1,
    dUHys=0.01,
    timPer=480,
    timPer1=180,
    timPer2=300,
    timPer3=300,
    minComSpe=0.1,
    maxComSpe=1)
    "DX coil staging and compressor speed control"
    annotation (Placement(transformation(extent={{-10,-14},{10,14}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1[3](
    final pre_u_start=fill(false,3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramCooCoi(
    final height=0.5,
    final duration=3600,
    final offset=0.5) "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

equation
  connect(DXCoiCon.yDXCoi, pre1.u)
    annotation (Line(points={{12,5.6},{22,5.6},{22,0},{28,0}},
                                                           color={255,0,255}));
  connect(pre1.y, DXCoiCon.uDXCoi) annotation (Line(points={{52,0},{60,0},{60,
          30},{-20,30},{-20,11.2},{-12,11.2}},
                                             color={255,0,255}));
  connect(ramCooCoi.y, DXCoiCon.uCooCoi) annotation (Line(points={{-38,-50},{-20,
          -50},{-20,-11.2},{-12,-11.2}}, color={0,0,127}));
  connect(con1.y, DXCoiCon.uDXCoiAva) annotation (Line(points={{-38,40},{-30,40},
          {-30,5.6},{-12,5.6}},   color={255,0,255}));
  connect(conInt.y, DXCoiCon.uCoiSeq) annotation (Line(points={{-38,-4},{-25,-4},
          {-25,-5.32},{-12,-5.32}},                 color={255,127,0}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller\">
    Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller</a>.
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the availablity of the first DX coil is ture <code>con1[1].y=true</code> and its sequencing order is set to 1 <code>conInt[1].y=1</code>, 
    the controller enables this coil <code>DXCoiCon.yDXCoi[1]=true</code> and adjusts the compressor speed <code>DXCoiCon.yComSpe[1]</code> 
    once the cooling coil valve position signal <code>DXCoiCon.uCooCoi</code> remains above 0.8 for a continuous duration of 300 seconds. 
    </li>
    <li>
    When <code>con1[2].y=true</code> and <code>conInt[2].y=2</code>, 
    the controller stages up the subsequent available coil <code>DXCoiCon.yDXCoi[2]=true</code> and adjusts <code>DXCoiCon.yComSpe[2]</code> 
    once <code>DXCoiCon.uCooCoi</code> remains consistently above 0.8 for a continuous duration of 480 seconds. 
    </li>
    <li>
    When <code>con1[3].y=true</code> and <code>conInt[3].y=3</code>, 
    the controller continually stages up the next available coil <code>DXCoiCon.yDXCoi[3]=true</code> and adjusts <code>DXCoiCon.yComSpe[3]</code> 
    once <code>DXCoiCon.uCooCoi</code> remains consistently above 0.8 for a continuous duration of 480 seconds. 
    </li>
    </ul>
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    August 8, 2022, by Junke Wang and Karthik Devaprasad:<br/>
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
