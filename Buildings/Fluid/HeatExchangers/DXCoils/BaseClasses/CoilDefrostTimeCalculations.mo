within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoilDefrostTimeCalculations
  "Calculates defrost curve value at given temperature and mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTimeMethods
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTimeMethods.timed
    "Type of method to trigger the defrost cycle";

  parameter Real tDefRun(
    final unit="1",
    displayUnit="1") = 0.5
    "Time period for which defrost cycle is run"
    annotation(Dialog(enable=defTri == Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTimeMethods.timed));

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim
    "Maximum temperature at which defrost operation is activated";

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Humidity ratio of outdoor air"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}}),
      iconTransformation(extent={{-120,10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput XOut(
    final unit="kg/kg",
    displayUnit="kg/kg",
    final quantity="MassFraction") "Humidity ratio of outdoor air"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealOutput tFracDef(
    final unit="1",
    displayUnit="1")
    "Defrost time period fraction"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput heaCapMul(
    final unit="1",
    displayUnit="1")
    "Heating capacity multiplier"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput inpPowMul(
    final unit="1",
    displayUnit="1")
    "Input power multiplier"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Units.SI.MassFraction delta_XCoilOut
    "Difference between outdoor air humidity ratio and the saturated air humidity 
    ratio at estimated outdoor coil temperature";

  Modelica.Units.SI.ThermodynamicTemperature TCoiOut
    "Outdoor coil temperature";

  Modelica.Units.SI.MassFraction XOutDryAir;

  Buildings.Utilities.Psychrometrics.ToDryAir toDryAir
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  // Outdoor coil surface temperature
  TCoiOut = Modelica.Units.Conversions.from_degC(0.82*Modelica.Units.Conversions.to_degC(TOut) - 8.589);
  connect(XOut, toDryAir.XiTotalAir);
  XOutDryAir = toDryAir.XiDry;
  // Calculate difference between outdoor air humidity ratio and saturated air humidity
  // ratio at estimated outdoor coil temperature
  delta_XCoilOut = max(1e-6, (XOutDryAir - Buildings.Utilities.Psychrometrics.Functions.X_pTphi(101325, TCoiOut, 1)));
  if TOut < TDefLim then
    if defTri == Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTimeMethods.timed
         then
      tFracDef = tDefRun;
      heaCapMul = 0.909 - 107.33*delta_XCoilOut;
      inpPowMul = 0.9 - 36.45*delta_XCoilOut;
    else
      tFracDef = 1/(1+(0.01446/delta_XCoilOut));
      heaCapMul = 0.875*(1 - tFracDef);
      inpPowMul = 0.954*(1 - tFracDef);
    end if;
  else
    tFracDef = 0;
    heaCapMul = 1;
    inpPowMul = 1;
  end if;
  annotation (
    defaultComponentName="cooCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          textColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(To,Xo)")}),
          Documentation(info="<html>
          <p>
          Block to calculate defrost cycling time.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 8, 2022, by Michael Wetter:<br/>
Corrected calculation of performance which used the wrong upper bound.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/3146\">issue 3146</a>.
</li>
<li>
October 21, 2019, by Michael Wetter:<br/>
Ensured that transition interval for computation of <code>corFac</code> is non-zero.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">issue 1202</a>.
</li>
<li>
February 27, 2017 by Yangyang Fu:<br/>
Revised the documentation.
</li>
<li>
December 18, 2012 by Michael Wetter:<br/>
Added warning if the evaporator or condenser inlet temperature of the current stage
cross the minimum and maximum allowed values.
</li>
<li>
September 20, 2012 by Michael Wetter:<br/>
Revised model and documentation.
</li>
<li>
May 18, 2012 by Kaustubh Phalak:<br/>
Combined cooling capacity and EIR modifier function together to avoid repeatation of same variable calculations.
Added heaviside function.
</li>
<li>
April 20, 2012 by Michael Wetter:<br/>
Added unit conversion directly to function calls to avoid doing
the conversion when the coil is switched off.
</li>
<li>
April 6, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"));
end CoilDefrostTimeCalculations;
