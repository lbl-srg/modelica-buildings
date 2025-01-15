within Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.Validation;
model TDewPoi_TDryBulPhi
  "Model to test the dew point temperature computation"

  Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.TDewPoi_TDryBulPhi dewBulPhi
   "Model for dew point temperature"
    annotation (Placement(transformation(extent={{16,74},{36,94}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant p(k=101325) "Pressure"
     annotation (Placement(transformation(extent={{-94,8}, {-74,28}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp phi(
    duration=1,
    height=1,
    offset=0.001) "Relative humidity"
    annotation (Placement(transformation(extent={{-94,40},{-74,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TDryBul(k=273.15 + 29.4)
    "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-94,74},{-74,94}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant p2(k=101325) "Pressure"
    annotation (Placement(transformation(extent={{-94,-94},{-74,-74}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TDryBul2(
    duration=1,
    height=35,
    offset=273.15+2.0) "Dry bulb temperature"
    annotation (Placement(transformation(extent={{-94,-28},{-74,-8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant phi2(k=0.4)
    "Relative humidity"
    annotation (Placement(transformation(extent={{-94,-60},{-74,-40}})));

 // ============ Below blocks are from Buildings Library ============
  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewPoi "Dew point temperature"
    annotation (Placement(transformation(extent={{18,4},{38,24}})));
  Buildings.Utilities.Psychrometrics.X_pTphi X_pTphi "Steam mass fraction"
    annotation (Placement(transformation(extent={{-46,4},{-26,24}})));
  Buildings.Utilities.Psychrometrics.pW_X humRat(use_p_in=false)
    "Water vapor pressure"
    annotation (Placement(transformation(extent={{-12,4},{8,24}})));
  // ===================================================================

  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Dew point temperature difference"
    annotation (Placement(transformation(extent={{52,40},{72,60}})));
  Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.TDewPoi_TDryBulPhi dewBulPhi1
   "Model for dew point temperature"
    annotation (Placement(transformation(extent={{18,-28},{38,-8}})));
  Buildings.Utilities.Psychrometrics.TDewPoi_pW TDewPoi1
    "Dew point temperature"
    annotation (Placement(transformation(extent={{20,-98},{40,-78}})));
  Buildings.Utilities.Psychrometrics.pW_X humRat1(use_p_in=false)
    "Water vapor pressure"
    annotation (Placement(transformation(extent={{-10,-98},{10,-78}})));
  Buildings.Utilities.Psychrometrics.X_pTphi X_pTphi1 "Steam mass fraction"
    annotation (Placement(transformation(extent={{-44,-98},{-24,-78}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Dew point temperature difference"
    annotation (Placement(transformation(extent={{52,-60},{72,-40}})));

equation
  connect(humRat.p_w, TDewPoi.p_w)
    annotation (Line(points={{9,14},{12,14},{17,14}},
      color={0,0,127}));
  connect(X_pTphi.X[1], humRat.X_w)
    annotation (Line(points={{-25,14},{-22,14},{-13,14}},
      color={0,0,127}));
  connect(TDryBul.y, dewBulPhi.TDryBul)
    annotation (Line(points={{-72,84},{-68,84},{-68,92},{14,92}},
      color={0,0,127}));
  connect(phi.y, dewBulPhi.phi)
    annotation (Line(points={{-72,50},{-62,50},{-62,84},{14,84}},
      color={0,0,127}));
  connect(p.y, dewBulPhi.p)
    annotation (Line(points={{-72,18},{-56,18},{-56,76},{14,76}},
      color={0,0,127}));
  connect(p.y, X_pTphi.p_in)
    annotation (Line(points={{-72,18},{-56,18},{-56,20},{-48,20}},
      color={0,0,127}));
  connect(TDryBul.y, X_pTphi.T)
    annotation (Line(points={{-72,84},{-68,84},{-68,14},{-48,14}},
      color={0,0,127}));
  connect(phi.y, X_pTphi.phi)
    annotation (Line(points={{-72,50},{-62,50},{-62,8},{-48,8}},
      color={0,0,127}));
  connect(TDewPoi.T, sub.u2)
    annotation (Line(points={{39,14},{44,14},{44,44},{50,44}},
      color={0,0,127}));
  connect(dewBulPhi.TDewPoi, sub.u1)
    annotation (Line(points={{38,84},{42,84},{42,56},{50,56}},
      color={0,0,127}));
  connect(TDryBul2.y, dewBulPhi1.TDryBul)
    annotation (Line(points={{-72,-18},{-68,-18},{-68,-10},{16,-10}},
      color={0,0,127}));
  connect(TDryBul2.y, X_pTphi1.T)
    annotation (Line(points={{-72,-18},{-68,-18},{-68,-88},{-46,-88}},
      color={0,0,127}));
  connect(p2.y, X_pTphi1.p_in)
    annotation (Line(points={{-72,-84},{-56,-84},{-56,-82},{-46,-82}},
      color={0,0,127}));
  connect(p2.y, dewBulPhi1.p)
    annotation (Line(points={{-72,-84},{-56,-84},{-56,-26},{16,-26}},
      color={0,0,127}));
  connect(phi2.y, dewBulPhi1.phi)
    annotation (Line(points={{-72,-50},{-62,-50},{-62,-18},{16,-18}},
      color={0,0,127}));
  connect(phi2.y, X_pTphi1.phi)
    annotation (Line(points={{-72,-50},{-62,-50},{-62,-94},{-46,-94}},
      color={0,0,127}));
  connect(X_pTphi1.X[1], humRat1.X_w)
    annotation (Line(points={{-23,-88},{-11,-88},{-11,-88}},
      color={0,0,127}));
  connect(humRat1.p_w, TDewPoi1.p_w)
    annotation (Line(points={{11,-88},{19,-88},{19,-88}},
      color={0,0,127}));
  connect(dewBulPhi1.TDewPoi, sub1.u1)
    annotation (Line(points={{40,-18},{44,-18},{44,-44},{50,-44}},
      color={0,0,127}));
  connect(TDewPoi1.T, sub1.u2)
    annotation (Line(points={{41,-88},{46,-88},{46,-56},{50,-56}},
      color={0,0,127}));

annotation (experiment(StopTime=1.0, Tolerance = 1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Psychrometrics/Validation/TDewPoi_TDryBulPhi.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This examples is a unit test for the dew point temperature computation <a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.TDewPoi_TDryBulPhi\">
Buildings.Obsolete.Controls.OBC.CDL.Psychrometrics.TDewPoi_TDryBulPhi</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TDewPoi_TDryBulPhi;
