within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
function computeCoordinates
  input Integer nBorHol
    "Number of boreholes";
  input Modelica.SIunits.Distance dxy = 6
    "Distance in x-axis (and y-axis) between borehole axes";
  output Modelica.SIunits.Distance cooBor[nBorHol, 2]
    "Coordinates of boreholes";
protected
  Integer k = 1 "Iteration index";
algorithm
  for i in 0:sqrt(nBorHol)-1 loop
    for j in 0:sqrt(nBorHol)-1 loop
      cooBor[k, 1] := i*dxy;
      cooBor[k, 2] := j*dxy;
      k := k + 1;
    end for;
  end for;
end computeCoordinates;
