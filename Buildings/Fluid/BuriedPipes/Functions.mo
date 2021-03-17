within Buildings.Fluid.BuriedPipes;
package Functions
  extends Modelica.Icons.VariantsPackage;

  function make_ground_coupling_factors
    input Integer nPip(min=1, fixed=true) "Number of pipes";

    input Modelica.SIunits.Length dep[nPip] "Pipes Buried Depth";
    input Modelica.SIunits.Length pos[nPip] "Pipes Horizontal Coordinate (to an arbitrary reference point)";
    input Modelica.SIunits.Length rad[nPip] "Pipes external radius";

    output Real P[nPip, nPip] "Thermal coupling geometric factors";

  algorithm
    for i in 1:nPip loop
      for j in 1:nPip loop
        if i == j then
          P[i,j] := Modelica.Math.log(2*dep[i]/rad[i]);
        else
          P[i,j] := Modelica.Math.log(
          ((pos[i] - pos[j])^2 + (dep[i] + dep[j])^2)/
          ((pos[i] - pos[j])^2 + (dep[i] - dep[j])^2));
        end if;
      end for;
    end for;

  end make_ground_coupling_factors;
end Functions;
