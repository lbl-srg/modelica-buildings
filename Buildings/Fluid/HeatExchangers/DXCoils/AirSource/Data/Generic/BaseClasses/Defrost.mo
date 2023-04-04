within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses;
record Defrost
  "Data record for defrost nominal capacities and performance curve"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive
    "Defrost operation type";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method used to calculate defrost time fraction";

  parameter Real tDefRun(
    final unit="1",
    displayUnit="1")=0.5
    "Time period fraction for which defrost cycle is run";

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=273.65
    "Maximum temperature at which defrost operation is activated";

  parameter Modelica.Units.SI.Power QDefResCap
    "Heating capacity of resistive defrost element"
    annotation(Dialog(enable = defOpe==Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive));

  parameter Modelica.Units.SI.Power QCraCap
    "Crankcase heater capacity";
//-----------------------------Performance curves-----------------------------//
  parameter Real  defEIRFunT[6] = fill(0,6)
    "Biquadratic coefficients for defrost capacity function of temperature"
    annotation (Dialog(enable = defOpe==Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.reverseCycle));
  parameter Real PLFraFunPLR[:] = {1}
    "Quadratic/cubic equation for part load fraction as a function of part-load ratio";

  annotation (defaultComponentName="datDef", Documentation(info="<html>
<p>
This record declares the data used to specify performance curves for defrost operation of
air source DX heating coils.
</p>
<p>
 See the information section of
 <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil\">
 Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil</a>
 for a description of the data.
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
</html>"),
    Icon(graphics={
        Text(
          extent={{-87,47},{-4,-8}},
          textColor={0,0,255},
          textString="EIRFunT")}));
end Defrost;
