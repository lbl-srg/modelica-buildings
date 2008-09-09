  package SimpleAir "Air: Simple dry air model (0..100 degC)" 
    
    extends Buildings.Media.Interfaces.PartialSimpleIdealGasMedium
      (mediumName="SimpleAir",
       cp_const=1005.45,
       MM_const=0.0289651159,
       R_gas=Constants.R/0.0289651159,
       eta_const=1.82e-5,
       lambda_const=0.026,
       T_min=Cv.from_degC(0),
       T_max=Cv.from_degC(100));
    
    import SI = Modelica.SIunits;
    import Cv = Modelica.SIunits.Conversions;
    import Modelica.Constants;
    
    constant FluidConstants[nS] fluidConstants =
      FluidConstants(iupacName={"simple air"},
                     casRegistryNumber={"not a real substance"},
                     chemicalFormula={"N2, O2"},
                     structureFormula={"N2, O2"},
                     molarMass=Modelica.Media.IdealGases.Common.SingleGasesData.N2.MM) "constant data for the fluid";
        
    annotation (Documentation(info="<html>
                              <h2>Simple Ideal gas air model for low temperatures<h1>
                              <p>This model demonstrats how to use the PartialSimpleIdealGas base class to build a
                              simple ideal gas model with a limited temperature validity range.</p>
<p>
This partial package is identical to 
<a href=\"Modelica:Modelica.Media.Air.SimpleAir\">
Modelica.Media.Air.SimpleAir</a> but it fixes two bugs
in the original implementation. The bugs are fixed by using a new
base class
<a href=\"Modelica:Buildings.Media.Interfaces.PartialSimpleIdealGasMedium\">
Buildings.Media.Interfaces.PartialSimpleIdealGasMedium</a>
 (that fixes the bugs) instead of
<a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>.
</p>
<p>
With the original implementation, initial states of fluid volumes can be far away from
the steady-state value because of an inconsistent implementation of the the enthalpy
and internal energy.
When the <tt>Buildings</tt> library is upgraded to
to Modelica 3.0.0, it should be safe to remove this package as the bug is fixed
since Modelica 3.0.0 (but not in Modelica 2.2.2).
</HTML>", revisions="<html>
<ul>
<li>
September 4, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end SimpleAir;
