within Buildings.Fluid.DXSystems.Heating.BaseClasses;
block CoilDefrostTimeCalculations
  "Calculates defrost curve value at given temperature and mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method to trigger the defrost cycle";

  parameter Real tDefRun(
    final unit="1") = 0.5
    "If defrost operation is timed, timestep fraction for which defrost cycle is run"
    annotation(Dialog(enable=defTri == Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed));

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim
    "Maximum temperature at which defrost operation is activated";

  parameter Modelica.Units.SI.TemperatureDifference dTHys = 0.5
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of outdoor air"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}}),
      iconTransformation(extent={{-120,10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of outdoor air"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealOutput tDefFra(
    final unit="1")
    "Defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
      iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput heaCapMul(
    final unit="1")
    "Heating capacity multiplier"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput inpPowMul(
    final unit="1")
    "Input power multiplier"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Units.SI.MassFraction delta_XCoilOut
    "Difference between outdoor air humidity ratio and the saturated air humidity 
    ratio at estimated outdoor coil temperature";

  Modelica.Units.SI.ThermodynamicTemperature TCoiOut
    "Outdoor coil temperature";

  Modelica.Units.SI.MassFraction XOutDryAir
    "Outdoor air humidity ratio per kg total air";

  Buildings.Utilities.Psychrometrics.ToDryAir toDryAir
    "Convert outdoor air humidity ratio from total air to dry air";

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysTOut(
    final uLow=-dTHys,
    final uHigh=dTHys)
    "Check if outdoor air temperature is below maximum limit for defrost operation";

equation
  // Estimated outdoor coil surface temperature, based on outdoor air temperature.
  // 0.82 and 8.589 are empirical coefficients for this conversion, that are valid
  // only when outdoor air temperature is in degree Celsius.
  TCoiOut = Modelica.Units.Conversions.from_degC(0.82*Modelica.Units.Conversions.to_degC(TOut) - 8.589);

  // Provide outdoor air as input to conversion block
  XOut = toDryAir.XiTotalAir;

  // Get outdoor air humidity ratio per kg of dry air
  XOutDryAir = toDryAir.XiDry;

  // Calculate difference between outdoor air humidity ratio and saturated air humidity
  // ratio at estimated outdoor coil surface temperature, which will indicate frost formation
  delta_XCoilOut = Buildings.Utilities.Math.Functions.smoothMax(
    1e-6,
    XOutDryAir - Buildings.Utilities.Psychrometrics.Functions.X_pTphi(101325, TCoiOut, 1),
    0.5*1e-6);

  //  Use hysteresis block for comparison of outdoor air temperature with max limit
  //  for defrost operation
  hysTOut.u = TOut - TDefLim;

  // Check if defrost operation is allowed
  if not hysTOut.y then
    if defTri == Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed then
      tDefFra = tDefRun;
      // Empirical coefficients for calculating multipliers valid only for humidity
      // ratio difference per kg of dry air
      heaCapMul = 0.909 - 107.33*delta_XCoilOut;
      inpPowMul = 0.9 - 36.45*delta_XCoilOut;
    else
      // Empirical coefficients for calculating multipliers valid only for humidity
      // ratio per kg of dry air
      tDefFra = 1/(1 + (0.01446/delta_XCoilOut));
      heaCapMul =0.875*(1 - tDefFra);
      inpPowMul =0.954*(1 - tDefFra);
    end if;
  // Condition for when defrost is not operated
  else
    tDefFra = 0;
    heaCapMul = 1;
    inpPowMul = 1;
  end if;
  annotation (
    defaultComponentName="defTimFra",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          textColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(To,Xo)")}),
          Documentation(info="<html>
<p>
Block to calculate defrost cycling time fraction <code>tDefFra</code> as defined 
in section 15.2.11.4 in the the EnergyPlus 22.2 
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.2.0/EngineeringReference.pdf\">engineering reference</a>
document. It also calculates the heating capacity multiplier <code>heaCapMul</code>
and the input power multiplier <code>inpPowMul</code>. The inputs are the measured
temperature <code>TOut</code> and humidity ratio per kg total air <code>XOut</code> 
of the outdoor air.
</p>
<h4>Calculations</h4>
<p>
The model first estimates the outdoor coil temperature <code>TCoiOut</code> from 
the outdoor air drybulb temperature <code>TOut</code> using the following relation 
<p align=\"center\" style=\"font-style:italic;\">
TCoiOut = 0.82*TOut - 8.589
</p>
</p>
<p>
The difference between the outdoor air humidity ratio <code>XOutDryAir</code> and 
the saturated air humidity ratio at outdoor coil temperature is used to determine 
frost formation on the outdoor coil as follows
<p align=\"center\" style=\"font-style:italic;\">
delta_XCoilOut = max(1e-6, (XOutDryAir - XSatOutCoil))
</p>
</p>
<p>
The block then calculates the time period fraction <code>tDefFra</code> for which 
the defrost operation is assumed to run, based on the input for the defrost trigger 
type parameter <code>defTri</code>.<br/>
In the EnergyPlus model, <code>tDefFra</code> represents the fraction of the constant 
timestep in the simulation model for which the defrost operation is assumed to be 
active. This is calculated to be a higher value when the outdoor air temperature 
is lower and the relative humidity is higher. This results in a higher proportion
of the consumed power going towards the defrost operation and lower heating of 
the HVAC air stream.
</p>
<p>
In this Modelica implementation of the model, while the timestep may not be constant
and may vary based on the solver for the simulation, the same assumption is used 
for calculating the proportion of energy consumed for defrost mode operation. The coil
does not actually enter defrost operation (with reverse flow of refrigerant) during 
this timestep fraction.
</p>
<p>
If <code>defTri</code> is set to <code>timed</code>, <code>tDefFra</code> is set 
to the user input parameter for defrost operation timestep fraction <code>tDefRun</code>.
The heating capacity multiplier <code>heaCapMul</code> and input power multiplier
<code>inpPowMul</code> are calculated as follows:
<p align=\"center\" style=\"font-style:italic;\">
tDefFra = tDefRun<br/>
heaCapMul = 0.909 - 107.33*delta_XCoilOut<br/>
inpPowMul = 0.9 - 36.45*delta_XCoilOut
</p>
</p>
<p>
If <code>defTri</code> is set to <code>onDemand</code>, <code>tDefFra</code>, 
<code>heaCapMul</code> and <code>inpPowMul</code> are calculated as follows:
<p align=\"center\" style=\"font-style:italic;\">
tDefFra = 1/(1 + (0.01446/delta_XCoilOut))<br/>
heaCapMul = 0.875*(1 - tDefFra)<br/>
inpPowMul = 0.954*(1 - tDefFra)
</p>
</p>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2023, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoilDefrostTimeCalculations;
