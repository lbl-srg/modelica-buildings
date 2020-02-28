within Buildings.HeatTransfer.Windows.Functions;
function glassPropertyCoated
  "Compute angular variation and hemispherical integration of the transmittance and reflectance for a coated glass pane without shading"
  extends
    Buildings.HeatTransfer.Windows.Functions.BaseClasses.partialSingleGlassRadiation;
  input Real glass[3] "Propertry of one glass pane";
  input Modelica.Units.SI.Angle psi[HEM - 1] "Incident angles";

  output Real layer[3, HEM] "Transmittance, front and back reflectance";

protected
  constant Real a[4, 5]={{-0.0015,3.355,-3.840,1.460,0.0288},{0.999,-0.563,
      2.043,-2.532,1.054},{-0.002,2.813,-2.341,-0.05725,0.599},{0.997,-1.868,
      6.513,-7.862,3.225}} "Coeffcients in Table A.2";

  Integer NDIR "Number of incident angles";

  Real psi_c "cos(psi), psi is incident angle";
  Real psi_cs "cos(psi)*sin(psi)";
  Real angT "Angular variation of transmittance";
  Real angR "Angular variation of reflectance";
  Real f[3, HEM-1]
    "Temporary variables for integration in hemispherical transmittance and reflectance";
  Real deltaX;

  Integer id1 "Index of coefficients for transmittance";
  Integer id2 "Index of coefficients for reflectance";

algorithm
  NDIR:=HEM - 1;
  deltaX := 0.5*Modelica.Constants.pi/(NDIR - 1);
  // Compute specular value for angle 0 to 90 degree (psi[1] to psi[N])
    for k in TRA:Rb loop
      layer[k, 1] := glass[k] "Copy the data at 0 degree (normal incidence)";
    end for;

    for j in 2:HEM-2 loop
      psi_c := Modelica.Math.cos(psi[j]);
       if layer[TRA, 1] > 0.645 then
        id1 := 1;
        id2 := 2;
      else
        id1 := 3;
        id2 := 4;
      end if;
      angT := a[id1, 1] + psi_c*(a[id1, 2] + psi_c*(a[id1, 3] + psi_c*(a[id1, 4]
         + psi_c*a[id1, 5]))) "Equation (A.4.68a)";
      angR := a[id2, 1] + psi_c*(a[id2, 2] + psi_c*(a[id2, 3] + psi_c*(a[id2, 4]
         + psi_c*a[id2, 5]))) - angT "Equation (A.4.68b)";
      layer[TRA, j] := layer[TRA, 1]*angT "Equation (A4.69a)";
      layer[Ra, j] := layer[Ra, 1]*(1 - angR) + angR "Equation (A4.69b)";
      layer[Rb, j] := layer[Rb, 1]*(1 - angR) + angR "Equation (A4.69b)";

    end for;

    layer[TRA, NDIR] := 0;
    layer[Ra, NDIR] := 1.0;
    layer[Rb, NDIR] := 1.0;

  // Computer hemispherical value: HEM.
    for j in 1:HEM-1 loop
      psi_cs := Modelica.Math.cos(psi[j])*Modelica.Math.sin(psi[j]);
      for k in TRA:Rb loop
        f[k, j] := 2*layer[k, j]*psi_cs;
      end for;
    end for;

    for k in TRA:Rb loop
      layer[k, HEM] :=
        Buildings.Utilities.Math.Functions.trapezoidalIntegration(
        NDIR,
        f[k, :],
        deltaX) "Equation (A.4.70a) and (A.4.70b)";
    end for;

  annotation (Documentation(info="<html>
<p>
This function computes the angular variation and the hemispherical integration of the transmittance and reflectance for one coated glass pane.
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2014, by Michael Wetter:<br/>
Changed use of <code>NDIR</code> for OpenModelica.
</li>
<li>
December 09, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end glassPropertyCoated;
