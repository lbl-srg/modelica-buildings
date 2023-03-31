within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoilDefrostCapacity
  "Calculates defrost curve value at given temperature and mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTriggers
    defTri = Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTriggers.timed
    "Type of method to trigger the defrost cycle";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation
    defOpe = Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.resistive
    "Type of defrost method";

  parameter Real tDefRun(
    final unit="1",
    displayUnit="1") = 0.5
    "Time period for which defrost cycle is run"
    annotation(Dialog(enable= defTri==Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTriggers.timed));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    defCur constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    "Defrost curve parameter record";

  Modelica.Blocks.Interfaces.RealInput tFracDef(
    final unit="1",
    displayUnit="1") "Defrost time period fraction"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
      iconTransformation(extent={{-120,80},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput heaCapMul(
    final unit="1",
    displayUnit="1")
    "Heating capacity multiplier"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
      iconTransformation(extent={{-120,50},{-100,70}})));

  Modelica.Blocks.Interfaces.RealInput inpPowMul(
    final unit="1",
    displayUnit="1")
    "Input power multiplier"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
      iconTransformation(extent={{-120,20},{-100,40}})));

  Modelica.Blocks.Interfaces.RealInput TConIn(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Temperature of air entering indoor condenser unit"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.RealInput XConIn(
    final unit="kg/kg",
    displayUnit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of air entering indoor condenser coil"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput pIn(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="AbsolutePressure")
    "Pressure of air entering indoor condenser coil"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") "Temperature of outdoor air"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));

  Modelica.Blocks.Interfaces.RealOutput QDef(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Power extracted from airloop to defrost outdoor coil"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput PDef(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Power input required for running defrost operation"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  Real defMod_T
    "Defrost modifier curve value";

  Real RTF(
    final unit="1",
    displayUnit="1")
    "Run-time fraction";

  Real PLR(
    final unit="1",
    displayUnit="1")
    "Part-load ratio";

  Real PLFra(
    final unit="1",
    displayUnit="1")
    "Part-load fraction";

  Modelica.Units.SI.ThermodynamicTemperature TConInWetBul
    "Wet bulb temperature of air entering indoor condenser coil";

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput QTot(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Total heating capacity from heating coil curve calculations"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}}),
      iconTransformation(extent={{-120,-170},{-100,-150}})));

  parameter Modelica.Units.SI.Power QDefResCap = defCur.QDefResCap
    "Capacity of resistive defrost element";

  Modelica.Blocks.Interfaces.RealInput EIR(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Total energy input ratio from heating coil curve calculations"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}}),
      iconTransformation(extent={{-120,-130},{-100,-110}})));

  Modelica.Blocks.Interfaces.RealOutput PTot(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Total power input required for running heating coil with defrost operation"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
      iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput QTotDef(
    final unit="W",
    displayUnit="W",
    final quantity="Power") "Total heat added to airloop after defrost"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput PCra(
    final unit="W",
    displayUnit="W",
    final quantity="Power") "Crankcase heater power consumption" annotation (
      Placement(transformation(extent={{100,70},{120,90}}), iconTransformation(
          extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealInput uSpe(final unit="1", displayUnit="1")
    "Input speed signal" annotation (Placement(transformation(extent={{-120,110},
            {-100,130}}), iconTransformation(extent={{-120,110},{-100,130}})));
//algorithm
//  PLR:= min(1, (PLR+(QDef/QTotDef)));
equation
  TConInWetBul=wetBul.TWetBul
    "Find wet-bulb temperature of inlet air";
  defMod_T =Buildings.Utilities.Math.Functions.smoothMax(
    x1=Buildings.Utilities.Math.Functions.biquadratic(
      a=defCur.defEIRFunT,
      x1=Modelica.Units.Conversions.to_degC(TConInWetBul),
      x2=Modelica.Units.Conversions.to_degC(TOut)),
      x2=0.001,
      deltaX=0.0001)
      "Cooling capacity modification factor as function of temperature";
  PLR = uSpe;
  if defOpe == Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.resistive then
    QDef = 0;
    PDef = QDefResCap * tFracDef * RTF;
  else
    QDef = 0.01 * tFracDef * (7.222 - Modelica.Units.Conversions.to_degC(TOut)) * QTot/1.01667;
    PDef = defMod_T * QTot * tFracDef * RTF/1.01667;
  end if;
  QTotDef = QTot * heaCapMul;
// when (PLR+(QDef/QTotDef)) < 1 then
//   PLR =  pre(PLR)+(QDef/QTotDef);
// end when;
  //if (PLR+(QDef/QTotDef)) < 1 then
    //PLR=1;
  //end if;
  //PLR = min(1, (pre(PLR)+(QDef/QTotDef)));
  PLFra = Buildings.Fluid.Utilities.extendedPolynomial(
      x=PLR,
      c=defCur.PLFraFunPLR,
      xMin=0,
      xMax=1)
    "Part load fraction for heating coil";
  PTot = QTot * EIR * PLR * inpPowMul/PLFra;
  RTF = PLR/PLFra;
  PCra = defCur.QCraCap * (1 - RTF);

  connect(pIn, wetBul.p)
    annotation (Line(points={{-110,-50},{-70,-50},{-70,-28},{-61,-28}},
      color={0,0,127}));
  connect(XConIn, wetBul.Xi[1])
    annotation (Line(points={{-110,-20},{-61,-20}}, color={0,0,127}));
  connect(TConIn, wetBul.TDryBul)
    annotation (Line(points={{-110,10},{-70,10},{-70,-12},{-61,-12}},
                                                                   color={0,0,127}));
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
end CoilDefrostCapacity;
