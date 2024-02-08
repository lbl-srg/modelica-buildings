within Buildings.Controls.OBC.RooftopUnits.DXCoil.Validation;
model Controller
  "Validation model for DX coil controller"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Controller DXCoiCon(
    final nCoi=3,
    final uThrCoiUp=0.8,
    final uThrCoiDow=0.2,
    final dUHys=0.01)
    "DX coil staging and compressor speed control"
    annotation (Placement(transformation(extent={{-10,6},{10,34}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[3](
    final pre_u_start=fill(false,3))
    "Logical Pre block"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[3](
    final k={1,2,3})
    "Constant integer signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramCoi(
    final height=0.2,
    final duration=3600,
    final offset=0.8)
    "Coil valve position"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[3](
    final k={true,true,true})
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pulComSpe[3](
    final period=fill(900, 3))
    "Coil valve position"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));

equation
  connect(DXCoiCon.yDXCoi, pre1.u)
    annotation (Line(points={{12,20},{28,20}},             color={255,0,255}));
  connect(pre1.y, DXCoiCon.uDXCoi) annotation (Line(points={{52,20},{60,20},{60,
          50},{-20,50},{-20,25.6},{-12,25.6}},
                                             color={255,0,255}));
  connect(ramCoi.y, DXCoiCon.uCoi) annotation (Line(points={{-38,-20},{-30,-20},
          {-30,14.4},{-12,14.4}},        color={0,0,127}));
  connect(con1.y, DXCoiCon.uDXCoiAva) annotation (Line(points={{-38,60},{-30,60},
          {-30,31.2},{-12,31.2}}, color={255,0,255}));
  connect(conInt.y, DXCoiCon.uCoiSeq) annotation (Line(points={{-38,20},{-12,20}},
                                                    color={255,127,0}));

  connect(pulComSpe.y, DXCoiCon.uComSpe) annotation (Line(points={{-38,-60},{-20,
          -60},{-20,8.8},{-12,8.8}}, color={0,0,127}));
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
    When the availablity of the first DX coil is ture <code>DXCoiCon.uDXCoiAva[1]=true</code> 
    and its sequencing order is set to 1 <code>DXCoiCon.uCoiSeq[1]=1</code>, 
    the controller enables this coil <code>DXCoiCon.yDXCoi[1]=true</code>
    once the coil valve position signal <code>DXCoiCon.uCoi</code> remains 
    above 0.8 for a continuous duration of 300 seconds. 
    </li>
    <li>
    When <code>DXCoiCon.uDXCoiAva[2]=true</code> and <code>DXCoiCon.uCoiSeq[2]=2</code>, 
    the controller stages up the subsequent available coil <code>DXCoiCon.yDXCoi[2]=true</code>
    once <code>DXCoiCon.uCoi</code> remains consistently above 0.8 for a continuous duration of 480 seconds. 
    </li>
    <li>
    When <code>DXCoiCon.uDXCoiAva[3]=true</code> and <code>DXCoiCon.uCoiSeq[3]=3</code>, 
    the controller continually stages up the next available coil <code>DXCoiCon.yDXCoi[3]=true</code>
    once <code>DXCoiCon.uCoi</code> remains consistently above 0.8 for a continuous duration of 480 seconds. 
    </li>
    <li>
    When the compressor speed ratio <code>DXCoiCon.uComSpe</code> falls below a threshold of coil valve position 
    <code>uThrCoiDow</code> of 0.2 for the duration <code>timPerDow</code> of 180 seconds, 
    the controller stages down the last enabled DX coil <code>DXCoiCon.yDXCoi=false</code>. 
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
