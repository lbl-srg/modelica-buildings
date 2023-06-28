within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves;
record DXHeating_DefrostCurve "DX heating coil defrost curve"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost(
    defEIRFunT={0.9135970355,0.0127860478,0.0000527533,-0.0005917719,0.000136017,
        -0.0000894155});

  annotation (defaultComponentName="per", Documentation(info="<html>
<p>
This record declares performance curves for the heating capacity and the EIR for use in
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.SingleSpeedHeating\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.SingleSpeedHeating</a>.
It has been obtained from the EnergyPlus 9.6 example file
<code>PackagedTerminalHeatPump.idf</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 08, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end DXHeating_DefrostCurve;
