within Buildings.Controls.OBC.CDL.Psychrometrics.Validation;
model WetBulb_TDryBulPhi
  "Model to test the wet bulb temperature computation"
  package Medium=Buildings.Media.Air
    "Medium model"
    annotation (choicesAllMatching=true);
  Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi wetBulPhi
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{-10,46},{10,66}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant p(
    k=101325)
    "Pressure"
    annotation (Placement(transformation(extent={{-90,-34},{-70,-14}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp phi(
    duration=1,
    height=0.95,
    offset=0.05)
    "Relative humidity"
    annotation (Placement(transformation(extent={{-90,6},{-70,26}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TDryBul(
    k=273.15+29.4)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-90,46},{-70,66}})));
  // ============ Below blocks are from Buildings Library ============
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBulPhi_BuiLib(
    redeclare package Medium=Medium,
    approximateWetBulb=true)
    "Model for wet bulb temperature"
    annotation (Placement(transformation(extent={{-10,6},{10,26}})));
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBulXi(
    redeclare package Medium=Medium,
    approximateWetBulb=true)
    "Model for wet bulb temperature using Xi as an input, used to verify consistency with wetBulPhi"
    annotation (Placement(transformation(extent={{-10,-34},{10,-14}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi
    "Computes mass fraction"
    annotation (Placement(transformation(extent={{-32,-30},{-20,-18}})));
  // ===================================================================
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Wet bulb temperature difference"
    annotation (Placement(transformation(extent={{40,6},{60,26}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Wet bulb temperature difference"
    annotation (Placement(transformation(extent={{40,-34},{60,-14}})));

equation
  connect(x_pTphi.X[1],wetBulXi.Xi[1])
    annotation (Line(points={{-19.4,-24},{-11,-24}},color={0,0,127}));
  connect(TDryBul.y,wetBulPhi.TDryBul)
    annotation (Line(points={{-68,56},{-40,56},{-40,62},{-12,62}},color={0,0,127}));
  connect(TDryBul.y,wetBulPhi_BuiLib.TDryBul)
    annotation (Line(points={{-68,56},{-40,56},{-40,24},{-11,24}},color={0,0,127}));
  connect(TDryBul.y,wetBulXi.TDryBul)
    annotation (Line(points={{-68,56},{-40,56},{-40,-10},{-16,-10},{-16,-16},{-11,-16}},color={0,0,127}));
  connect(p.y,x_pTphi.p_in)
    annotation (Line(points={{-68,-24},{-52,-24},{-52,-20.4},{-33.2,-20.4}},color={0,0,127}));
  connect(phi.y,x_pTphi.phi)
    annotation (Line(points={{-68,16},{-46,16},{-46,-27.6},{-33.2,-27.6}},color={0,0,127}));
  connect(p.y,wetBulXi.p)
    annotation (Line(points={{-68,-24},{-52,-24},{-52,-32},{-11,-32}},color={0,0,127}));
  connect(phi.y,wetBulPhi_BuiLib.phi)
    annotation (Line(points={{-68,16},{-11,16}},color={0,0,127}));
  connect(phi.y,wetBulPhi.phi)
    annotation (Line(points={{-68,16},{-46,16},{-46,52},{-28,52},{-28,50},{-12,50}},color={0,0,127}));
  connect(p.y,wetBulPhi_BuiLib.p)
    annotation (Line(points={{-68,-24},{-52,-24},{-52,8},{-11,8}},color={0,0,127}));
  connect(TDryBul.y,x_pTphi.T)
    annotation (Line(points={{-68,56},{-40,56},{-40,-24},{-33.2,-24}},color={0,0,127}));
  connect(wetBulPhi.TWetBul,sub.u1)
    annotation (Line(points={{12,56},{22,56},{22,22},{38,22}},color={0,0,127}));
  connect(wetBulPhi_BuiLib.TWetBul,sub.u2)
    annotation (Line(points={{11,16},{28,16},{28,10},{38,10}},color={0,0,127}));
  connect(sub1.u1,sub.u1)
    annotation (Line(points={{38,-18},{22,-18},{22,30},{22,30},{22,22},{38,22}},color={0,0,127}));
  connect(wetBulXi.TWetBul,sub1.u2)
    annotation (Line(points={{11,-24},{28,-24},{28,-30},{38,-30}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Psychrometrics/Validation/WetBulb_TDryBulPhi.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This examples is a unit test for the dew point temperature computation
<a href=\"modelica://Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi\">
Buildings.Controls.OBC.CDL.Psychrometrics.WetBulb_TDryBulPhi</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 29, 2020, by Michael Wetter:<br/>
Renamed model and updated for new input of the psychrometric blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2139\">issue 2139</a>
</li>
<li>
April 7, 2017, by Jianjun Hu:<br/>
First implementation in CDL package.
</li>
<li>
June 23, 2016, by Michael Wetter:<br/>
Changed graphical annotation.
</li>
<li>
May 24, 2016, by Filip Jorissen:<br/>
Updated example with validation data.
See  <a href=\"https://github.com/ibpsa/modelica/issues/474\">#474</a>
for a discussion.
</li>
<li>
October 1, 2012 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end WetBulb_TDryBulPhi;
