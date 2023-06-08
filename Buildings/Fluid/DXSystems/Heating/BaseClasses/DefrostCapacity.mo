within Buildings.Fluid.DXSystems.Heating.BaseClasses;
block DefrostCapacity
  "Calculates defrost curve value at given temperature and mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Fluid medium package";

  parameter Real tDefRun(
    final unit="1") = 0.5
    "If defrost operation is timed, timestep fraction for which defrost cycle is run"
    annotation(Dialog(enable=defTri == Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed));

  parameter Modelica.Units.SI.Power QDefResCap = defCur.QDefResCap
    "Capacity of resistive defrost element";

  parameter Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods defTri=
    Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method to trigger the defrost cycle";

  parameter Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation defOpe=
    Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation.resistive
    "Type of defrost method";

  parameter Buildings.Fluid.DXSystems.Heating.AirSource.Data.Generic.DXCoil defCur
    "Defrost curve parameter record";

  Modelica.Blocks.Interfaces.RealInput tDefFra(
    final unit="1")
    "Calculated fraction of timestep for which the defrost cycle is assumed to run"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
      iconTransformation(extent={{-120,100},{-100,120}})));

  Modelica.Blocks.Interfaces.RealInput heaCapMul(
    final unit="1")
    "Heating capacity multiplier"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput inpPowMul(
    final unit="1")
    "Input power multiplier"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
      iconTransformation(extent={{-120,40},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput TConIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of air entering indoor condenser unit"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}}),
      iconTransformation(extent={{-120,10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput XConIn(
    final unit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of air entering indoor condenser coil"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealInput pIn(
    final unit="Pa",
    final quantity="Pressure")
    "Pressure of air entering indoor condenser coil"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Temperature of outdoor air"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealInput QTot_flow(
    final unit="W",
    final quantity="Power")
    "Total heating capacity from heating coil curve calculations"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}}),
      iconTransformation(extent={{-120,-150},{-100,-130}})));

  Modelica.Blocks.Interfaces.RealInput EIR(
    final unit="1")
    "Total energy input ratio from heating coil curve calculations"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}}),
      iconTransformation(extent={{-120,-120},{-100,-100}})));

  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1")
    "Input speed signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}}),
      iconTransformation(extent={{-120,130},{-100,150}})));

  Modelica.Blocks.Interfaces.RealOutput QDef_flow(
    final unit="W",
    final quantity="Power")
    "Power extracted from airloop to defrost outdoor coil"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput PDef(
    final unit="W",
    final quantity="Power")
    "Power input required for running defrost operation"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealOutput PTot(
    final unit="W",
    final quantity="Power")
    "Total power input required for running heating coil with defrost operation"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
      iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput QTotDef_flow(
    final unit="W",
    final quantity="Power")
    "Total heat added to airloop after defrost"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput PCra(
    final unit="W",
    final quantity="Power")
    "Crankcase heater power consumption"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
      iconTransformation(extent={{100,70},{120,90}})));

  Real defMod_T(
    final unit="1")
    "Defrost modifier curve value";

  Real RTF(
    final unit="1")
    "Run-time fraction";

  Real PLR(
    final unit="1")
    "Part-load ratio";

  Real PLFra(
    final unit="1")
    "Part-load fraction";

  Modelica.Units.SI.ThermodynamicTemperature TConInWetBul
    "Wet bulb temperature of air entering indoor condenser coil";

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = MediumA)
    "Calculate wetbulb temperature of condensor inlet air";

