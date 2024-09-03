within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation;
model ShiftAggregationCells "This validation case test the cell shifting procedure"
  extends Modelica.Icons.Example;

  discrete Integer curCel "Current occupied cell";
  discrete Modelica.Units.SI.HeatFlowRate[5] QAggShi_flow
    "Shifted vector of aggregated loads";

initial equation
  curCel=3;
  QAggShi_flow={1,3,2,0,0};

equation
  when (sample(4, 1)) then
    (curCel,QAggShi_flow) = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.shiftAggregationCells(
        i=5,
        QAgg_flow=pre(QAggShi_flow),
        rCel={1,1,1,2,2},
        nu={1,2,3,5,7},
        curTim=time);
  end when;

annotation (experiment(StartTime=3.5,StopTime=5.5,Tolerance=1e-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/LoadAggregation/Validation/ShiftAggregationCells.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case replicates the load-shifting procedure illustred in the figure below by Cimmino (2014).
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Geothermal/Borefields/LoadAggregation_01.png\" />
</p>
<h4>References</h4>
<p>
Cimmino, M. 2014. <i>D&eacute;veloppement et validation exp&eacute;rimentale de facteurs de r&eacute;ponse
thermique pour champs de puits g&eacute;othermiques</i>,
Ph.D. Thesis, &Eacute;cole Polytechnique de Montr&eacute;al.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShiftAggregationCells;
