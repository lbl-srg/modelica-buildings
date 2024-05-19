within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.Validation;
model PumpSpeedLimits
    "Validation model for PumpSpeedLimits sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits
    pumSpeLim(
    final have_varPriPum=true,
    final nSta=1,
    final minSecPumSpe=0.1,
    final minPriPumSpeSta={0.2})
    "Testing scenario with variable primary pumps"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits
    pumSpeLim1(
    final have_varPriPum=false,
    final nSta=1,
    final minSecPumSpe=0.1,
    final minPriPumSpeSta={0.2})
    "Testing scenario with fixed-speed primary pumps"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Sine sin(
    final amplitude=0.6,
    final freqHz=1/60,
    final offset=0.50)
    "Sine input"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant Integer source"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

equation
  connect(conInt.y, pumSpeLim.uCurSta) annotation (Line(points={{-8,20},{0,20},
          {0,25},{8,25}}, color={255,127,0}));
  connect(sin.y, pumSpeLim.uRegSig) annotation (Line(points={{-8,-20},{0,-20},{
          0,15},{8,15}}, color={0,0,127}));
  connect(sin.y, pumSpeLim1.uRegSig) annotation (Line(points={{-8,-20},{0,-20},
          {0,-25},{8,-25}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=false)),
    experiment(
      StopTime=60,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/SetPoints/Subsequences/Validation/PumpSpeedLimits.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.SetPoints.Subsequences.PumpSpeedLimits</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      July 22, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end PumpSpeedLimits;