equation
  //  Find wet-bulb temperature of inlet air
  pIn = wetBul.p;
  XConIn = wetBul.Xi[1];
  TConIn = wetBul.TDryBul;
  TConInWetBul=wetBul.TWetBul;

  // Calculate modifying factor for defrost operation power consumption
  defMod_T =Buildings.Utilities.Math.Functions.smoothMax(
    x1=Buildings.Utilities.Math.Functions.biquadratic(
      a=defCur.defEIRFunT,
      x1=Modelica.Units.Conversions.to_degC(TConInWetBul),
      x2=Modelica.Units.Conversions.to_degC(TOut)),
      x2=0.001,
      deltaX=0.0001);

  PLR = uSpe;

  //  Calculate heat transferred from airflow to outdoor coil, and power consumed by
  //  compressor for defrost operation.
  if defOpe == Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostOperation.resistive then
    QDef_flow = 0;
    PDef =QDefResCap*tDefFra*RTF;
  else
    //  All coefficients are empirical values valid only for temperature in degree
    //  Celsius and heat flow rate in Watts.
    QDef_flow = 0.01*tDefFra*(7.222 - Modelica.Units.Conversions.to_degC(TOut))*
      QTot_flow/1.01667;
    PDef =defMod_T*QTot_flow*tDefFra*RTF/1.01667;
  end if;
  QTotDef_flow = QTot_flow*heaCapMul;

  // Partload fraction for heating coil
  PLFra = Buildings.Fluid.Utilities.extendedPolynomial(
      x=PLR,
      c=defCur.PLFraFunPLR,
      xMin=0,
      xMax=1);

  //  Calculate total power consumption, run-time fraction and crankcase heater
  //  power consumption.
  PTot =QTot_flow*EIR*PLR*inpPowMul/PLFra;
  RTF = PLR/PLFra;
  PCra = defCur.QCraCap * (1 - RTF);

   annotation (
    defaultComponentName="defCap",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(
          extent={{-100,100},{100,-100}},
          textColor={0,0,255},
          textStyle={TextStyle.Italic},
          textString="f(To,Xo)")}),
          Documentation(info="<html>
<p>
Block to calculate heat transfered to airloop <code>QTotDef_flow</code>, as well as
the total heating power consumption of the component <code>PTot</code>, as defined
in section 15.2.11.5 and 11.6 in the the EnergyPlus 22.2
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.2.0/EngineeringReference.pdf\">engineering reference</a>
document. It also calculates the defrost input power consumption <code>PDef</code>
and the crankcase heater input power consumption <code>PCra</code>.<br/>
The inputs are as follows:
</p>
<ul>
<li>
the defrost cycle time fraction <code>tDefFra</code>, the heating capacity multiplier
<code>heaCapMul</code> and the input power multiplier <code>inpPowMul</code>
calculated by <a href=\"modelica://Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations\">
Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations</a>.
</li>
<li>
the total heat transfer <code>QTot_flow</code> and energy input ratio <code>EIR</code>
calculated by <a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.DryCoil\">
Buildings.Fluid.DXSystems.BaseClasses.DryCoil</a>.
</li>
<li>
the measured temperature <code>TConIn</code>, humidity ratio per kg of total air
<code>XConIn</code> and pressure <code>pIn</code> of the indoor coil inlet air
temperature.
</li>
<li>
the measured outdoor air temperature <code>TOut</code>.
</li>
</ul>
<h4>Calculations</h4>
<ul>
<li>
<p>
If the type of defrost method <code>defOpe</code> is set to <code>reverseCycle</code>,
the heat transfer rate from the airstream to the outdoor coil <code>QDef_flow</code>
and the power consumption for defrost <code>PDef</code> are calculated as follows:
<p align=\"center\" style=\"font-style:italic;\">
QDef_flow = 0.01*tDefFra*(7.222 - TOut)*(QTot_flow/1.01667)<br/>
PDef = defMod_T*(QTot_flow/1.01667)*tDefFra*RTF<br/>
</p>
where <code>defMod_T</code> is the defrost operation modifier (from curve 
<code>defCur</code> function of inlet air wet-bulb temperature 
<code>TConInWetBul</code> and <code>TOut</code>) calculated as
<p align=\"center\" style=\"font-style:italic;\">
defMod_T = defCur[1] + defCur[2]*TConInWetBul + defCur[3]*TConInWetBul<sup>2</sup>
+ defCur[4]*TOut + defCur[5]*TOut<sup>2</sup> + defCur[6]*TOut*TConInWetBul
</p>
and <code>RTF</code> is the runtime fraction of the heating coil, calculated from 
part load ratio <code>PLR</code> and part load fraction <code>PLFra</code> as
<p align=\"center\" style=\"font-style:italic;\">
RTF = PLR/PLFra
</p>
<code>PLR</code> is currently being hardcoded with a value of <code>1</code> since 
this is currently only implemented for a constant speed DX heating coil.<br/>
<code>PLFra</code> is calculated from the part load fraction curve (function of 
<code>PLR</code>) <code>defCur.PLFraFunPLR</code> as follows:
<p align=\"center\" style=\"font-style:italic;\">
PLFra = PLFraFunPLR[1] + PLFraFunPLR[2]*PLR + PLFraFunPLR[3]*PLR<sup>2</sup> +
PLFraFunPLR[4]*PLR<sup>3</sup>
</p>
</p>
</li>
<br/>
<li>
<p>
If the type of defrost method <code>defOpe</code> is set to <code>reverseCycle</code>,
the calculations are as follows:
<p align=\"center\" style=\"font-style:italic;\">
QDef_flow = 0<br/>
PDef = QDefResCap*tDefFra*RTF
</p>
where <code>QDefResCap</code> is the rated capacity of the resistive heating 
element on the outdoor coil.<br/>
The remaining variable calculations for <code>RTF</code>, <code>PLR</code> and 
<code>PLFra</code> are the same as above.
</p>
</li>
<br/>
<li>
The total power consumption <code>PTot</code> and total heat flowrate to the air stream 
<code>QTotDef_flow</code> (while accounting for defrost operation) is calculated 
as follows:<br/>
<p align=\"center\" style=\"font-style:italic;\">
PTot = QTot_flow*EIR*PLR*inpPowMul/PLFra<br/>
QTotDef_flow = QTot_flow*heaCapMul
</p>
</li>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2023, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end DefrostCapacity;
