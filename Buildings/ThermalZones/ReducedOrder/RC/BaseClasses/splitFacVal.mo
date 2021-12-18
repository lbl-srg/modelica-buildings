within Buildings.ThermalZones.ReducedOrder.RC.BaseClasses;
function splitFacVal
  "Share of vector entries at sum of vector for multiple vectors"
  extends Modelica.Icons.Function;

  input Integer nRow "Number of rows";
  input Integer nCol "Number of columns";
  input Modelica.Units.SI.Area[:] AArray "Vector of areas";
  input Modelica.Units.SI.Area[nCol] AExt "Vector of exterior wall areas";
  input Modelica.Units.SI.Area[nCol] AWin "Vector of window areas";
  output Real[nRow,nCol] splitFacValues "Split factor values for ThermSplitter";
protected
  Modelica.Units.SI.Area ATot=sum(AArray) "Total area";
  Integer j=1 "Row counter";
  Integer k=1 "Column counter";
  Integer l=1 "AArray counter";
algorithm
    for A in AArray loop
      if A > 0 then
        k :=1;
        if l == 1 then
          for AWall in AExt loop
            splitFacValues[j,k] :=(A-AWall)/(ATot-AWall-AWin[k]);
            k := k + 1;
          end for;
        elseif l == 2 then
          for AWall in AExt loop
            splitFacValues[j,k] :=(A-AWin[k])/(ATot-AWall-AWin[k]);
            k := k + 1;
          end for;
        else
          for AWall in AExt loop
            splitFacValues[j,k] :=A/(ATot-AWall-AWin[k]);
            k := k + 1;
          end for;
        end if;
        j :=j + 1;
      end if;
      l :=l + 1;
    end for;

  annotation (Documentation(info="<html>
  <p>Calculates the ratio of the surface areas of a wall to the total wall area,
  unless the area is zero. It subtracts the wall area <code>AExt</code>
  for first entry in <code>AArray</code> and <code>AWin</code> for
  second entry in AArray unless <code>AArray[1]</code> and/or
  <code>AArray[2]</code> are not zero. This is done separately for each
  orientation. Consequently, the function gives an <code>nRow x nCol</code>
  array back as output. Each row stands for one area in
  <code>AArray</code> and each column for one orientation in
  <code>AExt</code> and <code>AWin</code>. The function is used to
  calculate the split factors for
  <a href=\"Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ThermSplitter\">
  Buildings.ThermalZones.ReducedOrder.RC.BaseClasses.ThermSplitter</a>.</p>
  For internal gains, the calculation is:
  <p align=\"center\" style=\"font-style:italic;\">
 SplitFac<sub>i</sub> = AArray[i]
  /ATot
  </p>
  whereby <code>ATot</code> is the sum of <code>AArray</code>. To
  perform this,
  <code>AExt</code> and <code>AWin</code> can just be set to vectors  of
  zeros with length 1.
  For solar radiation through windows, the window and wall area with the same
  orientation as the incoming radiation should be subtracted as these areas
  cannot be hit by the radiation. This needs to be done separately for each
  orientation and for exterior walls and windows only, according to:
  <p align=\"center\" style=\"font-style:italic;\">
 SplitFac<sub>i,k</sub> = (AArray[i]
  - AExt[k])
  /(ATot
  - AExt[k]
  -AWin[k])
  </p>
  and
  <p align=\"center\" style=\"font-style:italic;\">
 SplitFac<sub>i,k</sub> = (AArray[i]
  - AWin[k])
  /(ATot
  - AExt[k]
  - AWin[k])
  </p>
  respectively. For all other walls, the equation is:
  <p align=\"center\" style=\"font-style:italic;\">
 SplitFac<sub>i,k</sub> = AArray[i]
  /(ATot
  - AExt[k]
  - AWin[k])
  </p>
  </html>", revisions="<html>
  <ul>
  <li>December 15, 2015 by Moritz Lauster:<br/>
  First Implementation.
  </li>
  </ul>
  </html>"));
end splitFacVal;
