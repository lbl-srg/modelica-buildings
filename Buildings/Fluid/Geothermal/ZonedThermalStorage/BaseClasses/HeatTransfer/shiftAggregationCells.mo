within Buildings.Fluid.Geothermal.ZonedThermalStorage.BaseClasses.HeatTransfer;
function shiftAggregationCells
  "Performs the shifting operation for load aggregation and determines the current cell"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation cells";
  input Integer nSeg "Number of segments";
  input Modelica.Units.SI.HeatFlowRate QAgg_flow[nSeg,i]
    "Vector of aggregated loads";
  input Real rCel[i](each min=Modelica.Constants.small) "Aggregation cell widths";
  input Modelica.Units.SI.Time nu[i] "Cell aggregation times";
  input Modelica.Units.SI.Time curTim "Current simulation time";

  output Integer curCel "Current occupied aggregation cell";
  output Modelica.Units.SI.HeatFlowRate QAggShi_flow[nSeg,i]
    "Shifted vector of aggregated loads";

algorithm
  curCel := 1;
  for j in (i-1):-1:1 loop
    if curTim>=nu[j+1] then
      QAggShi_flow[:,j+1] := ((rCel[j+1] - 1)*QAgg_flow[:,j+1] + QAgg_flow[:,j])/rCel[j+1];
      if j==(i-1) then
        curCel := i;
      end if;
    elseif curTim>=nu[j] then
      QAggShi_flow[:,j+1] := (rCel[j+1]*QAgg_flow[:,j+1] + QAgg_flow[:,j])/rCel[j+1];
      curCel := j+1;
    else
      QAggShi_flow[:,j+1] := QAgg_flow[:,j+1];
    end if;
  end for;

  QAggShi_flow[:,1] := zeros(nSeg);

  annotation (Documentation(info="<html>
<p>
Performs the shifting operation which propagates the thermal load history
towards the more distant aggregation cells, and then sets the current cell's
value at <i>0</i>. Additionally, this function also outputs the last filled load
aggregation cell.
</p>
<p>
This is a vectorized implementation of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.shiftAggregationCells\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.shiftAggregationCells</a>,
which applies load aggregation on a vector of aggregated load histories.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end shiftAggregationCells;
