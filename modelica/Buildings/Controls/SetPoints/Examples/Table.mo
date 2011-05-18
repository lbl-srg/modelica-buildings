within Buildings.Controls.SetPoints.Examples;
model Table "Test model for table that determines set points"
  extends Modelica.Icons.Example; 
  import Buildings;
  Buildings.Controls.SetPoints.Table tabConExt(table=[20,0; 22,0.5; 25,0.5; 26,1])
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Ramp TRoo(
    duration=1,
    offset=15,
    height=15)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.SetPoints.Table tabLinExt(constantExtrapolation=false, table=[
        20,0; 22,0.5; 25,0.5; 26,1])
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(TRoo.y, tabLinExt.u) annotation (Line(
      points={{-59,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo.y, tabConExt.u) annotation (Line(
      points={{-59,10},{-50,10},{-50,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/SetPoints/Examples/Table.mos" "Simulate and plot"),
              Diagram(graphics));
end Table;
