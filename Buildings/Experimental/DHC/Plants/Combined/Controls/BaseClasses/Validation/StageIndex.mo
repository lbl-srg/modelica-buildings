within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.Validation;
model StageIndex
  extends Modelica.Icons.Example;

  Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.StageIndex
    sta(nSta=3, tSta=60) "Staging"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,0,0,0; 1,1,0,0; 2,1,1,1; 3,0,1,1; 4,1,0,0; 5,1,0,1; 6,1,1,0; 7,1,0,
        1],
    timeScale=100,
    period=1000) "Source signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(booTimTab.y[1], sta.u1) annotation (Line(points={{-38,0},{-20,0},{-20,
          6},{-12,6}}, color={255,0,255}));
  connect(booTimTab.y[2], sta.u1Up)
    annotation (Line(points={{-38,0},{-12,0}}, color={255,0,255}));
  connect(booTimTab.y[3], sta.u1Dow) annotation (Line(points={{-38,0},{-20,0},{-20,
          -5.8},{-12,-5.8}}, color={255,0,255}));

annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Controls/BaseClasses/Validation/StageIndex.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This is a validation model for the block
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.StageIndex\">
Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.StageIndex</a>.
</p>
</html>"));
end StageIndex;
