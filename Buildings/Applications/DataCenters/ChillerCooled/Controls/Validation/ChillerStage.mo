within Buildings.Applications.DataCenters.ChillerCooled.Controls.Validation;
model ChillerStage
  "Test the model ChillerWSE.Examples.BaseClasses.ChillerStageControl"
  extends Modelica.Icons.Example;

  Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage chiStaCon(
    tWai=30,
    QEva_nominal=-100*3.517*1000,
    dT=0.5)
    "Staging controller for chillers"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant QTot(
    k=0.55*chiStaCon.QEva_nominal)
    "Total cooling load in chillers"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.IntegerTable cooMod(
    table=[0,0;
           360,1;
           720,2;
           1080,3])
    "Cooling mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Pulse TCHWSup(
    amplitude=2,
    period=360,
    offset=273.15 + 5) "WSE chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(QTot.y, chiStaCon.QTot)
    annotation (Line(points={{-39,0},{-39,0},{-12,0}},
                            color={0,0,127}));
  connect(cooMod.y, chiStaCon.cooMod)
    annotation (Line(points={{-39,50},{-26,50},{-26,6},{-12,6}},
                            color={255,127,0}));
  connect(TCHWSup.y, chiStaCon.TCHWSup)
    annotation (Line(points={{-39,-30},{-26,-30},{-26,-6},{-12,-6}},
                                 color={0,0,127}));
  annotation (    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Controls/Validation/ChillerStage.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example test the chiller staging controller implemented in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage</a>.
</p>
<p>
The number of running chillers is determined by cooling mode signal and total cooling load. In Free Cooling
(FC) mode, no chillers are required; in Partial Mechanic Cooling (PMC) mode and Fully Mechanic Cooling (FMC) mode,
chillers are required to run and the running number is based on cooling load. Details can be found in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage\">
Buildings.Applications.DataCenters.ChillerCooled.Controls.ChillerStage</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=1440,
      Tolerance=1e-06));
end ChillerStage;
