within Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Validation;
model Enable
  "Validate sequence for enabling and disabling DX coils"

  Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable coiEna(
    final nCoi=1,
    final dUHys=0.01)
    "Enable DX coil array"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pulCooCoi(
    final amplitude=0.9,
    final width=0.6,
    final period=1800,
    final offset=0.05)
    "Cooling coil valve position"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold coiEnaSig(
    final trueHoldDuration=10)
    "Hold pulse signal for easy visualization"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Feedback delay"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));

equation
  connect(coiEna.yDXCoi, coiEnaSig.u)
    annotation (Line(points={{12,0},{38,0}}, color={255,0,255}));
  connect(coiEna.yDXCoi, pre1.u) annotation (Line(points={{12,0},{20,0},{20,40},
          {38,40}}, color={255,0,255}));
  connect(pre1.y, coiEna.uDXCoi[1]) annotation (Line(points={{62,40},{70,40},{
          70,60},{-20,60},{-20,6},{-12,6}},
                                         color={255,0,255}));

  connect(pulCooCoi.y, coiEna.uCoi) annotation (Line(points={{-38,-40},{-20,-40},
          {-20,-6},{-12,-6}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RooftopUnits/DXCoil/Subsequences/Validation/Enable.mos"
    "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the controller
    <a href=\"modelica://Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable\">
    Buildings.Controls.OBC.RooftopUnits.DXCoil.Subsequences.Enable</a>. 
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the coil valve position <code>coiEna.uCoi</code> exceeds the threshold 
    <code>coiEna.uThrCoiEna</code> set at 0.8 for a duration of <code>coiEna.timPerEna</code> 
    amounting to 300 seconds, and no changes in DX coil status <code>coiEna.uDXCoi[1]</code> 
    are detected, the controller enables the DX coil array <code>coiEna.yDXCoi=true</code>. 
    </li>
    <li>
    When <code>coiEna.uCoi</code> falls below the threshold <code>coiEna.uThrCoiDis</code> set at 0.1 
    for a duration of <code>coiEna.timPerDis</code> amounting to 300 seconds, and no changes in 
    <code>coiEna.uDXCoi[1]</code> are detected, the controller initiates staging down 
    of the DX coil <code>coiEna.yDXCoi=false</code>. 
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    August 7, 2023, by Junke Wang and Karthik Devaprasad:<br/>
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
end Enable;
