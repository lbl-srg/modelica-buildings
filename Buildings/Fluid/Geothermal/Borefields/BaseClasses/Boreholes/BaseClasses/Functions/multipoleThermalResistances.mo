within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function multipoleThermalResistances
  "Thermal resistances from multipole solution"
  extends Modelica.Icons.Function;

  input Integer nPip "Number of pipes";
  input Integer J "Number of multipoles";
  input Modelica.Units.SI.Position xPip[nPip] "x-Coordinates of pipes";
  input Modelica.Units.SI.Position yPip[nPip] "y-Coordinates of pipes";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.Radius rPip[nPip] "Outter radius of pipes";
  input Modelica.Units.SI.ThermalConductivity kFil
    "Thermal conductivity of grouting material";
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of soil material";
  input Real RFluPip[nPip](each unit="(m.K)/W") "Fluid to pipe wall thermal resistances";
  input Modelica.Units.SI.Temperature TBor=0
    "Average borehole wall temperature";

  output Real RDelta[nPip,nPip](each unit="(m.K)/W") "Delta-circuit thermal resistances";
  output Real R[nPip,nPip](each unit="(m.K)/W") "Internal thermal resistances";

protected
  Real QPip_flow[nPip](each unit="W/m") "Pipe heat transfer rates";
  Modelica.Units.SI.Temperature TFlu[nPip] "Fluid temperatures";
  Real K[nPip,nPip](each unit="W/(m.K)") "Internal thermal conductances";

algorithm
  for m in 1:nPip loop
    for n in 1:nPip loop
      if n == m then
        QPip_flow[n] := 1;
      else
        QPip_flow[n] := 0;
      end if;
    end for;
    TFlu :=
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.multipoleFluidTemperature(
      nPip,
      J,
      xPip,
      yPip,
      QPip_flow,
      TBor,
      rBor,
      rPip,
      kFil,
      kSoi,
      RFluPip);
    for n in 1:nPip loop
      R[n, m] := TFlu[n];
    end for;
  end for;
  K := -Modelica.Math.Matrices.inv(R);
  for m in 1:nPip loop
    K[m, m] := -K[m, m];
    for n in 1:nPip loop
      if m <> n then
        K[m, m] := K[m, m] - K[m, n];
      end if;
    end for;
  end for;
  for m in 1:nPip loop
    for n in 1:nPip loop
      RDelta[m, n] := 1./K[m, n];
    end for;
  end for;

  annotation (Documentation(info="<html>
<p>This model evaluates the delta-circuit borehole thermal resistances using the multipole method of Claesson and Hellstrom (2011).
</p>
<h4>References</h4>
<p>J. Claesson and G. Hellstrom. 
<i>Multipole method to calculate borehole thermal resistances in a borehole heat exchanger. 
</i>
HVAC&amp;R Research,
17(6): 895-911, 2011.</p>
</html>", revisions="<html>
<ul>
<li>
February 12, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end multipoleThermalResistances;
