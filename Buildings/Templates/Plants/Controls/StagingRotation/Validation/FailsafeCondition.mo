within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model FailsafeCondition "Validation model for failsafe staging logic"
  Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition
    faiSafHea(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    have_pumSec=true,
    dT=2.5) "Failsafe stage up condition for heating applications"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(k=60 + 273.15)
    "HWST setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatPriSup(
    amplitude=5,
    freqHz=1/3000,
    offset=THeaWatSupSet.k) "PHWST"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatSecSup(
    amplitude=5,
    freqHz=1/3000,
    phase=1.7453292519943,
    offset=THeaWatSupSet.k) "SHWST"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse         booPul(
    width=1/2000,                                                 period=2000,
    shift=100)
    "Reset" annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition
    faiSafCooPri(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    have_pumSec=false,
    dT=1) "Failsafe stage up condition – Cooling application, primary-only"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=7 + 273.15)
    "CHWST setpoint"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatPriSup(
    amplitude=3,
    freqHz=1/3000,
    offset=TChiWatSupSet.k) "PCHWST"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatSecSup(
    amplitude=3,
    freqHz=1/3000,
    phase=1.7453292519943,
    offset=TChiWatSupSet.k) "SCHWST"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition
    faiSafCoo(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    have_pumSec=true,
    dT=1) "Failsafe stage up condition – Cooling application"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
equation
  connect(THeaWatSupSet.y, faiSafHea.TSupSet) annotation (Line(points={{-58,40},
          {10,40},{10,24},{38,24}},
                                  color={0,0,127}));
  connect(THeaWatPriSup.y, faiSafHea.TPriSup) annotation (Line(points={{-28,20},
          {6,20},{6,20},{38,20}}, color={0,0,127}));
  connect(THeaWatSecSup.y, faiSafHea.TSecSup) annotation (Line(points={{2,0},{6,
          0},{6,16},{38,16}},        color={0,0,127}));
  connect(booPul.y, faiSafHea.reset) annotation (Line(points={{-58,80},{20,80},
          {20,28},{38,28}},
                        color={255,0,255}));
  connect(TChiWatSupSet.y, faiSafCooPri.TSupSet) annotation (Line(points={{-58,
          -20},{10,-20},{10,-16},{38,-16}}, color={0,0,127}));
  connect(TChiWatPriSup.y, faiSafCooPri.TPriSup) annotation (Line(points={{-28,
          -40},{16,-40},{16,-20},{38,-20}}, color={0,0,127}));
  connect(booPul.y, faiSafCooPri.reset) annotation (Line(points={{-58,80},{20,
          80},{20,-12},{38,-12}}, color={255,0,255}));
  connect(TChiWatSupSet.y, faiSafCoo.TSupSet) annotation (Line(points={{-58,-20},
          {10,-20},{10,-56},{38,-56}}, color={0,0,127}));
  connect(booPul.y, faiSafCoo.reset) annotation (Line(points={{-58,80},{20,80},
          {20,-52},{38,-52}}, color={255,0,255}));
  connect(TChiWatPriSup.y, faiSafCoo.TPriSup) annotation (Line(points={{-28,-40},
          {16,-40},{16,-60},{38,-60}}, color={0,0,127}));
  connect(TChiWatSecSup.y, faiSafCoo.TSecSup) annotation (Line(points={{2,-60},
          {6,-60},{6,-64},{38,-64}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/FailsafeCondition.mos"
        "Simulate and plot"),
    experiment(
      StopTime=5000.0,
      Tolerance=1e-06),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Documentation(revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition\">
Buildings.Templates.Plants.Controls.StagingRotation.FailsafeCondition</a>
for the following configurations.
</p>
<ul>
<li>
Heating plant with primary-secondary distribution (component <code>faiSafHea</code>)
</li>
<li>
Cooling plant with primary-only distribution (component <code>faiSafCoo</code>)
</li>
<li>
Cooling plant with primary-only distribution (component <code>faiSafCooPri</code>)
</li>
</ul>
</html>"));
end FailsafeCondition;
