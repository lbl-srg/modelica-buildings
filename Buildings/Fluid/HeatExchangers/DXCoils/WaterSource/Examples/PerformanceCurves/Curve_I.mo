within Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Examples.PerformanceCurves;
record Curve_I "Curve_I"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.BaseClasses.PerformanceCurve(
    each capFunT={1.43085,-0.0453653,0.00199378,-0.00805944,3.93414E-05,
        -1.81187E-04},
    each capFunFF={1.0,0.0,0,0},
    each capFunFFCon={1.0,0.0,0.0},
    each EIRFunT={0.138848,0.0457985,-0.00138661,0.0141485,0.000386055,
        -4.38194E-04},
    each EIRFunFF={1.0,0.0,0.0},
    each EIRFunFFCon={1.0,0.0,0.0},
    TConInMin=7.2+273.15,
    TConInMax=48.9+273.15,
    TEvaInMin=10+273.15,
    TEvaInMax=25.6+273.15,
    ffMin=0.0,
    ffMax=1.0,
    ffConMin=0.0,
    ffConMax=1.0);
  annotation (Documentation(info="<html>
<p>
This record declares performance curves for the cooling capacity and the EIR.
It has been obtained from the EnergyPlus 8.6 example file
<code>UnitarySystem_VSHeatPumpWaterToAirEquationFit.idf</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Curve_I;
