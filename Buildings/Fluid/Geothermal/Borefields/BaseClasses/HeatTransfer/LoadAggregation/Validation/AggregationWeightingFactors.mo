within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.Validation;
model AggregationWeightingFactors
  "This validation case verifies the calculation of the weighting factors kappa"
  extends Modelica.Icons.Example;

  parameter Real[6,2] timSer=
    [0, 0;
    0.999999999999999, 7.96581783184631e-06;
    2.30986142530843, 1.36683711896241e-05;
    4.02559837881946, 1.89652463558340e-05;
    6.27297603019976, 2.43435015306157e-05;
    9.21672932384307, 3.00295537091117e-05]
    "Complete time matrix with TStep";
  Modelica.Units.SI.ThermalResistance[10] kappa
    "Weight factor for each aggregation cell";

equation
  kappa = Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation.aggregationWeightingFactors(
    i=10,
    nTimTot=6,
    TStep=timSer,
    nu=cat(1,linspace(0.4,2,5),linspace(2.8,6,5)));

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/LoadAggregation/Validation/AggregationWeightingFactors.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This validation case uses the first few values of a borehole temperature reponse
time series to construct the weighting factors <code>kappa</code>. The aggregation
cells are chosen such that there is a change in levels (and therefore a doubling
in the size of the cells) from cell 5 to 6. Therefore, <code>kappa[5]</code> is lower than
<code>kappa[4]</code> and <code>kappa[7]</code> is lower than <code>kappa[6]</code>, but
<code>kappa[6]</code> is higher than <code>kappa[5]</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end AggregationWeightingFactors;
