within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples.PerformanceCurves;
record Curve_I_AirCooled "Curve_I for air source DX coils"
  extends
    Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
    capFunT={0.942587793,0.009543347,0.000683770,-0.011042676,0.000005249,
        -0.000009720},
    capFunFF={0.8,0.2,0,0},
    EIRFunT={0.342414409,0.034885008,-0.000623700,0.004977216,0.000437951,
        -0.000728028},
    EIRFunFF={1.1552,-0.1808,0.0256,0},
    TConInMin=291.15,
    TConInMax = 319.26111,
    TEvaInMin= 285.92778,
    TEvaInMax= 297.03889,
    ffMin=0.6,
    ffMax=1.8);
  annotation (Documentation(info="<html>
<p>
This record declares performance curves for the cooling capacity and the EIR.
It has been obtained from the EnergyPlus 7.1 example file
<code>AirflowNetwork_MultiZone_House.idf</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 25, 2012 by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
August 15, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Curve_I_AirCooled;
