within Buildings.Controls.OBC.Utilities.SetPoints.Validation;
model SupplyReturnTemperatureResetExponent
  "Test model for the heating curve with different exponent"
  Buildings.Controls.OBC.Utilities.SetPoints.SupplyReturnTemperatureReset heaCur(
    m=1,
    TSup_nominal=313.15,
    TRet_nominal=308.15,
    TOut_nominal=263.15)
    "Compute the supply and return set point of heating systems with varying outdoor temperature and m=1"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    height=30,
    duration=1,
    offset=258.15,
    y(unit="K"))
    "Outdoor temperature varying from -10 degC to 30 degC"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TRoo(
    k=273.15+20,
    y(unit="K"))
    "Room temperature 20 degC"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.Utilities.SetPoints.SupplyReturnTemperatureReset heaCurM(
    m=1.3,
    TSup_nominal=313.15,
    TRet_nominal=308.15,
    TOut_nominal=263.15)
    "Compute the supply and return set point of heating systems with varying outdoor temperature and m=1.3"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(TOut.y,heaCur.TOut)
    annotation (Line(points={{-38,60},{-38,60},{0,60},{0,46},{18,46}},color={0,0,127}));
  connect(TRoo.y,heaCur.TSetZon)
    annotation (Line(points={{-38,20},{-10,20},{-10,34},{18,34}},color={0,0,127}));
  connect(heaCurM.TOut,TOut.y)
    annotation (Line(points={{18,-4},{0,-4},{0,60},{-38,60}},color={0,0,127}));
  connect(TRoo.y,heaCurM.TSetZon)
    annotation (Line(points={{-38,20},{-10,20},{-10,-16},{18,-16}},color={0,0,127}));
  annotation (
    experiment(
      Tolerance=1e-6,
      StopTime=1.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/SetPoints/Validation/SupplyReturnTemperatureResetExponent.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Example that demonstrates the use of the hot water temperature reset
for a heating system.
Both instances are identical except that <code>heaCurM</code> sets <i>m=1.3</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
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
end SupplyReturnTemperatureResetExponent;
