within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model SupervisoryController "ETS supervisory controller validation"
  extends Modelica.Icons.Example;
  FifthGeneration.Controls.Supervisory ETSCon(THys=1)
    "ETS main controller of the hot and chilled water circuits"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  FifthGeneration.BaseClasses.Constants cons(
    k={40 + 273.15,10 + 273.15},
    conNam={"TSetHea","TSetCoo"},
    nCon=2) "Multiple constant functions"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Pulse TTanHotTop(
    amplitude=5,
    width=50,
    period=500,
    offset=39 + 273.15)
  "Hot buffer tank top temperature. "
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.Pulse TTanHotBot(
    amplitude=5,
    width=50,
    period=500,
    offset=39 + 273.15)
  "Hot buffer tank bottom temperature. "
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Sources.Pulse TTanCooTop(
    amplitude=5,
    width=50,
    period=500,
    offset=9 + 273.15)
  "Cold buffer tank top temperature. "
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Pulse TTanColBot(
    amplitude=5,
    width=50,
    period=500,
    offset=9 + 273.15)
  "Cold buffer tank bottom temperature. "
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(cons.y[1], ETSCon.TSetHea) annotation (Line(points={{-39,-0.5},{-38,-0.5},
          {-38,5},{39,5}},               color={0,0,127}));
  connect(cons.y[2], ETSCon.TSetCoo) annotation (Line(points={{-39,0.5},{-38,0.5},
          {-38,-5},{39,-5}},              color={0,0,127}));
  connect(ETSCon.TTanHeaTop, TTanHotTop.y) annotation (Line(points={{39,9},{30,9},{30,40},{21,40}}, color={0,0,127}));
  connect(TTanHotBot.y, ETSCon.TTanHeaBot) annotation (Line(points={{-19,40},{-12,
          40},{-12,7},{39,7}}, color={0,0,127}));
  connect(TTanCooTop.y, ETSCon.TTanCooTop) annotation (Line(points={{21,-30},{32,
          -30},{32,-9},{39,-9}}, color={0,0,127}));
  connect(TTanColBot.y, ETSCon.TTanCooBot) annotation (Line(points={{-19,-30},{-14,
          -30},{-14,-7},{39,-7}}, color={0,0,127}));

annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Line(points={{-22,22}}, color={28,108,200})}),
        experiment(StopTime=1000,Tolerance=1e-06,__Dymola_Algorithm="Dassl"),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/ETSMainController.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the controller block
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Control.ETSMainController\">
Buildings.Applications.DHC.EnergyTransferStations.Control.ETSMainController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 20, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupervisoryController;
