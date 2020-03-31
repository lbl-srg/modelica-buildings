within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation;
function aggregationWeightingFactors
  "Calculates the kappa vector for load aggregation"
  extends Modelica.Icons.Function;

  input Integer i "Size of aggregation vector";
  input Integer nTimTot "Size of g-function time table";
  input Modelica.Units.SI.ThermalResistance TStep[nTimTot,2]
    "Time matrix with TStep";
  input Modelica.Units.SI.Time nu[i] "Aggregation time vector nu";

  output Modelica.Units.SI.ThermalResistance kappa[i]
    "Weighting factors vector";

protected
  Modelica.Units.SI.ThermalResistance prevT
    "Interpolated value of TStep at previous cell";
  Modelica.Units.SI.ThermalResistance curT
    "Interpolated value of TStep at current cell";
  Integer curInt "Integer to select data interval";
  Real[size(TStep[:,1], 1)] d(each unit="K/J") "Derivatives at the support points";

algorithm
  d := Buildings.Utilities.Math.Functions.splineDerivatives(
    x=TStep[:,1],
    y=TStep[:,2],
    ensureMonotonicity=false);

  for j in 1:i loop
    if j==1 then
      prevT := 0;
    else
      //Spline interpolation at nu[j-1]
      for k in 1:size(TStep[:,1], 1) - 1 loop
        if nu[j-1] > TStep[k,1] then
          curInt := k;
        end if;
      end for;

      prevT := Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
        x=nu[j-1],
        x1=TStep[curInt,1],
        x2=TStep[curInt+1,1],
        y1=TStep[curInt,2],
        y2=TStep[curInt+1,2],
        y1d=d[curInt],
        y2d=d[curInt + 1]);
    end if;

    //Spline interpolation at nu[j]
    for k in 1:size(TStep[:,1], 1) - 1 loop
      if nu[j] > TStep[k,1] then
        curInt := k;
      end if;
    end for;

    curT := Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
      x=nu[j],
      x1=TStep[curInt,1],
      x2=TStep[curInt+1,1],
      y1=TStep[curInt,2],
      y2=TStep[curInt+1,2],
      y1d=d[curInt],
      y2d=d[curInt + 1]);

    kappa[j] := curT-prevT;
  end for;

  annotation (Documentation(info="<html>
<p>
This function uses spline interpolation to construct the weighting factors
vector <code>kappa</code> using the aggregation times <code>nu</code> and the
temperature step reponse (a time-series in the form of a matrix) of the
borefield as an input.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end aggregationWeightingFactors;
