within Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.Validation;
model ChillerStage
  "Example to test the chiller staging controller"
  extends Modelica.Icons.Example;
  Buildings.Experimental.DHC.CentralPlants.Cooling.Controls.ChillerStage chiStaCon(
    tWai=30,
    QEva_nominal=-200*3.517*1000)
    "Chiller staging controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.BooleanTable on(
    table(
      each displayUnit="s")={300,900})
    "On signal of the cooling plant"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Sine QTot(
    amplitude=0.5*chiStaCon.QEva_nominal,
    freqHz=1/300,
    offset=0.5*chiStaCon.QEva_nominal)
    "Total cooling load"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(on.y,chiStaCon.on)
    annotation (Line(points={{-39,30},{-28,30},{-28,4},{-12,4}},color={255,0,255}));
  connect(QTot.y,chiStaCon.QLoa)
    annotation (Line(points={{-39,-30},{-28,-30},{-28,-4},{-12,-4}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    experiment(
      StopTime=1200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="Resources/Scripts/Dymola/Experimental/DHC/CentralPlants/Cooling/Controls/Validation/ChillerStage.mos" "Simulate and Plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model validates the chiller staging control logic implemented in <a href=\"modelica://Buildings.Applications.DHC.CentralPlants.Cooling.Controls.ChillerStage\">Buildings.Applications.DHC.CentralPlants.Cooling.Controls.ChillerStage</a>.</p>
</html>"));
end ChillerStage;
