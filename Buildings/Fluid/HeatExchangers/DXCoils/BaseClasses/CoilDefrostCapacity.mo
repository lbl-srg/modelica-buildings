within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block CoilDefrostCapacity
  "Calculates defrost curve value at given temperature and mass flow rate"
  extends Modelica.Blocks.Icons.Block;

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Fluid medium package";

  parameter Real tDefRun(
    final unit="1",
    displayUnit="1") = 0.5
    "Time period for which defrost cycle is run"
    annotation(Dialog(enable=defTri == Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed));

  parameter Modelica.Units.SI.Power QDefResCap = defCur.QDefResCap
    "Capacity of resistive defrost element";

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods
    defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed
    "Type of method to trigger the defrost cycle";

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation
    defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive
    "Type of defrost method";

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    defCur constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    "Defrost curve parameter record";

  Modelica.Blocks.Interfaces.RealInput tFracDef(
    final unit="1",
    displayUnit="1") "Defrost time period fraction"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
      iconTransformation(extent={{-120,100},{-100,120}})));

  Modelica.Blocks.Interfaces.RealInput heaCapMul(
    final unit="1",
    displayUnit="1")
    "Heating capacity multiplier"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput inpPowMul(
    final unit="1",
    displayUnit="1")
    "Input power multiplier"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}}),
      iconTransformation(extent={{-120,40},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput TConIn(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Temperature of air entering indoor condenser unit"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}}),
      iconTransformation(extent={{-120,10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput XConIn(
    final unit="kg/kg",
    displayUnit="kg/kg",
    final quantity="MassFraction")
    "Humidity ratio of air entering indoor condenser coil"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealInput pIn(
    final unit="Pa",
    displayUnit="Pa",
    final quantity="Pressure")
    "Pressure of air entering indoor condenser coil"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") "Temperature of outdoor air"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealInput QTot(
    final unit="W",
    final displayUnit="W",
    final quantity="Power")
    "Total heating capacity from heating coil curve calculations"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}}),
      iconTransformation(extent={{-120,-150},{-100,-130}})));

  Modelica.Blocks.Interfaces.RealInput EIR(
    final unit="1",
    final displayUnit="1")
    "Total energy input ratio from heating coil curve calculations"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}}),
      iconTransformation(extent={{-120,-120},{-100,-100}})));

  Modelica.Blocks.Interfaces.RealInput uSpe(
    final unit="1",
    displayUnit="1")
    "Input speed signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}}),
      iconTransformation(extent={{-120,130},{-100,150}})));

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
    final quantity="Power")
    "Total heat added to airloop after defrost"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
      iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput PCra(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Crankcase heater power consumption"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
      iconTransformation(extent={{100,70},{120,90}})));

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
  if defOpe == Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive then
    QDef = 0;
    PDef = QDefResCap * tFracDef * RTF;
  else
    QDef = 0.01 * tFracDef * (7.222 - Modelica.Units.Conversions.to_degC(TOut)) * QTot/1.01667;
    PDef = defMod_T * QTot * tFracDef * RTF/1.01667;
  end if;
  QTotDef = QTot * heaCapMul;
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
Block to calculate heat transfered to airloop <code>QTotDef</code>, as well as 
the total heating power consumption of the component <code>PTot</code>, as defined 
in section 15.2.11.5 and 11.6 in the the EnergyPlus 22.2 
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v22.2.0/EngineeringReference.pdf\">engineering reference</a>
document. It also calculates the defrost input power consumption <code>PDef</code>
and the crankcase heater input power consumption <code>PCra</code>.<br/>
The inputs are as follows:
<ul>
<li>
the defrost cycle time fraction <code>tFracDef</code>, the heating capacity multiplier 
<code>heaCapMul</code> and the input power multiplier <code>inpPowMul</code> 
calculated by <a href=\"Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostTimeCalculations\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostTimeCalculations</a>.
</li>
<li>
the total heat transfer <code>QTot</code> and energy input ratio <code>EIR</code>
calculated by <a href=\"Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil</a>.
</li>
<li>
the measured temperature <code>TConIn</code>, humidity ratio (total air) 
<code>XConIn</code> and pressure <code>pIn</code> of the indoor coil inlet air 
temperature.
</li>
<li>
the measured outdoor air temperature <code>TOut</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2023, by Karthik Devaprasad and Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoilDefrostCapacity;
