within Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls.Examples;
model ChillerStage "Example to test the chiller staging controller"
  extends Modelica.Icons.Example;

  Buildings.Applications.DHC.CentralPlants.Gen1st.Cooling.Controls.ChillerStage
    chiStaCon(tWai=30,QEva_nominal=-200*3.517*1000)
    "Chiller staging controller"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Pulse QTot(
    amplitude=0.6*chiStaCon.QEva_nominal,
    period=300,
    offset=0.2*chiStaCon.QEva_nominal,
    startTime=150) "Total district cooling load"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Modelica.Blocks.Sources.BooleanTable on(table(displayUnit="s") = {300,900})
    "On signal of the cooling plant"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(QTot.y, chiStaCon.QLoa) annotation (Line(points={{-39,-30},{-28,-30},{
          -28,-4},{-12,-4}}, color={0,0,127}));
  connect(on.y, chiStaCon.on) annotation (Line(points={{-39,30},{-28,30},{-28,4},
          {-12,4}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1200, Tolerance=1e-06),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/CentralPlants/Cooling/Controls/Examples/ChillerStage.mos"
        "Simulate and Plot"));
end ChillerStage;
