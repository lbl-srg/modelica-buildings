within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation;
function shiftAggregationCells
  "Performs the shifting operation for load aggregation and determines the current cell"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation cells";
  input Modelica.Units.SI.HeatFlowRate QAgg_flow[i]
    "Vector of aggregated loads";
  input Real rCel[i](each min=Modelica.Constants.small) "Aggregation cell widths";
  input Modelica.Units.SI.Time nu[i] "Cell aggregation times";
  input Modelica.Units.SI.Time curTim "Current simulation time";

  output Integer curCel "Current occupied aggregation cell";
  output Modelica.Units.SI.HeatFlowRate QAggShi_flow[i]
    "Shifted vector of aggregated loads";

algorithm
  curCel := 1;
  for j in (i-1):-1:1 loop
    if curTim>=nu[j+1] then
      QAggShi_flow[j+1] := ((rCel[j+1] - 1)*QAgg_flow[j+1] + QAgg_flow[j])/rCel[j+1];
      if j==(i-1) then
        curCel := i;
      end if;
    elseif curTim>=nu[j] then
      QAggShi_flow[j+1] := (rCel[j+1]*QAgg_flow[j+1] + QAgg_flow[j])/rCel[j+1];
      curCel := j+1;
    else
      QAggShi_flow[j+1] := QAgg_flow[j+1];
    end if;
  end for;

  QAggShi_flow[1] := 0;

  annotation (Documentation(info="<html>
<p>
Performs the shifting operation which propagates the thermal load history
towards the more distant aggregation cells, and then sets the current cell's
value at <i>0</i>. Additionally, this function also outputs the last filled load
aggregation cell.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Added <code>min=Modelica.Constants.small</code> to <code>rCel</code>
so that a tool can infer that this quantity is non-zero.
</li>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end shiftAggregationCells;
