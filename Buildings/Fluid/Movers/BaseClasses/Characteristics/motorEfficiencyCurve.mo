within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function motorEfficiencyCurve
  "This function generates the generic curve for motor efficiency based on rated motor power"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Power P_nominal "Rated input power of the motor";
  input Modelica.Units.SI.Efficiency eta_max "Maximum motor efficiency";
  // Below, default values are assigned so that that dimensions are known.
  output Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    motorEfficiency_yMot(
        y={0, 0.1, 0.2, 0.3, 0.4, 0.6, 0.8, 1, 1.2},
        eta=zeros(nPoi)) "Motor efficiency vs. motor part load ratio";

protected
  constant Modelica.Units.SI.Power u2[nSiz]={700, 2500, 7500, 15000, 35000, 70000, 80000, 90000}
    "Rated motor input power";
  constant Integer nSiz=8 "Number of motor sizes";
  constant Integer nPoi=9 "Size";
  // Two rows and two columns of 1 are added to the ends of the table in order to
  //   prevent the lookup table from producing values larger than 1.
  constant Real[nPoi, nSiz] tab=
    [             1E-6,              1E-6,              1E-6,              1E-6,              1E-6,              1E-6, 1E-6, 1E-6;
     0.319836509737628, 0.329886760993909, 0.458027464511497, 0.576112127457564, 0.643957112752703, 0.724359122802955,    1,    1;
     0.551721742352314, 0.613279531297038, 0.752726767477942, 0.843179028784475, 0.903480536322164, 0.962525762452817,    1,    1;
     0.716480140443274, 0.804199438688888, 0.886622050343885, 0.936873306625292, 0.956973809137855, 0.987124562906699,    1,    1;
     0.816999745270129, 0.922527383461084, 0.950165574415858, 0.980316328184702,                 1,                 1,    1,    1;
     0.906409929833499,                 1,                 1,                 1,                 1,                 1,    1,    1;
     0.956863812148299,                 1,                 1,                 1,                 1,                 1,    1,    1;
                     1,                 1,                 1,                 1,                 1,                 1,    1,    1;
                     1,                 1,                 1,                 1,                 1,                 1,    1,    1]
    "Generic motor efficiency table (eta / eta_max)";
algorithm
  if P_nominal>1E-6 then
    for j in 1:nPoi loop
      motorEfficiency_yMot.eta[j]:=eta_max * Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=P_nominal,
        xSup=u2,
        ySup=tab[j, :],
        ensureMonotonicity=true);
    end for;
  else
    motorEfficiency_yMot.eta := 0.7*ones(nPoi);
  end if;

annotation (Documentation(info="<html>
<p>
This function generates a generic motor efficiency curve based on the
rated motor power input and maximum motor efficiency according to U.S. DOE (2014)
(shown below). It returns a constant array if the rated power is unavailable.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/BaseClasses/Characteristics/MotorEfficiencyCurves.png\"
width=\"500\"/>
</p>
<h4>References</h4>
<p>
U.S. DOE (2014).
<i>Determining Electric Motor Load and Efficiency.</i>
URL:
<a href=\"https://www.energy.gov/sites/prod/files/2014/04/f15/10097517.pdf\">
https://www.energy.gov/sites/prod/files/2014/04/f15/10097517.pdf</a>
</p>
</html>", revisions="<html>
<ul>
<li>April 5, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end motorEfficiencyCurve;
