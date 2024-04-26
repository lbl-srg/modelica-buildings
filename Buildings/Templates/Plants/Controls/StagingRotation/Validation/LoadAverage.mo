within Buildings.Templates.Plants.Controls.StagingRotation.Validation;
model LoadAverage "Validation model for heating and cooling load calculation"
  Buildings.Templates.Plants.Controls.StagingRotation.LoadAverage loaHea(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Heating,
    cp_default=4186,
    rho_default=1000) "Calculate heating load"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(k=60 + 273.15)
    "HWST setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin THeaWatRet(
    amplitude=10,
    freqHz=2/3000,
    phase=3.1415926535898,
    offset=THeaWatSupSet.k) "HWRT"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp V_flow(
    height=-0.1,
    duration=100,
    offset=0.1,
    startTime=1200) "Volume flow rate"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Templates.Plants.Controls.StagingRotation.LoadAverage loaCoo(
    typ=Buildings.Templates.Plants.Controls.Types.Application.Cooling,
    cp_default=4186,
    rho_default=1000) "Calculate cooling load"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=7 + 273.15)
    "CHWST setpoint"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    amplitude=5,
    freqHz=2/3000,
    phase=3.1415926535898,
    offset=TChiWatSupSet.k) "CHWRT"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(THeaWatSupSet.y, loaHea.TSupSet) annotation (Line(points={{-58,40},{20,
          40},{20,26},{38,26}}, color={0,0,127}));
  connect(TChiWatSupSet.y, loaCoo.TSupSet) annotation (Line(points={{-58,-20},{10,
          -20},{10,-14},{38,-14}}, color={0,0,127}));
  connect(THeaWatRet.y, loaHea.TRet)
    annotation (Line(points={{-28,20},{38,20}}, color={0,0,127}));
  connect(V_flow.y, loaHea.V_flow)
    annotation (Line(points={{2,0},{20,0},{20,14},{38,14}}, color={0,0,127}));
  connect(TChiWatRet.y, loaCoo.TRet) annotation (Line(points={{-28,-40},{30,-40},
          {30,-20},{38,-20}}, color={0,0,127}));
  connect(V_flow.y, loaCoo.V_flow) annotation (Line(points={{2,0},{20,0},{20,-26},
          {38,-26}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/StagingRotation/Validation/LoadAverage.mos"
        "Simulate and plot"),
    experiment(
      StopTime=2000.0,
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
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.LoadAverage\">
Buildings.Templates.Plants.Controls.StagingRotation.LoadAverage</a>
for heating and cooling applications.
</p>
</html>"));
end LoadAverage;
