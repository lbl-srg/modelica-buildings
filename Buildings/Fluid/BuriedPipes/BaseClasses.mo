within Buildings.Fluid.BuriedPipes;
package BaseClasses
  function make_ground_coupling_factors
    input Integer nPipes(min=1) "Number of pipes";

    input Modelica.SIunits.Length dep[nPipes] "Pipes Buried Depth";
    input Modelica.SIunits.Length pos[nPipes] "Pipes Horizontal Coordinate (to an arbitrary reference point)";
    input Modelica.SIunits.Length rad[nPipes] "Pipes external radius";

    output Real P[nPipes, nPipes] "Thermal coupling geometric factors";

  algorithm
    for i in 1:nPipes loop
      for j in 1:nPipes loop
        if i == j then
          P[i,j] := Modelica.Math.log((2*dep[i]/rad[i]));
        else
          P[i,j] := Modelica.Math.log((((pos[i] - pos[j])^2 + (dep[i] + dep[j])^2)/
            ((pos[i] - pos[j])^2 + (dep[i] - dep[j])^2)));
        end if;
      end for;
    end for;

  end make_ground_coupling_factors;
end BaseClasses;
